import 'package:flutter/widgets.dart';

class AppSpacing {
  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;

  static const EdgeInsets page = EdgeInsets.all(md);
  static const EdgeInsets card = EdgeInsets.all(sm);
  static const EdgeInsets listTile = EdgeInsets.symmetric(
    horizontal: md,
    vertical: xs,
  );
}
