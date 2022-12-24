import 'package:flutter/material.dart';

class K {
  Color white = Colors.white;
  Color black = Colors.black;
  Color blue = Colors.blue;

  Widget gap({double size = 0}) {
    return SizedBox(
      height: size,
      width: size,
    );
  }

  BorderRadius roundedCorners({double radius = 16}) {
    return BorderRadius.all(Radius.circular(radius));
  }

  TextStyle style({
    double fontSize = 18,
    Color color = Colors.white,
    FontWeight weight = FontWeight.normal,
  }) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: weight,
    );
  }

  List<BoxShadow> shadows({
    Color color = Colors.grey,
    Offset offset = const Offset(3, 3),
  }) {
    return [
      BoxShadow(
        color: color,
        offset: offset,
        blurRadius: 5,
      )
    ];
  }
}
