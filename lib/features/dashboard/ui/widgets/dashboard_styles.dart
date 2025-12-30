import 'package:flutter/material.dart';

class DashboardStyles {
  // Spacing
  static const double page = 24;
  static const double section = 24;
  static const double cardGap = 16;
  static const double itemGap = 12;

  // Radius
  static const double cardRadius = 14;
  static const double chipRadius = 20;

  // Shadow (unified)
  static const List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Color(0x14000000),
      blurRadius: 14,
      offset: Offset(0, 8),
    ),
  ];

  // Typography
  static const TextStyle h1 = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    height: 1.2,
  );

  static const TextStyle h2 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    height: 1.3,
  );

  static const TextStyle valueXL = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    height: 1.2,
  );

  static const TextStyle valueL = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle label = TextStyle(
    fontSize: 12,
    color: Colors.grey,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 11,
    color: Colors.grey,
  );
}
