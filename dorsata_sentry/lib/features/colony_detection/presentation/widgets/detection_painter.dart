import 'package:flutter/material.dart';

class DetectionPainter extends CustomPainter {
  final List<Map<String, dynamic>> detections;
  final Size previewSize; // Camera resolution (e.g., 640x480)
  final Size screenSize;  // Phone screen size

  DetectionPainter({
    required this.detections, 
    required this.previewSize, 
    required this.screenSize
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint borderPaint = Paint()
      ..color = const Color(0xFFFFC107) // Apis Gold
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    final Paint bgPaint = Paint()
      ..color = const Color(0xFFFFC107).withOpacity(0.2)
      ..style = PaintingStyle.fill;

    // Calculate scaling factors to map Camera coords to Screen coords
    double scaleX = screenSize.width / previewSize.height; // Flipped because of portrait mode
    double scaleY = screenSize.height / previewSize.width;

    for (var detection in detections) {
      final List<double> rect = detection['rect']; // [x, y, w, h]
      
      // Convert normalized YOLO coords (0-640) to Screen Coords
      // Note: This math depends heavily on your resize logic in Step 2.
      // Assuming rect is in 640x640 space:
      
      double left = rect[0] * scaleX;
      double top = rect[1] * scaleY;
      double width = rect[2] * scaleX;
      double height = rect[3] * scaleY;

      final Rect drawRect = Rect.fromLTWH(left, top, width, height);

      canvas.drawRect(drawRect, bgPaint);
      canvas.drawRect(drawRect, borderPaint);
      
      // Draw Label
      _drawText(canvas, "${detection['label']} ${(detection['confidence']*100).toInt()}%", left, top);
    }
  }
  
  void _drawText(Canvas canvas, String text, double x, double y) {
    TextSpan span = TextSpan(
      style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
      text: text,
    );
    TextPainter tp = TextPainter(
      text: span, 
      textAlign: TextAlign.left, 
      textDirection: TextDirection.ltr
    );
    tp.layout();
    
    // Draw background for text
    canvas.drawRect(
      Rect.fromLTWH(x, y - 20, tp.width + 10, 20), 
      Paint()..color = const Color(0xFFFFC107)
    );
    
    tp.paint(canvas, Offset(x + 5, y - 18));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
