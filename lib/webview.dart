import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_webview_pro/webview_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'iframehome.dart';

class WebViewExample extends StatefulWidget {
  var url;
  WebViewExample({required this.url});
  @override
  _WebViewExampleState createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<WebViewExample> {
  Completer<WebViewController> _controller = Completer<WebViewController>();
  late SharedPreferences logindata;
  late String yeniurl;
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  void initial() async {
    logindata = await SharedPreferences.getInstance();
    setState(() {
      yeniurl = logindata.getString('url')!;
    });
  }

  @override
  Widget build(BuildContext context) {
    initial();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text(yeniurl + ".i-frame.io"),
        actions: <Widget>[
          NavigationControls(_controller.future),
          Padding(
              padding: EdgeInsets.only(left: 0.0, right: 0.0),
              child: SizedBox(
                child: FlatButton(
                  onPressed: () {
                    logindata.setBool('login', true);
                    Navigator.pushReplacement(
                      context,
                      new MaterialPageRoute(builder: (context) => iframehome()),
                    );
                  },
                  child: Text(
                    'Çıkış Yap',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )),
        ],
      ),
      body: Builder(builder: (BuildContext context) {
        return WebView(
          initialUrl: "https://" + yeniurl + ".i-frame.io/html/login.html",

          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },

          javascriptChannels: <JavascriptChannel>{
            _toasterJavascriptChannel(context),
          },

          gestureNavigationEnabled: true,
          backgroundColor: const Color(0x00000000),
          geolocationEnabled: true, // set geolocationEnable true or not
        );
      }),
      /*  floatingActionButton: FloatingActionButton(
        onPressed: () {
          logindata.setBool('login', true);
          Navigator.pushReplacement(
            context,
            new MaterialPageRoute(builder: (context) => iframehome()),
          );
        },
        backgroundColor: Colors.red,
        child: const Icon(Icons.arrow_back),
      ),*/
    );
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          // ignore: deprecated_member_use
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }

  Widget favoriteButton() {
    return FutureBuilder<WebViewController>(
        future: _controller.future,
        builder: (BuildContext context,
            AsyncSnapshot<WebViewController> controller) {
          return Container();
        });
  }
}

class NavigationControls extends StatelessWidget {
  const NavigationControls(this._webViewControllerFuture)
      : assert(_webViewControllerFuture != null);

  final Future<WebViewController> _webViewControllerFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
      future: _webViewControllerFuture,
      builder:
          (BuildContext context, AsyncSnapshot<WebViewController> snapshot) {
        final bool webViewReady =
            snapshot.connectionState == ConnectionState.done;
        final WebViewController? controller = snapshot.data;
        return Row(
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: !webViewReady
                  ? null
                  : () async {
                      if (await controller!.canGoBack()) {
                        await controller.goBack();
                      } else {
                        // ignore: deprecated_member_use
                        Scaffold.of(context).showSnackBar(
                          const SnackBar(content: Text('Sayfa Bulunamadı')),
                        );
                        return;
                      }
                    },
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: !webViewReady
                  ? null
                  : () async {
                      if (await controller!.canGoForward()) {
                        await controller.goForward();
                      } else {
                        // ignore: deprecated_member_use
                        Scaffold.of(context).showSnackBar(
                          const SnackBar(content: Text('Sayfa Bulunamadı')),
                        );
                        return;
                      }
                    },
            ),
            IconButton(
              icon: const Icon(Icons.replay),
              onPressed: !webViewReady
                  ? null
                  : () {
                      controller!.reload();
                    },
            ),
          ],
        );
      },
    );
  }
}
