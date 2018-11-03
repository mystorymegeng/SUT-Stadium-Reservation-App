import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:barcode_scan/barcode_scan.dart';

import 'time_function.dart';
import 'register_page.dart';
import 'tableb_page.dart';

class InfoPage extends StatefulWidget {

  String uid,ctime,sname;

  InfoPage({Key key, this.uid,this.ctime,this.sname}) : super(key: key);

  static String tag = 'info-page';

  @override
  _InfoPageState createState() => new _InfoPageState();
}

var _date = DateTime.now();
final _datetime = _date.year.toString()+"-"+_date.month.toString()
    +"-"+_date.day.toString();
final _sname = TextEditingController();
final _ctime = TextEditingController();
final _userid = TextEditingController();
final _username = TextEditingController();
final _stadium = TextEditingController();
final _confirm = TextEditingController();
final _confirmtext = TextEditingController();

class _InfoPageState extends State<InfoPage> {
  bool _loadingInProgress;

  void initState() {
    _date = DateTime.now();
    // TODO: implement initState
    super.initState();
    _checkuser();
  }

  _checkuser()async{
    _loadingInProgress = true;
    await FirebaseDatabase.instance.reference().child('user').child(widget.uid)
        .once().then((DataSnapshot value) {
      var data = new User.fromSnapshot(value);
      _userid.text=data.userid;
      _username.text=data.username;
    }
    );
    try{
      if(_date.hour>=15){
        await Time_Function(widget.uid).deletetableusertableuser();
      }
      await FirebaseDatabase.instance.reference().child('user').child(widget.uid).child('table')
          .child(_datetime)
          .once().then((DataSnapshot value) {
        var data = new Tableuser.fromSnapshot(value);
        _sname.text=data.stadium;
        _ctime.text=data.time;
        _confirm.text=data.confirm;
        if(_confirm.text=="true"){
          _confirmtext.text="ยืนยันการจองแล้ว";
        }
        else{
          _confirmtext.text="ยังไม่ได้ยืนยันการจอง";
        }
      }
      );
      if(_sname.text=="b1"||_sname.text=="b2"||_sname.text=="b3"||_sname.text=="b4"||_sname.text=="b5"||_sname.text=="b6"||_sname.text=="b7"||_sname.text=="b8"||_sname.text=="b9"||_sname.text=="b10"){
        _stadium.text = "Badminton";
      }
      else{
        _stadium.text = "Tennis";
      }
      _loadData();
    }
    catch(e){
      if(widget.sname=="b1"||widget.sname=="b2"||widget.sname=="b3"||widget.sname=="b4"||widget.sname=="b5"||widget.sname=="b6"||widget.sname=="b7"||widget.sname=="b8"||widget.sname=="b9"||widget.sname=="b10"){
        _stadium.text = "Badminton";
      }
      else{
        _stadium.text = "Tennis";
      }
      try{
        await FirebaseDatabase.instance.reference().child("time_table").child(_stadium.text.toLowerCase())
            .child(widget.sname).child(_datetime).child(widget.ctime).remove().whenComplete(() {
          print("Deleted Successfully");
          setState(() {});
        }).catchError((e) => print(e));
        _onerrrortime();
      }
      catch(e){
        _onerrrortime();
      }
    }
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

  void _update() async{
    Map<String, String> data = <String, String>{
      "count": "0"+_datetime,
    };
    await FirebaseDatabase.instance.reference().child('user').child(widget.uid)
        .update(data).whenComplete(() {print("Document Updated");})
        .catchError((e) => print(e));
  }

  void _updateconfirm()async{
    Map<String, String> data = <String, String>{
      "confirm": "true",
    };
    await FirebaseDatabase.instance.reference().child('time_table').child(_stadium.text.toLowerCase())
        .child(_sname.text).child(_datetime).child(_ctime.text)
        .update(data).whenComplete(() {print("Document Updated");})
        .catchError((e) => print(e));

    await FirebaseDatabase.instance.reference().child('user').child(widget.uid).child("table").child(_datetime)
        .update(data).whenComplete(() {print("Document Updated");})
        .catchError((e) => print(e));
  }

  void _delete()async{
    await FirebaseDatabase.instance.reference().child("time_table").child(_stadium.text.toLowerCase())
        .child(_sname.text).child(_datetime).child(_ctime.text).remove().whenComplete(() {
      print("Deleted Successfully");
      setState(() {});
    }).catchError((e) => print(e));
    await FirebaseDatabase.instance.reference().child("user").child(widget.uid)
        .child("table").child(_datetime).remove().whenComplete(() {
      print("Deleted Successfully");
      setState(() {});
    }).catchError((e) => print(e));
  }

  @override
  String result = "Hey there !";
  Future _scanQR() async {
    try {
      String qrResult = await BarcodeScanner.scan();
      setState(() {
        result = qrResult;
      });
      if(result=="Hello World"){
        _updateconfirm();
        _onconfirmapp();
      }
      else{
        _onerrror();
      }
    }
    catch(e){
      _onerrrorapp();
    }
  }

  Future<bool> _onconfirmapp(){
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("ยืนยันเสร็จสิ้น"),
        actions: <Widget>[
          FlatButton(
            child: Text("ตกลง"),
            onPressed: (){
              Navigator.pop(context,false);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  Future<bool> _onerrror(){
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("ข้อมูลไม่ถูกต้องกรุณาลองอีกครั้ง"),
        actions: <Widget>[
          FlatButton(
            child: Text("ตกลง"),
            onPressed: (){
              Navigator.pop(context,false);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  Future<bool> _onerrrorapp(){
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("เกิดข้อผิดพลาดกรุณาลองอีกครั้ง"),
        actions: <Widget>[
          FlatButton(
            child: Text("ตกลง"),
            onPressed: (){
              Navigator.pop(context,false);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  Future<bool> _onerrrortime(){
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("ไม่สามารถทำการจองในเวลาดังกล่าวได้หรือเวลาที่จองอาจถูกยกเลิกจากการไม่ยืนยัน"),
        actions: <Widget>[
          FlatButton(
            child: Text("ตกลง"),
            onPressed: (){
              Navigator.pop(context,false);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
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
          backgroundColor: Colors.blue,
          iconTheme: new IconThemeData(color: Colors.white.withOpacity(1.0)),
          leading: new IconButton(icon: Icon(Icons.home), onPressed: (){Navigator.of(context).pop();Navigator.of(context).pop();}),
        ),
        body: const Center(
          child: CupertinoActivityIndicator(),
        ),
      );
    }
    else if(_confirm.text=="true"){
      return Scaffold(
        backgroundColor: Color.fromARGB(255, 237,237,237),
        appBar: AppBar(
          title: Text('Reservation Badminton',
            style: new TextStyle(color: Colors.white.withOpacity(1.0)),),
          backgroundColor: Colors.blue,
          iconTheme: new IconThemeData(color: Colors.white.withOpacity(1.0)),
          leading: new IconButton(icon: Icon(Icons.home), onPressed: (){Navigator.of(context).pop();Navigator.of(context).pop();}),
        ),
        body: Center(
            child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.only(left: 40.0, right: 40.0,top: 40.0,bottom: 40.0),
                children: <Widget>[
                  new Text(
                    "Infomation\nDate: "+_datetime,
                    style: new TextStyle(fontSize:25.0,
                        color: const Color(0xFF000000),
                        fontWeight: FontWeight.w700,
                        fontFamily: "Merriweather"),
                  ),
                  new Divider(color: Colors.black54,indent: 0.0,),
                  SizedBox(height: 10.0),
                  TextFormField(
                    enabled: false,
                    controller: _stadium,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      filled: true,
                      icon: Icon(Icons.location_searching),
                      labelText: 'Sport ',
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    enabled: false,
                    controller: _sname,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      filled: true,
                      icon: Icon(Icons.location_on),
                      labelText: 'Stadium ',
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    enabled: false,
                    controller: _ctime,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      filled: true,
                      icon: Icon(Icons.access_time),
                      labelText: 'Time ',
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    enabled: false,
                    controller: _confirmtext,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      filled: true,
                      icon: Icon(Icons.assignment),
                      labelText: 'Status ',
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    enabled: false,
                    controller: _userid,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      filled: true,
                      icon: Icon(Icons.credit_card),
                      labelText: 'ID ',
                    ),
                  ),
                  SizedBox(height: 20.0,),
                  new Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      new RaisedButton(
                        child: new Text('กลับ',
                            style: new TextStyle(
                              color: Color.fromARGB(255,255,255,255),
                              fontWeight: FontWeight.w700,
                            )
                        ),
                        color: Colors.blue ,
                        onPressed:(){Navigator.of(context).pop();},
                      ),
                    ],
                  )
                ]
            )
        ),
      );
    }
    else if(_confirm.text==""||_confirm.text==null){
      return Scaffold(
        appBar: AppBar(
          title: Text('Reservation Badminton',
            style: new TextStyle(color: Colors.white.withOpacity(1.0)),),
          backgroundColor: Colors.blue,
          iconTheme: new IconThemeData(color: Colors.white.withOpacity(1.0)),
          leading: new IconButton(icon: Icon(Icons.home), onPressed: (){Navigator.of(context).pop();Navigator.of(context).pop();}),
        ),
        body: Center(
          child:
          new Text("การจองของคุณถูกยกเลิกเนื่องจากไม่ได้ทำการยืนยันตามเวลาที่กำหนด",
            style: new TextStyle(fontSize:30.0,
                color: const Color(0xFF000000),
                fontWeight: FontWeight.w700,
                fontFamily: "Merriweather"
            ),
          ),
        ),
      );
    }
    else{
      return Scaffold(
        backgroundColor: Color.fromARGB(255, 237,237,237),
        appBar: AppBar(
          title: Text('Reservation Badminton',
            style: new TextStyle(color: Colors.white.withOpacity(1.0)),),
          backgroundColor: Colors.blue,
          iconTheme: new IconThemeData(color: Colors.white.withOpacity(1.0)),
          leading: new IconButton(icon: Icon(Icons.home), onPressed: (){Navigator.of(context).pop();Navigator.of(context).pop();}),
        ),
        body: Center(
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(left: 40.0, right: 40.0,top: 40.0,bottom: 40.0),
            children: <Widget>[
              new Text(
                "Infomation\nDate: "+_datetime,
                style: new TextStyle(fontSize:25.0,
                color: const Color(0xFF000000),
                fontWeight: FontWeight.w700,
                fontFamily: "Merriweather"),
              ),
              new Divider(color: Colors.black54,indent: 0.0,),
              SizedBox(height: 10.0),
              TextFormField(
                enabled: false,
                controller: _stadium,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  filled: true,
                  icon: Icon(Icons.location_searching),
                  labelText: 'Sport ',
                ),
              ),
              SizedBox(height: 10.0),
              TextFormField(
                enabled: false,
                controller: _sname,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  filled: true,
                  icon: Icon(Icons.location_on),
                  labelText: 'Stadium ',
                ),
              ),
              SizedBox(height: 10.0),
              TextFormField(
                enabled: false,
                controller: _ctime,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  filled: true,
                  icon: Icon(Icons.access_time),
                  labelText: 'Time ',
                ),
              ),
              SizedBox(height: 10.0),
              TextFormField(
                enabled: false,
                controller: _confirmtext,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  filled: true,
                  icon: Icon(Icons.assignment),
                  labelText: 'Status ',
                ),
              ),
              SizedBox(height: 10.0),
              TextFormField(
                enabled: false,
                controller: _userid,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  filled: true,
                  icon: Icon(Icons.credit_card),
                  labelText: 'ID ',
                ),
              ),
              SizedBox(height: 20.0,),
              new Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  new RaisedButton(
                    child: new Text('ยืนยันการจอง',
                        style: new TextStyle(
                          color: Color.fromARGB(255,255,255,255),
                          fontWeight: FontWeight.w700,
                        )
                    ),
                  color: Colors.green ,
                  onPressed:_scanQR,
                ),
                new RaisedButton(
                  child: new Text('ยกเลิกการจอง',
                      style: new TextStyle(
                        color: Color.fromARGB(255,255,255,255),
                        fontWeight: FontWeight.w700,
                      )
                  ),
                  color: Colors.red ,
                  onPressed:() async {
                    _update();
                    _delete();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            )
            ]
          )
        ),
      );
    }
  }
}