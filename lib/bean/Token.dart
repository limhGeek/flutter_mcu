import 'dart:convert';

class Token {
  int createAt;
  int toeknId;
  int userId;
  String refreshToken;
  String token;

  Token.fromParams(
      {this.createAt,
      this.toeknId,
      this.userId,
      this.refreshToken,
      this.token});

  Token.fromJson(jsonRes) {
    createAt = jsonRes['createAt'];
    toeknId = jsonRes['toeknId'];
    userId = jsonRes['userId'];
    refreshToken = jsonRes['refreshToken'];
    token = jsonRes['token'];
  }

  @override
  String toString() {
    return '{"createAt": $createAt,"toeknId": $toeknId,"userId": $userId,"refreshToken": ${refreshToken != null ? '${json.encode(refreshToken)}' : 'null'},"token": ${token != null ? '${json.encode(token)}' : 'null'}}';
  }

  Token.empty();
}
