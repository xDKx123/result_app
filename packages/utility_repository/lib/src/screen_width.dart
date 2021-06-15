import 'dart:async';

enum ScreenWidthStatus {ExtraSmall, Small, Medium, Large}

class ScreenWidth {
  static const int ExtraSmallMax = 768;
  static const int SmallMin = 768;
  static const int MediumMin = 992;
  static const int LargeAbove = 1200;

  static ScreenWidthStatus determineScreen(double size) {
    if (size < ExtraSmallMax) {
      return ScreenWidthStatus.ExtraSmall;
    }
    else if (SmallMin < size && size < MediumMin) {
      return ScreenWidthStatus.Small;
    }
    else if (MediumMin < size && size < LargeAbove) {
      return ScreenWidthStatus.Medium;
    }
    else {
      return ScreenWidthStatus.Large;
    }
  }
}