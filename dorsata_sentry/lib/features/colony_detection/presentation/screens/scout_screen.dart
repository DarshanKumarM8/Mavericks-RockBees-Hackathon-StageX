import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dorsata_sentry/core/utils/isolate_manager.dart'; // From Phase 3
import 'package:dorsata_sentry/features/colony_detection/presentation/widgets/hud_overlay.dart';
import 'package:dorsata_sentry/features/colony_detection/presentation/widgets/detection_painter.dart';
import 'package:dorsata_sentry/features/colony_detection/presentation/providers/detection_provider.dart';
import 'package:dorsata_sentry/main.dart'; // To access global 'cameras' variable

class ScoutScreen extends ConsumerStatefulWidget {
  const ScoutScreen({super.key});

  @override
  ConsumerState<ScoutScreen> createState() => _ScoutScreenState();
}

class _ScoutScreenState extends ConsumerState<ScoutScreen> with WidgetsBindingObserver {
  CameraController? _cameraController;
  bool _isProcessing = false; // Prevents flooding the Isolate
  Isolate? _inferenceIsolate;
  SendPort? _isolateSendPort;
  ReceivePort? _mainReceivePort;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // Listen for app pause/resume
    _initializePipeline();
  }

  Future<void> _initializePipeline() async {
    // 1. Setup the Background Isolate
    _mainReceivePort = ReceivePort();
    await spawnInferenceIsolate(_mainReceivePort!.sendPort);
    
    // Listen for the Isolate's handshake
    _mainReceivePort!.listen((message) {
      if (message is SendPort) {
        _isolateSendPort = message; // Connection established!
      } else if (message is Map<String, dynamic>) {
        // Result received from Isolate (Detections)
        _handleInferenceResult(message);
      }
    });

    // 2. Setup the Camera
    if (cameras.isEmpty) return;
    _cameraController = CameraController(
      cameras[0], // Back Camera
      ResolutionPreset.medium, // 480p/720p is faster for AI than 4K
      enableAudio: true, // Needed for Hiss Detection
      imageFormatGroup: ImageFormatGroup.yuv420,
    );

    await _cameraController!.initialize();
    if (!mounted) return;

    // 3. Start the Stream
    _cameraController!.startImageStream((CameraImage image) {
      if (_isProcessing) return; // Drop frame if Isolate is busy
      if (_isolateSendPort == null) return; // Wait for Isolate connection

      _isProcessing = true; // Lock the gate
      
      // Send image pointer/data to Isolate
      // NOTE: In production, passing full bytes is slow. 
      // We pass the reference here for the guide.
      _isolateSendPort!.send(image); 
    });

    setState(() {});
  }

  void _handleInferenceResult(Map<String, dynamic> result) {
    // result contains: {'detections': List, 'time': double}
    final detections = result['detections'] as List<Map<String, dynamic>>;
    final time = result['time'] as double;

    // Update Riverpod State (UI will auto-redraw)
    ref.read(detectionProvider.notifier).updateDetections(detections, time);

    // Unlock the gate for the next frame
    _isProcessing = false;
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _inferenceIsolate?.kill();
    _mainReceivePort?.close();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Access the current detections from Riverpod
    final detectionState = ref.watch(detectionProvider);

    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Layer 1: The Camera Feed
          CameraPreview(_cameraController!),

          // Layer 2: The Bounding Boxes (The "Painter")
          CustomPaint(
            painter: DetectionPainter(
              detections: detectionState.detections,
              previewSize: _cameraController!.value.previewSize!,
              screenSize: size,
            ),
          ),

          // Layer 3: The Bio-HUD Overlay
          // Corrected from HUDOverlay to HudOverlay to match existing file
          const HudOverlay(
             status: "Scanning...",
             isDetecting: true,
          ), 
          
          // Debug Layer: Inference Speed
          Positioned(
            top: 50, right: 20,
            child: Text(
              "${detectionState.inferenceTime.toStringAsFixed(1)} ms",
              style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}
