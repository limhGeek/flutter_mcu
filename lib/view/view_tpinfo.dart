import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mcu/bean/Reply.dart';
import 'package:flutter_mcu/bean/Token.dart';
import 'package:flutter_mcu/bean/Topic.dart';
import 'package:flutter_mcu/bean/User.dart';
import 'package:flutter_mcu/comm/config/Config.dart';
import 'package:flutter_mcu/comm/net/Api.dart';
import 'package:flutter_mcu/comm/net/Http.dart';
import 'package:flutter_mcu/comm/redux/AppState.dart';
import 'package:flutter_mcu/utils/comm_utils.dart';
import 'package:flutter_mcu/utils/sp_utils.dart';
import 'package:flutter_mcu/utils/toast_utils.dart';
import 'package:flutter_mcu/widget/view_loading.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class TpInfoPage extends StatefulWidget {
  final Topic topic;

  TpInfoPage(this.topic);

  @override
  State<StatefulWidget> createState() {
    return _TpInfoPage();
  }
}

class _TpInfoPage extends State<TpInfoPage> {
  var _replys = [];
  int _replyCount = 1;
  var _sendScroller = TextEditingController();
  bool _loading = false;
  Token token;

  @override
  void initState() {
    super.initState();
    _initParams();
    _getReply();
  }

  @override
  Widget build(BuildContext context) {
    return StoreBuilder<AppState>(
      builder: (context, store) {
        return Scaffold(
            body: ProgressDialog(
          loading: _loading,
          msg: '操作中，请稍后...',
          child: Column(
            children: <Widget>[
              Expanded(
                  child: CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    pinned: false,
                    floating: true,
                  ),
                  SliverToBoxAdapter(
                    child: Offstage(
                      offstage: widget.topic.title.length == 0,
                      child: Container(
                        margin: EdgeInsets.only(left: 10.0, top: 10.0),
                        child: Text(
                          widget.topic.title,
                          style: TextStyle(fontSize: 18.0, color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  SliverPersistentHeader(
                      floating: true,
                      pinned: true,
                      delegate: _SliverAppBarDelegate(
                          minHeight: 48.0,
                          maxHeight: 48.0,
                          child: Padding(
                            padding: EdgeInsets.only(top: 10, left: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  width: 36.0,
                                  height: 36.0,
                                  margin: EdgeInsets.only(right: 8.0),
                                  child: ClipOval(
                                    child: CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      placeholder: Image.asset(
                                          Config.ASSERT_HEAD_DEFAULT),
                                      imageUrl: null == widget.topic.userImg
                                          ? ""
                                          : Api.BaseUrl + widget.topic.userImg,
                                      errorWidget: Image.asset(
                                          Config.ASSERT_HEAD_DEFAULT),
                                    ),
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Text(
                                      widget.topic.userName,
                                      style: TextStyle(
                                          fontSize: 16.0, color: Colors.black),
                                    ),
                                    Text(
                                        CommUtil.getTimeDiff(
                                            widget.topic.replyAt),
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            color:
                                                Theme.of(context).hintColor)),
                                  ],
                                )
                              ],
                            ),
                          ))),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        widget.topic.content,
                        style: TextStyle(fontSize: 16.0, color: Colors.black87),
                      ),
                    ),
                  ),
                  _sliverList(widget.topic.imgsUrl),
                  SliverToBoxAdapter(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        GestureDetector(
                          child: Container(
                            margin: EdgeInsets.only(left: 10.0),
                            width: 80.0,
                            height: 40.0,
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.launch,
                                  size: 16.0,
                                  color: Theme.of(context).disabledColor,
                                ),
                                Container(
                                  width: 6.0,
                                ),
                                Text(
                                  '分享',
                                  style: TextStyle(
                                      color: Theme.of(context).disabledColor,
                                      fontSize: 12.0),
                                )
                              ],
                            ),
                          ),
                          onTap: () {},
                        ),
                        GestureDetector(
                          child: Container(
                            width: 80.0,
                            height: 40.0,
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.chat_bubble_outline,
                                  size: 16.0,
                                  color: Theme.of(context).disabledColor,
                                ),
                                Container(
                                  width: 6.0,
                                ),
                                Text(
                                  widget.topic.replayCount == 0
                                      ? '评论'
                                      : '${widget.topic.replayCount}',
                                  style: TextStyle(
                                      color: Theme.of(context).disabledColor,
                                      fontSize: 12.0),
                                )
                              ],
                            ),
                          ),
                          onTap: () {},
                        ),
                        GestureDetector(
                          child: Container(
                            height: 40.0,
                            width: 40.0,
                            margin: EdgeInsets.only(right: 10.0),
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.sentiment_satisfied,
                                  size: 16.0,
                                  color: Theme.of(context).disabledColor,
                                ),
                                Container(
                                  width: 6.0,
                                ),
                                Text(
                                  widget.topic.praise == 0
                                      ? '点赞'
                                      : '${widget.topic.praise}',
                                  style: TextStyle(
                                      color: Theme.of(context).disabledColor,
                                      fontSize: 12.0),
                                )
                              ],
                            ),
                          ),
                          onTap: () {
                            _addPraise();
                          },
                        )
                      ],
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 10.0,
                      color: Theme.of(context).highlightColor,
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      return _repyItem(context, index, store);
                    }, childCount: _replyCount),
                  ),
                  SliverToBoxAdapter(
                    child: Offstage(
                      offstage: _replys.isEmpty,
                      child: Container(
                        height: 80,
                      ),
                    ),
                  ),
                ],
              )),
              TextField(
                controller: _sendScroller,
                decoration: InputDecoration(
                    hintText: '输入您的评论',
                    contentPadding: EdgeInsets.only(left: 10.0, right: 6.0),
                    suffix: IconButton(
                        icon: Icon(
                          Icons.send,
                          color: Theme.of(context).primaryColor,
                        ),
                        onPressed: () {
                          _addReply();
                        })),
              )
            ],
          ),
        ));
      },
    );
  }

  Widget _sliverList(String imgUrls) {
    if (null == imgUrls || imgUrls.length == 0) {
      return SliverToBoxAdapter();
    }
    List<String> str = imgUrls.split(',');
    return SliverList(
        delegate:
            SliverChildBuilderDelegate((BuildContext context, int position) {
      return Column(children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 10.0, right: 10.0),
          width: MediaQuery.of(context).size.width,
          child: CachedNetworkImage(
            imageUrl: Api.BaseUrl + str[position],
            errorWidget: Image.asset(Config.ASSERT_HEAD_DEFAULT),
            fit: BoxFit.cover,
          ),
        ),
        Divider(
          height: 6.0,
          color: Theme.of(context).canvasColor,
        )
      ]);
    }, childCount: str.length));
  }

  Widget _repyItem(BuildContext context, int index, Store store) {
    if (_replys.isEmpty) {
      return Container(
          width: MediaQuery.of(context).size.width,
          height: 140.0,
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.child_care,
                size: 60.0,
                color: Theme.of(context).highlightColor,
              ),
              Text(
                '还没有人评论，快来抢沙发...',
                style: TextStyle(
                    color: Theme.of(context).highlightColor, fontSize: 16.0),
              )
            ],
          )));
    } else {
      Reply reply = _replys[index];
      User user = store.state.user;
      return Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 30.0,
                    height: 30.0,
                    margin: EdgeInsets.only(right: 8.0),
                    child: ClipOval(
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        placeholder: Image.asset(Config.ASSERT_HEAD_DEFAULT),
                        imageUrl: null == reply.userImg
                            ? ""
                            : Api.BaseUrl + reply.userImg,
                        errorWidget: Image.asset(Config.ASSERT_HEAD_DEFAULT),
                      ),
                    ),
                  ),
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Text(
                        reply.userName,
                        style: TextStyle(fontSize: 14.0, color: Colors.black),
                      ),
                      Text(CommUtil.getTimeDiff(reply.createAt),
                          style: TextStyle(
                              fontSize: 10.0,
                              color: Theme.of(context).hintColor)),
                    ],
                  )),
                  Offstage(
                    offstage: null == user || user.userId != reply.userId,
                    child: GestureDetector(
                        onTap: () {
                          _delReply(reply);
                        },
                        child: Container(
                          height: 30.0,
                          padding: EdgeInsets.only(left: 10.0),
                          child: Center(
                              child: Text(
                            '删除',
                            style: TextStyle(
                                color: Theme.of(context).disabledColor,
                                fontSize: 12.0),
                          )),
                        )),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(left: 36.0, top: 6.0),
                child: Text(
                  reply.content,
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
              Divider()
            ],
          ));
    }
  }

  Future _initParams() async {
    token = await SpUtils.getToken();
  }

  Future _addPraise() async {
    Http.put(Api.URL_PRAISE, params: {"topicId": '${widget.topic.topicId}'},
        successCallBack: (data) {
      Topic topic = Topic.fromJson(data);
      print('更新后：$topic');
      setState(() {
        widget.topic.praise = topic.praise;
      });
    }, errorCallBack: (msg) {
      Toast.show(context, msg);
    });
  }

  Future _getReply() async {
    Http.get(Api.URL_REPLY_DATA + "?topicId=${widget.topic.topicId}",
        successCallBack: (data) {
      print('回复表：${json.encode(data)}');
      List list = data.map((m) => Reply.fromJson(m)).toList();
      setState(() {
        _replys.clear();
        _replys.addAll(list);
        if (_replys.isNotEmpty) _replyCount = _replys.length;
      });
    }, errorCallBack: (msg) {
      Toast.show(context, msg);
    });
  }

  Future _addReply() async {
    if (_sendScroller.text == null) {
      Toast.show(context, '请输入评论内容');
    } else {
      setState(() {
        _loading = true;
      });
      Map<String, String> params = Map();
      params['content'] = _sendScroller.text;
      params['topicId'] = '${widget.topic.topicId}';
      Http.post(Api.URL_REPLY_ADD,
          header: {"Token": "${token.token}"},
          params: params, successCallBack: (_) {
        setState(() {
          _sendScroller.text = "";
          _loading = false;
        });
        _getReply();
      }, errorCallBack: (msg) {
        setState(() {
          _loading = false;
        });
        Toast.show(context, msg);
      });
    }
  }

  Future _delReply(Reply reply) async {
    setState(() {
      _loading = true;
    });
    Http.put(
        Api.URL_REPLY_DEL +
            "?replyId=${reply.replyId}&topicId=${widget.topic.topicId}",
        successCallBack: (_) {
      setState(() {
        _loading = false;
      });
      _getReply();
      Toast.show(context, '操作成功');
    }, errorCallBack: (msg) {
      setState(() {
        _loading = false;
      });
      Toast.show(context, msg);
    });
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
