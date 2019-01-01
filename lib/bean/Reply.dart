import 'dart:convert' show json;

class Reply {
  int lastId;
  String userImg;
  int createAt;
  int replyId;
  int topicId;
  int userId;
  String content;
  String userName;

  Reply.fromParams(
      {this.lastId,
      this.userImg,
      this.createAt,
      this.replyId,
      this.topicId,
      this.userId,
      this.content,
      this.userName});

  factory Reply(jsonStr) => jsonStr == null
      ? null
      : jsonStr is String
          ? new Reply.fromJson(json.decode(jsonStr))
          : new Reply.fromJson(jsonStr);

  Reply.fromJson(jsonRes) {
    lastId = jsonRes['lastId'];
    userImg = jsonRes['userImg'];
    createAt = jsonRes['createAt'];
    replyId = jsonRes['replyId'];
    topicId = jsonRes['topicId'];
    userId = jsonRes['userId'];
    content = jsonRes['content'];
    userName = jsonRes['userName'];
  }

  @override
  String toString() {
    return '{"lastId": $lastId,"userImg": ${userImg != null ? '${json.encode(userImg)}' : 'null'},"createAt": $createAt,"replyId": $replyId,"topicId": $topicId,"userId": $userId,"content": ${content != null ? '${json.encode(content)}' : 'null'},"userName": ${userName != null ? '${json.encode(userName)}' : 'null'}}';
  }
}
