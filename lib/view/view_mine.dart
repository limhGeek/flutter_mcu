import 'dart:convert';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mcu/bean/Fans.dart';
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
import 'package:flutter_mcu/view/view_fans.dart';
import 'package:flutter_mcu/view/view_setting.dart';
import 'package:flutter_mcu/view/view_tpinfo.dart';
import 'package:flutter_redux/flutter_redux.dart';

class MinePage extends StatefulWidget {
  MinePage();

  @override
  _MinePageState createState() => _MinePageState();
}

class _MinePageState extends State<MinePage>
    with AutomaticKeepAliveClientMixin {
  bool loading = false;
  User user;
  Token token;
  Fans fans;
  String nullHint = "用户未登录";

  @override
  void initState() {
    super.initState();
    initParams();
  }

  Future initParams() async {
    token = await SpUtils.getToken();
    user = await SpUtils.getUser();
    setState(() {
      if (null == user) {
        nullHint = "用户未登录";
      } else {
        nullHint = "尚未发布任何动态";
      }
    });
    _getFansData();
  }

  @override
  Widget build(BuildContext context) {
    return StoreBuilder<AppState>(
      builder: (context, store) {
        User user = store.state.user;
        return Scaffold(
          body: RefreshIndicator(
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                      leading: Icon(
                        Icons.ac_unit,
                        color: Colors.transparent,
                      ),
                      backgroundColor: Colors.transparent,
                      flexibleSpace: _sliverHeader(user),
                      expandedHeight: 250.0,
                      actions: <Widget>[
                        IconButton(
                            icon: Icon(Icons.settings),
                            onPressed: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (_) {
                                return SettingPage();
                              }));
                            })
                      ]),
                  _buttomView()
                ],
              ),
              onRefresh: () => _getFansData()),
        );
      },
    );
  }

  Widget _buttomView() {
    if (null == fans || null == fans.topicList || fans.topicList.isEmpty) {
      return SliverToBoxAdapter(
        child: Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(top: 80.0),
          child: Center(
            child: Column(
              children: <Widget>[
                Icon(Icons.memory,
                    size: 64, color: Theme.of(context).highlightColor),
                Text(nullHint,
                    style: TextStyle(
                        color: Theme.of(context).highlightColor,
                        fontSize: 18.0))
              ],
            ),
          ),
        ),
      );
    } else {
      return SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
        return GestureDetector(
            child: _itemView(index),
            onTap: () {
              if (null != fans &&
                  fans.topicList != null &&
                  fans.topicList[index] != null) {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                  return TpInfoPage(fans.topicList[index]);
                }));
              }
            });
      }, childCount: null == fans ? 0 : fans.topicList.length));
    }
  }

  Widget _sliverHeader(User user) {
    String _coverImg = null != user ? user.coverImg : null;
    String _userImg = null != user ? user.imgUrl : null;
    return Stack(
      children: <Widget>[
        _userBgView(),
        Offstage(
          offstage: null == user || _coverImg != null,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
            child: Container(
              color: Colors.white.withOpacity(0.3),
              width: MediaQuery.of(context).size.width,
              height: 250.0,
            ),
          ),
        ),
        Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ClipOval(
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    width: 72.0,
                    height: 72.0,
                    placeholder: Image.asset(Config.ASSERT_HEAD_DEFAULT),
                    imageUrl: _userImg == null
                        ? (Api.BaseUrl + "default_head.jpg")
                        : (Api.BaseUrl + _userImg),
                    errorWidget: Image.asset(Config.ASSERT_HEAD_DEFAULT),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: Text(
                    null == user || user.userName == null
                        ? "未登录"
                        : user.userName,
                    style: TextStyle(
                        fontSize: 20.0, color: Theme.of(context).canvasColor),
                  ),
                ),
                GestureDetector(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '发布 ${null == fans ? 0 : fans.topicNum}',
                        style: TextStyle(color: Theme.of(context).canvasColor),
                      ),
                      Container(
                        width: 1,
                        height: 10,
                        margin: EdgeInsets.only(left: 10, right: 10),
                      ),
                      Text('关注 ${null == fans ? 0 : fans.followNum}',
                          style:
                              TextStyle(color: Theme.of(context).canvasColor)),
                      Container(
                        width: 1,
                        height: 10,
                        margin: EdgeInsets.only(left: 10, right: 10),
                      ),
                      Text('粉丝 ${null == fans ? 0 : fans.fansNum}',
                          style:
                              TextStyle(color: Theme.of(context).canvasColor)),
                    ],
                  ),
                  onTap: () {
                    if (null != fans)
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_) {
                        return FansPage(
                          fans: fans,
                        );
                      }));
                  },
                )
              ],
            )),
      ],
    );
  }

  Widget _itemView(int index) {
    Topic topic = fans.topicList[index];
    return Card(
        child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Row(children: <Widget>[
                      ClipOval(
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          width: 36.0,
                          height: 36.0,
                          placeholder: Image.asset(Config.ASSERT_HEAD_DEFAULT),
                          imageUrl: topic.userImg == null
                              ? (Api.BaseUrl + "default_head.jpg")
                              : (Api.BaseUrl + topic.userImg),
                          errorWidget: Image.asset(Config.ASSERT_HEAD_DEFAULT),
                        ),
                      ),
                      Container(width: 10.0, height: 10.0),
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
                    ]),
                    Positioned(
                        right: 10.0,
                        top: 10.0,
                        child: GestureDetector(
                            child: Text('删除',
                                style: TextStyle(
                                    color: Theme.of(context).hintColor)),
                            onTap: () {}))
                  ],
                ),
                Container(
                    padding: EdgeInsets.all(10.0),
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                        topic.title == null ? topic.content : topic.title,
                        style: TextStyle(fontSize: 18.0))),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.only(left: 10.0),
                        width: 80.0,
                        height: 40.0,
                        child: Row(children: <Widget>[
                          Icon(
                            Icons.launch,
                            size: 16.0,
                            color: Theme.of(context).disabledColor,
                          ),
                          Container(
                            width: 6.0,
                          ),
                          Text('分享',
                              style: TextStyle(
                                  color: Theme.of(context).disabledColor,
                                  fontSize: 12.0))
                        ])),
                    Container(
                        width: 80.0,
                        height: 40.0,
                        child: Row(children: <Widget>[
                          Icon(
                            Icons.chat_bubble_outline,
                            size: 16.0,
                            color: Theme.of(context).disabledColor,
                          ),
                          Container(
                            width: 6.0,
                          ),
                          Text(
                              topic.replayCount == 0
                                  ? '评论'
                                  : '${topic.replayCount}',
                              style: TextStyle(
                                  color: Theme.of(context).disabledColor,
                                  fontSize: 12.0))
                        ])),
                    Container(
                        height: 40.0,
                        width: 40.0,
                        margin: EdgeInsets.only(right: 10.0),
                        child: Row(children: <Widget>[
                          Icon(
                            Icons.sentiment_satisfied,
                            size: 16.0,
                            color: Theme.of(context).disabledColor,
                          ),
                          Container(
                            width: 6.0,
                          ),
                          Text(topic.praise == 0 ? '点赞' : '${topic.praise}',
                              style: TextStyle(
                                  color: Theme.of(context).disabledColor,
                                  fontSize: 12.0))
                        ]))
                  ],
                )
              ],
            )));
  }

  Widget _userBgView() {
    if (null == user) {
      return Container(
          width: MediaQuery.of(context).size.width,
          height: 250.0,
          color: Theme.of(context).primaryColor);
    } else {
      return CachedNetworkImage(
        width: MediaQuery.of(context).size.width,
        height: 250.0,
        fit: BoxFit.cover,
        placeholder: Container(color: Theme.of(context).primaryColor),
        imageUrl: null == user.coverImg
            ? (user.imgUrl == null
                ? (Api.BaseUrl + "default_head.jpg")
                : (Api.BaseUrl + user.imgUrl))
            : (Api.BaseUrl + user.coverImg),
        errorWidget: Container(color: Theme.of(context).primaryColor),
      );
    }
  }

  Future<Null> _getFansData() async {
    if (loading) return;
    loading = true;
    int userId = null != user ? user.userId : null;
    print('加载个人数据');
    if (null == userId) return;
    await Http.get(Api.URL_FANS_DATA + "?userId=$userId",
        header: {"Token": token.token}, successCallBack: (data) {
      print("${json.encode(data)}");
      setState(() {
        loading = false;
        fans = Fans.fromJson(data);
      });
    }, errorCallBack: (msg) {
      loading = false;
      if (msg == null) msg = "未知异常";
      Toast.show(context, "$msg");
    });
  }

  @override
  bool get wantKeepAlive => true;
}
