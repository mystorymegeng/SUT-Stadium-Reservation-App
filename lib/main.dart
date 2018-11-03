import 'package:flutter/material.dart';
import 'login_page.dart';
import 'root_page.dart';
import 'rule_page.dart';



void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  final routes = <String, WidgetBuilder>{

  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App by mystoryme',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Nunito',
      ),
      home: RootPage(),
      routes: routes,
    );
  }
}



