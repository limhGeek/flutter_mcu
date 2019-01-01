import 'package:flutter/material.dart';
import 'package:flutter_mcu/comm/net/Api.dart';
import 'package:flutter_mcu/comm/net/Http.dart';
import 'package:flutter_mcu/utils/sp_utils.dart';
import 'package:flutter_mcu/utils/toast_utils.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RegisterPage();
  }
}

class _RegisterPage extends State<RegisterPage> {
  var textTips = new TextStyle(fontSize: 16.0, color: Colors.black);
  var hintTips = new TextStyle(fontSize: 15.0, color: Colors.black26);
  var _userNameController = new TextEditingController();
  var _userPassController = new TextEditingController();
  var _truePassController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('注册'),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 40, 30.0, 0),
            child: TextField(
              controller: _userNameController,
              decoration: new InputDecoration(hintText: "请输入手机号"),
              obscureText: false,
              keyboardType: TextInputType.phone,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 20, 30.0, 0),
            child: TextField(
              controller: _userPassController,
              decoration: new InputDecoration(hintText: "请输入密码"),
              obscureText: true,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 20, 30.0, 0),
            child: TextField(
              controller: _truePassController,
              decoration: new InputDecoration(hintText: "请确认密码"),
              obscureText: true,
            ),
          ),
          new Container(
            width: 360.0,
            margin: new EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 0.0),
            padding: new EdgeInsets.fromLTRB(20.0, 4, 20.0, 4),
            child: new Card(
              elevation: 6.0,
              color: Theme.of(context).primaryColor,
              child: new FlatButton(
                  onPressed: () {
                    _postRegister(_userNameController.text,
                        _userPassController.text, _truePassController.text);
                  },
                  child: new Padding(
                    padding: new EdgeInsets.all(10.0),
                    child: new Text(
                      '马上注册',
                      style: TextStyle(color: Theme.of(context).indicatorColor),
                    ),
                  )),
            ),
          )
        ],
      ),
    );
  }

  void _postRegister(String phone, String password1, String password2) async {
    if (phone.isEmpty || password1.isEmpty || password2.isEmpty) {
      Toast.show(context, "用户名或密码不能为空");
      return;
    }
    if (password1.compareTo(password2) != 0) {
      Toast.show(context, "两次输入密码不一致");
      return;
    }
    Http.post(Api.URL_REGISTER,
        successCallBack: (data) {
          SpUtils.saveToken(data);
          SpUtils.getToken().then((token) {
            Toast.show(context, "注册成功");
            Navigator.pushReplacementNamed(context, "/");
          });
        },
        params: {'phone': phone, 'password': password1},
        errorCallBack: (errorMsg) {
          Toast.show(context, errorMsg);
        });
  }
}
