// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'safety_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$safetyStatusHash() => r'b09e7fb934132ce60dd331616f9874d0c5d346d8';

/// Safety Status Provider - Connects Senses to Brain
/// Monitors audio (hiss detection) and visual (optical flow) inputs
/// to determine colony agitation state
///
/// Copied from [SafetyStatus].
@ProviderFor(SafetyStatus)
final safetyStatusProvider =
    AutoDisposeNotifierProvider<SafetyStatus, String>.internal(
      SafetyStatus.new,
      name: r'safetyStatusProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$safetyStatusHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SafetyStatus = AutoDisposeNotifier<String>;
String _$detailedSafetyStatusHash() =>
    r'c5fa886b5840ccff6662e555409e691a602f30f6';

/// Extended safety state with more details
///
/// Copied from [DetailedSafetyStatus].
@ProviderFor(DetailedSafetyStatus)
final detailedSafetyStatusProvider =
    AutoDisposeNotifierProvider<DetailedSafetyStatus, SafetyState>.internal(
      DetailedSafetyStatus.new,
      name: r'detailedSafetyStatusProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$detailedSafetyStatusHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$DetailedSafetyStatus = AutoDisposeNotifier<SafetyState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
