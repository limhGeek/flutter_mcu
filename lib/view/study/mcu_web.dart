import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class WebInfoPage extends StatefulWidget {
  final String title;
  final String url;

  WebInfoPage(this.title, this.url);

  @override
  State<StatefulWidget> createState() {
    return _WebInfoPage();
  }
}

class _WebInfoPage extends State<WebInfoPage> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    print('${widget.title}https://tdnr.gitee.io/limh/${widget.url}?height=0');
  }

//  FlutterWebviewPlugin _flutterWebviewPlugin = FlutterWebviewPlugin();
  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      appBar: AppBar(title: Text(widget.title)),
      url: 'https://tdnr.gitee.io/limh/${widget.url}?height=0',
      initialChild: Center(
          child:
              SpinKitWave(color: Theme.of(context).primaryColor, size: 30.0)),
    );
  }
}
