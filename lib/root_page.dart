import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';
import 'home_page.dart';

import 'package:firebase_database/firebase_database.dart';

class RootPage extends StatefulWidget {
  static String tag = 'root-page';
  String uid,ctime,sname;
  RootPage({Key key, this.uid}) : super(key: key);
  @override
  RootPageState createState() => new RootPageState();
}

SharedPreferences _uidroot,_uidroot1;

Future<bool> saveuidPreferences (String save) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("uidroot", save);
  return prefs.commit();
}

Future<bool> saveuidPreferences2 (String save) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("uidroot2", save);

  return prefs.commit();
}

Future<String> getuidPreferences () async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String getuid = prefs.getString("uidroot");

  return getuid;
}

Future<String> getuidPreferences2 () async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String getuid = prefs.getString("uidroot2");

  return getuid;
}

Future<bool> removeuidPreferences () async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.clear();
  prefs.remove("uidroot2");
  prefs.remove("uidroot");
  return prefs.commit();
}

final _uid0 = TextEditingController();
final _uid1 = TextEditingController();
final _date = DateTime.now();
final _datetime = _date.year.toString()+"-"+_date.month.toString()
    +"-"+_date.day.toString();

class RootPageState extends State<RootPage> {
  bool _loadingInProgress;
  void initState() {
    super.initState();
    maindata();
  }

  void maindata() async {
    _loadingInProgress = true;
    // uidroot = widget.uid
    await saveuidPreferences(widget.uid);
    // _uid0 = uidroot
    await getuidPreferences().then(upDateData);
    // _uid1 = uidroot2
    await getuidPreferences2().then(upDateData2);

    if(_uid0.text==""||_uid0.text==null){
      // uidroot = _uid1
      await saveuidPreferences(_uid1.text);
    }
    else{
      // uidroot2 = widget.uid
      await saveuidPreferences2(widget.uid);
      // _uid1 = uidroot2
      await getuidPreferences2().then(upDateData2);
    }
    // _uid0 = uidroot
    await getuidPreferences().then(upDateData);
    _loadData();
  }

  void upDateData(String data){
    setState(() {
      _uid0.text = data;
    });
  }

  void upDateData2(String data){
    setState(() {
      _uid1.text = data;
    });
  }

  Future _loadData() async {
    await new Future.delayed(new Duration());
    _dataLoaded();
  }

  void _dataLoaded() {
    setState(() {
      _loadingInProgress = false;
    });
  }



  Widget build(BuildContext context) {
    if(_loadingInProgress){
      return Scaffold(
        appBar: AppBar(
          title: Text('Reservation Badminton',
            style: new TextStyle(color: Colors.white.withOpacity(1.0)),),
          backgroundColor: Colors.blue,
          iconTheme: new IconThemeData(color: Colors.white.withOpacity(1.0)),
        ),
        body: const Center(
          child: CupertinoActivityIndicator(),
        ),
      );
    }
    else if(_uid0.text==""||_uid0.text==null||_uid0.text=="-"){
      return LoginPage();
    }
    else if(_uid0.text==_uid1.text){
      return HomePage(uid: _uid0.text,);
    }
    else{
      return LoginPage();
    }
  }

  Widget _getLandingPage() {
    return StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.providerData.length == 1) { // logged in using email and password
            return snapshot.data.isEmailVerified
                ? LoginPage()
                : HomePage(uid: snapshot.data.uid);
          } else { // logged in using other providers
            return LoginPage();
          }
        } else {
          return LoginPage();
        }
      },
    );
  }


}

