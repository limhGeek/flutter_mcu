/**
 * @Author: limh
 * @Description:
 * @Date: 2018/9/23 19:58
 */

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_mcu/bean/Topic.dart';
import 'package:flutter_mcu/comm/config/Config.dart';
import 'package:flutter_mcu/comm/net/Api.dart';
import 'package:flutter_mcu/comm/net/Http.dart';
import 'package:flutter_mcu/utils/Toast.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePage();
  }
}

class _HomePage extends State<HomePage> {
  int pageNum = 0;
  var _item = [];
  bool isLoading = false;

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
      body: RefreshIndicator(
          child: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              if (index < _item.length) {
                return _itemView(context, index);
              } else if (isLoading) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: 40.0,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text('加载中,请稍后'),
                      ),
                    ],
                  ),
                );
              }
            },
            itemCount: _item.length + 1,
          ),
          onRefresh: () => _getData()),
    );
  }

  Widget _itemView(BuildContext context, int index) {
    print('数据总数：${_item.length}');
    Topic topic = _item[index];
    return Padding(
      padding: EdgeInsets.all(6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(6.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 40.0,
                  height: 40.0,
                  margin: EdgeInsets.only(right: 6.0),
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: topic.userImg??"xx.jpg",
                      errorWidget: Image.asset(Config.DEGAULT_IMG),
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      topic.userName,
                      style: TextStyle(fontSize: 14.0),
                    ),
                    Text('${topic.userName}', style: TextStyle(fontSize: 12.0)),
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(6),
            child: Text(
              topic.content,
              style: TextStyle(fontSize: 16.0),
            ),
          ),
//          Offstage(
//            offstage: null != topic.imgsUrl || topic.imgsUrl.length != 0,
//            child: _imgItemView(topic.imgsUrl),
//          ),
          Divider(
            color: Colors.grey,
            height: 1,
          )
        ],
      ),
    );
  }

  Widget _imgItemView(String imgUrls) {
    List<String> str = imgUrls.split(',');
    print('原始$imgUrls图片数组$str 数组长度：${str.length}');

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context, int position) {
        return Container(
          width: MediaQuery.of(context).size.width / 3,
          height: 80.0,
          child: CachedNetworkImage(
            imageUrl: str[position],
            errorWidget: Image.asset(Config.DEGAULT_IMG),
          ),
        );
      },
      itemCount: str.length,
    );
  }

  Future<Null> _getData() async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });
    Http.get(Api.URL_TOPICS + '/$pageNum', successCallBack: (data) {
      print(json.encode(data));
      List list = data.map((m) => Topic.fromJson(m)).toList();
      if (null != list && list.length == 10) {
        pageNum++;
      }
      setState(() {
        isLoading = false;
        _item.addAll(list);
      });
    }, errorCallBack: (errorMsg) {
      setState(() {
        isLoading = false;
      });
      Toast.show(context, errorMsg);
    });
  }
}
