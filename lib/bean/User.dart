import 'dart:convert';

class User {
  int createAt;
  int permId;
  int updateAt;
  int userId;
  int userType;
  String birthday;
  String email;
  String imgUrl;
  String mac;
  String phone;
  String userName;
  String userSex;

  User.fromParams(
      {this.createAt,
      this.permId,
      this.updateAt,
      this.userId,
      this.userType,
      this.birthday,
      this.email,
      this.imgUrl,
      this.mac,
      this.phone,
      this.userName,
      this.userSex});

  User.fromJson(jsonRes) {
    createAt = jsonRes['createAt'];
    permId = jsonRes['permId'];
    updateAt = jsonRes['updateAt'];
    userId = jsonRes['userId'];
    userType = jsonRes['userType'];
    birthday = jsonRes['birthday'];
    email = jsonRes['email'];
    imgUrl = jsonRes['imgUrl'];
    mac = jsonRes['mac'];
    phone = jsonRes['phone'];
    userName = jsonRes['userName'];
    userSex = jsonRes['userSex'];
  }

  @override
  String toString() {
    return '{"createAt": $createAt,"permId": $permId,"updateAt": $updateAt,"userId": $userId,"userType": $userType,"birthday": ${birthday != null ? '${json.encode(birthday)}' : 'null'},"email": ${email != null ? '${json.encode(email)}' : 'null'},"imgUrl": ${imgUrl != null ? '${json.encode(imgUrl)}' : 'null'},"mac": ${mac != null ? '${json.encode(mac)}' : 'null'},"phone": ${phone != null ? '${json.encode(phone)}' : 'null'},"userName": ${userName != null ? '${json.encode(userName)}' : 'null'},"userSex": ${userSex != null ? '${json.encode(userSex)}' : 'null'}}';
  }

  User.empty();
}
