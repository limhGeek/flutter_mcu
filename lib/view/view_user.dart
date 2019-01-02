import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mcu/bean/User.dart';
import 'package:flutter_mcu/comm/config/Config.dart';
import 'package:flutter_mcu/comm/net/Api.dart';
import 'package:flutter_mcu/comm/redux/AppState.dart';
import 'package:flutter_mcu/view/view_setting.dart';
import 'package:flutter_mcu/widget/sliver_header.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

class UserInfoPage extends StatefulWidget {
  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  @override
  Widget build(BuildContext context) {
    return StoreBuilder<AppState>(builder: (context, store) {
      User user = store.state.user;
      return Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              backgroundColor: Colors.transparent,
              flexibleSpace: _sliverHeader(user),
              expandedHeight: 200.0,
              actions: <Widget>[
                IconButton(icon: Icon(Icons.settings), onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                    return SettingPage();
                  }));
                })
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _sliverHeader(User user) {
    return Stack(
      children: <Widget>[
        CachedNetworkImage(
          width: MediaQuery.of(context).size.width,
          height: 200.0,
          fit: BoxFit.cover,
          placeholder: Image.asset(Config.ASSERT_HEAD_DEFAULT),
          imageUrl: null == user || user.imgUrl == null
              ? (Api.BaseUrl + "default_head.jpg")
              : (Api.BaseUrl + user.imgUrl),
          errorWidget: Image.asset(Config.ASSERT_HEAD_DEFAULT),
        ),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
          child: Container(
            color: Colors.white.withOpacity(0.3),
            width: MediaQuery.of(context).size.width,
            height: 200.0,
          ),
        ),
        Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ClipOval(
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                width: 72.0,
                height: 72.0,
                placeholder: Image.asset(Config.ASSERT_HEAD_DEFAULT),
                imageUrl: null == user || user.imgUrl == null
                    ? (Api.BaseUrl + "default_head.jpg")
                    : (Api.BaseUrl + user.imgUrl),
                errorWidget: Image.asset(Config.ASSERT_HEAD_DEFAULT),
              ),
            ),
            Text(
              null == user || user.userName == null ? "|" : user.userName,
              style: TextStyle(
                  fontSize: 20.0, color: Theme.of(context).canvasColor),
            ),
          ],
        )),
      ],
    );
  }
}
