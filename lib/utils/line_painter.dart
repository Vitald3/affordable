import 'package:flutter/material.dart';
import '../model/chart_point_model.dart';
import 'package:collection/collection.dart';
import 'dimensions.dart';
import 'extension.dart';

class LineChartPainter extends CustomPainter {
  BuildContext context;
  List<List<ChartPointModel>> points;
  LineChartPainter(this.context, this.points);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(0, size.height);
    canvas.scale(1, -1);
    double min = points.map((e) => e.map((e) => e.value).min).min;
    double max = points.map((e) => e.map((e) => e.value).max).max;
    double xFactor = size.width / (points[0].length - 1);
    double yFactor = max == min ? max : max - min;

    if (yFactor.isInfinite) {
      yFactor = Dimensions.regular;
    }

    int index = 0;

    for (var point in points.reversed) {
      index++;
      drawForeground(canvas, xFactor, yFactor, points.length - index, point, min, max, size.height);
    }
  }

  void drawBackground(Canvas canvas, Size size) {
    double xFactor = size.width / (points[0].length - 1);
    double yFactor = size.height / points.map((e) => e.map((p) => p.value).max).max;

    for (int i = 0; i != points[0].length; i++) {
      Paint paint = Paint();

      paint.style = PaintingStyle.stroke;
      paint.strokeWidth = Dimensions.line;
      paint.color = Colors.blueGrey.shade200;

      Path path = Path();

      path.moveTo(i * xFactor, 0);
      path.lineTo(i * xFactor, size.height);
      canvas.drawPath(path, paint);
    }

    double yValueStep = points.map((e) => e.map((p) => p.value).max).max / 10.0;

    for (int i = 0; i != 10 + 1; i++) {
      Paint paint = Paint();

      paint.style = PaintingStyle.stroke;
      paint.strokeWidth = Dimensions.line;
      paint.color = Colors.blueGrey.shade200;

      Path path = Path();

      path.moveTo(0, i * yValueStep * yFactor);
      path.lineTo(size.width, i * yValueStep * yFactor);
      canvas.drawPath(path, paint);
    }
  }

  void drawForeground(Canvas canvas, double xFactor, double yFactor, int index, List<ChartPointModel> point, double min, double max, double height) {
    Paint paint = Paint();

    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = Dimensions.line * 3.0;
    paint.color = getColors(index, reset: true);
    paint.strokeCap = StrokeCap.round;
    paint.strokeJoin = StrokeJoin.round;

    Path path = Path();

    for (int i = 0; i < point.length; i++) {
      double yValue = point[i].value;

      yValue = yFactor == 0 ? 0 : height - ((max - yValue) / yFactor) * height;

      if (i == 0) {
        path.moveTo(0, yValue);
      } else {
        double previousX = (i - 1) * xFactor;
        double previousY = yFactor == 0 ? 0 : height - ((max - point[i - 1].value) / yFactor) * height;
        double x = i * xFactor;
        double controlX = previousX + (x - previousX) / 2.0;
        path.cubicTo(controlX, previousY, controlX, yValue, x, yValue);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}