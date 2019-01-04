import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mcu/bean/Fans.dart';
import 'package:flutter_mcu/bean/User.dart';
import 'package:flutter_mcu/comm/net/Api.dart';

class FansPage extends StatefulWidget {
  final Fans fans;

  const FansPage({Key key, this.fans}) : super(key: key);

  @override
  _FansPageState createState() => _FansPageState();
}

class _FansPageState extends State<FansPage>
    with SingleTickerProviderStateMixin {
  var _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          body: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverOverlapAbsorber(
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                        context),
                    child: SliverAppBar(
                      title: Text('${widget.fans.userName}'),
                      bottom: TabBar(
                        tabs: [Tab(text: '关注'), Tab(text: '粉丝')],
                        controller: _tabController,
                      ),
                      pinned: true,
                      expandedHeight: 46.0,
                      forceElevated: innerBoxIsScrolled,
                    ),
                  ),
                ];
              },
              body: TabBarView(controller: _tabController, children: [
                SafeArea(top: false, child: _ListPage(widget.fans.followList)),
                SafeArea(
                  top: false,
                  child: _ListPage(widget.fans.fansList),
                )
              ])),
        ));
  }
}

class _ListPage extends StatelessWidget {
  final List<User> userList;

  const _ListPage(this.userList);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: false,
        child: ListView.builder(
            itemCount: (null == userList ? 0 : userList.length),
            itemBuilder: (context, index) {
              return _userItem(context, index);
            }));
  }

  Widget _userItem(BuildContext context, int index) {
    User user = userList[index];
    String _userImg = userList[index].imgUrl;
    return Container(
        width: MediaQuery.of(context).size.width,
        height: 46.0,
        padding: EdgeInsets.all(10),
        child: Row(children: <Widget>[
          ClipOval(
              child: CachedNetworkImage(
            width: 36.0,
            height: 36.0,
            fit: BoxFit.cover,
            imageUrl: _userImg == null
                ? (Api.BaseUrl + "default_head.jpg")
                : (Api.BaseUrl + _userImg),
          )),
          Expanded(
              child: Column(children: <Widget>[
            Text('${user.userName}', style: TextStyle(fontSize: 18.0)),
            Text(
              '${user.profile == null ? "他很懒，什么也没留下" : user.profile}',
              style: TextStyle(fontSize: 16.0),
            )
          ]))
        ]));
  }
}
