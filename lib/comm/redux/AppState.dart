import 'package:flutter/material.dart';
import 'ThemeRedux.dart';

class AppState {
  ThemeData themeData;

  AppState({this.themeData});

}
AppState appReducer(AppState config, action) {
  return AppState(themeData: ThemeDataReduer(config.themeData, action));
}
