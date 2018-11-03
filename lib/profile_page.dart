import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';

import 'package:firebase_database/firebase_database.dart';

import 'register_page.dart';

class ProfilePage extends StatefulWidget {
  String uid,ctime,sname;
  ProfilePage({Key key, this.uid,this.ctime,this.sname}) : super(key: key);
  static String tag = 'info-page';
  @override
  _ProfilePageState createState() => new _ProfilePageState();
}

final _userid = TextEditingController();
final _username = TextEditingController();
final _email = TextEditingController();
final _major = TextEditingController();

class _ProfilePageState extends State<ProfilePage> {
  bool _loadingInProgress;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _profilecheck();
  }
  _profilecheck()async{
    _loadingInProgress = true;
    await FirebaseDatabase.instance.reference().child('user').child(widget.uid)
        .once().then((DataSnapshot value) {
      var data = new User.fromSnapshot(value);
      _userid.text=data.userid;
      _username.text=data.username;
      _email.text=data.email;
      _major.text=data.major;
    }
    );
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
  @override
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
        ),
        body: const Center(
          child: CupertinoActivityIndicator(),
        ),
      );
    }
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 237,237,237),
      appBar: AppBar(
        title: Text('Reservation Badminton',
          style: new TextStyle(color: Colors.white.withOpacity(1.0)),),
        backgroundColor: Colors.blue,
        iconTheme: new IconThemeData(color: Colors.white.withOpacity(1.0)),
      ),
      body: Center(
          child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 40.0, right: 40.0,top: 40.0,bottom: 40.0),
              children: <Widget>[
                new Text(
                  "Profile",
                  style: new TextStyle(fontSize:25.0,
                      color: const Color(0xFF000000),
                      fontWeight: FontWeight.w700,
                      fontFamily: "Merriweather"),
                ),
                new Divider(color: Colors.black54,indent: 0.0,),
                SizedBox(height: 10.0),
                TextFormField(
                  enabled: false,
                  controller: _email,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    filled: true,
                    icon: Icon(Icons.email),
                    labelText: 'Email ',
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
                SizedBox(height: 10.0),
                TextFormField(
                  enabled: false,
                  controller: _username,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    filled: true,
                    icon: Icon(Icons.person),
                    labelText: 'Name ',
                  ),
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  enabled: false,
                  controller: _major,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    filled: true,
                    icon: Icon(Icons.person_pin),
                    labelText: 'Major ',
                  ),
                ),
                SizedBox(height: 10.0),
                new Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    new RaisedButton(
                      child: new Text('แก้ไข',
                          style: new TextStyle(
                            color: Color.fromARGB(255,255,255,255),
                            fontWeight: FontWeight.w700,
                          )
                      ),
                      color: Colors.blue ,
                      onPressed:(){
                        var route = new MaterialPageRoute(
                          builder: (BuildContext context) => new ProfileeditPage(uid: widget.uid,)
                      );
                      Navigator.of(context).push(route);
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

class ProfileeditPage extends StatefulWidget {
  String uid,ctime,sname;
  ProfileeditPage({Key key, this.uid,this.ctime,this.sname}) : super(key: key);
  static String tag = 'info-page';
  @override
  _ProfileeditPageState createState() => new _ProfileeditPageState();
}

final _usernameedit = TextEditingController();
final _majoredit = TextEditingController();

class _ProfileeditPageState extends State<ProfileeditPage> {
  bool _loadingInProgress;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _profilecheck();
  }
  _profilecheck()async{
    _loadingInProgress = true;
    await FirebaseDatabase.instance.reference().child('user').child(widget.uid)
        .once().then((DataSnapshot value) {
      var data = new User.fromSnapshot(value);
      _userid.text=data.userid;
      _usernameedit.text=data.username;
      _email.text=data.email;
      _majoredit.text=data.major;
    }
    );
    _loadData();
  }

  Future _updateprofile()async{
    Map<String, String> data = <String, String>{
      "username": _usernameedit.text,
      "major": _majoredit.text,
    };
    await FirebaseDatabase.instance.reference().child('user').child(widget.uid)
        .update(data).whenComplete(() {print("Document Updated");})
        .catchError((e) => print(e));
    Navigator.of(context).pop();
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
  String dropdown1Value ;
  Widget buildDropdownButton() {
    return new Padding(
      padding: const EdgeInsets.all(0.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Text(' '),
          new DropdownButton<String>(
            value: dropdown1Value,
            hint: const Text('Major'),
            onChanged: (String newValue) {
              setState(() {
                dropdown1Value = newValue;
              });
              _majoredit.text=newValue;
            },
            items: <String>[
              'วิศวกรรมเกษตรและอาหาร', 'วิศวกรรมขนส่งและโลจิสติกส์', 'วิศวกรรมคอมพิวเตอร์', 'วิศวกรรมเคมี'
              , 'วิศวกรรมเครื่องกล', 'วิศวกรรมเซรามิก', 'วิศวกรรมโทรคมนาคม', 'วิศวกรรมพอลิเมอร์', 'วิศวกรรมไฟฟ้า'
              , 'วิศวกรรมโยธา', 'วิศวกรรมโลหการ', 'วิศวกรรมสิ่งแวดล้อม', 'วิศวกรรมอุตสาหการ', 'เทคโนโลยีธรณี'
              , 'เทคโนโลยีการผลิตพืช', 'เทคโนโลยีการผลิตสัตว์', 'เทคโนโลยีชีวภาพ', 'เทคโนโลยีอาหาร', 'แพทยศาสตร์'
              , 'พยาบาลศาสตร์', 'อาชีวอนามัยและความปลอดภัย', 'อนามัยสิ่งแวดล้อม', 'เทคโนโลยีสารสนเทศ', 'เทคโนโลยีการจัดการ'
              , 'วิทยาศาสตร์การกีฬา', 'ฟิสิกส์', 'ชีววิทยา', 'คณิตศาสตร์', 'เคมี', 'อื่นๆ'
            ]
                .map((String value) {
              return new DropdownMenuItem<String>(
                value: value,
                child: new Text(value),
              );
            }).toList(),
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
        ),
        body: const Center(
          child: CupertinoActivityIndicator(),
        ),
      );
    }
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 237,237,237),
      appBar: AppBar(
        title: Text('Reservation Badminton',
          style: new TextStyle(color: Colors.white.withOpacity(1.0)),),
        backgroundColor: Colors.blue,
        iconTheme: new IconThemeData(color: Colors.white.withOpacity(1.0)),
      ),
      body: Center(
          child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 40.0, right: 40.0,top: 40.0,bottom: 40.0),
              children: <Widget>[
                new Text(
                  "EditProfile",
                  style: new TextStyle(fontSize:25.0,
                      color: const Color(0xFF000000),
                      fontWeight: FontWeight.w700,
                      fontFamily: "Merriweather"),
                ),
                new Divider(color: Colors.black54,indent: 0.0,),
                SizedBox(height: 10.0),
                TextFormField(
                  controller: _usernameedit,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    filled: true,
                    icon: Icon(Icons.person),
                    labelText: 'Name ',
                  ),
                ),
                SizedBox(height: 10.0),
                buildDropdownButton(),
                TextFormField(
                  enabled: false,
                  controller: _majoredit,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    filled: true,
                    icon: Icon(Icons.person_pin),
                    labelText: 'Major ',
                  ),
                ),
                SizedBox(height: 10.0),
                new Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    new RaisedButton(
                      child: new Text('ยืนยัน',
                          style: new TextStyle(
                            color: Color.fromARGB(255,255,255,255),
                            fontWeight: FontWeight.w700,
                          )
                      ),
                      color: Colors.green ,
                      onPressed:(){_updateprofile();},
                    ),
                  ],
                )
              ]
          )
      ),
    );
  }

}