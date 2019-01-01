import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mcu/bean/User.dart';
import 'package:flutter_mcu/comm/config/Config.dart';
import 'package:flutter_mcu/comm/redux/AppState.dart';
import 'package:flutter_mcu/comm/redux/ThemeRedux.dart';
import 'package:flutter_mcu/comm/redux/UserRedux.dart';
import 'package:flutter_mcu/utils/sp_utils.dart';
import 'package:flutter_mcu/utils/toast_utils.dart';
import 'package:flutter_mcu/view/view_home.dart';
import 'package:flutter_mcu/view/view_mine.dart';
import 'package:flutter_mcu/view/view_study.dart';
import 'package:flutter_mcu/view/view_tools.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final store = Store<AppState>(appReducer,
      initialState: AppState(
          user: User.empty(),
          themeData: ThemeData(primarySwatch: Config.getThemeListColor()[0])));

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
        store: store,
        child: StoreBuilder<AppState>(builder: (context, store) {
          return MaterialApp(
            home: MyHomePage(store),
            theme: store.state.themeData,
          );
        }));
  }
}

class MyHomePage extends StatefulWidget {
  final store;

  MyHomePage(this.store);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  PageController pageController;
  int page = 0;
  int lastTime = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          backgroundColor: Colors.grey,
          body: PageView(
            children: <Widget>[
              HomePage(),
              StudyPage(),
              ToolsPage(),
              MinePage()
            ],
            controller: pageController,
            onPageChanged: onPageChanged,
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home), title: Text("首页")),
              BottomNavigationBarItem(
                  icon: Icon(Icons.laptop_chromebook), title: Text("学习")),
              BottomNavigationBarItem(
                  icon: Icon(Icons.featured_play_list), title: Text("工具")),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), title: Text("我的")),
            ],
            type: BottomNavigationBarType.fixed,
            fixedColor: Theme.of(context).primaryColor,
            onTap: onTap,
            currentIndex: page,
          ),
        ),
        onWillPop: () {
          int newTime = DateTime.now().millisecondsSinceEpoch;
          int result = newTime - lastTime;
          lastTime = newTime;
          if (result > 2000) {
            Toast.show(context, '再按一次退出');
          } else {
            SystemNavigator.pop();
          }
          return null;
        });
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: this.page);
    _getConfig();
  }

  //初始化全局配置
  Future<Null> _getConfig() async {
    int theme = await SpUtils.getTheme();
    User user = await SpUtils.getUser();
    setState(() {
      widget.store.dispatch(UpdateUserAction(user));
      widget.store.dispatch(RefreshThemeDataAction(
          ThemeData(primarySwatch: Config.getThemeListColor()[theme])));
    });
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
