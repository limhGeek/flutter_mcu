/**
 * @Author: limh
 * @Description:
 * @Date: 2018/9/23 19:58
 */

import 'package:flutter/material.dart';
import 'package:flutter_mcu/comm/net/Api.dart';
import 'package:flutter_mcu/comm/net/Http.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePage();
  }
}

class _HomePage extends State<HomePage> {
  int pageNum = 1;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('论坛'),
        centerTitle: true,
      ),
//      body: ,
    );
  }

  Future<Null> _getData() async {
    Http.get(Api.URL_TOPICS + '/$pageNum', successCallBack: (data) {
      print(data);
    }, errorCallBack: (errorMsg) {});
  }
}
