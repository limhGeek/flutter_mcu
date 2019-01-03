import 'dart:convert' show json;

class Fans {
  bool myFollow;
  String coverImg;
  String profile;
  int fansNum;
  int followNum;
  int userId;
  String imgUrl;
  String userName;
  List<FansUser> fansList;
  List<FansUser> followList;

  Fans.fromParams({this.myFollow,this.coverImg, this.profile, this.fansNum, this.followNum, this.userId, this.imgUrl, this.userName, this.fansList, this.followList});

  factory Fans(jsonStr) => jsonStr == null ? null : jsonStr is String ? new Fans.fromJson(json.decode(jsonStr)) : new Fans.fromJson(jsonStr);

  Fans.fromJson(jsonRes) {
    myFollow = jsonRes['myFollow'];
    coverImg = jsonRes['coverImg'];
    profile = jsonRes['profile'];
    fansNum = jsonRes['fansNum'];
    followNum = jsonRes['followNum'];
    userId = jsonRes['userId'];
    imgUrl = jsonRes['imgUrl'];
    userName = jsonRes['userName'];
    fansList = jsonRes['fansList'] == null ? null : [];

    for (var fansListItem in fansList == null ? [] : jsonRes['fansList']){
      fansList.add(fansListItem == null ? null : new FansUser.fromJson(fansListItem));
    }

    followList = jsonRes['followList'] == null ? null : [];

    for (var followListItem in followList == null ? [] : jsonRes['followList']){
      followList.add(followListItem == null ? null : new FansUser.fromJson(followListItem));
    }
  }

  @override
  String toString() {
    return '{"coverImg": ${coverImg != null?'${json.encode(coverImg)}':'null'},"profile": ${profile != null?'${json.encode(profile)}':'null'},"fansNum": $fansNum,"followNum": $followNum,"userId": $userId,"imgUrl": ${imgUrl != null?'${json.encode(imgUrl)}':'null'},"userName": ${userName != null?'${json.encode(userName)}':'null'},"fansList": $fansList,"followList": $followList}';
  }
}

class FansUser {

  String coverImg;
  String profile;
  int userId;
  String imgUrl;
  String userName;

  FansUser.fromParams({this.coverImg, this.profile, this.userId, this.imgUrl, this.userName});

  FansUser.fromJson(jsonRes) {
    coverImg = jsonRes['coverImg'];
    profile = jsonRes['profile'];
    userId = jsonRes['userId'];
    imgUrl = jsonRes['imgUrl'];
    userName = jsonRes['userName'];
  }

  @override
  String toString() {
    return '{"coverImg": ${coverImg != null?'${json.encode(coverImg)}':'null'},"profile": ${profile != null?'${json.encode(profile)}':'null'},"userId": $userId,"imgUrl": ${imgUrl != null?'${json.encode(imgUrl)}':'null'},"userName": ${userName != null?'${json.encode(userName)}':'null'}}';
  }
}