import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mcu/bean/Letter.dart';
import 'package:flutter_mcu/bean/Token.dart';
import 'package:flutter_mcu/bean/User.dart';
import 'package:flutter_mcu/comm/net/Api.dart';
import 'package:flutter_mcu/comm/net/Http.dart';
import 'package:flutter_mcu/utils/comm_utils.dart';
import 'package:flutter_mcu/utils/sp_utils.dart';
import 'package:flutter_mcu/utils/toast_utils.dart';
import 'package:flutter_mcu/view/view_chat.dart';

class MessagePage extends StatefulWidget {
  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage>
    with AutomaticKeepAliveClientMixin {
  Token _token;
  User _user;
  var _item = [];

  @override
  void initState() {
    super.initState();
    _initDatas();
  }

  Future _initDatas() async {
    _token = await SpUtils.getToken();
    _user = await SpUtils.getUser();
    if (null != _token) {
      _getMsgList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Icon(
            Icons.ac_unit,
            color: Colors.transparent,
          ),
          title: Text('消息'),
          centerTitle: true,
        ),
        body: _bodyWidget());
  }

  Widget _bodyWidget() {
    if (null == _item || _item.isEmpty) {
      return _nullPage();
    } else {
      return RefreshIndicator(
          child: ListView.builder(
            itemBuilder: (context, index) {
              return GestureDetector(
                child: _itemView(context, index),
                onTap: () {
                  Letter letter = _item[index];
                  if (letter.sendId == _user.userId) {
                    User user = User.fromParams(
                        userId: letter.recvId,
                        userName: letter.recvName,
                        imgUrl: letter.recvImg);
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                      return ChatPage(user);
                    }));
                  } else {
                    User user = User.fromParams(
                        userId: letter.sendId,
                        userName: letter.sendName,
                        imgUrl: letter.sendImg);
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                      return ChatPage(user);
                    }));
                  }
                },
              );
            },
            itemCount: null == _item ? 0 : _item.length,
          ),
          onRefresh: _getMsgList);
    }
  }

  Widget _itemView(BuildContext context, int index) {
    Letter letter = _item[index];
    return Padding(
        padding: EdgeInsets.all(10.0),
        child: Stack(
          children: <Widget>[
            Row(children: <Widget>[
              Container(
                  margin: EdgeInsets.only(right: 10.0),
                  child: ClipOval(
                    child: CachedNetworkImage(
                      width: 40.0,
                      height: 40.0,
                      fit: BoxFit.cover,
                      imageUrl: Api.BaseUrl +
                          (letter.recvId == _user.userId
                              ? letter.sendImg
                              : letter.recvImg),
                      errorWidget: Container(
                        color: Theme.of(context).highlightColor,
                      ),
                    ),
                  )),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      letter.recvId == _user.userId
                          ? letter.sendName
                          : letter.recvName,
                      style: TextStyle(fontSize: 16.0),
                    ),
                    Text(letter.content,
                        style:
                            TextStyle(color: Theme.of(context).disabledColor)),
                    Container(
                        margin: EdgeInsets.only(top: 6.0),
                        width: MediaQuery.of(context).size.width - 70.0,
                        height: 1.0,
                        color: Theme.of(context).highlightColor)
                  ]),
            ]),
            Positioned(
                top: 0,
                right: 0,
                child: Text(CommUtil.getMsTime(letter.createAt),
                    style: TextStyle(color: Theme.of(context).disabledColor)))
          ],
        ));
  }

  Widget _nullPage() {
    return GestureDetector(
      child: Container(
          child: Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        Icon(
          Icons.not_listed_location,
          size: 64,
          color: Theme.of(context).highlightColor,
        ),
        Text(
          '暂时没有消息,点击刷新',
          style: TextStyle(
              color: Theme.of(context).highlightColor, fontSize: 16.0),
        )
      ]))),
      onTap: () => _getMsgList(),
    );
  }

  Future _getMsgList() async {
    await Http.get(Api.URL_MSG_LIST,
        header: {"Token": _token == null ? "" : _token.token},
        successCallBack: (data) {
      print('${json.encode(data)}');
      List list = data.map((m) => Letter.fromJson(m)).toList();
      if (null != list) {
        setState(() {
          _item.clear();
          _item.addAll(list);
        });
      }
    }, errorCallBack: (msg) {
      Toast.show(context, msg);
    });
  }

  @override
  bool get wantKeepAlive => true;
}
