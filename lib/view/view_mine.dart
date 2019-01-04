import 'dart:convert';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mcu/bean/Fans.dart';
import 'package:flutter_mcu/bean/Token.dart';
import 'package:flutter_mcu/bean/User.dart';
import 'package:flutter_mcu/comm/config/Config.dart';
import 'package:flutter_mcu/comm/net/Api.dart';
import 'package:flutter_mcu/comm/net/Http.dart';
import 'package:flutter_mcu/comm/redux/AppState.dart';
import 'package:flutter_mcu/utils/sp_utils.dart';
import 'package:flutter_mcu/utils/toast_utils.dart';
import 'package:flutter_mcu/view/view_fans.dart';
import 'package:flutter_mcu/view/view_setting.dart';
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
    print('初始化参数：$user');
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
    if (null == fans) {
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
        return Container();
      }, childCount: null == fans ? 0 : fans.topicList.length));
    }
  }

  Widget _sliverHeader(User user) {
    String _coverImg = null != user ? user.coverImg : null;
    String _userImg = null != user ? user.imgUrl : null;
    return Stack(
      children: <Widget>[
        CachedNetworkImage(
          width: MediaQuery.of(context).size.width,
          height: 250.0,
          fit: BoxFit.cover,
          placeholder: Image.asset(Config.ASSERT_HEAD_DEFAULT),
          imageUrl: null == _coverImg
              ? (_userImg == null
                  ? (Api.BaseUrl + "default_head.jpg")
                  : (Api.BaseUrl + _userImg))
              : (Api.BaseUrl + _coverImg),
          errorWidget: Image.asset(Config.ASSERT_HEAD_DEFAULT),
        ),
        Offstage(
          offstage: _coverImg != null,
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
                    null == user || user.userName == null ? "|" : user.userName,
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
