import 'package:flutter/material.dart';

class Config {
  static const ROUTER_TPINFO = "tpinfo";

  static const ASSERT_HEAD_DEFAULT = "images/default_head.jpg";
  static const ASSERT_PIC_ADD = "images/pic_add.png";
  static const ASM_INFO =
      '符号 含义：\n1、Rn R0～R7寄存器n=0～7。\n2、Direct 直接地址,内部数据区的地址RAM(00H～7FH)。\n3、SFR(80H～FFH) B,ACC,PSW,IP,P3,IE,P2,SCON,P1,TCON,P0。\n4、@Ri 间接地址Ri=R0或R1;8051/31RAM地址(00H～7FH);8052/32RAM地址(00H～FFH)。\n5、#data 8位常数。\n6、#data16 16位常数。\n7、Addr16 16位的目标地址。\n8、Addr11 11位的目标地址。\n9、Rel 相关地址。\n10、bit 内部数据RAM(20H～2FH),特殊功能寄存器的直接地址的位';
  static const HTML_HEAD = '''
  <!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>tttt</title>
</head>
<body>
dddd
</body>
</html>
  ''';

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
