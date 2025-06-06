import 'dart:math';
import 'package:flutter/material.dart';

class HexagonPathBuilder {
  final HexagonType type;
  final bool inBounds;
  final double borderRadius;

  ///
  HexagonPathBuilder(this.type, {this.inBounds = true, this.borderRadius = 0}) : assert(borderRadius >= 0);

  /// Builds hexagon shaped path in given size.
  Path build(Size size) => _hexagonPath(size);

  Point<double> _flatHexagonCorner(Offset center, double size, int i) {
    var angleDeg = 60 * i + 90; // Add 90 degrees to rotate 90 degrees to the right
    var angleRad = pi / 180 * angleDeg;
    return Point(center.dx + size * cos(angleRad), center.dy + size * sin(angleRad));
  }

  Point<double> _pointyHexagonCorner(Offset center, double size, int i) {
    var angleDeg = 60 * i - 30 + 90; // Add 90 degrees to rotate 90 degrees to the right
    var angleRad = pi / 180 * angleDeg;
    return Point(center.dx + size * cos(angleRad), center.dy + size * sin(angleRad));
  }

  /// Calculates hexagon corners for given size and center.
  List<Point<double>> _flatHexagonCornerList(Offset center, double size) => List<Point<double>>.generate(
        6,
        (index) => _flatHexagonCorner(center, size, index),
        growable: false,
      );

  /// Calculates hexagon corners for given size and center.
  List<Point<double>> _pointyHexagonCornerList(Offset center, double size) => List<Point<double>>.generate(
        6,
        (index) => _pointyHexagonCorner(center, size, index),
        growable: false,
      );

  Point<double> _pointBetween(Point<double> start, Point<double> end, {double? distance, double? fraction}) {
    double xLength = end.x - start.x;
    double yLength = end.y - start.y;
    if (fraction == null) {
      if (distance == null) {
        throw Exception('Distance or fraction should be specified.');
      }
      double length = sqrt(xLength * xLength + yLength * yLength);
      fraction = distance / length;
    }
    return Point(start.x + xLength * fraction, start.y + yLength * fraction);
  }

  Point<double> _radiusStart(Point<double> corner, int index, List<Point<double>> cornerList, double radius) {
    var prevCorner = index > 0 ? cornerList[index - 1] : cornerList[cornerList.length - 1];
    double distance = radius * tan(pi / 6);
    return _pointBetween(corner, prevCorner, distance: distance);
  }

  Point<double> _radiusEnd(Point<double> corner, int index, List<Point<double>> cornerList, double radius) {
    var nextCorner = index < cornerList.length - 1 ? cornerList[index + 1] : cornerList[0];
    double distance = radius * tan(pi / 6);
    return _pointBetween(corner, nextCorner, distance: distance);
  }

  /// Returns path in shape of hexagon.
  Path _hexagonPath(Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    List<Point<double>> cornerList;
    if (type == HexagonType.FLAT) {
      cornerList = _flatHexagonCornerList(center, size.width / type.flatFactor(inBounds) / 2);
    } else {
      cornerList = _pointyHexagonCornerList(center, size.height / type.pointyFactor(inBounds) / 2);
    }

    final path = Path();
    if (borderRadius > 0) {
      var rStart;
      var rEnd;
      cornerList.asMap().forEach((index, point) {
        rStart = _radiusStart(point, index, cornerList, borderRadius);
        rEnd = _radiusEnd(point, index, cornerList, borderRadius);
        if (index == 0) {
          path.moveTo(rStart.x, rStart.y);
        } else {
          path.lineTo(rStart.x, rStart.y);
        }
        // rough approximation of an circular arc for 120 deg angle.
        var control1 = _pointBetween(rStart, point, fraction: 0.7698);
        var control2 = _pointBetween(rEnd, point, fraction: 0.7698);
        path.cubicTo(
          control1.x,
          control1.y,
          control2.x,
          control2.y,
          rEnd.x,
          rEnd.y,
        );
      });
    } else {
      cornerList.asMap().forEach((index, point) {
        if (index == 0) {
          path.moveTo(point.x, point.y);
        } else {
          path.lineTo(point.x, point.y);
        }
      });
    }

    return path..close();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HexagonPathBuilder &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          inBounds == other.inBounds &&
          borderRadius == other.borderRadius;

  @override
  int get hashCode => type.hashCode ^ inBounds.hashCode ^ borderRadius.hashCode;

  void paintHexagon(Canvas canvas, Size size, Color borderColor, double borderWidth) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth
      ..color = borderColor;

    final path = _hexagonPath(size);
    canvas.drawPath(path, paint);
  }
}

enum HexagonType { FLAT, POINTY }

extension HexagonTypeExtension on HexagonType {
  static double _ratioPointy = (sqrt(3) / 2);
  static double _ratioFlat = 1 / _ratioPointy;

  /// Hexagon width to height ratio
  double get ratio {
    if (isFlat) return _ratioFlat;
    return _ratioPointy;
  }

  /// Returns true for POINTY;
  bool get isPointy => this == HexagonType.POINTY;

  /// Returns true for FLAT;
  bool get isFlat => this == HexagonType.FLAT;

  double flatFactor(bool inBounds) => (isFlat && inBounds == false) ? 0.75 : 1;

  double pointyFactor(bool inBounds) => (isPointy && inBounds == false) ? 0.75 : 1;
}

class HexagonPainter extends CustomPainter {
  HexagonPainter(this.pathBuilder, {this.color, this.elevation = 0});

  final HexagonPathBuilder pathBuilder;
  final double elevation;
  final Color? color;

  final Paint _paint = Paint();
  Path? _path;

  @override
  void paint(Canvas canvas, Size size) {
    _paint.color = color ?? Colors.white;
    _paint.isAntiAlias = true;
    _paint.style = PaintingStyle.fill;

    Path path = pathBuilder.build(size);
    _path = path;

    if ((elevation) > 0) canvas.drawShadow(path, Colors.black, elevation, false);

    canvas.drawPath(path, _paint);
  }

  @override
  bool hitTest(Offset position) {
    return _path?.contains(position) ?? false;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HexagonPainter &&
          runtimeType == other.runtimeType &&
          pathBuilder == other.pathBuilder &&
          elevation == other.elevation &&
          color == other.color;

  @override
  int get hashCode => pathBuilder.hashCode ^ elevation.hashCode ^ color.hashCode;
}

class HexagonClipper extends CustomClipper<Path> {
  HexagonClipper(this.pathBuilder);

  final HexagonPathBuilder pathBuilder;

  @override
  Path getClip(Size size) {
    return pathBuilder.build(size);
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    if (oldClipper is HexagonClipper) {
      return oldClipper.pathBuilder != pathBuilder;
    }
    return true;
  }
}
