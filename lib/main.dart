import 'package:flutter_mcu/comm/redux/AppState.dart';
import 'package:flutter_mcu/view/view_drawer.dart';
import 'package:flutter_mcu/view/view_home.dart';
import 'package:flutter_mcu/view/view_mine.dart';
import 'package:flutter_mcu/view/view_study.dart';
import 'package:flutter_mcu/view/view_tools.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  final store = Store<AppState>(appReducer,
      initialState: AppState(themeData: ThemeData(primarySwatch: Colors.blue)));

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
        store: store,
        child: StoreBuilder<AppState>(builder: (context, store) {
          return MaterialApp(
            home: MyHomePage(),
            theme: store.state.themeData,
          );
        }));
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  PageController pageController;
  int page = 0;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      drawer: MyDrawer(),
      backgroundColor: Colors.grey,
      body: new PageView(
        children: <Widget>[
          new HomePage(),
          new StudyPage(),
          new ToolsPage(),
          new MinePage()
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
        fixedColor: Theme.of(context).primaryColor,
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
      this.page = value;
    });
  }
}
