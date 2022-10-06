import 'package:flutter/material.dart';
import 'package:iframe/webview.dart';
import 'package:shared_preferences/shared_preferences.dart';

class iframehome extends StatefulWidget {
  const iframehome({Key? key}) : super(key: key);

  @override
  _iframehomeState createState() => _iframehomeState();
}

class _iframehomeState extends State<iframehome> {
  TextEditingController url = TextEditingController();
  late SharedPreferences logindata;
  late bool newuser;

  void initState() {
    super.initState();
    check_if_already_login();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.blueGrey,
      body: Center(
        child: Card(
          margin: EdgeInsets.all(30),
          shape: RoundedRectangleBorder(
              side: BorderSide(
                color: Colors.blueAccent,
              ),
              borderRadius: BorderRadius.circular(30.0)),
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.transparent,
                  backgroundImage: AssetImage('asset/iframe.png'),
                ),
                SizedBox(
                  height: 10,
                ),
                const ListTile(
                  leading: Icon(Icons.computer),
                  title: Text(
                    'Hoş Geldiniz',
                    style: TextStyle(fontSize: 20),
                  ),
                  subtitle: Text(
                    'Giriş yapmak istediğiniz adresi yazınız',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 70.0),
                  child: TextFormField(
                    controller: url,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Doğru adres girdiğinizden emin olun";
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      labelText: "Adres",
                      hintStyle: TextStyle(fontSize: 18),
                    ),
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    TextButton(
                      child: const Text('Giriş Yap',
                          style: TextStyle(fontSize: 18)),
                      onPressed: () {
                        if (url.text == null || url.text == "") {
                          showDialog(
                              context: context,
                              builder: (_) {
                                return Dialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4)),
                                  child: Stack(
                                    overflow: Overflow.visible,
                                    alignment: Alignment.topCenter,
                                    children: [
                                      Container(
                                        height: 200,
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 70, 10, 10),
                                          child: Column(children: [
                                            Text(
                                              "UYARI!!",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              "Lütfen Doğru Adres Giriniz ",
                                              style: TextStyle(
                                                fontSize: 20,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            SizedBox(height: 20),
                                            RaisedButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text("Tamam",
                                                    style: TextStyle(
                                                        color: Colors
                                                            .blueAccent))),
                                          ]),
                                        ),
                                      ),
                                      Positioned(
                                        child: CircleAvatar(
                                          backgroundColor: Colors.redAccent,
                                          radius: 50,
                                          child: Icon(
                                            Icons.warning,
                                            size: 50,
                                            color: Colors.white,
                                          ),
                                        ),
                                        top: -60,
                                      )
                                    ],
                                  ),
                                );
                              });
                        } else {
                          logindata.setBool('login', false);
                          logindata.setString('url', url.text);

                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                // builder: (context) => iframesite(url: url.text),
                                builder: (context) =>
                                    WebViewExample(url: url.text),
                              ));
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void check_if_already_login() async {
    logindata = await SharedPreferences.getInstance();
    newuser = (logindata.getBool('login') ?? true);
    if (newuser == false) {
      Navigator.pushReplacement(
          context,
          new MaterialPageRoute(
              builder: (context) => WebViewExample(
                    url: url.text,
                  )));
    }
  }

  void dispose() {
    url.dispose();
    super.dispose();
  }
}
