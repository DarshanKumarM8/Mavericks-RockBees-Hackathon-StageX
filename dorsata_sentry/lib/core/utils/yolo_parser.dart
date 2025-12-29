import 'dart:math';
import 'package:flutter/foundation.dart';

class YoloParser {
  // Config specific to your YOLOv8n model
  static const int _inputSize = 640;
  static const double _confThreshold = 0.50; // 50% confidence required
  static const double _iouThreshold = 0.45;  // Overlap threshold for NMS

  /// Parses the raw output tensor from TFLite into a list of simplified detections
  static List<Map<String, dynamic>> parse(List<dynamic> output) {
    // YOLOv8 Output Shape is usually [1, 5, 8400]
    // 1 Batch, 4 coords + 1 class score, 8400 anchor points
    // We need to transpose this conceptually to iterate easily.
    
    final List<List<double>> candidates = [];
    
    // The output is a flattened array or nested list depending on the plugin.
    // Assuming output[0] is the main tensor:
    final List<dynamic> tensor = output[0]; 
    
    // Iterate through the 8400 anchor points
    for (int i = 0; i < 8400; i++) {
      // Indexing logic depends on your specific TFLite export format (transposed vs not).
      // Standard YOLOv8 export usually needs:
      double score = tensor[4][i]; // Class probability (Bee)
      
      if (score > _confThreshold) {
        double xCenter = tensor[0][i];
        double yCenter = tensor[1][i];
        double width = tensor[2][i];
        double height = tensor[3][i];
        
        candidates.add([xCenter, yCenter, width, height, score]);
      }
    }

    return _nonMaxSuppression(candidates);
  }

  static List<Map<String, dynamic>> _nonMaxSuppression(List<List<double>> boxes) {
    // Sort by confidence (highest first)
    boxes.sort((a, b) => b[4].compareTo(a[4]));

    final List<Map<String, dynamic>> finalDetections = [];

    while (boxes.isNotEmpty) {
      var current = boxes.removeAt(0);
      finalDetections.add({
        'rect': [
          current[0] - current[2] / 2, // xMin
          current[1] - current[3] / 2, // yMin
          current[2],                  // width
          current[3]                   // height
        ],
        'confidence': current[4],
        'label': 'Apis dorsata',
      });

      // Remove boxes that overlap too much with the current one
      boxes.removeWhere((box) => _calculateIoU(current, box) > _iouThreshold);
    }

    return finalDetections;
  }

  static double _calculateIoU(List<double> boxA, List<double> boxB) {
    // Intersection Over Union Math
    double x1 = max(boxA[0] - boxA[2]/2, boxB[0] - boxB[2]/2);
    double y1 = max(boxA[1] - boxA[3]/2, boxB[1] - boxB[3]/2);
    double x2 = min(boxA[0] + boxA[2]/2, boxB[0] + boxB[2]/2);
    double y2 = min(boxA[1] + boxA[3]/2, boxB[1] + boxB[3]/2);

    double intersection = max(0, x2 - x1) * max(0, y2 - y1);
    double boxAArea = boxA[2] * boxA[3];
    double boxBArea = boxB[2] * boxB[3];

    return intersection / (boxAArea + boxBArea - intersection);
  }
}
