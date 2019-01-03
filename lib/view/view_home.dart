import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mcu/bean/Topic.dart';
import 'package:flutter_mcu/comm/config/Config.dart';
import 'package:flutter_mcu/comm/net/Api.dart';
import 'package:flutter_mcu/comm/net/Http.dart';
import 'package:flutter_mcu/utils/comm_utils.dart';
import 'package:flutter_mcu/utils/toast_utils.dart';
import 'package:flutter_mcu/view/view_addtp.dart';
import 'package:flutter_mcu/view/view_drawer.dart';
import 'package:flutter_mcu/view/view_image.dart';
import 'package:flutter_mcu/view/view_tpinfo.dart';
import 'package:flutter_mcu/view/view_user.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePage();
  }
}

class _HomePage extends State<HomePage> with AutomaticKeepAliveClientMixin {
  //分页参数
  int _pageNum = 0;

  //数据集合
  var _item = [];

  //是否加载
  bool _isLoading = false;

  //加载完全部
  bool _isAll = false;

  //上拉加载更多
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _getData(true);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getData(false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: Text('论坛'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
          child: ListView.builder(
            physics: AlwaysScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              if (index < _item.length) {
                return GestureDetector(
                  child: _itemView(context, index),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                      return TpInfoPage(_item[index]);
                    }));
                  },
                );
              } else if (_isLoading && _pageNum != 0) {
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
              } else if (_isAll) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: 60.0,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 60,
                        height: 1,
                        color: Theme.of(context).buttonColor,
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          '我也是有底线的',
                          style:
                              TextStyle(color: Theme.of(context).buttonColor),
                        ),
                      ),
                      Container(
                        width: 60,
                        height: 1,
                        color: Theme.of(context).buttonColor,
                      ),
                    ],
                  ),
                );
              }
              return Container();
            },
            controller: _scrollController,
            itemCount: _item.length + 1,
          ),
          onRefresh: () => _getData(true)),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  Widget _itemView(BuildContext context, int index) {
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
                GestureDetector(
                  child: Container(
                    width: 40.0,
                    height: 40.0,
                    margin: EdgeInsets.only(right: 6.0),
                    child: ClipOval(
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        placeholder: Image.asset(Config.ASSERT_HEAD_DEFAULT),
                        imageUrl: null == topic.userImg
                            ? ""
                            : Api.BaseUrl + topic.userImg,
                        errorWidget: Image.asset(Config.ASSERT_HEAD_DEFAULT),
                      ),
                    ),
                  ),
                  onTap: () => Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_) {
                        return UserInfoPage(userId: topic.userId);
                      })),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      topic.userName,
                      style: TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                    Text(CommUtil.getTimeDiff(topic.replyAt),
                        style: TextStyle(
                            fontSize: 12.0,
                            color: Theme.of(context).disabledColor)),
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(6),
            child: Text(
              topic.content,
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
          ),
          Offstage(
            offstage: topic.imgsUrl == null || topic.imgsUrl.length == 0,
            child: Container(
              height: 100.0,
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(left: 10.0, bottom: 10.0),
              child: _imgItemView(topic.imgsUrl),
            ),
          ),
          Row(
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
                        topic.replayCount == 0 ? '评论' : '${topic.replayCount}',
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
                        topic.praise == 0 ? '点赞' : '${topic.praise}',
                        style: TextStyle(
                            color: Theme.of(context).disabledColor,
                            fontSize: 12.0),
                      )
                    ],
                  ),
                ),
                onTap: () {
                  _addPraise(topic.topicId);
                },
              )
            ],
          ),
          Divider(
            color: Colors.grey,
            height: 1,
          )
        ],
      ),
    );
  }

  Widget _imgItemView(String imgUrls) {
    if (imgUrls.endsWith(",")) {
      imgUrls = imgUrls.substring(0, imgUrls.length - 1);
    }
    List<String> str = imgUrls.split(',');

    return GestureDetector(
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int position) {
            return Container(
              width: MediaQuery.of(context).size.width / 3,
              margin: EdgeInsets.only(right: 6.0),
              child: CachedNetworkImage(
                imageUrl: Api.BaseUrl + str[position],
                errorWidget: Image.asset(Config.ASSERT_HEAD_DEFAULT),
                fit: BoxFit.cover,
              ),
            );
          },
          itemCount: str.length,
        ),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) {
            return ImagePage(str);
          }));
        });
  }

  Future<Null> _getData(bool isRefresh) async {
    if (isRefresh) {
      _pageNum = 0;
      _isAll = false;
    }
    //如果已经加载完全部或者正在请求数据，则不会继续请求
    if (_isLoading || _isAll) return;
    setState(() {
      _isLoading = true;
    });
    await Http.get(Api.URL_TOPIC_DATA + '/$_pageNum', successCallBack: (data) {
      print(json.encode(data));
      List list = data.map((m) => Topic.fromJson(m)).toList();
      if (null != list && list.length == 10) {
        _pageNum++;
      } else {
        setState(() {
          _isAll = true;
        });
      }
      setState(() {
        if (isRefresh) {
          _item.clear();
        }
        _isLoading = false;
        _item.addAll(list);
      });
    }, errorCallBack: (errorMsg) {
      setState(() {
        _isLoading = false;
      });
      Toast.show(context, errorMsg);
    });
  }

  Future _addPraise(int topicId) async {
    Http.put(Api.URL_PRAISE, params: {"topicId": '$topicId'},
        successCallBack: (data) {
      Topic topic = Topic.fromJson(data);
      print('更新后：$topic');
      for (int i = 0; i < _item.length; i++) {
        if (topic.topicId == _item[i].topicId) {
          setState(() {
            _item[i] = topic;
          });
        }
      }
    }, errorCallBack: (msg) {
      Toast.show(context, msg);
    });
  }

  @override
  bool get wantKeepAlive => true;
}
