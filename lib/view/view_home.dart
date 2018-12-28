/**
 * @Author: limh
 * @Description:
 * @Date: 2018/9/23 19:58
 */

import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: Container(
          color: Color.fromARGB(255, 66, 165, 245),
          alignment: AlignmentDirectional(0.0, 0.0),
          child: Container(
            color: Colors.green,
            child: new Text("首页"),
            constraints: BoxConstraints(
                maxHeight: 300.0,
                maxWidth: 200.0,
                minHeight: 150.0,
                minWidth: 150.0),
          ),
        ),
      ),
    );
  }
}
