import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1. The State Class: Holds the list of current detections
class DetectionState {
  final List<Map<String, dynamic>> detections;
  final double inferenceTime; // In milliseconds (for the HUD)

  DetectionState({this.detections = const [], this.inferenceTime = 0});
}

// 2. The Notifier: Updates the state
class DetectionNotifier extends StateNotifier<DetectionState> {
  DetectionNotifier() : super(DetectionState());

  void updateDetections(List<Map<String, dynamic>> newDetections, double time) {
    state = DetectionState(detections: newDetections, inferenceTime: time);
  }
}

// 3. The Provider: Exposes the state to the UI
final detectionProvider = StateNotifierProvider<DetectionNotifier, DetectionState>((ref) {
  return DetectionNotifier();
});
