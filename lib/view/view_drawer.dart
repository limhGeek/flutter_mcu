import 'package:flutter/material.dart';
import 'package:flutter_mcu/comm/config/Config.dart';
import 'package:flutter_mcu/comm/redux/AppState.dart';
import 'package:flutter_mcu/comm/redux/ThemeRedux.dart';
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
      return Drawer(
        child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text(
                  'limh',
                  style: TextStyle(fontSize: 26.0),
                ),
                accountEmail: Text(''),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage(Config.DEGAULT_IMG),
                ),
                decoration: new BoxDecoration(
                  //用一个BoxDecoration装饰器提供背景图片
                  color: themeData.primaryColor,
                ),
              ),
              ListTile(
                title: Text(
                  '问题反馈',
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
                onTap: () {},
              ),
            ],
          ),
        ),
      );
    });
  }

  _showThemeDialog(BuildContext context, Store store) {
    List<Color> color = Config.getThemeListColor();
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
                              '主题',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 14.0),
                            ),
                            onPressed: () {
                              store.dispatch(RefreshThemeDataAction(
                                  ThemeData(primarySwatch: color[index])));
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
