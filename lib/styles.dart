import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

abstract class Styles {
  static const TextStyle textBold = TextStyle(
    color: Colors.black,
    fontSize: 18,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle productRowTotal = TextStyle(
    color: Color.fromRGBO(0, 0, 0, 0.8),
    fontSize: 18,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle cardH1 = TextStyle(
    color: Colors.white,
    fontSize: 18,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle cardH2 = TextStyle(
    color: Colors.white,
    fontSize: 15,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.normal,
  );
  static const TextStyle cardH3 = TextStyle(
    color: Colors.white,
    fontSize: 10,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle placeH1 = TextStyle(
    color: Colors.black,
    fontSize: 20,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.bold,
  );
  static TextStyle placeRedH1 = TextStyle(
    color: primaryRed,
    fontSize: 20,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle placeH2 = TextStyle(
    color: Colors.black,
    fontSize: 15,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle placeNormal = TextStyle(
    color: Colors.black,
    fontSize: 15,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.normal,
  );
  static TextStyle placeRed = TextStyle(
    color: primaryRed,
    fontSize: 15,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle bold = TextStyle(
    fontWeight: FontWeight.bold,
  );

  static Color primaryRed = Colors.pink[600] as Color;
}
