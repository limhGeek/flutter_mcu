/**
 * @Author: limh
 * @Description:
 * @Date: 2018/9/23 19:58
 */

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePage();
  }
}

class _HomePage extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('论坛'),
        centerTitle: true,
      ),
    );
  }
}
