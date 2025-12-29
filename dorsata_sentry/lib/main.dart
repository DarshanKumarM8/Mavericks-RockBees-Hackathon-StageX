import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dorsata_sentry/features/colony_detection/presentation/screens/scout_screen.dart';

import 'package:camera/camera.dart';

late List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(const ProviderScope(child: DorsataSentryApp()));
}

/// DorsataSentry - Bee Colony Detection App
/// Uses YOLOv8 for real-time colony detection with a Bio-Tech HUD interface
class DorsataSentryApp extends StatelessWidget {
  const DorsataSentryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dorsata Sentry',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFF00FF88),
          secondary: const Color(0xFFFFAA00),
          surface: Colors.black,
        ),
        scaffoldBackgroundColor: Colors.black,
        fontFamily: 'monospace',
      ),
      home: const ScoutScreen(),
    );
  }
}
