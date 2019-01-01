import 'package:flutter/material.dart';
import 'package:flutter_mcu/bean/User.dart';

import 'ThemeRedux.dart';
import 'UserRedux.dart';

class AppState {
  ThemeData themeData;
  User user;

  AppState({this.themeData, this.user});
}

AppState appReducer(AppState config, action) {
  return AppState(
      themeData: ThemeDataReduer(config.themeData, action),
      user: UserReducer(config.user, action));
}
