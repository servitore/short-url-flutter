import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shortlinkflutter/models/linkResponse.dart';
import 'package:toast/toast.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _shortlink = "";
  String _text = "";

  Future<http.Response> _shortLinkFunction(String link) async {
    return await http.post(Uri.https('api-ssl.bitly.com', 'v4/shorten'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer f68ede047e604d09c97d6dc90fecb26e2101ae58'
        },
        body: jsonEncode(<String, String>{'long_url': link}));
  }

  showMessage(String msg) {
    Toast.show(msg, context, gravity: Toast.CENTER);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Create short link Flutter',
              style: Theme.of(context).textTheme.headline5,
            ),
            SelectableText(
              'Your link: $_shortlink',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            TextField(
              onChanged: (String value) {
                print("On change $value");
                setState(() {
                  _text = value;
                });
              },
            ),
            TextButton(
                onPressed: () async {
                  print(
                    "pressed $_text",
                  );
                  http.Response response = await _shortLinkFunction(_text);
                  if (response.statusCode != 200 &&
                      response.statusCode != 201) {
                    showMessage("Somethin went wrong");
                  } else {
                    showMessage("Link created");
                    var obj = LinkResponse.fromJson(jsonDecode(response.body));
                    setState(() {
                      _shortlink = obj?.link;
                    });
                  }
                },
                child: Text("Press me"))
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
