import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:gank/bean/gank_detail.dart';

String selectedUrl;
String webViewTitle;

class GankDetailPage extends StatefulWidget {

  final GankDetail gankDetail;

  GankDetailPage({@required this.gankDetail});

  @override
  State<StatefulWidget> createState() {
    return new _GankDetailPage();
  }
}

class _GankDetailPage extends State<GankDetailPage> {

  final flutterWebviewPlugin = new FlutterWebviewPlugin();

  StreamSubscription _onDestroy;

  StreamSubscription<String> _onUrlChanged;

  StreamSubscription<WebViewStateChanged> _onStateChanged;

  @override
  void initState() {
    super.initState();

    flutterWebviewPlugin.close();

    selectedUrl = widget.gankDetail.url;
    webViewTitle = widget.gankDetail.desc;

    _onDestroy = flutterWebviewPlugin.onDestroy.listen((_) {
      print("Webview Destroyed");
      if (mounted) {
        Navigator.of(context).pop('/web');
      }
    });

    _onUrlChanged =
        flutterWebviewPlugin.onUrlChanged.listen((String url) async {
          if (mounted) {
            print('加载 $url ');
          }
        });

    _onStateChanged =
        flutterWebviewPlugin.onStateChanged.listen((WebViewStateChanged state) {
          if (mounted) {
            print("onStateChanged: ${state.type} ${state.url}");
          }
        });
  }

  @override
  void dispose() {
    _onDestroy.cancel();
    _onUrlChanged.cancel();
    _onStateChanged.cancel();

    flutterWebviewPlugin.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new WebviewScaffold(
      enableAppScheme: true,
      url: selectedUrl,
      withJavascript: true,
      appBar: new AppBar(
        title: new Text(webViewTitle, style: Theme
            .of(context)
            .textTheme
            .title
            .copyWith(color: Colors.white),),
      ),
      withZoom: true,
    );
  }


}