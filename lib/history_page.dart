import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';
import 'package:firebase_database/ui/firebase_animated_list.dart';

import 'time_function.dart';

class HistoryPage extends StatefulWidget {

  String uid,ctime,sname;

  HistoryPage({Key key, this.uid,this.ctime,this.sname}) : super(key: key);

  static String tag = 'info-page';

  @override
  _HistoryPageState createState() => new _HistoryPageState();

}

final _date = DateTime.now();
final _datetime = _date.year.toString()+"-"+_date.month.toString()
    +"-"+_date.day.toString();
final _id = TextEditingController();
final _username = TextEditingController();
final _userid = TextEditingController();
final _ctime = TextEditingController();
final _sname = TextEditingController();
final _stadium = TextEditingController();
final _status = TextEditingController();
final _confirm = TextEditingController();
final _p = TextEditingController();

final List _list1 = ["16:00-16:30", "16:30-17:00","17:00-17:30","17:30-18:00","18:00-18:30","18:30-19:00","19:00-19:30","19:30-20:00","20:00-20:30","20:30-21:00"];
final List _list2 = ["16:00-17:00","17:00-18:00", "18:00-19:00","19:00-20:00","20:00-21:00"];
final List _datelist = [];



class _HistoryPageState extends State<HistoryPage> {

  Query _query;
  bool _loadingInProgress;


  void initState() {
    super.initState();
    _id.text="${widget.uid}";
    _loadhistorydata();
  }

  void _loadhistorydata()async{
    _loadingInProgress = true;
    await queryMountains().then((Query query) {
      setState(() {
        _query = query;
      });
    });
    _loadData();
  }

  Future _loadData() async {
    await new Future.delayed(new Duration(seconds: 1));
    _dataLoaded();
  }

  void _dataLoaded() {
    setState(() {
      _loadingInProgress = false;
    });
  }

  Future _delete(String date)async{
    await FirebaseDatabase.instance.reference().child('user').child(widget.uid).child('table').child(date)
        .remove();
  }


  static Future<Query> queryMountains() async {
    return FirebaseDatabase.instance
        .reference()
        .child("user")
        .child(_id.text)
        .child("table")
        .orderByChild("date");
  }
  @override
  Widget build(BuildContext context) {
    Widget body = new ListView(
      children: <Widget>[
        new ListTile(
          title: new Text("ยังไม่มีประวัติการจอง"),
        )
      ],
    );
    if (_loadingInProgress) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Reservation Badminton',
            style: new TextStyle(color: Colors.white.withOpacity(1.0)),),
          backgroundColor: Colors.blue,
          iconTheme: new IconThemeData(color: Colors.white.withOpacity(1.0)),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: (){Navigator.of(context).pop();},
          ),
        ),
        body: const Center(
          child: CupertinoActivityIndicator(),
        ),
      );
    }
    else if(_query != null) {
      body = new Center (
        child: new FirebaseAnimatedList(
          padding: EdgeInsets.only(top: 20.0,bottom: 20.0),
          query: _query,
          itemBuilder: (
              BuildContext context,
              DataSnapshot snapshot,
              Animation<double> animation,
              int index,
              ) {
            String mountainKey = snapshot.key;
            Map map = snapshot.value;
            String name = map['date'] as String;
            String time = map['time'] as String;
            String stadium = map['stadium'] as String;
            String confirm = map['confirm'] as String;

            if(_datetime==name){

            }
            else{
              if(confirm=='false'){
                  _delete(name);
              }
            }

            return new Column(
              children: <Widget>[
                new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      new Text('Date',
                        style: new TextStyle(fontSize:20.0,
                            color: const Color(0xFF000000),
                            fontWeight: FontWeight.w300,
                            fontFamily: "Merriweather"),
                      ),
                      new Text('Stadium',
                        style: new TextStyle(fontSize:20.0,
                            color: const Color(0xFF000000),
                            fontWeight: FontWeight.w300,
                            fontFamily: "Merriweather"),
                      ),
                      new Text('Time',
                        style: new TextStyle(fontSize:20.0,
                            color: const Color(0xFF000000),
                            fontWeight: FontWeight.w300,
                            fontFamily: "Merriweather"),
                      ),

                    ]
                ),
                SizedBox(height: 15.0),
                new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      new Text('$name',
                        style: new TextStyle(fontSize:20.0,
                            color: const Color(0xFF000000),
                            fontWeight: FontWeight.w300,
                            fontFamily: "Merriweather"),
                      ),
                      new Text('$stadium',
                        style: new TextStyle(fontSize:20.0,
                            color: const Color(0xFF000000),
                            fontWeight: FontWeight.w300,
                            fontFamily: "Merriweather"),
                      ),
                      new Text('$time',
                        style: new TextStyle(fontSize:20.0,
                            color: const Color(0xFF000000),
                            fontWeight: FontWeight.w300,
                            fontFamily: "Merriweather"),
                      ),

                    ]
                ),
                SizedBox(height: 15.0),
                new Divider(
                  height: 10.0,
                ),
              ],
            );
          },
        ),
      );
    }
    return new Scaffold(
      appBar: AppBar(
        title: Text('Reservation Badminton',
          style: new TextStyle(color: Colors.white.withOpacity(1.0)),),
        backgroundColor: Colors.blue,
        iconTheme: new IconThemeData(color: Colors.white.withOpacity(1.0)),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: (){Navigator.of(context).pop();},
        ),
      ),
      body: body,
    );
  }
}
