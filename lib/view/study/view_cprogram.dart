import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_mcu/bean/Course.dart';
import 'package:flutter_mcu/comm/net/Api.dart';
import 'package:flutter_mcu/comm/net/Http.dart';
import 'package:flutter_mcu/utils/sp_utils.dart';
import 'package:flutter_mcu/utils/toast_utils.dart';
import 'package:flutter_mcu/view/study/mcu_web.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CProgramPage extends StatefulWidget {
  final String title;
  final String type;

  CProgramPage(this.title, this.type);

  @override
  _CProgramPageState createState() => _CProgramPageState();
}

class _CProgramPageState extends State<CProgramPage> {
  bool isLoading = false;

  var _item = [];

  @override
  void initState() {
    super.initState();
    _getCagalog();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title), centerTitle: true),
      body: _bodyView(),
    );
  }

  Widget _bodyView() {
    if (isLoading) {
      return Center(
          child:
              SpinKitWave(color: Theme.of(context).primaryColor, size: 30.0));
    }
    if (null == _item || _item.isEmpty) {
      return Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        IconButton(
            icon: Icon(Icons.cached,
                size: 36, color: Theme.of(context).disabledColor),
            onPressed: () => _getCagalog()),
        Text('加载失败，点击重试',
            style: TextStyle(
                color: Theme.of(context).disabledColor, fontSize: 16.0))
      ]));
    } else {
      return ListView.builder(
          itemCount: null == _item ? 0 : _item.length,
          itemBuilder: (context, index) {
            return GestureDetector(
                child: _itemView(index),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                    Course course = _item[index];
                    return WebInfoPage(course.subTitle, course.url);
                  }));
                });
          });
    }
  }

  Widget _itemView(int index) {
    Course course = _item[index];
    return Card(
        child: Container(
            padding: EdgeInsets.only(
                left: 10.0, top: 20.0, bottom: 20.0, right: 10.0),
            child: Row(children: <Widget>[
              Icon(Icons.description),
              Container(width: 10.0, height: 10.0),
              Expanded(
                  child:
                      Text(course.subTitle, style: TextStyle(fontSize: 18.0)))
            ])));
  }

  Future _getCagalog() async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });

    print('${widget.title}_${widget.type}');
    List list = await SpUtils.getMcu(widget.type);
    if (null != list && list.length > 0) {
      setState(() {
        _item.clear();
        _item.addAll(list);
        isLoading = false;
      });
    } else {
      Http.get(Api.URL_COURSE_CATALOG,
          params: {"type": widget.type, 'title': widget.title},
          successCallBack: (data) {
        print(json.encode(data));
        SpUtils.saveMcu(widget.type, json.encode(data));
        List list = data.map((m) => Course.fromJson(m)).toList();
        setState(() {
          _item.clear();
          _item.addAll(list);
          isLoading = false;
        });
      }, errorCallBack: (msg) {
        Toast.show(context, msg);
        setState(() {
          isLoading = false;
        });
      });
    }
  }
}
