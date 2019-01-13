import 'dart:convert' show json;

class Course {
  String html;
  int readNum;
  int id;
  String subTitle;
  String title;
  String type;

  Course.fromParams(
      {this.html, this.readNum, this.id, this.subTitle, this.title, this.type});

  factory Course(jsonStr) => jsonStr == null
      ? null
      : jsonStr is String
          ? new Course.fromJson(json.decode(jsonStr))
          : new Course.fromJson(jsonStr);

  Course.fromJson(jsonRes) {
    html = jsonRes['html'];
    readNum = jsonRes['readNum'];
    id = jsonRes['id'];
    subTitle = jsonRes['subTitle'];
    title = jsonRes['title'];
    type = jsonRes['type'];
  }

  @override
  String toString() {
    return '{"html": ${html != null ? '${json.encode(html)}' : 'null'},"readNum": $readNum,"id": $id,"subTitle": ${subTitle != null ? '${json.encode(subTitle)}' : 'null'},"title": ${title != null ? '${json.encode(title)}' : 'null'},"type": ${type != null ? '${json.encode(type)}' : 'null'}}';
  }
}
