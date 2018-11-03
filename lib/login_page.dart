import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';

import 'register_page.dart';
import 'home_page.dart';
import 'root_page.dart';

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';
  @override
  _LoginPageState createState() => new _LoginPageState();
}

final _uid = TextEditingController();
final _email = TextEditingController();
final _password = TextEditingController();

class _LoginPageState extends State<LoginPage> {
  void _login()async{
    try{
      _onloadingapp();
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email.text, password: _password.text)
          .then((data) => _uid.text=data.uid);
      Navigator.pop(context,false);
      var route = new MaterialPageRoute(
          builder: (BuildContext context) => new RootPage(uid: _uid.text)
      );
      Navigator.of(context).push(route);
    }
    catch(e){
      _onerrorapp();
    }
  }
  @override
  Future<bool> _oncloseapp(){
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("ต้องการปิดแอพใช่หรือไม่"),
        actions: <Widget>[
          FlatButton(
            child: Text("ไม่"),
            onPressed: (){
              Navigator.pop(context,false);
            },
          ),
          FlatButton(
            child: Text("ใช่"),
            onPressed: (){
              exit(0);
            },
          )
        ],
      ),
    );
  }
  Future<bool> _onloadingapp(){
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("กำลังเข้าสู่ระบบ"),
        content: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new CupertinoActivityIndicator(),
          ],
        ),
      ),
    );
  }
  Future<bool> _onerrorapp(){
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(

        title: Text("โปรดใส่ข้อมูลให้ถูกต้อง"),
        actions: <Widget>[
          FlatButton(
            child: Text("ตกลง"),
            onPressed: (){
              Navigator.pop(context,false);
              Navigator.pop(context,false);
            },
          ),
        ],
      ),
    );
  }
  Widget build(BuildContext context) {
    // TODO: implement build
    return new WillPopScope(
        onWillPop: _oncloseapp,
        child: new Scaffold(
          backgroundColor: Color.fromARGB(255, 237,237,237),
          appBar: AppBar(
            title: Text('Stadium Reservation',
              style: new TextStyle(color: Colors.white.withOpacity(1.0)),),
            backgroundColor: Colors.blue,
            iconTheme: new IconThemeData(color: Colors.white.withOpacity(1.0)),
          ),
          body: new Center(
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 40.0, right: 40.0),
              children: <Widget>[
                new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Text(
                      "Login",
                      style: new TextStyle(fontSize:24.0,
                          color: const Color(0xFF000000),
                          fontWeight: FontWeight.w700,
                          fontFamily: "Merriweather"),
                    ),
                  ],
                ),
                new Divider(color: Colors.black54,indent: 0.0,),
                SizedBox(height: 15.0,),
                new TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  autofocus: false,
                  controller: _email,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    filled: true,
                    labelText: 'Email ',
                  ),
                ),
                SizedBox(height: 15.0,),
                new TextFormField(
                  keyboardType: TextInputType.text,
                  autofocus: false,
                  obscureText: true,
                  controller: _password,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    filled: true,
                    labelText: 'Password ',
                  ),
                ),
                SizedBox(height: 30.0,),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new RaisedButton(
                        onPressed: (){
                          _login();
                        },
                        child: new Text("Login"),
                        textColor: Colors.white,
                        color: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 50.0),
                    ),
                  ],
                ),
                SizedBox(height: 15.0,),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new FlatButton(
                      onPressed: (){
                        var route = new MaterialPageRoute(
                            builder: (BuildContext context) => new RegisterPage()
                        );
                        Navigator.of(context).push(route);
                      },
                      child: new Text("Register"),
                      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 50.0),
                    ),
                  ],
                ),
              ]
            )
          )
        )
    );
  }
}
