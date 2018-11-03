import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';


class RegisterPage extends StatefulWidget {
  static String tag = 'login-page';
  @override
  _RegisterPageState createState() => new _RegisterPageState();
}
final _uid = TextEditingController();
final _email = TextEditingController();
final _password = TextEditingController();
final _userid = TextEditingController();
final _username = TextEditingController();
final _major = TextEditingController();
final _count = TextEditingController();
final _status = TextEditingController();

class _RegisterPageState extends State<RegisterPage> {
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _uid.text="";
      _email.text='';
      _password.text='';
      _userid.text='';
      _username.text='';
      _major.text='';
    });
  }
  register()async{
    if(_email.text==""||_email.text==null||_password.text==""||_password.text==null||_username.text==""||_username.text==null||_userid.text==""||_userid.text==null||_major.text==""||_major.text==null){
      _onerrorapp();
    }
    else if (_password.text.length<6){
      _onerrorapp2();
    }
    else{
      _count.text='0';
      _onloadingapp();
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email.text, password: _password.text)
          .then((data)=> _uid.text = data.uid);
      print("hi"+_uid.text);
      final user = User(_uid.text, _email.text,_password.text,_userid.text,_status.text,_username.text,_major.text,_count.text);
      await FirebaseDatabase.instance.reference().child('user').child(_uid.text).set(user.toJson());
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    }
  }
  @override
  Future<bool> _onerrorapp(){
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("โปรดใส่ข้อมูลครบทุกช่อง"),
        actions: <Widget>[
          FlatButton(
            child: Text("ตกลง"),
            onPressed: (){
              Navigator.pop(context,false);
            },
          ),
        ],
      ),
    );
  }
  Future<bool> _onerrorapp2(){
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("โปรดใส่รหัสผ่าน6หลักเป็นอย่างน้อย"),
        actions: <Widget>[
          FlatButton(
            child: Text("ตกลง"),
            onPressed: (){
              Navigator.pop(context,false);
            },
          ),
        ],
      ),
    );
  }
  Future<bool> _onloadingapp(){
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("กำลังลงทะเบียน"),
        content: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new CupertinoActivityIndicator(),
          ],
        ),
      ),
    );
  }
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
              _major.text=newValue;
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
  String dropdown1Value2 ;
  Widget buildDropdownButton2() {
    return new Padding(
      padding: const EdgeInsets.all(0.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Text(' '),
          new DropdownButton<String>(
            value: dropdown1Value2,
            hint: const Text('Status'),
            onChanged: (String newValue) {
              setState(() {
                dropdown1Value2 = newValue;
              });
              _status.text=newValue;
            },
            items: <String>[
              'student', 'employee', 'outsider', 'อื่นๆ'
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
    // TODO: implement build
    return Scaffold(
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
                  "Register",
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
            SizedBox(height: 15.0,),
            new TextFormField(
              keyboardType: TextInputType.text,
              autofocus: false,
              controller: _userid,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                filled: true,
                labelText: 'ID ',
              ),
            ),
            SizedBox(height: 15.0,),
            new TextFormField(
              keyboardType: TextInputType.text,
              autofocus: false,
              controller: _username,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                filled: true,
                labelText: 'Name ',
              ),
            ),
            SizedBox(height: 15.0,),
            buildDropdownButton(),
            SizedBox(height: 15.0,),
            buildDropdownButton2(),
//            new TextFormField(
//              keyboardType: TextInputType.text,
//              enabled: false,
//              autofocus: false,
//              controller: _major,
//              decoration: const InputDecoration(
//                border: UnderlineInputBorder(),
//                filled: true,
//                labelText: 'Major ',
//              ),
//            ),
            SizedBox(height: 30.0,),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new RaisedButton(
                  onPressed: (){register();},
                  child: new Text("Register"),
                  textColor: Colors.white,
                  color: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 50.0),
                ),
              ],
            ),
          ]
        )
      )
    );
  }
}

class User {
  String key;
  String email;
  String password;
  String status;
  String userid;
  String username;
  String major;
  String count;
  DateTime dateTime;

  User(this.key, this.email, this.password,this.userid,this.status,this.username,this.major,this.count);

  User.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        email = snapshot.value["email"],
        password = snapshot.value["password"],
        status = snapshot.value["status"],
        userid = snapshot.value["userid"],
        username = snapshot.value["username"],
        major = snapshot.value["major"],
        count = snapshot.value["count"];
  toJson() {
    return {
      "email": _email.text,
      "password": _password.text,
      "userid": _userid.text,
      "status": _status.text,
      "username": _username.text,
      "major": _major.text,
      "count": _count.text,
    };
  }
}