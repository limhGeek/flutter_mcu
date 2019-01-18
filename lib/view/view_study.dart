/**
 * @Author: limh
 * @Description:
 * @Date: 2018/9/23 20:06
 */

import 'package:flutter/material.dart';
import 'package:flutter_mcu/view/study/mcu_web.dart';
import 'package:flutter_mcu/view/study/view_cprogram.dart';
import 'package:flutter_mcu/view/study/view_mcu.dart';
import 'package:flutter_mcu/widget/iconfont.dart';

class StudyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final btnTextStyle = TextStyle(
        color: Theme.of(context).primaryColor,
        fontSize: 16.0,
        fontWeight: FontWeight.bold);

    return Scaffold(
        appBar: AppBar(
          leading: Icon(
            Icons.ac_unit,
            color: Colors.transparent,
          ),
          title: Text('学海无涯'),
          centerTitle: true,
        ),
        body: GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 8.0,
            crossAxisSpacing: 8.0,
            children: <Widget>[
              GestureDetector(
                  child: Card(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                        Icon(
                          FontIcon.lvzhou_cpu,
                          size: 48.0,
                          color: Theme.of(context).primaryColor,
                        ),
                        Container(width: 10.0, height: 10.0),
                        Text("51单片机", style: btnTextStyle),
                      ])),
                  onTap: () => Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_) {
                        return McuPage("51单片机教程", "MCU");
                      }))),
              GestureDetector(
                  child: Card(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                        Icon(
                          FontIcon.lvzhou_lujing_guiji,
                          size: 48.0,
                          color: Theme.of(context).primaryColor,
                        ),
                        Container(width: 10.0, height: 10.0),
                        Text("汇编语言", style: btnTextStyle),
                      ])),
                  onTap: () => Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_) {
                        return McuPage("汇编语言教程", "ASM");
                      }))),
              GestureDetector(
                  child: Card(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                        Icon(
                          Icons.code,
                          size: 48.0,
                          color: Theme.of(context).primaryColor,
                        ),
                        Container(width: 10.0, height: 10.0),
                        Text("汇编指令", style: btnTextStyle),
                      ])),
                  onTap: () => Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_) {
                        return McuPage("汇编指令", "ORDER");
                      }))),
              GestureDetector(
                child: Card(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                      Icon(
                        FontIcon.Programming,
                        size: 48.0,
                        color: Theme.of(context).primaryColor,
                      ),
                      Container(width: 10.0, height: 10.0),
                      Text("C语言教程", style: btnTextStyle),
                    ])),
                onTap: () =>
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                      return CProgramPage("C语言教程", 'C');
                    })),
              ),
              Card(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                    Icon(
                      FontIcon.hanshu,
                      size: 48.0,
                      color: Theme.of(context).primaryColor,
                    ),
                    Container(width: 10.0, height: 10.0),
                    Text("C函数库", style: btnTextStyle),
                  ])),
              Card(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                    Icon(
                      FontIcon.suanfa,
                      size: 48.0,
                      color: Theme.of(context).primaryColor,
                    ),
                    Container(width: 10.0, height: 10.0),
                    Text("经典算法", style: btnTextStyle),
                  ])),
            ]));
  }
}
