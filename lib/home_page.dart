import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'register_page.dart';
import 'history_page.dart';
import 'info_page.dart';
import 'profile_page.dart';
import 'rule_page.dart';
import 'root_page.dart';

class HomePage extends StatefulWidget {
  String uid,username,userid;
  HomePage({Key key, this.uid,this.username,this.userid}) : super(key: key);
  static String tag = 'newhome-page';
  @override
  _HomePageState createState() => new _HomePageState();
}

final _date = DateTime.now();
final _datetime = _date.year.toString()+"-"+_date.month.toString()
    +"-"+_date.day.toString();
final _userid = TextEditingController();
final _username = TextEditingController();
final _count = TextEditingController();

class _HomePageState extends State<HomePage> {
  bool _loadingInProgress;
  void initState() {
    // TODO: implement initState
    super.initState();
    _loaduser();
  }
  _loaduser()async{
    _loadingInProgress = true;
    await FirebaseDatabase.instance.reference().child("user").child(widget.uid)
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
        title: Text("กำลังดำเนินการ"),
        content: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new CupertinoActivityIndicator(),
          ],
        ),
      ),
    );
  }
  Future<bool> _onerror(){
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("วันนี้ยังไม่มีการจอง"),
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
  @override
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
    else{
      return new WillPopScope(
          onWillPop: _oncloseapp,
          child: Scaffold(
            backgroundColor: Color.fromARGB(255, 237,237,237),
            appBar: AppBar(
              title: Text('Stadium Reservation',
                style: new TextStyle(color: Colors.white.withOpacity(1.0)),),
              backgroundColor: Colors.blue,
              iconTheme: new IconThemeData(color: Colors.white.withOpacity(1.0)),
            ),
            drawer: new Drawer(
              child: new ListView(
                children: <Widget>[
                  ListTile(
                    trailing: new Icon((Icons.menu)),
                    title: Text('Menu'),
                    onTap: () {
                      Navigator.pop(context,false);
                    },
                  ),
                  DrawerHeader(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Text("ID: "+_userid.text),
                          new Text("Name: "+_username.text),
                        ]),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 237,237,237),
                    ),
                  ),
                  ListTile(
                    trailing: new Icon((Icons.account_circle)),
                    title: Text('Profile'),
                    onTap: () {
                      var route = new MaterialPageRoute(
                          builder: (BuildContext context) => new ProfilePage(uid: widget.uid,)
                      );
                      Navigator.of(context).push(route);
                    },
                  ),
                  ListTile(
                    trailing: new Icon((Icons.assignment)),
                    title: Text('Reservation'),
                    onTap: () async{
                      _onloadingapp();
                      await FirebaseDatabase.instance.reference().child("user").child(widget.uid)
                          .once().then((DataSnapshot snapshot) {
                        var user = new User.fromSnapshot(snapshot);
                        setState(() {
                          _username.text = user.username;
                          _userid.text = user.userid;
                          _count.text = user.count;
                        });
                      });
                      if(_count.text == "1" + _datetime){
                        var route = new MaterialPageRoute(
                            builder: (BuildContext context) => new InfoPage(uid: widget.uid,)
                        );
                        Navigator.pop(context,false);
                        Navigator.of(context).push(route);
                      }
                      else{
                        _onerror();
                      }
                    },
                  ),
                  ListTile(
                    trailing: new Icon((Icons.access_time)),
                    title: Text('History'),
                    onTap: () {
                      var route = new MaterialPageRoute(
                          builder: (BuildContext context) => new HistoryPage(uid: widget.uid,)
                      );
                      Navigator.of(context).push(route);
                    },
                  ),
                  ListTile(
                    trailing: new Icon((Icons.label_outline)),
                    title: Text('Singout'),
                    onTap: ()async {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      var route = new MaterialPageRoute(
                          builder: (BuildContext context) => new RootPage(uid: "-")
                      );
                      Navigator.of(context).push(route);
                    },
                  ),
                ],
              ),
            ),
            body: new Container(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0,top: 30.0,bottom: 20.0),
              alignment: Alignment.center,
              child:
              new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          new RaisedButton(
                            child: new Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Center(child: Icon(MdiIcons.badminton)),
                                Center(child: Text("Batminton")),
                              ],
                            ),
                            color: new Color.fromARGB(255, 8,61,119),
                            textColor: Color.fromARGB(255, 214,214,192),
                            padding: const EdgeInsets.symmetric(vertical: 60.0, horizontal: 50.0),
                            elevation: 10.0,
                            splashColor: Colors.white70,
                            onPressed: ()async {
                              var route = new MaterialPageRoute(
                                  builder: (BuildContext context) => new RulePage(uid: widget.uid,sname: 'b',)
                              );
                              Navigator.of(context).push(route);
                            },
                          ),
                          new RaisedButton(
                            child: new Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Center(child: Icon(MdiIcons.tennis)),
                                Center(child: Text("Tennis")),
                              ],
                            ),
                            color:  Colors.green,
                            textColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 60.0, horizontal: 60.0),
                            elevation: 10.0,
                            splashColor: Colors.white70,
                            onPressed: () async {
                              var route = new MaterialPageRoute(
                                  builder: (BuildContext context) => new RulePage(uid: widget.uid,sname: "t",)
                              );
                              Navigator.of(context).push(route);
                            },
                          ),
                        ]
                    ),
                    SizedBox(height: 25.0),
                    new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          new RaisedButton(
                            child: new Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Center(child: Icon(MdiIcons.basketball)),
                                Center(child: Text("Basketball")),
                              ],
                            ),
                            color: new Color.fromARGB(255, 222,75,38),
                            textColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 60.0, horizontal: 50.0),
                            elevation: 10.0,
                            splashColor: Colors.white70,
                            onPressed: (){

                            },
                          ),
                          new RaisedButton(
                            child: new Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Center(child: Icon(MdiIcons.soccer)),
                                Center(child: Text("Football")),
                              ],
                            ),
                            color: new Color.fromARGB(255, 229,229,215),
                            textColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 60.0, horizontal: 55.0),
                            elevation: 10.0,
                            splashColor: Colors.white70,
                            onPressed: (){

                            },
                          ),
                        ]
                    )
                  ]
              ),
            ),
          )
      );
    }
  }
}
