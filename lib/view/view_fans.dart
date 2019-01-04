import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mcu/bean/Fans.dart';
import 'package:flutter_mcu/bean/User.dart';
import 'package:flutter_mcu/comm/net/Api.dart';
import 'package:flutter_mcu/view/view_user.dart';

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
    return Scaffold(
      appBar: AppBar(
          title: Text('${widget.fans.userName}'),
          bottom: TabBar(
              labelStyle: TextStyle(fontSize: 18.0),
              tabs: [Tab(text: '关注'), Tab(text: '粉丝')],
              controller: _tabController)),
      body: TabBarView(
        children: [
          _ListPage(widget.fans.followList),
          _ListPage(widget.fans.fansList)
        ],
        controller: _tabController,
      ),
    );
  }
}

class _ListPage extends StatelessWidget {
  final List<User> userList;

  const _ListPage(this.userList);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: (null == userList ? 0 : userList.length),
        itemBuilder: (context, index) {
          return GestureDetector(
            child: _userItem(context, index),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                return UserInfoPage(userId: userList[index].userId);
              }));
            },
          );
        });
  }

  Widget _userItem(BuildContext context, int index) {
    User user = userList[index];
    String _userImg = userList[index].imgUrl;
    return Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(10),
        child: Row(children: <Widget>[
          ClipOval(
              child: CachedNetworkImage(
                  width: 46.0,
                  height: 46.0,
                  fit: BoxFit.cover,
                  imageUrl: _userImg == null
                      ? (Api.BaseUrl + "default_head.jpg")
                      : (Api.BaseUrl + _userImg))),
          Container(width: 10, height: 10),
          Expanded(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                Text('${user.userName}',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                Text(
                  '${user.profile == null ? "他很懒，什么也没留下" : user.profile}',
                  style: TextStyle(fontSize: 16.0),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10.0),
                  width: MediaQuery.of(context).size.width,
                  height: 1.0,
                  color: Theme.of(context).highlightColor,
                )
              ]))
        ]));
  }
}
