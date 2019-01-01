import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mcu/bean/Token.dart';
import 'package:flutter_mcu/bean/User.dart';
import 'package:flutter_mcu/comm/net/Api.dart';
import 'package:flutter_mcu/comm/net/Http.dart';
import 'package:flutter_mcu/comm/redux/AppState.dart';
import 'package:flutter_mcu/comm/redux/UserRedux.dart';
import 'package:flutter_mcu/utils/sp_utils.dart';
import 'package:flutter_mcu/utils/toast_utils.dart';
import 'package:flutter_mcu/view/view_register.dart';
import 'package:flutter_mcu/widget/view_loading.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginPage();
  }
}

class _LoginPage extends State<LoginPage> {
  static const leftRightPadding = 30.0;
  static const topBottomPadding = 4.0;
  var _userPassController = new TextEditingController();
  var _userNameController = new TextEditingController();
  static const LOGO = "images/ic_launcher.png";
  bool _isLoading = false;
  int lastTime = 0;

  @override
  void initState() {
    super.initState();
    initParams();
  }

  initParams() async {
    User user = await SpUtils.getUser();
    if (null != user)
      _userNameController.value = new TextEditingValue(text: user.phone ?? "");
  }

  @override
  Widget build(BuildContext context) {
    return StoreBuilder<AppState>(
      builder: (context, store) {
        return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text('登录'),
            ),
            body: ProgressDialog(
              loading: _isLoading,
              msg: '登录中...',
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new Container(
                    margin: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                    child: new Image.asset(
                      LOGO,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  Padding(
                    padding: new EdgeInsets.fromLTRB(leftRightPadding, 20.0,
                        leftRightPadding, topBottomPadding),
                    child: new TextField(
                      controller: _userNameController,
                      decoration: new InputDecoration(hintText: "请输入手机号"),
                      obscureText: false,
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                  Padding(
                    padding: new EdgeInsets.fromLTRB(leftRightPadding, 20.0,
                        leftRightPadding, topBottomPadding),
                    child: new TextField(
                      controller: _userPassController,
                      decoration: new InputDecoration(hintText: "请输入密码"),
                      obscureText: true,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      InkWell(
                        child: Container(
                          child: Text(
                            '注册',
                          ),
                          padding: EdgeInsets.fromLTRB(
                              leftRightPadding, 10.0, leftRightPadding, 10.0),
                        ),
                        onTap: () => Navigator.push(context,
                                MaterialPageRoute(builder: (_) {
                              return RegisterPage();
                            })),
                      ),
                      Expanded(
                        child: Text(''),
                        flex: 1,
                      ),
                      InkWell(
                        child: Container(
                          child: Text(
                            '忘记密码',
                          ),
                          padding: EdgeInsets.fromLTRB(
                              leftRightPadding, 10.0, leftRightPadding, 10.0),
                        ),
                        onTap: () {
                          //TODO 忘记密码
                        },
                      ),
                    ],
                  ),
                  new Container(
                    width: 360.0,
                    margin: new EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0.0),
                    padding: new EdgeInsets.fromLTRB(leftRightPadding,
                        topBottomPadding, leftRightPadding, topBottomPadding),
                    child: new Card(
                      color: Theme.of(context).primaryColor,
                      elevation: 6.0,
                      child: new FlatButton(
                          onPressed: () {
                            _postLogin(_userNameController.text,
                                _userPassController.text, store);
                          },
                          child: new Padding(
                            padding: new EdgeInsets.all(10.0),
                            child: new Text(
                              '马上登录',
                              style: TextStyle(
                                  color: Theme.of(context).canvasColor),
                            ),
                          )),
                    ),
                  )
                ],
              ),
            ));
      },
    );
  }


  void _postLogin(String phone, String password, Store store) async {
    if (phone.isEmpty || password.isEmpty) {
      Toast.show(context, "手机号或密码不能为空");
      return;
    }
    setState(() {
      _isLoading = true;
    });
    Map<String, String> params = {'phone': phone, 'password': password};

    Http.post(Api.URL_LOGIN,
        successCallBack: (data) async {
          SpUtils.saveToken(json.encode(data));
          Token token = await SpUtils.getToken();
          _getUserInfo(token, store);
        },
        params: params,
        errorCallBack: (errorMsg) {
          Toast.show(context, errorMsg.toString());
          setState(() {
            _isLoading = false;
          });
        });
  }

  void _getUserInfo(Token token, Store store) {
    print('Token=' + token.toString());
    Http.get(Api.URL_USERINFO,
        successCallBack: (data) {
          setState(() {
            _isLoading = false;
          });
          SpUtils.saveUser(json.encode(data));
          SpUtils.getUser().then((user) {
            store.dispatch(UpdateUserAction(user));
            Navigator.pushReplacementNamed(context, "/");
            Toast.show(context, "登录成功");
          });
        },
        header: {'Token': token.token},
        errorCallBack: (errorMsg) {
          Toast.show(context, errorMsg.toString());
          setState(() {
            _isLoading = false;
          });
        });
  }
}
