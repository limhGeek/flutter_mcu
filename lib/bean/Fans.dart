import 'dart:convert' show json;

import 'package:flutter_mcu/bean/Topic.dart';
import 'package:flutter_mcu/bean/User.dart';

class Fans {
  bool myFollow;
  String coverImg;
  String profile;
  int topicNum;
  int fansNum;
  int followNum;
  int userId;
  String imgUrl;
  String userName;
  List<Topic> topicList;
  List<User> fansList;
  List<User> followList;

  Fans.fromParams(
      {this.myFollow,
      this.coverImg,
      this.profile,
      this.topicNum,
      this.fansNum,
      this.followNum,
      this.userId,
      this.imgUrl,
      this.userName,
      this.fansList,
      this.followList});

  factory Fans(jsonStr) => jsonStr == null
      ? null
      : jsonStr is String
          ? new Fans.fromJson(json.decode(jsonStr))
          : new Fans.fromJson(jsonStr);

  Fans.fromJson(jsonRes) {
    myFollow = jsonRes['myFollow'];
    coverImg = jsonRes['coverImg'];
    profile = jsonRes['profile'];
    topicNum = jsonRes['topicNum'];
    fansNum = jsonRes['fansNum'];
    followNum = jsonRes['followNum'];
    userId = jsonRes['userId'];
    imgUrl = jsonRes['imgUrl'];
    userName = jsonRes['userName'];
    topicList = jsonRes['topicList'] == null ? null : [];

    for (var topicListItem in topicList == null ? [] : jsonRes['topicList']) {
      topicList.add(
          topicListItem == null ? null : new Topic.fromJson(topicListItem));
    }

    fansList = jsonRes['fansList'] == null ? null : [];

    for (var fansListItem in fansList == null ? [] : jsonRes['fansList']) {
      fansList
          .add(fansListItem == null ? null : new User.fromJson(fansListItem));
    }

    followList = jsonRes['followList'] == null ? null : [];

    for (var followListItem
        in followList == null ? [] : jsonRes['followList']) {
      followList.add(
          followListItem == null ? null : new User.fromJson(followListItem));
    }
  }

  @override
  String toString() {
    return '{"coverImg": ${coverImg != null ? '${json.encode(coverImg)}' : 'null'},"profile": ${profile != null ? '${json.encode(profile)}' : 'null'},"fansNum": $fansNum,"followNum": $followNum,"userId": $userId,"imgUrl": ${imgUrl != null ? '${json.encode(imgUrl)}' : 'null'},"userName": ${userName != null ? '${json.encode(userName)}' : 'null'},"fansList": $fansList,"followList": $followList}';
  }
}
