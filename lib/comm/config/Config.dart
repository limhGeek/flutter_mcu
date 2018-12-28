import 'package:flutter/material.dart';

class Config {
  static const DEGAULT_IMG =
      "http://img3.duitang.com/uploads/item/201601/14/20160114001813_LTUWP.thumb.700_0.jpeg";

  static List<Color> getThemeListColor() {
    return [
      AppColors.primarySwatch,
      Colors.brown,
      Colors.blue,
      Colors.cyan,
      Colors.green,
      Colors.blueGrey,
      Colors.deepOrange,
    ];
  }

  static List<String> getThemeDesc() {
    return [
      '默认主题',
      '主题1',
      '主题2',
      '主题3',
      '主题4',
      '主题5',
      '主题6',
    ];
  }
}

class AppColors {
  static const String primaryValueString = "#24292E";
  static const String primaryLightValueString = "#42464b";
  static const String primaryDarkValueString = "#121917";
  static const String miWhiteString = "#ececec";
  static const String actionBlueString = "#267aff";
  static const String webDraculaBackgroundColorString = "#282a36";

  static const int primaryValue = 0xFF24292E;
  static const int primaryLightValue = 0xFF42464b;
  static const int primaryDarkValue = 0xFF121917;

  static const int cardWhite = 0xFFFFFFFF;
  static const int textWhite = 0xFFFFFFFF;
  static const int miWhite = 0xffececec;
  static const int white = 0xFFFFFFFF;
  static const int actionBlue = 0xff267aff;
  static const int subTextColor = 0xff959595;
  static const int subLightTextColor = 0xffc4c4c4;

  static const int mainBackgroundColor = miWhite;

  static const int mainTextColor = primaryDarkValue;
  static const int textColorWhite = white;

  static const MaterialColor primarySwatch = const MaterialColor(
    primaryValue,
    const <int, Color>{
      50: const Color(primaryLightValue),
      100: const Color(primaryLightValue),
      200: const Color(primaryLightValue),
      300: const Color(primaryLightValue),
      400: const Color(primaryLightValue),
      500: const Color(primaryValue),
      600: const Color(primaryDarkValue),
      700: const Color(primaryDarkValue),
      800: const Color(primaryDarkValue),
      900: const Color(primaryDarkValue),
    },
  );
}
