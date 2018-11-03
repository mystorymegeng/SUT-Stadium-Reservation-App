import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';

import 'package:firebase_database/firebase_database.dart';

import 'info_page.dart';
import 'register_page.dart';

class TableBPage extends StatefulWidget {
  static String tag = 'table-page';
  String uid,ctime,sname;
  TableBPage({Key key, this.uid,this.sname}) : super(key: key);
  @override
  _TableBPageState createState() => new _TableBPageState();
}
final List _list = ["16:00-16:30", "16:30-17:00","17:00-17:30","17:30-18:00","18:00-18:30","18:30-19:00","19:00-19:30","19:30-20:00","20:00-20:30","20:30-21:00"];
final _date = DateTime.now();
final _datetime = _date.year.toString()+"-"+_date.month.toString()
    +"-"+_date.day.toString();

final _status = TextEditingController();
final _userid = TextEditingController();
final _username = TextEditingController();
final _id = TextEditingController();
final _confirm = TextEditingController();
final _ctime = TextEditingController();
final _sname = TextEditingController();

final _check0 =  TextEditingController();
final _check =  TextEditingController();
final _check2 = TextEditingController();
final _check3 = TextEditingController();
final _check4 = TextEditingController();
final _check5 = TextEditingController();
final _check6 = TextEditingController();
final _check7 = TextEditingController();
final _check8 = TextEditingController();
final _check9 = TextEditingController();
final _check10 = TextEditingController();

final _count = TextEditingController();

class _TableBPageState extends State<TableBPage> {
  bool _loadingInProgress;

  void initState() {
    // TODO: implement initState
    super.initState();
    _checkData();
  }

  void _checkData()async{
    _loadingInProgress = true;
    await FirebaseDatabase.instance.reference().child('user').child(widget.uid)
        .once().then((DataSnapshot value) {
      var data = new User.fromSnapshot(value);
      setState(() {
        _userid.text=data.userid;
        _username.text=data.username;
        _count.text=data.count;
      });
    }
    );
    for(int i=0;i<_list.length;i++){
      try{
        await FirebaseDatabase.instance.reference().child("time_table").child("badminton")
            .child(widget.sname).child(_datetime).child(_list[i])
            .once().then((DataSnapshot snapshot) {
          var data = new TableB.fromSnapshot(snapshot);
          if(_list[i]=="16:00-16:30"){
            _check.text = data.status;
          }else if(_list[i]=="16:30-17:00"){
            _check2.text = data.status;
          }
          else if(_list[i]=="17:00-17:30"){
            _check3.text = data.status;
          }
          else if(_list[i]=="17:30-18:00"){
            _check4.text = data.status;
          }
          else if(_list[i]=="18:00-18:30"){
            _check5.text = data.status;
          }
          else if(_list[i]=="18:30-19:00"){
            _check6.text = data.status;
          }
          else if(_list[i]=="19:00-19:30"){
            _check7.text = data.status;
          }
          else if(_list[i]=="19:30-20:00"){
            _check8.text = data.status;
          }
          else if(_list[i]=="20:00-20:30"){
            _check9.text = data.status;
          }
          else if(_list[i]=="20:30-21:00"){
            _check10.text = data.status;
          }
        }
        );
      }
      catch(e){

      }
    }
    _loadData();
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

  void _reservations(String time)async{
    _status.text="true";
    _confirm.text="false";
    _id.text=widget.uid;
    _ctime.text=time;
    _sname.text=widget.sname;
    final item = TableB("",_status.text,_userid.text,_username.text,_confirm.text,_id.text);
    await FirebaseDatabase.instance.reference().child("time_table").child("badminton")
        .child(widget.sname).child(_datetime).child(time).set(item.toJson());
  }

  void _update ()async{
    Map<String, String> data = <String, String>{
      "count": "1"+_datetime,
    };
    await FirebaseDatabase.instance.reference().child('user').child(widget.uid)
        .update(data).whenComplete(() {print("Document Updated");})
        .catchError((e) => print(e));
    final item0 = Tableuser("",_datetime,_ctime.text,_sname.text,_confirm.text);
    await FirebaseDatabase.instance.reference().child("user").child("${widget.uid}")
        .child("table").child(_datetime).set(item0.toJson());
  }

  @override
  Future<bool> _onreservates(String time){
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("ต้องการจองเวลา: "+time+""),
        actions: <Widget>[
          FlatButton(
            child: Text("ไม่"),
            onPressed: (){
              Navigator.pop(context,false);
            },
          ),
          FlatButton(
            child: Text("ใช่"),
            onPressed: ()async{
              try{
                await FirebaseDatabase.instance.reference().child("time_table").child("badminton")
                    .child(widget.sname).child(_datetime).child(time)
                    .once().then((DataSnapshot snapshot) {
                  var data = new TableB.fromSnapshot(snapshot);
                  if(data.status=='true'){
                    Navigator.pop(context,false);
                    _onerror2();
                  }
                });
              }
              catch(e){
                _onloadingapp();
                _reservations(time);
                _update();
                Navigator.pop(context,false);
                Navigator.of(context).pop();
                var route = new MaterialPageRoute(
                    builder: (BuildContext context) => new InfoPage(uid: widget.uid,sname: widget.sname,ctime: _ctime.text,)
                );
                Navigator.of(context).push(route);
              }
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
        title: Text("กำลังโหลด"),
        content: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new CupertinoActivityIndicator(),
          ],
        ),
      ),
    );
  }

  Future<bool> _onerror (){
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("คุณได้ทำการจองไว้แล้ว\nภายใน1วันจองได้เพียง1ครั้งเท่านั้น"),
        actions: <Widget>[
          FlatButton(
            child: Text("ตกลง"),
            onPressed: ()async{
              Navigator.pop(context,false);
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }

  Future<bool> _onerror2 (){
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("มีผู้จองเวลาดังกล่าวแล้วหรือหมดเวลาทำการจอง"),
        actions: <Widget>[
          FlatButton(
            child: Text("ตกลง"),
            onPressed: ()async{
              Navigator.pop(context,false);
              Navigator.pop(context,false);
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }

  VoidCallback _buttons1 (String time)  {
    if(_check.text=="true"){
      _check.text="";
      return null;
    }
    else{
      return(){
        if(_count.text=="0"+_datetime){
          _onreservates(time);
        }
        else{_onerror();}
      };
    }
  }
  VoidCallback _buttons2 (String time)  {

    if(_check2.text=="true"){
      _check2.text="";
      return null;
    }
    else{
      return(){
        if(_count.text=="0"+_datetime){
          _onreservates(time);
        }
        else{_onerror();}
      };
    }
  }
  VoidCallback _buttons3 (String time)  {

    if(_check3.text=="true"){
      _check3.text="";
      return null;
    }
    else{
      return(){
        if(_count.text=="0"+_datetime){
          _onreservates(time);
        }
        else{_onerror();}
      };
    }
  }
  VoidCallback _buttons4 (String time)  {

    if(_check4.text=="true"){
      _check4.text="";
      return null;
    }
    else{
      return(){
        if(_count.text=="0"+_datetime){
          _onreservates(time);
        }
        else{_onerror();}
      };
    }
  }
  VoidCallback _buttons5 (String time)  {

    if(_check5.text=="true"){
      _check5.text="";
      return null;
    }
    else{
      return(){
        if(_count.text=="0"+_datetime){
          _onreservates(time);
        }
        else{_onerror();}
      };
    }
  }
  VoidCallback _buttons6 (String time)  {

    if(_check6.text=="true"){
      _check6.text="";
      return null;
    }
    else{
      return(){
        if(_count.text=="0"+_datetime){
          _onreservates(time);
        }
        else{_onerror();}
      };
    }
  }
  VoidCallback _buttons7 (String time)  {

    if(_check7.text=="true"){
      _check7.text="";
      return null;
    }
    else{
      return(){
        if(_count.text=="0"+_datetime){
          _onreservates(time);
        }
        else{_onerror();}
      };
    }
  }
  VoidCallback _buttons8 (String time)  {

    if(_check8.text=="true"){
      _check8.text="";
      return null;
    }
    else{
      return(){
        if(_count.text=="0"+_datetime){
          _onreservates(time);
        }
        else{_onerror();}
      };
    }
  }
  VoidCallback _buttons9 (String time)  {

    if(_check9.text=="true"){
      _check9.text="";
      return null;
    }
    else{
      return(){
        if(_count.text=="0"+_datetime){
          _onreservates(time);
        }
        else{_onerror();}
      };
    }
  }
  VoidCallback _buttons10 (String time)  {

    if(_check10.text=="true"){
      _check10.text="";
      return null;
    }
    else{
      return(){
        if(_count.text=="0"+_datetime){

          _onreservates(time);
        }
        else{_onerror();}
      };
    }
  }

  Row makeRow(String time, VoidCallback _buttons) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[

        new Text(
          time,
          style: new TextStyle(fontSize:18.0,
              color: const Color(0xFF000000),
              fontWeight: FontWeight.w500,
              fontFamily: "Merriweather"),
        ),

        new RaisedButton(
          child: new Text('จอง',
              style: new TextStyle(
                color: Color.fromARGB(255,255,255,255),
                fontWeight: FontWeight.w700,
              )
          ),
          color: new Color.fromARGB(255, 8,61,119),
          onPressed:_buttons,
        ),
      ],
    );
  }

  Widget build(BuildContext context) {
    return new Scaffold(
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loadingInProgress) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Reservation Badminton',
          style: new TextStyle(color: Colors.white.withOpacity(1.0)),),
          backgroundColor: new Color.fromARGB(255, 8,61,119),
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
          title: Text('Reservation Badminton',
            style: new TextStyle(color: Colors.white.withOpacity(1.0)),),
          backgroundColor: new Color.fromARGB(255, 8,61,119),
          iconTheme: new IconThemeData(color: Colors.white.withOpacity(1.0)),
        ),
        body: new Center(
          child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 40.0, right: 40.0,top: 35.0),
              children: <Widget>[
                new Text(
                  "Badminton: "+widget.sname+" \nDate: "+_datetime,
                  style: new TextStyle(fontSize:24.0,
                  color: const Color(0xFF000000),
                  fontWeight: FontWeight.w700,
                  fontFamily: "Merriweather"),
                ),
                new Divider(color: Colors.black54,indent: 0.0,),
                SizedBox(height: 10.0),
                makeRow("16:00-16:30",_buttons1("16:00-16:30")),
                SizedBox(height: 10.0),
                new Divider(color: Colors.black54,indent: 0.0,),
                SizedBox(height: 10.0),
                makeRow("16:30-17:00",_buttons2("16:30-17:00")),
                SizedBox(height: 10.0),
                new Divider(color: Colors.black54,indent: 0.0,),
                SizedBox(height: 10.0),
                makeRow("17:00-17:30",_buttons3("17:00-17:30")),
                SizedBox(height: 10.0),
                new Divider(color: Colors.black54,indent: 0.0,),
                SizedBox(height: 10.0),
                makeRow("17:30-18:00",_buttons4("17:30-18:00")),
                SizedBox(height: 10.0),
                new Divider(color: Colors.black54,indent: 0.0,),
                SizedBox(height: 10.0),
                makeRow("18:00-18:30",_buttons5("18:00-18:30")),
                SizedBox(height: 10.0),
                new Divider(color: Colors.black54,indent: 0.0,),
                SizedBox(height: 10.0),
                makeRow("18:30-19:00",_buttons6("18:30-19:00")),
                SizedBox(height: 10.0),
                new Divider(color: Colors.black54,indent: 0.0,),
                SizedBox(height: 10.0),
                makeRow("19:00-19:30",_buttons7("19:00-19:30")),
                SizedBox(height: 10.0),
                new Divider(color: Colors.black54,indent: 0.0,),
                SizedBox(height: 10.0),
                makeRow("19:30-20:00",_buttons8("19:30-20:00")),
                SizedBox(height: 10.0),
                new Divider(color: Colors.black54,indent: 0.0,),
                SizedBox(height: 10.0),
                makeRow("20:00-20:30",_buttons9("20:00-20:30")),
                SizedBox(height: 10.0),
                new Divider(color: Colors.black54,indent: 0.0,),
                SizedBox(height: 10.0),
                makeRow("20:30-21:00",_buttons10("20:30-21:00")),
                SizedBox(height: 10.0),
                new Divider(color: Colors.black54,indent: 0.0,),
              ]
          )
        )
      );
    }
  }
}

class TableB {
  String key;
  String status;
  String userid;
  String username;
  String confirm;
  String id;

  TableB(this.key, this.status, this.userid,this.username,this.confirm,this.id);

  TableB.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,

//        dateTime =
//        new DateTime.fromMillisecondsSinceEpoch(snapshot.value["date"]),
        status = snapshot.value["status"],
        userid = snapshot.value["userid"],
        username = snapshot.value["username"],
        confirm = snapshot.value["confirm"],
        id = snapshot.value["id"];

  toJson() {
    return {
      "status": status,
      "userid": userid,
      "username": username,
      "confirm": confirm,
      "id": id,
    };
  }

}

class Tableuser {
  String key;
  String date;
  String time;
  String stadium;
  String confirm;


  Tableuser(this.key, this.date, this.time,this.stadium,this.confirm);

  Tableuser.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        date = snapshot.value["date"],
        time = snapshot.value["time"],
        stadium = snapshot.value["stadium"],
        confirm = snapshot.value["confirm"];
  toJson() {
    return {
      "date": date,
      "time": time,
      "stadium": stadium,
      "confirm": confirm,
    };
  }

}
