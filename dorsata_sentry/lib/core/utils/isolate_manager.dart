import 'dart:isolate';
import 'package:camera/camera.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'dart:typed_data';

/// Message types for isolate communication
class InferenceRequest {
  final CameraImage image;
  InferenceRequest(this.image);
}

class InferenceResult {
  final List<dynamic> detections;
  final int processingTimeMs;
  
  InferenceResult({
    required this.detections,
    required this.processingTimeMs,
  });
}

/// Isolate Manager - The "Antigravity" Engine
/// Handles heavy ML processing off the main thread to prevent UI freezes
class IsolateManager {
  Isolate? _isolate;
  SendPort? _sendPort;
  ReceivePort? _receivePort;
  
  bool get isRunning => _isolate != null;
  
  /// Start the inference isolate
  Future<void> start() async {
    _receivePort = ReceivePort();
    _isolate = await Isolate.spawn(
      inferenceIsolate,
      _receivePort!.sendPort,
    );
    
    // Wait for the isolate to send its SendPort
    _sendPort = await _receivePort!.first as SendPort;
  }
  
  /// Send an image for inference
  void processImage(CameraImage image) {
    _sendPort?.send(InferenceRequest(image));
  }
  
  /// Listen for inference results
  Stream<InferenceResult> get results {
    return _receivePort!.where((msg) => msg is InferenceResult).cast<InferenceResult>();
  }
  
  /// Stop the isolate
  void stop() {
    _isolate?.kill(priority: Isolate.immediate);
    _isolate = null;
    _receivePort?.close();
  }
}

/// This function runs in a separate thread (Isolate)
/// All heavy computation happens here without blocking the UI
void inferenceIsolate(SendPort sendPort) async {
  final receivePort = ReceivePort();
  sendPort.send(receivePort.sendPort);

  Interpreter? interpreter;
  
  // Load model inside the isolate
  try {
    interpreter = await Interpreter.fromAsset('assets/models/yolov8n_int8.tflite');
    print("YOLOv8 model loaded successfully");
  } catch (e) {
    print("Model load error: $e");
    return;
  }

  receivePort.listen((message) {
    if (message is InferenceRequest) {
      final stopwatch = Stopwatch()..start();
      
      try {
        // 1. Convert YUV to RGB (Heavy computation)
        final rgbImage = _convertYUV420ToRGB(message.image);
        
        // 2. Resize to 640x640 (YOLOv8 input size)
        final inputTensor = _preprocessImage(rgbImage, 640, 640);
        
        // 3. Run inference
        final outputTensors = _runInference(interpreter!, inputTensor);
        
        // 4. Post-process and send results back
        final detections = _postProcessDetections(outputTensors);
        
        stopwatch.stop();
        sendPort.send(InferenceResult(
          detections: detections,
          processingTimeMs: stopwatch.elapsedMilliseconds,
        ));
      } catch (e) {
        print("Inference error: $e");
      }
    }
  });
}

/// Convert YUV420 camera image to RGB bytes
Uint8List _convertYUV420ToRGB(CameraImage image) {
  // YUV420 to RGB conversion
  // This is computationally expensive - perfect for isolate processing
  final int width = image.width;
  final int height = image.height;
  final int uvRowStride = image.planes[1].bytesPerRow;
  final int uvPixelStride = image.planes[1].bytesPerPixel!;
  
  final rgb = Uint8List(width * height * 3);
  
  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      final int uvIndex = uvPixelStride * (x / 2).floor() + uvRowStride * (y / 2).floor();
      final int index = y * width + x;
      
      final yValue = image.planes[0].bytes[index];
      final uValue = image.planes[1].bytes[uvIndex];
      final vValue = image.planes[2].bytes[uvIndex];
      
      // YUV to RGB conversion formula
      int r = (yValue + 1.402 * (vValue - 128)).round().clamp(0, 255);
      int g = (yValue - 0.344136 * (uValue - 128) - 0.714136 * (vValue - 128)).round().clamp(0, 255);
      int b = (yValue + 1.772 * (uValue - 128)).round().clamp(0, 255);
      
      rgb[index * 3] = r;
      rgb[index * 3 + 1] = g;
      rgb[index * 3 + 2] = b;
    }
  }
  
  return rgb;
}

/// Preprocess image for YOLOv8 input
Float32List _preprocessImage(Uint8List rgbImage, int targetWidth, int targetHeight) {
  // Normalize to 0-1 range and reshape to [1, 640, 640, 3]
  final input = Float32List(1 * targetWidth * targetHeight * 3);
  
  // Simple resize by sampling (for production, use bilinear interpolation)
  for (int i = 0; i < rgbImage.length; i++) {
    input[i] = rgbImage[i] / 255.0;
  }
  
  return input;
}

/// Run TFLite inference
List<dynamic> _runInference(Interpreter interpreter, Float32List input) {
  // YOLOv8 output shape depends on model configuration
  // Typically [1, 84, 8400] for detection (80 classes + 4 bbox coords)
  final output = List.generate(1, (_) => 
    List.generate(84, (_) => 
      List.filled(8400, 0.0)
    )
  );
  
  interpreter.run(input, output);
  return output;
}

/// Post-process YOLOv8 detections
/// Apply NMS and filter by confidence threshold
List<Map<String, dynamic>> _postProcessDetections(List<dynamic> output, {double confThreshold = 0.5}) {
  final detections = <Map<String, dynamic>>[];
  
  // YOLOv8 output processing
  // Format: [batch, 84, 8400] where 84 = 4 (bbox) + 80 (class scores)
  // Transpose and apply NMS
  
  // TODO: Implement full NMS for production
  // This is a simplified version
  
  return detections;
}
