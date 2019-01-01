import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mcu/bean/Reply.dart';
import 'package:flutter_mcu/bean/Topic.dart';
import 'package:flutter_mcu/comm/config/Config.dart';
import 'package:flutter_mcu/comm/net/Api.dart';
import 'package:flutter_mcu/comm/net/Http.dart';
import 'package:flutter_mcu/utils/comm_utils.dart';
import 'package:flutter_mcu/utils/toast_utils.dart';

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
  int replyCount = 1;

  @override
  void initState() {
    super.initState();
    _getReply();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
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
                              placeholder: Image.asset(Config.ASSERT_HEAD_DEFAULT),
                              imageUrl: null == widget.topic.userImg
                                  ? ""
                                  : widget.topic.userImg,
                              errorWidget: Image.asset(Config.ASSERT_HEAD_DEFAULT),
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
                            Text(CommUtil.getTimeDiff(widget.topic.replyAt),
                                style: TextStyle(
                                    fontSize: 12.0,
                                    color: Theme.of(context).hintColor)),
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
            delegate:
                SliverChildBuilderDelegate((BuildContext context, int index) {
              return _repyItem(context, index);
            }, childCount: replyCount),
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      title: TextField(
                        decoration: InputDecoration(hintText: '输入您的评论'),
                      ),
                      trailing: GestureDetector(
                        child: Container(
                          height: 40.0,
                          child: Text('发布'),
                        ),
                        onTap: () {},
                      ),
                      onTap: () async {
                        Navigator.pop(context);
                      },
                    )
                  ],
                );
              });
        },
        child: Icon(Icons.edit),
      ),
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

  Widget _repyItem(BuildContext context, int index) {
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
                        placeholder: Image.asset(Config.ASSERT_HEAD_DEFAULT),
                        imageUrl: null == reply.userImg ? "" : reply.userImg,
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
                    offstage: false,
                    child: GestureDetector(
                        onTap: () {},
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
    Http.get(Api.URL_REPLYS + "?topicId=${widget.topic.topicId}",
        successCallBack: (data) {
      print('回复表：${json.encode(data)}');
      List list = data.map((m) => Reply.fromJson(m)).toList();
      setState(() {
        _replys.clear();
        _replys.addAll(list);
        if (_replys.isNotEmpty) replyCount = _replys.length;
      });
    }, errorCallBack: (msg) {
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
