import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'tablet_page.dart';
import 'dart:async';

import 'package:firebase_database/firebase_database.dart';

import 'register_page.dart';
import 'time_function.dart';

class MenuTPage extends StatefulWidget {
  String uid,ctime,sname;
  MenuTPage({Key key, this.uid,this.ctime,this.sname}) : super(key: key);
  static String tag = 'newmenutableb-page';
  @override
  _MenuTPageState createState() => new _MenuTPageState();
}

var _date = DateTime.now();
final _datetime = _date.year.toString()+"-"+_date.month.toString()
    +"-"+_date.day.toString();
final _userid = TextEditingController();
final _username = TextEditingController();
final _count = TextEditingController();

class _MenuTPageState extends State<MenuTPage> {
  bool _loadingInProgress;
  void initState() {
    _date = DateTime.now();
    // TODO: implement initState
    super.initState();
    FirebaseDatabase.instance.reference().child("user").child(widget.uid)
        .once().then((DataSnapshot snapshot) {
      var user = new User.fromSnapshot(snapshot);
      setState(() {
        _username.text = user.username;
        _userid.text = user.userid;
        _count.text = user.count;
      });
      if (user.count == "0" + _datetime || user.count == "1" + _datetime) {
      }
      else {
        _update();
      }
    });
    _updatetimetable();
  }

  _updatetimetable()async{
    _loadingInProgress = true;
    if(_date.hour>=16){
      await Time_Function(widget.uid).deletetable();
    }
    _loadData();
  }

  _update()async{
    Map<String, String> data = <String, String>{
      "count": "0"+_datetime,
    };
    await FirebaseDatabase.instance.reference().child('user').child(widget.uid)
        .update(data).whenComplete(() {print("Document Updated");})
        .catchError((e) => print(e));
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

  @override
  RaisedButton makeRaisedButton(String name) {
    return RaisedButton(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            //Center(child: Icon(Icons.menu)),
            Center(child: Text("Tennis "+name.toUpperCase(),
                style: new TextStyle(fontSize:24.0,)
            )
            ),
          ],
        ),
        color: Colors.green,
        textColor: Color.fromARGB(255, 255,255,255),
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 55.0),
        elevation: 10.0,
        splashColor: Colors.white70,
        onPressed: () {
          var route = new MaterialPageRoute(
              builder: (BuildContext context) => new TableTPage(uid: widget.uid,sname: name,)
          );
          Navigator.of(context).push(route);
        }
    );
  }
  Widget build(BuildContext context) {
    if(_loadingInProgress){
      return Scaffold(
        appBar: AppBar(
          title: Text('Reservation Badminton',
            style: new TextStyle(color: Colors.white.withOpacity(1.0)),),
          backgroundColor: Colors.green,
          iconTheme: new IconThemeData(color: Colors.white.withOpacity(1.0)),
        ),
        body: const Center(
          child: CupertinoActivityIndicator(),
        ),
      );
    }
    else{
      return Scaffold(
          backgroundColor: Color.fromARGB(255, 237,237,237),
          appBar: AppBar(
            title: Text('Stadium Reservation',
              style: new TextStyle(color: Colors.white.withOpacity(1.0)),),
            backgroundColor: Colors.green,
            iconTheme: new IconThemeData(color: Colors.white.withOpacity(1.0)),
          ),
          body: new Center(
              child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.only(left: 40.0, right: 40.0,top: 20.0,bottom: 10.0),
                  children: <Widget>[
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        new Text(
                          "Tennis\n"
                              "Date: "+_datetime,
                          style: new TextStyle(fontSize:24.0,
                              color: const Color(0xFF000000),
                              fontWeight: FontWeight.w700,
                              fontFamily: "Merriweather"),
                        ),
                      ],
                    ),
                    new Divider(color: Colors.black54,indent: 0.0,),
                    SizedBox(height: 10.0),
                    makeRaisedButton('t1'),
                    SizedBox(height: 10.0),
                    makeRaisedButton('t2'),
                    SizedBox(height: 10.0),
                    makeRaisedButton('t3'),
                    SizedBox(height: 10.0),
                    makeRaisedButton('t4'),
                    SizedBox(height: 10.0),
                    makeRaisedButton('t5'),
                    SizedBox(height: 10.0),
                    makeRaisedButton('t6'),
                    SizedBox(height: 10.0),
                    makeRaisedButton('t7'),
                    SizedBox(height: 10.0),
                  ]
              )
          )
      );
    }
  }
}