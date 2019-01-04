/**
 * @Author: limh
 * @Description:
 * @Date: 2018/9/23 20:06
 */

import 'package:flutter/material.dart';

class StudyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(
          Icons.ac_unit,
          color: Colors.transparent,
        ),
        title: Text('51'),
        centerTitle: true,
      ),
      body: Center(
        child: Text("学习"),
      ),
    );
  }
}
