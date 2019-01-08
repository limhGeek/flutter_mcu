import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mcu/bean/Letter.dart';
import 'package:flutter_mcu/bean/Token.dart';
import 'package:flutter_mcu/bean/User.dart';
import 'package:flutter_mcu/comm/net/Api.dart';
import 'package:flutter_mcu/comm/net/Http.dart';
import 'package:flutter_mcu/utils/sp_utils.dart';
import 'package:flutter_mcu/utils/toast_utils.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ChatPage extends StatefulWidget {
  final User user;

  ChatPage(this.user);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  var _sendScroller = TextEditingController();
  var _scrollControllsr = ScrollController();
  Token _token;
  User _user;
  bool _isSend = false;
  bool _sendFail = false;
  var _item = [];

  @override
  void initState() {
    super.initState();
//    _scrollControllsr.animateTo(_item.length * _ITEM_HEIGHT,
//        duration: new Duration(seconds: 2), curve: Curves.ease);
    _initParams();
  }

  Future _initParams() async {
    _user = await SpUtils.getUser();
    _token = await SpUtils.getToken();
    _getMsgList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      appBar: AppBar(
        title: Text('${null == widget.user ? "" : widget.user.userName}'),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
              child: ListView.builder(
                  controller: _scrollControllsr,
                  itemCount: null == _item || _item.isEmpty ? 0 : _item.length,
                  itemBuilder: (context, index) {
                    return _itemView(context, index);
                  })),
          Padding(
              padding: EdgeInsets.all(10.0),
              child: TextField(
                controller: _sendScroller,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 10.0, right: 6.0),
                    suffix: IconButton(
                        icon: Icon(
                          Icons.send,
                          color: Theme.of(context).primaryColor,
                        ),
                        onPressed: () {
                          _sendMsg(false);
                        })),
              ))
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _itemView(BuildContext context, int index) {
    if (null == _item || _item.isEmpty || null == _user) {
      return Container();
    }
    Letter letter = _item[index];
    if (letter.sendId == _user.userId) {
      return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Offstage(offstage: _item.length - 1 != index, child: _msgStatus()),
            Card(
                color: Theme.of(context).primaryColor,
                child: Container(
                    padding: EdgeInsets.all(10.0),
                    child: Text('${letter.content}',
                        style: TextStyle(color: Colors.white)))),
            Container(
                margin: EdgeInsets.only(right: 10.0),
                child: ClipOval(
                  child: CachedNetworkImage(
                    width: 40.0,
                    height: 40.0,
                    fit: BoxFit.cover,
                    imageUrl: Api.BaseUrl + letter.sendImg,
                    errorWidget: Container(
                      color: Theme.of(context).highlightColor,
                    ),
                  ),
                )),
          ]);
    } else {
      return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(right: 10.0, left: 10.0),
                child: ClipOval(
                  child: CachedNetworkImage(
                    width: 40.0,
                    height: 40.0,
                    fit: BoxFit.cover,
                    imageUrl: Api.BaseUrl + letter.sendImg,
                    errorWidget: Container(
                      color: Theme.of(context).highlightColor,
                    ),
                  ),
                )),
            Card(
                color: Theme.of(context).canvasColor,
                child: Container(
                    padding: EdgeInsets.all(10.0),
                    child: Text('${letter.content}'))),
          ]);
    }
  }

  Widget _msgStatus() {
    if (_isSend) {
      return Container(
          padding: EdgeInsets.all(10.0),
          child: SpinKitCircle(size: 20, color: Colors.grey));
    } else if (_sendFail) {
      return IconButton(
          icon: Icon(
            Icons.error_outline,
            color: Theme.of(context).errorColor,
            size: 28.0,
          ),
          onPressed: () => _sendMsg(true));
    } else {
      return Container();
    }
  }

  Future _getMsgList() async {
    await Http.get(Api.URL_MSG_LIST,
        params: {"userId": "${widget.user.userId}"},
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

  Future _sendMsg(bool isRepeat) async {
    print("开始发送");
    if (_isSend) return;
    Letter letter;
    if (!isRepeat) {
      letter = Letter.fromParams(
          sendId: _user.userId,
          sendImg: _user.imgUrl,
          sendName: _user.userName,
          recvId: widget.user.userId,
          recvImg: widget.user.imgUrl,
          recvName: widget.user.userName,
          content: _sendScroller.text,
          createAt: DateTime.now().millisecondsSinceEpoch,
          msgType: 0);
      setState(() {
        _item.add(letter);
        _sendScroller.value = TextEditingValue();
      });
    } else {
      letter = _item.last;
    }
    setState(() {
      _isSend = true;
      _sendFail = false;
    });
    Map<String, String> params = Map();
    params["recvId"] = "${_item.last.recvId}";
    params["content"] = _item.last.content;
    params['msgType'] = "0";
    Http.post(Api.URL_MSG_SEND, header: {"Token": _token.token}, params: params,
        successCallBack: (data) {
      print('${json.encode(data)}');
      Letter letter = Letter.fromJson(data);
      setState(() {
        _isSend = false;
        _item.last = letter;
      });
    }, errorCallBack: (msg) {
      setState(() {
        _isSend = false;
        _sendFail = true;
      });
      Toast.show(context, msg);
    });
  }
}
