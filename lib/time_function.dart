import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';
import 'tableb_page.dart';

var _date = DateTime.now();
var _min = DateTime.now().minute;
final _datetime = _date.year.toString()+"-"+_date.month.toString()
    +"-"+_date.day.toString();
final _confirm = TextEditingController();
final _time = TextEditingController();
final List _list1 = ["b1","b2","b3","b4","b5","b6","b7","b8","b9","b10"];
final List _list2 = ["t1","t2","t3","t4","t5","t6","t7"];

final List _list3 = ["16:00-16:30", "16:30-17:00","17:00-17:30","17:30-18:00","18:00-18:30","18:30-19:00","19:00-19:30","19:30-20:00","20:00-20:30","20:30-21:00"];
final List _list4 = ["16:00-17:00","17:00-18:00", "18:00-19:00","19:00-20:00","20:00-21:00"];

class Time_Function {
  String uid;

  Time_Function(this.uid);

  Future<Null> deletetableusertableuser()async{
    await FirebaseDatabase.instance.reference().child('user').child(uid).child('table').child(_datetime)
        .once().then((DataSnapshot snapshot) {
      var data = new Tableuser.fromSnapshot(snapshot);
      _confirm.text=data.confirm;
      _time.text = data.time;
    }
    );
    print(_confirm.text+' + '+_time.text);
    if(_confirm.text=='true'){ }
    else if(_confirm.text=='false'){
      _date=DateTime.now();
      if(_time.text=='16:00-16:30'||_time.text=='16:00-17:00'){
        if(_date.hour>=15&&_date.minute>=50||(_date.hour>=16)){
          await _userdeletetable();
        }
      }
      else if(_time.text=='16:30-17:00'){
        if(_date.hour>=16&&_date.minute>=20||(_date.hour>=17&&_date.minute>=00)){
          await _userdeletetable();
        }
      }
      else if(_time.text=='17:00-17:30'||_time.text=='17:00-18:00'){
        if(_date.hour>=16&&_date.minute>=50||(_date.hour>=17&&_date.minute>=00)){
          await _userdeletetable();
        }
      }
      else if(_time.text=='17:30-18:00'){
        if(_date.hour>=17&&_date.minute>=20||(_date.hour>=18&&_date.minute>=00)){
          await _userdeletetable();
        }
      }
      else if(_time.text=='18:00-18:30'||_time.text=='18:00-19:00'){
        if(_date.hour>=17&&_date.minute>=50||(_date.hour>=18&&_date.minute>=00)){
          await _userdeletetable();
        }
      }
      else if(_time.text=='18:30-19:00'){
        if(_date.hour>=18&&_date.minute>=20||(_date.hour>=19&&_date.minute>=00)){
          await _userdeletetable();
        }
      }
      else if(_time.text=='19:00-19:30'||_time.text=='19:00-20:00'){
        if(_date.hour>=18&&_date.minute>=50||(_date.hour>=19&&_date.minute>=00)){
          await _userdeletetable();
        }
      }
      else if(_time.text=='19:30-20:00'){
        if(_date.hour>=19&&_date.minute>=20||(_date.hour>=20&&_date.minute>=00)){
          await _userdeletetable();
        }
      }
      else if(_time.text=='20:00-20:30'||_time.text=='20:00-21:00'){
        if(_date.hour>=19&&_date.minute>=50||(_date.hour>=20&&_date.minute>=00)){
          await _userdeletetable();
        }
      }
      else if(_time.text=='20:30-21:00'){
        if(_date.hour>=20&&_date.minute>=20||(_date.hour>=21&&_date.minute>=00)){
          await _userdeletetable();
        }
      }
    }
  }

  Future<Null> _userdeletetable()async{
    print(' + '+_date.hour.toString()+":"+_date.minute.toString());
    await FirebaseDatabase.instance.reference().child('user').child(uid).child('table').child(_datetime)
      .remove();

    Map<String, String> data = <String, String>{
      "count": "0"+_datetime,
    };
    await FirebaseDatabase.instance.reference().child('user').child(uid)
        .update(data).whenComplete(() {print("Document Updated");})
        .catchError((e) => print(e));
  }

  Future<Null> deletetable () async{
    _date=DateTime.now();
    _min = DateTime.now().minute;
    if(_date.hour==16){
      if(_date.minute>=30){
         await _deletetable3("16:00-16:30");
      }
    }
    else if(_date.hour==17&&_date.minute>=0&&_date.minute<30){
         _deletetable3("16:00-16:30");
         _deletetable3("16:30-17:00");
         await _deletetable4("16:00-17:00");
    }
    else if(_date.hour==17){
      if(_date.minute>=30){
         _deletetable3("16:00-16:30");
         _deletetable3("16:30-17:00");
         _deletetable4("16:00-17:00");
         await _deletetable3("17:00-17:30");
      }
    }
    else if(_date.hour==18&&_date.minute>=0&&_date.minute<30){
         _deletetable3("16:00-16:30");
         _deletetable3("16:30-17:00");
         _deletetable4("16:00-17:00");
         _deletetable3("17:00-17:30");
         _deletetable3("17:30-18:00");
         await _deletetable4("17:00-18:00");
    }
    else if(_date.hour==18){
      if(_date.minute>=30){
         _deletetable3("16:00-16:30");
         _deletetable3("16:30-17:00");
         _deletetable4("16:00-17:00");
         _deletetable3("17:00-17:30");
         _deletetable3("17:30-18:00");
         _deletetable4("17:00-18:00");
         await _deletetable3("18:00-18:30");
      }
    }
    else if(_date.hour==19&&_date.minute>=0&&_date.minute<30){
         _deletetable3("16:00-16:30");
         _deletetable3("16:30-17:00");
         _deletetable4("16:00-17:00");
         _deletetable3("17:00-17:30");
         _deletetable3("17:30-18:00");
         _deletetable4("17:00-18:00");
         _deletetable3("18:00-18:30");
         _deletetable3("18:30-19:00");
         await _deletetable4("18:00-19:00");
    }
    else if(_date.hour==19){
      if(_date.minute>=30){
         _deletetable3("16:00-16:30");
         _deletetable3("16:30-17:00");
         _deletetable4("16:00-17:00");
         _deletetable3("17:00-17:30");
         _deletetable3("17:30-18:00");
         _deletetable4("17:00-18:00");
         _deletetable3("18:00-18:30");
         _deletetable3("18:30-19:00");
         _deletetable4("18:00-19:00");
         await _deletetable3("19:00-19:30");
      }
    }
    else if(_date.hour==20&&_date.minute>=0&&_date.minute<30){
         _deletetable3("16:00-16:30");
         _deletetable3("16:30-17:00");
         _deletetable4("16:00-17:00");
         _deletetable3("17:00-17:30");
         _deletetable3("17:30-18:00");
         _deletetable4("17:00-18:00");
         _deletetable3("18:00-18:30");
         _deletetable3("18:30-19:00");
         _deletetable4("18:00-19:00");
         _deletetable3("19:00-19:30");
         _deletetable3("19:30-20:00");
         await _deletetable4("19:00-20:00");
    }
    else if(_date.hour==20){
      if(_date.minute>=30){
         _deletetable3("16:00-16:30");
         _deletetable3("16:30-17:00");
         _deletetable4("16:00-17:00");
         _deletetable3("17:00-17:30");
         _deletetable3("17:30-18:00");
         _deletetable4("17:00-18:00");
         _deletetable3("18:00-18:30");
         _deletetable3("18:30-19:00");
         _deletetable4("18:00-19:00");
         _deletetable3("19:00-19:30");
         _deletetable3("19:30-20:00");
         _deletetable4("19:00-20:00");
         await _deletetable3("20:00-20:30");
      }
    }
    else if(_date.hour>=21){
      if(_date.minute>=00){
         _deletetable3("16:00-16:30");
         _deletetable3("16:30-17:00");
         _deletetable4("16:00-17:00");
         _deletetable3("17:00-17:30");
         _deletetable3("17:30-18:00");
         _deletetable4("17:00-18:00");
         _deletetable3("18:00-18:30");
         _deletetable3("18:30-19:00");
         _deletetable4("18:00-19:00");
         _deletetable3("19:00-19:30");
         _deletetable3("19:30-20:00");
         _deletetable4("19:00-20:00");
         _deletetable3("20:00-20:30");
         _deletetable3("20:30-21:00");
        await _deletetable4("20:00-21:00");
      }
    }
    print("time: "+_date.hour.toString()+":"+_date.minute.toString());
  }

  Future<Null> _deletetable3(String t) async {
    Map<String, String> data = <String, String>{
      "status": "true",
    };
    for (int i=0;i<10;i++){
      await FirebaseDatabase.instance.reference().child("time_table").child("badminton")
          .child(_list1[i]).child(_datetime).child(t)
          .update(data).whenComplete(() {print("badminton Updated: "+t+":");})
          .catchError((e) => print(e));
    }
  }

  Future<Null> _deletetable4(String t)async{
    Map<String, String> data = <String, String>{
      "status": "true",
    };
    for (int i=0;i<7;i++){
      await FirebaseDatabase.instance.reference().child("time_table").child("tennis")
          .child(_list2[i]).child(_datetime).child(t)
          .update(data).whenComplete(() {print("tennis Updated: "+t);})
          .catchError((e) => print(e));
    }

  }

  Future<Null> deleteusertable ()async{
    _date=DateTime.now();
    if(_date.hour==15){
      if(_date.minute>=50){
        _deletetable("16:00-16:30");
        await _deletetable2("16:00-17:00");
      }
    }
    else if(_date.hour==16&&_date.minute>=20&&_date.minute<50){

        _deletetable("16:30-17:00");
        await _deletetable2("16:00-17:00");

    }
    else if(_date.hour==16){
      if(_date.minute>=50){
        _deletetable("17:00-17:30");
        await _deletetable2("17:00-18:00");
      }
    }
    else if(_date.hour==17&&_date.minute>=20&&_date.minute<50){
        _deletetable("17:30-18:00");
        await _deletetable2("17:00-18:00");

    }
    else if(_date.hour==17){
      if(_date.minute>=50){
        _deletetable("18:00-18:30");
        await _deletetable2("18:00-19:00");
      }
    }
    else if(_date.hour==18&&_date.minute>=20&&_date.minute<50){

        _deletetable("18:30-19:00");
        await _deletetable2("18:00-19:00");

    }
    else if(_date.hour==18){
      if(_date.minute>=50){
        _deletetable("19:00-19:30");
        await _deletetable2("19:00-20:00");
      }
    }
    else if(_date.hour==19&&_date.minute>=20&&_date.minute<50){
        _deletetable("19:30-20:00");
        await _deletetable2("19:00-20:00");

    }
    else if(_date.hour==19){
      if(_date.minute>=50){
        _deletetable("20:00-20:30");
        await _deletetable2("20:00-21:00");
      }
    }
    else if(_date.hour>=20){
      if(_date.minute>=20){
        _deletetable("20:30-21:00");
        await _deletetable2("20:00-21:00");
      }
    }
  }

//  Future<Null> _deletetable(String t)async{
//    for (int i=0;i<10;i++){
//      await FirebaseDatabase.instance.reference().child("time_table").child("badminton")
//          .child(_list1[i]).child(_datetime).child(t).remove().whenComplete(() {
//        print("Deleted Successfully");
//      }).catchError((e) => print(e));
//    }
//
//  }
//
//  Future<Null> _deletetable2(String t)async{
//    for (int i=0;i<7;i++){
//      await FirebaseDatabase.instance.reference().child("time_table").child("tennis")
//          .child(_list2[i]).child(_datetime).child(t).remove().whenComplete(() {
//        print("Deleted Successfully");
//      }).catchError((e) => print(e));
//    }
//  }

  Future<Null> _deletetable(String t)async{
    print('test');
    for (int i=0;i<10;i++){
      await FirebaseDatabase.instance.reference().child("time_table").child("badminton")
          .child(_list1[i]).child(_datetime).child(t).once().then((DataSnapshot value) {
        var data = new TableB.fromSnapshot(value);
        if(data.confirm=='false'){
           FirebaseDatabase.instance.reference().child("time_table").child("badminton")
              .child(_list1[i]).child(_datetime).child(t).remove().whenComplete(() {
            print("Deleted Successfully");
          }).catchError((e) => print(e));
        }
      }
      );
    }

  }

  Future<Null> _deletetable2(String t)async{
    print('test2');
    for (int i=0;i<7;i++){
      await FirebaseDatabase.instance.reference().child("time_table").child("tennis")
          .child(_list2[i]).child(_datetime).child(t).once().then((DataSnapshot value) {
        var data = new TableB.fromSnapshot(value);
        if(data.confirm=='false'){
          FirebaseDatabase.instance.reference().child("time_table").child("tennis")
              .child(_list2[i]).child(_datetime).child(t).remove().whenComplete(() {
            print("Deleted Successfully");
          }).catchError((e) => print(e));
        }
      }
      );
    }
  }

  Future loadingtable()async{
    _date = DateTime.now();
    print('HelloTest'+_date.hour.toString());
    if(_date.hour==15&&_date.minute>=50){
      await _deletetableb('16:00-16:30');
      await _deletetablet('16:00-17:00');
    }
    else if(_date.hour==16&&_date.minute>=20){
      await _deletetableb('16:00-16:30');
      await _deletetablet('16:00-17:00');
      await _deletetableb('16:30-17:00');
    }
    else if(_date.hour==16&&_date.minute>=50){
      await _deletetableb('16:00-16:30');
      await _deletetablet('16:00-17:00');
      await _deletetableb('16:30-17:00');
      await _deletetableb('17:00-17:30');
      await _deletetablet('17:00-18:00');
    }
    else if(_date.hour==17&&_date.minute>=20){
      await _deletetableb('16:00-16:30');
      await _deletetablet('16:00-17:00');
      await _deletetableb('16:30-17:00');
      await _deletetableb('17:00-17:30');
      await _deletetablet('17:00-18:00');
      await _deletetableb('17:30-18:00');
    }
    else if(_date.hour==17&&_date.minute>=50){
      await _deletetableb('16:00-16:30');
      await _deletetablet('16:00-17:00');
      await _deletetableb('16:30-17:00');
      await _deletetableb('17:00-17:30');
      await _deletetablet('17:00-18:00');
      await _deletetableb('17:30-18:00');
      await _deletetableb('18:00-18:30');
      await _deletetablet('18:00-19:00');
    }
    else if(_date.hour==18&&_date.minute>=20){
      await _deletetableb('16:00-16:30');
      await _deletetablet('16:00-17:00');
      await _deletetableb('16:30-17:00');
      await _deletetableb('17:00-17:30');
      await _deletetablet('17:00-18:00');
      await _deletetableb('17:30-18:00');
      await _deletetableb('18:00-18:30');
      await _deletetablet('18:00-19:00');
      await _deletetableb('18:30-19:00');
    }
    else if(_date.hour==18&&_date.minute>=50){
      await _deletetableb('16:00-16:30');
      await _deletetablet('16:00-17:00');
      await _deletetableb('16:30-17:00');
      await _deletetableb('17:00-17:30');
      await _deletetablet('17:00-18:00');
      await _deletetableb('17:30-18:00');
      await _deletetableb('18:00-18:30');
      await _deletetablet('18:00-19:00');
      await _deletetableb('18:30-19:00');
      await _deletetableb('19:00-19:30');
      await _deletetablet('19:00-20:00');
    }
    else if(_date.hour==19&&_date.minute>=20){
      await _deletetableb('16:00-16:30');
      await _deletetablet('16:00-17:00');
      await _deletetableb('16:30-17:00');
      await _deletetableb('17:00-17:30');
      await _deletetablet('17:00-18:00');
      await _deletetableb('17:30-18:00');
      await _deletetableb('18:00-18:30');
      await _deletetablet('18:00-19:00');
      await _deletetableb('18:30-19:00');
      await _deletetableb('19:00-19:30');
      await _deletetablet('19:00-20:00');
      await _deletetableb('19:30-20:00');
    }
    else if(_date.hour==19&&_date.minute>=50){
      await _deletetableb('16:00-16:30');
      await _deletetablet('16:00-17:00');
      await _deletetableb('16:30-17:00');
      await _deletetableb('17:00-17:30');
      await _deletetablet('17:00-18:00');
      await _deletetableb('17:30-18:00');
      await _deletetableb('18:00-18:30');
      await _deletetablet('18:00-19:00');
      await _deletetableb('18:30-19:00');
      await _deletetableb('19:00-19:30');
      await _deletetablet('19:00-20:00');
      await _deletetableb('19:30-20:00');
      await _deletetableb('20:00-20:30');
      await _deletetablet('20:00-21:00');
    }
    else if(_date.hour>=20&&_date.minute>=20){
      print('HelloTest'+_date.hour.toString());
      await _deletetableb('16:00-16:30');
      await _deletetablet('16:00-17:00');
      await _deletetableb('16:30-17:00');
      await _deletetableb('17:00-17:30');
      await _deletetablet('17:00-18:00');
      await _deletetableb('17:30-18:00');
      await _deletetableb('18:00-18:30');
      await _deletetablet('18:00-19:00');
      await _deletetableb('18:30-19:00');
      await _deletetableb('19:00-19:30');
      await _deletetablet('19:00-20:00');
      await _deletetableb('19:30-20:00');
      await _deletetableb('20:00-20:30');
      await _deletetablet('20:00-21:00');
      await _deletetableb('20:30-21:00');
    }

  }

  Future _deletetableb(String t)async{
    for (int i=0;i<10;i++){
       FirebaseDatabase.instance.reference().child("time_table").child("badminton")
          .child(_list1[i]).child(_datetime).child(t).once().then((DataSnapshot value) {
        var data = new TableB.fromSnapshot(value);
        if(data.confirm=='false'){
          FirebaseDatabase.instance.reference().child("time_table").child("badminton")
              .child(_list1[i]).child(_datetime).child(t).remove().whenComplete(() {
            print("Deleted Successfully");
          }).catchError((e) => print(e));
        }
      }
      );
    }
  }
  Future _deletetablet(String t)async{
    for (int i=0;i<7;i++){
       FirebaseDatabase.instance.reference().child("time_table").child("tennis")
          .child(_list2[i]).child(_datetime).child(t).once().then((DataSnapshot value) {
        var data = new TableB.fromSnapshot(value);
        if(data.confirm=='false'){
          FirebaseDatabase.instance.reference().child("time_table").child("tennis")
              .child(_list2[i]).child(_datetime).child(t).remove().whenComplete(() {
            print("Deleted Successfully");
          }).catchError((e) => print(e));
        }
      }
      );
    }
  }


}
