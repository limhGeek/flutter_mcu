import 'package:flutter_mcu/view/view_home.dart';
import 'package:flutter_mcu/view/view_mine.dart';
import 'package:flutter_mcu/view/view_study.dart';
import 'package:flutter_mcu/view/view_tools.dart';
import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  PageController pageController;
  int page = -1;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.grey,
      body: new PageView(
        children: <Widget>[
          new HomeView(),
          new StudyView(),
          new ToolsView(),
          new MineView()
        ],
        controller: pageController,
        onPageChanged: onPageChanged,
      ),
      bottomNavigationBar: new BottomNavigationBar(
        items: [
          new BottomNavigationBarItem(
              icon: new Icon(Icons.home), title: new Text("首页")),
          new BottomNavigationBarItem(
              icon: new Icon(Icons.laptop_chromebook), title: new Text("学习")),
          new BottomNavigationBarItem(
              icon: new Icon(Icons.featured_play_list), title: new Text("工具")),
          new BottomNavigationBarItem(
              icon: new Icon(Icons.person), title: new Text("我的")),
        ],
        type: BottomNavigationBarType.fixed,
        fixedColor: Colors.lightBlue,
        onTap: onTap,
        currentIndex: page,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    pageController = new PageController(initialPage: this.page);
  }

  void onTap(int index) {
    pageController.animateToPage(index,
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
  }

  void onPageChanged(int value) {
    setState(() {
      this.page = page;
    });
  }
}
