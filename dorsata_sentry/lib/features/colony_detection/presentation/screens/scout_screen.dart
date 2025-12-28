import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:dorsata_sentry/features/colony_detection/presentation/widgets/hud_overlay.dart';
import 'package:dorsata_sentry/core/utils/isolate_manager.dart';

/// ScoutScreen - The main camera view for colony detection
/// Combines the camera preview ("The Eye") with the data overlay ("The Data Layer")
class ScoutScreen extends StatefulWidget {
  const ScoutScreen({super.key});
  
  @override
  State<ScoutScreen> createState() => _ScoutScreenState();
}

class _ScoutScreenState extends State<ScoutScreen> with WidgetsBindingObserver {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isInitialized = false;
  bool _isDetecting = false;
  
  // The Antigravity Engine
  final IsolateManager _isolateManager = IsolateManager();
  
  // Detection state
  int _detectionCount = 0;
  double _fps = 0.0;
  String _status = "Initializing...";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    _isolateManager.stop();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_controller == null || !_controller!.value.isInitialized) return;
    
    if (state == AppLifecycleState.inactive) {
      _controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras == null || _cameras!.isEmpty) {
        setState(() => _status = "No cameras available");
        return;
      }

      _controller = CameraController(
        _cameras!.first,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.yuv420,
      );

      await _controller!.initialize();
      
      // Start the Antigravity Engine
      await _isolateManager.start();
      
      if (mounted) {
        setState(() {
          _isInitialized = true;
          _status = "Ready";
        });
      }
    } catch (e) {
      setState(() => _status = "Camera error: $e");
    }
  }

  void _startDetection() async {
    if (_controller == null || !_controller!.value.isInitialized) return;
    if (_isDetecting) return;
    
    setState(() {
      _isDetecting = true;
      _status = "Scanning...";
    });

    await _controller!.startImageStream((CameraImage image) {
      // Send frame to isolate for processing
      _isolateManager.processImage(image);
    });

    // Listen for results from the isolate
    _isolateManager.results.listen((result) {
      if (mounted) {
        setState(() {
          _detectionCount = result.detections.length;
          _fps = 1000 / result.processingTimeMs;
        });
      }
    });
  }

  void _stopDetection() async {
    if (!_isDetecting) return;
    
    await _controller?.stopImageStream();
    setState(() {
      _isDetecting = false;
      _status = "Paused";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // The Eye - Camera Preview
          _buildCameraPreview(),
          
          // The Data Layer - HUD Overlay
          HudOverlay(
            fps: _fps,
            detectionCount: _detectionCount,
            status: _status,
            isDetecting: _isDetecting,
          ),
          
          // Control Button
          _buildControlButton(),
        ],
      ),
    );
  }

  Widget _buildCameraPreview() {
    if (!_isInitialized || _controller == null) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: CircularProgressIndicator(
            color: Color(0xFF00FF88),
          ),
        ),
      );
    }

    return SizedBox.expand(
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: _controller!.value.previewSize!.height,
          height: _controller!.value.previewSize!.width,
          child: CameraPreview(_controller!),
        ),
      ),
    );
  }

  Widget _buildControlButton() {
    return Positioned(
      bottom: 40,
      left: 0,
      right: 0,
      child: Center(
        child: GestureDetector(
          onTap: _isDetecting ? _stopDetection : _startDetection,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF00FF88),
                width: 3,
              ),
              color: _isDetecting 
                ? const Color(0xFF00FF88).withValues(alpha: 0.3)
                : Colors.transparent,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00FF88).withValues(alpha: 0.4),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Icon(
              _isDetecting ? Icons.stop : Icons.play_arrow,
              color: const Color(0xFF00FF88),
              size: 40,
            ),
          ),
        ),
      ),
    );
  }
}
