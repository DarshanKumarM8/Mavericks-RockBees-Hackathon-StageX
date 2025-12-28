import 'package:flutter/material.dart';
import 'dart:math' as math;

/// HudOverlay - The Bio-Tech Data Layer
/// Displays real-time telemetry data over the camera feed
class HudOverlay extends StatelessWidget {
  final double fps;
  final int detectionCount;
  final String status;
  final bool isDetecting;

  const HudOverlay({
    super.key,
    this.fps = 0.0,
    this.detectionCount = 0,
    this.status = "Initializing...",
    this.isDetecting = false,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          // Corner brackets for tech aesthetic
          _buildCornerBrackets(),
          
          // Top status bar
          _buildTopBar(),
          
          // Side telemetry
          _buildLeftTelemetry(),
          _buildRightTelemetry(),
          
          // Scanning animation
          if (isDetecting) _buildScanLine(),
          
          // Detection markers
          if (detectionCount > 0) _buildDetectionIndicator(),
        ],
      ),
    );
  }

  Widget _buildCornerBrackets() {
    return Stack(
      children: [
        // Top-left bracket
        Positioned(
          top: 20,
          left: 20,
          child: _CornerBracket(corner: CornerPosition.topLeft),
        ),
        // Top-right bracket
        Positioned(
          top: 20,
          right: 20,
          child: _CornerBracket(corner: CornerPosition.topRight),
        ),
        // Bottom-left bracket
        Positioned(
          bottom: 120,
          left: 20,
          child: _CornerBracket(corner: CornerPosition.bottomLeft),
        ),
        // Bottom-right bracket
        Positioned(
          bottom: 120,
          right: 20,
          child: _CornerBracket(corner: CornerPosition.bottomRight),
        ),
      ],
    );
  }

  Widget _buildTopBar() {
    return Positioned(
      top: 50,
      left: 60,
      right: 60,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color(0xFF00FF88).withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Status indicator
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDetecting 
                      ? const Color(0xFF00FF88) 
                      : const Color(0xFFFF6B6B),
                    boxShadow: [
                      BoxShadow(
                        color: (isDetecting 
                          ? const Color(0xFF00FF88) 
                          : const Color(0xFFFF6B6B)).withValues(alpha: 0.5),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  status.toUpperCase(),
                  style: const TextStyle(
                    color: Color(0xFF00FF88),
                    fontSize: 12,
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
            // System label
            const Text(
              'DORSATA SENTRY',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 10,
                fontFamily: 'monospace',
                letterSpacing: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeftTelemetry() {
    return Positioned(
      top: 150,
      left: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TelemetryItem(
            label: 'FPS',
            value: fps.toStringAsFixed(1),
            icon: Icons.speed,
          ),
          const SizedBox(height: 12),
          _TelemetryItem(
            label: 'DETECTIONS',
            value: detectionCount.toString(),
            icon: Icons.hexagon_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildRightTelemetry() {
    final now = DateTime.now();
    return Positioned(
      top: 150,
      right: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _TelemetryItem(
            label: 'TIME',
            value: '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}',
            icon: Icons.access_time,
            alignRight: true,
          ),
          const SizedBox(height: 12),
          _TelemetryItem(
            label: 'MODEL',
            value: 'YOLOv8n',
            icon: Icons.memory,
            alignRight: true,
          ),
        ],
      ),
    );
  }

  Widget _buildScanLine() {
    return const _AnimatedScanLine();
  }

  Widget _buildDetectionIndicator() {
    return Positioned(
      bottom: 140,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFFFAA00).withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFFFFAA00),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.warning_amber,
                color: Color(0xFFFFAA00),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'COLONY DETECTED: $detectionCount',
                style: const TextStyle(
                  color: Color(0xFFFFAA00),
                  fontSize: 14,
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Corner bracket decoration
enum CornerPosition { topLeft, topRight, bottomLeft, bottomRight }

class _CornerBracket extends StatelessWidget {
  final CornerPosition corner;
  
  const _CornerBracket({required this.corner});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: _getRotation(),
      child: CustomPaint(
        size: const Size(40, 40),
        painter: _BracketPainter(),
      ),
    );
  }

  double _getRotation() {
    switch (corner) {
      case CornerPosition.topLeft:
        return 0;
      case CornerPosition.topRight:
        return math.pi / 2;
      case CornerPosition.bottomRight:
        return math.pi;
      case CornerPosition.bottomLeft:
        return -math.pi / 2;
    }
  }
}

class _BracketPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF00FF88).withValues(alpha: 0.8)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(0, size.height * 0.4)
      ..lineTo(0, 0)
      ..lineTo(size.width * 0.4, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Telemetry display item
class _TelemetryItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool alignRight;

  const _TelemetryItem({
    required this.label,
    required this.value,
    required this.icon,
    this.alignRight = false,
  });

  @override
  Widget build(BuildContext context) {
    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!alignRight) ...[
          Icon(icon, color: const Color(0xFF00FF88).withValues(alpha: 0.7), size: 16),
          const SizedBox(width: 8),
        ],
        Column(
          crossAxisAlignment: alignRight 
            ? CrossAxisAlignment.end 
            : CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.5),
                fontSize: 9,
                fontFamily: 'monospace',
                letterSpacing: 1,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                color: Color(0xFF00FF88),
                fontSize: 18,
                fontFamily: 'monospace',
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        if (alignRight) ...[
          const SizedBox(width: 8),
          Icon(icon, color: const Color(0xFF00FF88).withValues(alpha: 0.7), size: 16),
        ],
      ],
    );

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFF00FF88).withValues(alpha: 0.2),
        ),
      ),
      child: content,
    );
  }
}

/// Animated scanning line
class _AnimatedScanLine extends StatefulWidget {
  const _AnimatedScanLine();

  @override
  State<_AnimatedScanLine> createState() => _AnimatedScanLineState();
}

class _AnimatedScanLineState extends State<_AnimatedScanLine>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Positioned(
          top: 100 + (_animation.value * (MediaQuery.of(context).size.height - 250)),
          left: 40,
          right: 40,
          child: Container(
            height: 2,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  const Color(0xFF00FF88).withValues(alpha: 0.8),
                  Colors.transparent,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00FF88).withValues(alpha: 0.5),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
