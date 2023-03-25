import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewWidget extends StatefulWidget {
  const WebViewWidget({
    Key? key,
    this.title,
    required this.url,
  }) : super(key: key);

  final String? title;
  final String url;

  @override
  _WebViewWidgetState createState() => _WebViewWidgetState();
}

class _WebViewWidgetState extends State<WebViewWidget> {
  final Completer<WebViewController> _controller =
  Completer<WebViewController>();

  bool _isLoading = false; // ページ読み込み状態
  double _downloadProgress = 0.0; // ページ読み込みの進捗値
  String _title = '';
  String _url = '';

  @override
  void initState() {
    super.initState();
    _title = widget.title ?? '';
    _url = widget.url;

    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      body: Column(
        children: [
          _isLoading
              ? LinearProgressIndicator(value: _downloadProgress)
              : const SizedBox.shrink(),
          Expanded(
            child: WebView(
              // 表示する初期URLの指定
              initialUrl: _url,
              // javascriptを有効化. disabled で無効化
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                _controller.complete(webViewController);
              },
              // ページ読み込み中の処理
              onProgress: (int progress) {
                print('Webサイトを読み込み中です... (進捗 : $progress%)');
                setState(() {
                  _downloadProgress = (progress / 100);
                });
              },
              // ページへの遷移処理開始時の処理
              navigationDelegate: (NavigationRequest request) {
                // 特定URLへのアクセスは拒否する
                if (request.url.startsWith('https://github.com/')) {
                  print('blocking navigation to $request}');
                  return NavigationDecision.prevent;
                }
                print('allowing navigation to $request');
                return NavigationDecision.navigate;
              },
              // ページの読み込み開始時の処理
              onPageStarted: (String url) {
                print('Page started loading: $url');
                setState(() {
                  _isLoading = true;
                });
              },
              // ページの読み込み完了時の処理
              onPageFinished: (String url) async {
                print('Page finished loading: $url');
                setState(() {
                  _isLoading = false;
                });
                // Webページのタイトルを取得
                final controller = await _controller.future;
                final title = await controller.getTitle();
                setState(() {
                  if (title != null) {
                    _title = title;
                  }
                });
              },
              // 水平方向のスワイプ時に戻る、進むを機能させるかのフラグ。iOSでのみ機能する。
              gestureNavigationEnabled: true,
              // 背景色
              backgroundColor: const Color(0x00000000),
              // ページ読み込み終了
            ),
          ),
        ],
      ),
    );
  }
}