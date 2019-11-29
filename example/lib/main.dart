import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xe_shop_sdk/xe_shop_sdk.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dio/dio.dart';
import 'dart:convert' show json;
import 'example.dart';

void main() => runApp(
    MyApp()
);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WebViewDemo(),
    );
  }
}

class WebViewDemo extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios),
          ),
          title: Text('XEWebView demo')
      ),
      body: Center(
        child: FlatButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Example()));
          },
          child: Text(
            "Open WebView Demo ",
            style: TextStyle(color: Colors.white),
          ),
          color: Colors.black,
        ),
      ),
    );
  }
}


