import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_mcu/bean/Course.dart';
import 'package:flutter_mcu/comm/config/Config.dart';
import 'package:flutter_mcu/comm/net/Api.dart';
import 'package:flutter_mcu/comm/net/Http.dart';
import 'package:flutter_mcu/utils/sp_utils.dart';
import 'package:flutter_mcu/utils/toast_utils.dart';
import 'package:flutter_mcu/view/study/view_course.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class McuPage extends StatefulWidget {
  final String title;
  final String type;

  McuPage(this.title, this.type);

  @override
  _McuPageState createState() => _McuPageState();
}

class _McuPageState extends State<McuPage> {
  List<ExpansionBean> _item = List();
  Map<String, List<Course>> _map = Map();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getCagalog();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title), centerTitle: true),
      body: _bodyView(),
    );
  }

  Widget _bodyView() {
    if (isLoading) {
      return Center(
          child:
              SpinKitWave(color: Theme.of(context).primaryColor, size: 30.0));
    }
    if (null == _item || _item.isEmpty) {
      return Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        IconButton(
            icon: Icon(Icons.cached,
                size: 36, color: Theme.of(context).disabledColor),
            onPressed: () => getCagalog()),
        Text('加载失败，点击重试',
            style: TextStyle(
                color: Theme.of(context).disabledColor, fontSize: 16.0))
      ]));
    } else {
      return SingleChildScrollView(
          child: Column(children: <Widget>[
        ExpansionPanelList(
          expansionCallback: (index, bol) {
            setState(() {
              _item[index].isOpen = !bol;
            });
          },
          children: _item.map((expansionBean) {
            return ExpansionPanel(
                headerBuilder: (context, isExpanded) {
                  return Container(
                      padding: EdgeInsets.all(10.0),
                      child: Row(children: <Widget>[
                        Icon(Icons.description),
                        Container(width: 10.0, height: 10.0),
                        Expanded(
                            child: Text(
                                widget.type == 'ORDER'
                                    ? '${expansionBean.course.title}(${_map[expansionBean.course.title].length}条)'
                                    : '${expansionBean.course.title}',
                                style: TextStyle(fontSize: 16.0)))
                      ]));
                },
                isExpanded: expansionBean.isOpen,
                body: Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: ListBody(
                      children: _expanList(_map[expansionBean.course.title]),
                    )));
          }).toList(),
        ),
        Offstage(
          offstage: widget.type != 'ORDER',
          child: Container(
              padding: EdgeInsets.all(10.0),
              child: Text(Config.ASM_INFO,
                  style: TextStyle(fontSize: 16.0, wordSpacing: 2))),
        )
      ]));
    }
  }

  List<Widget> _expanList(List<Course> _item) {
    List<Widget> _widgets = [];
    _item.forEach((course) {
      _widgets.add(_expanItem(course));
      _widgets.add(Divider());
    });
    return _widgets;
  }

  Widget _expanItem(Course course) {
    if (widget.type == "ORDER") {
      return Container(
          padding: EdgeInsets.fromLTRB(36.0, 10, 10, 10),
          child: Text(course.subTitle.replaceAll('|', '\n')));
    } else {
      return GestureDetector(
          child: Container(
              padding: EdgeInsets.fromLTRB(36.0, 10, 10, 10),
              child: Text(course.subTitle)),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) {
              return CoursePage(course.subTitle, course.id);
            }));
          });
    }
  }

  Future getCagalog() async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });
    print('${widget.title}_${widget.type}');
    List list = await SpUtils.getMcu(widget.type);
    if (null != list && list.length > 0) {
      setState(() {
        List<Course> itemCourse;
        list.forEach((tmp) {
          Course course = tmp;
          if (!_map.containsKey(course.title)) {
            itemCourse = List<Course>();
            _item.add(ExpansionBean(false, course));
            _map[course.title] = itemCourse;
          }
          itemCourse.add(course);
        });
        isLoading = false;
      });
    } else {
      Http.get(Api.URL_COURSE_CATALOG, params: {"type": widget.type},
          successCallBack: (data) {
        print(json.encode(data));
        SpUtils.saveMcu(widget.type, json.encode(data));
        List list = data.map((m) => Course.fromJson(m)).toList();
        setState(() {
          List<Course> itemCourse;
          list.forEach((tmp) {
            Course course = tmp;
            if (!_map.containsKey(course.title)) {
              itemCourse = List<Course>();
              _item.add(ExpansionBean(false, course));
              _map[course.title] = itemCourse;
            }
            itemCourse.add(course);
          });
          isLoading = false;
        });
        print("数组：$_map");
      }, errorCallBack: (msg) {
        Toast.show(context, msg);
        setState(() {
          isLoading = false;
        });
      });
    }
  }
}

class ExpansionBean {
  bool isOpen;
  Course course;

  ExpansionBean(this.isOpen, this.course);
}
