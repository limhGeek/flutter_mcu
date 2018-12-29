import 'dart:convert' show json;

class Topic {
  String audit;
  String userImg;
  int createAt;
  int praise;
  int replayCount;
  int replyAt;
  int status;
  int topicId;
  int userId;
  String content;
  String imgsUrl;
  String title;
  String userName;

  Topic.fromParams(
      {this.audit,
      this.userImg,
      this.createAt,
      this.praise,
      this.replayCount,
      this.replyAt,
      this.status,
      this.topicId,
      this.userId,
      this.content,
      this.imgsUrl,
      this.title,
      this.userName});

  factory Topic(jsonStr) => jsonStr == null
      ? null
      : jsonStr is String
          ? new Topic.fromJson(json.decode(jsonStr))
          : new Topic.fromJson(jsonStr);

  Topic.fromJson(jsonRes) {
    audit = jsonRes['audit'];
    userImg = jsonRes['userImg'];
    createAt = jsonRes['createAt'];
    praise = jsonRes['praise'];
    replayCount = jsonRes['replayCount'];
    replyAt = jsonRes['replyAt'];
    status = jsonRes['status'];
    topicId = jsonRes['topicId'];
    userId = jsonRes['userId'];
    content = jsonRes['content'];
    imgsUrl = jsonRes['imgsUrl'];
    title = jsonRes['title'];
    userName = jsonRes['userName'];
  }

  @override
  String toString() {
    return '{"audit": ${audit != null ? '${json.encode(audit)}' : 'null'},"userImg": ${userImg != null ? '${json.encode(userImg)}' : 'null'},"createAt": $createAt,"praise": $praise,"replayCount": $replayCount,"replyAt": $replyAt,"status": $status,"topicId": $topicId,"userId": $userId,"content": ${content != null ? '${json.encode(content)}' : 'null'},"imgsUrl": ${imgsUrl != null ? '${json.encode(imgsUrl)}' : 'null'},"title": ${title != null ? '${json.encode(title)}' : 'null'},"userName": ${userName != null ? '${json.encode(userName)}' : 'null'}}';
  }
}
