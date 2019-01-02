import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mcu/bean/User.dart';
import 'package:flutter_mcu/comm/config/Config.dart';
import 'package:flutter_mcu/comm/net/Api.dart';
import 'package:flutter_mcu/comm/redux/AppState.dart';
import 'package:flutter_mcu/comm/redux/ThemeRedux.dart';
import 'package:flutter_mcu/utils/sp_utils.dart';
import 'package:flutter_mcu/view/view_image.dart';
import 'package:flutter_mcu/view/view_login.dart';
import 'package:flutter_mcu/view/view_user.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class MyDrawer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyDrawer();
  }
}

class _MyDrawer extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return StoreBuilder<AppState>(builder: (context, store) {
      ThemeData themeData = store.state.themeData;
      User user = store.state.user;
      return Drawer(
        child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text(
                  null == user || null == user.userName
                      ? '51单片机助手'
                      : user.userName,
                  style: TextStyle(fontSize: 20.0),
                ),
                accountEmail: Text(
                    null == user || user.phone == null
                        ? "用户未登录"
                        : user.phone
                            .replaceAll(user.phone.substring(3, 7), "****"),
                    style: TextStyle(fontSize: 16.0)),
                currentAccountPicture: GestureDetector(
                    child: ClipOval(
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        placeholder: Image.asset(Config.ASSERT_HEAD_DEFAULT),
                        imageUrl: null == user || user.imgUrl == null
                            ? (Api.BaseUrl + "default_head.jpg")
                            : (Api.BaseUrl + user.imgUrl),
                        errorWidget: Image.asset(Config.ASSERT_HEAD_DEFAULT),
                      ),
                    ),
                    onTap: () {
                      _openImage();
                    }),
                decoration: new BoxDecoration(
                  //用一个BoxDecoration装饰器提供背景图片
                  color: themeData.primaryColor,
                ),
              ),
              ListTile(
                title: Text(
                  '个人中心',
                  style: TextStyle(fontSize: 16.0),
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                    return UserInfoPage();
                  }));
                },
              ),
              ListTile(
                title: Text(
                  '我要分享',
                  style: TextStyle(fontSize: 16.0),
                ),
                onTap: () {},
              ),
              ListTile(
                title: Text(
                  '切换主题',
                  style: TextStyle(fontSize: 16.0),
                ),
                onTap: () {
                  _showThemeDialog(context, store);
                },
              ),
              ListTile(
                title: Text(
                  '版本更新',
                  style: TextStyle(fontSize: 16.0),
                ),
                onTap: () {},
              ),
              ListTile(
                title: Text(
                  '关于',
                  style: TextStyle(fontSize: 16.0),
                ),
                onTap: () {},
              ),
              ListTile(
                title: RaisedButton(
                  onPressed: () {},
                  padding: new EdgeInsets.only(
                      left: 20.0, top: 10.0, right: 20.0, bottom: 10.0),
                  color: themeData.errorColor,
                  child: Text(
                    '退出登录',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                onTap: () {
                  print('退出登录');
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return LoginPage();
                  }));
                },
              ),
            ],
          ),
        ),
      );
    });
  }

  _openImage() async {
    User user = await SpUtils.getUser();
    List<String> str = List();
    if (null == user || null == user.imgUrl) {
      str.add('default_head.jpg');
    } else {
      str.add(user.imgUrl);
    }
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return ImagePage(str);
    }));
  }

  _showThemeDialog(BuildContext context, Store store) {
    List<Color> color = Config.getThemeListColor();
    List<String> themeDesc = Config.getThemeDesc();
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: Container(
              height: 400.0,
              padding: new EdgeInsets.all(4.0),
              margin: new EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
              ),
              child: ListView.builder(
                  itemCount: color.length,
                  itemBuilder: (context, index) {
                    return Column(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Container(
                          height: 46.0,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: color[index],
                            borderRadius:
                                BorderRadius.all(Radius.circular(4.0)),
                          ),
                          child: FlatButton(
                            padding: EdgeInsets.all(10),
                            color: Colors.transparent,
                            child: Text(
                              themeDesc[index],
                              style: TextStyle(
                                  color: Colors.white, fontSize: 14.0),
                            ),
                            onPressed: () {
                              SpUtils.saveTheme(index);
                              store.dispatch(RefreshThemeDataAction(ThemeData(
                                  primarySwatch: color[index],
                                  primaryColorBrightness: Brightness.dark)));
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        Divider(
                          color: Colors.white,
                          height: 10.0,
                        )
                      ],
                    );
                  }),
            ),
          );
        });
  }
}
