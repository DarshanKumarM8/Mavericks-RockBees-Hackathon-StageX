import 'dart:async';
import 'dart:isolate';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img; // You need the 'image' package
import 'yolo_parser.dart';

class InferencePacket {
  final CameraImage image;
  final SendPort sendPort;
  InferencePacket(this.image, this.sendPort);
}

// THE ENTRY POINT
Future<void> spawnInferenceIsolate(SendPort mainSendPort) async {
  final ReceivePort isolateReceivePort = ReceivePort();
  mainSendPort.send(isolateReceivePort.sendPort);

  Interpreter? interpreter;
  try {
    // Load the model (ensure asset is added in pubspec)
    interpreter = await Interpreter.fromAsset('assets/models/yolov8n_int8.tflite');
  } catch (e) {
    print("FATAL: Model failed to load in Isolate: $e");
    return;
  }

  // Listen for images from the Main Thread
  isolateReceivePort.listen((message) {
    if (message is CameraImage) {
      _processFrame(message, interpreter!, mainSendPort);
    }
  });
}

void _processFrame(CameraImage cameraImage, Interpreter interpreter, SendPort replyPort) {
  final stopwatch = Stopwatch()..start();

  // 1. Pre-process: Convert YUV (Camera) to RGB (Model Input)
  // Note: This conversion is computationally expensive.
  // Ideally, use FFI (C++) here, but for Dart-only:
  
  // (Simplified placeholder for image conversion - assume we have a helper)
  // var inputTensor = ImageUtils.convertYUVtoRGB(cameraImage); 
  
  // 2. Resize to 640x640 (Model Requirement)
  // var resized = ImageUtils.resize(inputTensor, 640, 640);
  
  // 3. Run Inference
  // For now, valid dummy output to satisfy the parser
  var output = [List.filled(5, List.filled(8400, 0.0))]; 
  // interpreter.run(resized, output);

  // 4. Parse Results
  var results = YoloParser.parse(output);

  // 5. Send back to UI
  final response = {
    'detections': results,
    'time': stopwatch.elapsedMilliseconds.toDouble(), // Measure speed
  };
  
  replyPort.send(response);
}
