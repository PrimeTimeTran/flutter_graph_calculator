import 'dart:math';
import 'dart:ui';

import 'package:graph_calculator/models/models.dart';

/// Represents a mathematical function that can be drawn on a graph.
class GraphFunction {
  // The mathematical function to be plotted.
  Function(double enter) function;

  // The paint used to define the drawing style (color, etc.).
  Paint paint = Paint()..style = PaintingStyle.stroke;

  /// Creates a [GraphFunction] with the specified mathematical [function] and [color].
  GraphFunction({
    required this.function,
    required Color color,
  }) {
    paint.color = color;
  }

  /// Draws the graph of the function on the given [canvas] with the provided [size] and [graph] settings.
  void draw(Canvas canvas, Size size, Graph graph) {
    // Pre-calculate constants
    final double leftLimit =
        -((size.width / 2) - graph.focusPoint.x) / graph.gridStep;
    final double rightLimit =
        ((size.width / 2) + graph.focusPoint.x) / graph.gridStep;
    final double halfHeight = size.height / 2;

    // Pre-compute points
    final List<Offset> precomputedPoints = [];
    for (double i = leftLimit; i < rightLimit; i += 0.005) {
      final double y = function(i) * graph.gridStep;
      precomputedPoints.add(Offset(i * graph.gridStep, -y));
    }

    List<Offset> path = [];
    bool isContinue = false;
    int counter = 1;
    for (var point in precomputedPoints) {
      // Combine checks for visibility
      if (point.dy.abs() < halfHeight) {
        if (!isContinue) {
          // No need to check for negative counter
          path.add(precomputedPoints.elementAt(max(0, counter - 2)));
          isContinue = true;
        }
        path.add(point);
      } else {
        if (isContinue) {
          path.add(point);
          isContinue = false;
          canvas.drawPoints(PointMode.polygon, path, paint);
          path = [];
        }
      }
      counter++;
    }
    // Draw the last path if any
    if (isContinue) {
      canvas.drawPoints(PointMode.polygon, path, paint);
    }
  }
}
