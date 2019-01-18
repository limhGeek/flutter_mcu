import 'package:flutter/material.dart';
import 'package:flutter_html_view/flutter_html_view.dart';
import 'package:flutter_mcu/bean/Course.dart';
import 'package:flutter_mcu/comm/config/Config.dart';
import 'package:flutter_mcu/comm/net/Api.dart';
import 'package:flutter_mcu/comm/net/Http.dart';
import 'package:flutter_mcu/utils/toast_utils.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CoursePage extends StatefulWidget {
  final String title;
  final int courseId;

  CoursePage(this.title, this.courseId);

  @override
  _CoursePageState createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  Course course;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _getCourse();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: _body(),
    );
  }

  Widget _body() {
    if (isLoading) {
      return Center(
          child:
              SpinKitWave(color: Theme.of(context).primaryColor, size: 30.0));
    }
    if (null == course || course.html.isEmpty) {
      return Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        IconButton(
            icon: Icon(Icons.cached,
                size: 36, color: Theme.of(context).disabledColor),
            onPressed: () => _getCourse()),
        Text('加载失败，点击重试',
            style: TextStyle(
                color: Theme.of(context).disabledColor, fontSize: 16.0))
      ]));
    } else {

      String html = Config.HTML_HEAD
          .replaceAll('tttt', widget.title)
          .replaceAll('dddd', course.html)
          .replaceAll('http://c.biancheng.net', '');

      print(html);
      return SingleChildScrollView(
          child: HtmlView(
        data: html,
        baseURL: "http://c.biancheng.net",
        onLaunchFail: (url) {
          print('加载失败:$url');
        },
      ));
    }
  }


  Future _getCourse() async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });
    Http.get(Api.URL_COURSE_CATALOG + "/${widget.courseId}",
        successCallBack: (data) {
      setState(() {
        course = Course.fromJson(data);
        isLoading = false;
      });
    }, errorCallBack: (msg) {
      Toast.show(context, msg);
      setState(() {
        isLoading = false;
      });
    });
  }
}
