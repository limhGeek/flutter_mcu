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
  FlutterWebviewPlugin flutterWebviewPlugin = FlutterWebviewPlugin();

  @override
  void initState() {
    super.initState();
    print('${widget.title}https://tdnr.gitee.io/limh/${widget.url}?height=0');
    flutterWebviewPlugin.onStateChanged.listen((wvs) {
      print(wvs.type);
      if (wvs.type == WebViewState.startLoad) {
        isLoading = true;
      } else if (wvs.type == WebViewState.finishLoad) {
        isLoading = false;
      }
      setState(() {});
    });
    flutterWebviewPlugin.onUrlChanged.listen((url) {
      print('url change:$url');
      if (!url.contains('height=0')) {
        flutterWebviewPlugin.stopLoading();
        url = '$url?height=0';
        flutterWebviewPlugin.reloadUrl(url);
      }
    });
  }

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

  @override
  void dispose() {
    super.dispose();
    flutterWebviewPlugin.dispose();
  }
}
