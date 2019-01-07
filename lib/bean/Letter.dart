import 'dart:convert' show json;

class Letter {
  int status;
  int createAt;
  int id;
  int msgType;
  int recvId;
  int sendId;
  String content;
  String recvImg;
  String recvName;
  String sendImg;
  String sendName;

  Letter.fromParams(
      {this.status,
      this.createAt,
      this.id,
      this.msgType,
      this.recvId,
      this.sendId,
      this.content,
      this.recvImg,
      this.recvName,
      this.sendImg,
      this.sendName});

  factory Letter(jsonStr) => jsonStr == null
      ? null
      : jsonStr is String
          ? new Letter.fromJson(json.decode(jsonStr))
          : new Letter.fromJson(jsonStr);

  Letter.fromJson(jsonRes) {
    status = jsonRes['status'];
    createAt = jsonRes['createAt'];
    id = jsonRes['id'];
    msgType = jsonRes['msgType'];
    recvId = jsonRes['recvId'];
    sendId = jsonRes['sendId'];
    content = jsonRes['content'];
    recvImg = jsonRes['recvImg'];
    recvName = jsonRes['recvName'];
    sendImg = jsonRes['sendImg'];
    sendName = jsonRes['sendName'];
  }

  @override
  String toString() {
    return '{"status": $status,"createAt": $createAt,"id": $id,"msgType": $msgType,"recvId": $recvId,"sendId": $sendId,"content": ${content != null ? '${json.encode(content)}' : 'null'},"recvImg": ${recvImg != null ? '${json.encode(recvImg)}' : 'null'},"recvName": ${recvName != null ? '${json.encode(recvName)}' : 'null'},"sendImg": ${sendImg != null ? '${json.encode(sendImg)}' : 'null'},"sendName": ${sendName != null ? '${json.encode(sendName)}' : 'null'}}';
  }
}
