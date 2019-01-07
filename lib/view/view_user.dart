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
import 'package:flutter_mcu/utils/sp_utils.dart';
import 'package:flutter_mcu/utils/toast_utils.dart';
import 'package:flutter_mcu/view/view_setting.dart';
import 'package:flutter_mcu/widget/iconfont.dart';
import 'package:flutter_mcu/widget/view_loading.dart';

class UserInfoPage extends StatefulWidget {
  final int userId;

  UserInfoPage({this.userId});

  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  bool loading = false;
  bool showBtn = false;
  User user;
  Token token;
  Fans fans;

  @override
  void initState() {
    super.initState();
    initParams();
  }

  Future initParams() async {
    user = await SpUtils.getUser();
    token = await SpUtils.getToken();
    setState(() {
      showBtn = widget.userId == null || user.userId == widget.userId;
    });
    getFansData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProgressDialog(
          loading: loading,
          msg: "加载中...",
          child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                backgroundColor: Colors.transparent,
                flexibleSpace: _sliverHeader(),
                expandedHeight: 250.0,
                actions: <Widget>[
                  Offstage(
                    offstage: !showBtn,
                    child: IconButton(
                        icon: Icon(Icons.settings),
                        onPressed: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (_) {
                            return SettingPage();
                          }));
                        }),
                  ),
                  Offstage(
                    offstage: showBtn,
                    child: IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () {

                        }),
                  ),
                ],
              ),
              SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                return Container(
                    width: MediaQuery.of(context).size.width, height: 100.0);
              },
                      childCount: null == fans || null == fans.topicList
                          ? 0
                          : fans.topicList.length)),
            ],
          )),
    );
  }

  Widget _sliverHeader() {
    String _coverImg = null != fans ? fans.coverImg : null;
    String _userImg = null != fans ? fans.imgUrl : null;
    return Stack(
      children: <Widget>[
        _userBgView(_coverImg, _userImg),
        Offstage(
          offstage: null==fans||_coverImg != null,
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
                    null == fans || fans.userName == null ? "" : fans.userName,
                    style: TextStyle(
                        fontSize: 20.0, color: Theme.of(context).canvasColor),
                  ),
                ),
                Row(
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
                        style: TextStyle(color: Theme.of(context).canvasColor)),
                    Container(
                      width: 1,
                      height: 10,
                      margin: EdgeInsets.only(left: 10, right: 10),
                    ),
                    Text('粉丝 ${null == fans ? 0 : fans.fansNum}',
                        style: TextStyle(color: Theme.of(context).canvasColor)),
                  ],
                )
              ],
            )),
        Positioned(
            bottom: 0,
            right: 20,
            child: Offstage(
              offstage: showBtn,
              child: FloatingActionButton(
                elevation: 0.0,
                onPressed: () {
                  if (null != fans) {
                    if (fans.myFollow) {
                      delFollow();
                    } else {
                      follow();
                    }
                  }
                },
                child: Icon(null != fans && fans.myFollow
                    ? FontIcon.icon_followed
                    : FontIcon.icon_follow),
              ),
            ))
      ],
    );
  }

  Widget _userBgView(String _coverImg, String _userImg) {
    if (null == fans) {
      return Container(
          width: MediaQuery.of(context).size.width,
          height: 250.0,
          color: Theme.of(context).primaryColor);
    } else {
      return CachedNetworkImage(
        width: MediaQuery.of(context).size.width,
        height: 250.0,
        fit: BoxFit.cover,
//        placeholder: Image.asset(Config.ASSERT_HEAD_DEFAULT),
        imageUrl: null == _coverImg
            ? (_userImg == null
                ? (Api.BaseUrl + "default_head.jpg")
                : (Api.BaseUrl + _userImg))
            : (Api.BaseUrl + _coverImg),
        errorWidget: Image.asset(Config.ASSERT_HEAD_DEFAULT),
      );
    }
  }

  Future getFansData() async {
    if (loading) return;
    loading = true;
    int userId;
    if (widget.userId != null) {
      userId = widget.userId;
    } else {
      userId = null != user ? user.userId : null;
    }
    if (null == userId) return;
    Http.get(Api.URL_FANS_DATA + "?userId=$userId",
        header: {"Token": token.token}, successCallBack: (data) {
      print("${json.encode(data)}");
      setState(() {
        loading = false;
        fans = Fans.fromJson(data);
      });
    }, errorCallBack: (msg) {
      setState(() {
        loading = false;
      });
      Toast.show(context, " $msg ");
    });
  }

  Future follow() async {
    if (loading) return;
    loading = true;
    Http.post(Api.URL_FANS_FOLLOW,
        header: {"Token": token.token},
        params: {"userId": "${widget.userId}"}, successCallBack: (data) {
      print("${json.encode(data)}");
      setState(() {
        loading = false;
        fans = Fans.fromJson(data);
      });
    }, errorCallBack: (msg) {
      loading = false;
      Toast.show(context, " $msg ");
    });
  }

  Future delFollow() async {
    if (loading) return;
    loading = true;
    Http.put(Api.URL_FANS_FOLLOW,
        header: {"Token": token.token},
        params: {"userId": "${widget.userId}"}, successCallBack: (data) {
      print("${json.encode(data)}");
      setState(() {
        loading = false;
        fans = Fans.fromJson(data);
      });
    }, errorCallBack: (msg) {
      loading = false;
      Toast.show(context, " $msg ");
    });
  }
}
