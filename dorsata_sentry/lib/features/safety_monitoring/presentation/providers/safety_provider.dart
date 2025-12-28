import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'safety_provider.g.dart';

/// Safety Status Provider - Connects Senses to Brain
/// Monitors audio (hiss detection) and visual (optical flow) inputs
/// to determine colony agitation state
@riverpod
class SafetyStatus extends _$SafetyStatus {
  @override
  String build() {
    return "SAFE";
  }

  /// Update based on audio analysis
  /// Logic from PDF: If Hiss Energy > threshold, bees are agitated
  void updateAudioLevel(double decibels) {
    // Hiss detection threshold: -10 dB indicates high-frequency content
    if (decibels > -10.0) { 
      state = "HISS DETECTED";
    } else if (state == "HISS DETECTED") {
      // Reset to safe if no longer hissing
      state = "SAFE";
    }
  }

  /// Update based on optical flow analysis
  /// Logic from PDF: If Flow > 0.3 m/s, colony is shimmering (agitated)
  void updateVisualFlow(double magnitude) {
    if (magnitude > 0.3) {
      state = "SHIMMERING (AGITATED)";
    } else if (state == "SHIMMERING (AGITATED)") {
      // Reset to safe if no longer shimmering
      state = "SAFE";
    }
  }

  /// Combined safety check
  void checkSafetyConditions({
    required double audioLevel,
    required double flowMagnitude,
  }) {
    if (flowMagnitude > 0.3) {
      state = "SHIMMERING (AGITATED)";
    } else if (audioLevel > -10.0) {
      state = "HISS DETECTED";
    } else {
      state = "SAFE";
    }
  }

  /// Force reset to safe state
  void reset() {
    state = "SAFE";
  }
}

/// Enum for more type-safe status handling
enum SafetyLevel {
  safe("SAFE", 0),
  hissDetected("HISS DETECTED", 1),
  shimmering("SHIMMERING (AGITATED)", 2),
  danger("DANGER - RETREAT", 3);

  final String displayName;
  final int severity;
  
  const SafetyLevel(this.displayName, this.severity);
}

/// Extended safety state with more details
@riverpod
class DetailedSafetyStatus extends _$DetailedSafetyStatus {
  @override
  SafetyState build() {
    return SafetyState(
      level: SafetyLevel.safe,
      audioLevel: 0.0,
      flowMagnitude: 0.0,
      lastUpdate: DateTime.now(),
    );
  }

  void update({
    double? audioLevel,
    double? flowMagnitude,
  }) {
    final newAudioLevel = audioLevel ?? state.audioLevel;
    final newFlowMagnitude = flowMagnitude ?? state.flowMagnitude;
    
    SafetyLevel newLevel = SafetyLevel.safe;
    
    if (newFlowMagnitude > 0.5) {
      newLevel = SafetyLevel.danger;
    } else if (newFlowMagnitude > 0.3) {
      newLevel = SafetyLevel.shimmering;
    } else if (newAudioLevel > -10.0) {
      newLevel = SafetyLevel.hissDetected;
    }

    state = SafetyState(
      level: newLevel,
      audioLevel: newAudioLevel,
      flowMagnitude: newFlowMagnitude,
      lastUpdate: DateTime.now(),
    );
  }
}

/// Immutable safety state object
class SafetyState {
  final SafetyLevel level;
  final double audioLevel;
  final double flowMagnitude;
  final DateTime lastUpdate;

  const SafetyState({
    required this.level,
    required this.audioLevel,
    required this.flowMagnitude,
    required this.lastUpdate,
  });

  bool get isSafe => level == SafetyLevel.safe;
  bool get isDangerous => level.severity >= 2;
}
