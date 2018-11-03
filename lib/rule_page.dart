import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';

import 'menub_page.dart';
import 'menut_page.dart';
import 'time_function.dart';


class RulePage extends StatefulWidget {

  String uid,ctime,sname;

  RulePage({Key key, this.uid,this.ctime,this.sname}) : super(key: key);

  static String tag = 'info-page';

  @override
  _RulePageState createState() => new _RulePageState();

}

var _date = DateTime.now();
class _RulePageState extends State<RulePage> {
  bool _loadingInProgress;

  void initState() {
    _date = DateTime.now();
    // TODO: implement initState
    super.initState();
    _loadtabledata();
  }
  @override
  _loadtabledata()async{
    _date = DateTime.now();
    _loadingInProgress = true;
    try{
      if(_date.hour>=15){
        await Time_Function(widget.uid).loadingtable();
        _loadData();
      }
      else{
        _loadData();
      }
    }
    catch(e){
      _loadData();
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

  Text maketext (String title){
    return Text(
      title,
      style: TextStyle(fontSize: 20.0, color: Colors.black,fontWeight: FontWeight.w600),
    );
  }

  Text maketext2 (String title){
    return Text(
      title,
      style: TextStyle(fontSize: 16.0, color: Colors.black),
    );
  }

  Widget build(BuildContext context) {
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
    else if (widget.sname=="b") {
      return Scaffold(
        appBar: AppBar(
          title: Text('Reservation Badminton',
            style: new TextStyle(color: Colors.white.withOpacity(1.0)),),
          backgroundColor: new Color.fromARGB(255, 8,61,119),
          iconTheme: new IconThemeData(color: Colors.white.withOpacity(1.0)),
        ),
        body: new Center(
            child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.only(left: 40.0, right: 40.0,top: 20.0,bottom: 10.0),
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'กฏการใช้สนามแบดมินตัน',
                      style: TextStyle(fontSize: 28.0, color: Colors.black,fontWeight: FontWeight.w700),
                    ),
                  ),
                  maketext(' เวลาให้บริการ'),
                  maketext2('   -ให้บริการทุกวัน เวลา 16.00 - 21.00 น. หยุดวันนักขัตฤกษ์และวันหยุดตามประกาศของมหาวิทยาลัย'),
                  SizedBox(height: 12.0),
                  maketext(' กฏการให้บริการ'),
                  maketext2('   -ลงชื่อและแสดงบัตรทุกครั้งก่อนเข้าใช้บริการสนามแบดมินตัน\n'
                      '   -ก่อนเข้าสนามแบดมินตันควรทำความสะอาดพื้นรองเท้าทุกครั้ง (เหยียบน้ำและเช็ดพื้นรองเท้าด้วยผ้าเช็ดเท้า)\n'
                      '   -แต่งกายสุภาพเรียบร้อยในชุดกีฬาและสวมรองเท้าแบดมินตันเท่านั้นในการลงเล่นในสนาม(ห้ามสวมรองเท้าแตะ และรองเท้าพื้นแข็ง)\n'
                      '   -กรุณาเคารพสิทธิของผู้อื่น\n'
                      '   -การยืมอุปกรณ์กีฬา/รองเท้า ต้องใช้บัตรประจำตัวประชาชน/บัตรนักศึกษาผู้ยืมเท่านั้น และคืนอุปกรณ์ก่อนเวลา 20.45 น.\n'
                      '   -จะกดกริ่งให้สัญญาณ 15 นาที ก่อนปิดสนาม\n'
                      '   -ห้ามนำอาหารมารับประทานในสนามแบดมินตัน\n'
                      '   -ห้ามนำสัตว์เลี้ยงทุกชนิดเข้ามาในสนามแบดมินตัน\n'
                      '   -ห้ามสูบบุหรี่และนำเครื่องดื่มแอลกอฮอล์ทุกชนิดเข้ามาในสนามแบดมินตัน\n'
                      '   -ห้ามนำทรัพย์สินที่มีค่าเข้ามาในสนามแบดมินตัน หากสูญหาย ทางสถานกีฬาและสุขภาพจะไม่รับผิดชอบ\n'
                      '   -หากมีข้อสงสัยอื่น ๆ กรุณาติดต่อสอบถามเจ้าหน้าที่สนามและชมรมแบดมินตัน\n'),
                  SizedBox(height: 10.0,),
                  new Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      new RaisedButton(
                        child: new Text('ไม่ยอมรับ',
                            style: new TextStyle(
                              color: Color.fromARGB(255,255,255,255),
                              fontWeight: FontWeight.w700,
                            )
                        ),
                        color: Colors.red ,
                        onPressed:(){Navigator.of(context).pop();},
                      ),
                      new RaisedButton(
                        child: new Text('ยอมรับ',
                            style: new TextStyle(
                              color: Color.fromARGB(255,255,255,255),
                              fontWeight: FontWeight.w700,
                            )
                        ),
                        color: Colors.green ,
                        onPressed:() async {
                          var route = new MaterialPageRoute(
                              builder: (BuildContext context) => new MenuBPage(uid: widget.uid)
                          );
                          Navigator.of(context).pop();
                          Navigator.of(context).push(route);
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0,),
                ]
            )
        ),
      );
    }
    else if (widget.sname=="t") {
      return Scaffold(
        appBar: AppBar(
          title: Text('Reservation Badminton',
            style: new TextStyle(color: Colors.white.withOpacity(1.0)),),
          backgroundColor: Colors.green,
          iconTheme: new IconThemeData(color: Colors.white.withOpacity(1.0)),
        ),
        body: new Center(
          child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 40.0, right: 40.0,top: 20.0,bottom: 10.0),
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'กฏการใช้สนามเทนนิส',
                    style: TextStyle(fontSize: 28.0, color: Colors.black,fontWeight: FontWeight.w700),
                  ),
                ),
                maketext(' เวลาให้บริการ'),
                maketext2('  -ให้บริการทุกวันจันทร์-อาทิตย์ เวลา 10.30-21.00 น. หยุดวันนักขัตฤกษ์และวันหยุดตามประกาศของมหาวิทยาลัย'),
                SizedBox(height: 12.0),
                maketext(' กฏการให้บริการ'),
                maketext2('   -ลงชื่อและแสดงบัตรทุกครั้งก่อนใช้บริการสนามเทนนิส\n'
                    '   -ห้ามสูบบุหรี่ในแนวเขตสนามเทนนิสโดยเด็ดขาด ให้ไปสูบในที่ที่จัดเตรียมไว้ให้\n'
                    '   -ห้ามเล่นการพนันทุกชนิดในบริเวณสนามโดยเด็ดขาด\n'
                    '   -ห้ามนำสุรา เหล้า เบียร์ ยาเสพติด ทุกชนิดเข้ามาในบริเวณสนาม และห้ามผู้มีอาการเมาสุรา ยาเสพติด ลงใช้บริการในสนามโดยเด็ดขาด\n'
                    '   -กรุณางดนำสัตว์เลี้ยงเข้าในบริเวณสนาม\n'
                    '   -ให้จอดรถในที่จัดเตรียมไว้ให้ ทางสถานกีฬาไม่รับผิดชอบทุกกรณี หากเกิดความเสียหาย\n'
                    '   -กรุณาสวมรองเท้ากีฬาขณะลงสนาม(ห้ามสวมรองเท้าพื้นแข็ง)\n'
                    '   -โปรดช่วยกันดูแลรักษาสนามเพื่อความสมบูรณ์ของสนาม\n'
                    '   -ห้ามนำอาหารเข้ามาทานในบริเวณสนามหญ้าและอย่าทิ้งเศษขยะลงในพื้นสนามหญ้า\n'
                    '   -ผู้ที่จะลงใช้บริการในสนามกรุณาแต่งกายด้วยชุดกีฬาเท่านั้น ห้ามกางเกงยีนส์หรือแต่งกายไม่สุภาพ\n'
                    '   -ขอความกรุณาทุกท่านเล่นเทนนิสด้วยความสุภาพ มีน้ำใจนักกีฬา\n'
                    '   -ขอสงวนสิทธิในการยกเลิกการใช้บริการกรณีส่งเสียงดังเกินไป ก่อความรำคาญ หรือเกิดการทะเลาะวิวาท\n'
                    '   -ทางสถานกีฬาและสุขภาพ สงวนสิทธิการใช้บริการเฉพาะกีฬาเทนนิสหรือกิจกรรมที่ไม่ก่อให้เกิดความเสียหายต่อสนามเท่านั้น หากมีการจัดกีฬาหรือกิจกรรมที่อาจเกิดความเสียหายต่อสนาม ทางสถานกีฬาและสุขภาพมีสิทธิยกเลิกกิจกรรมนั้น ๆ ทันที\n'
                    '   -ขอความกรุณา ผู้มาใช้บริการทุกท่านโปรดดูแลทรัพย์สินส่วนตัว ทางสถานกีฬาและสุขภาพจะไม่รับผิดชอบใด ๆ ในกรณีที่เกิดความเสียหาย หรือศูญหายในทรัพย์สิน\n'
                    '   -เจ้าหน้าที่ประจำสนามจะกดกริ่งให้สัญญาณ ก่อนปิดสนาม 15 นาที\n'
                    '   -ขอให้ทุกท่านเล่นเทนนิสด้วยความสนุก และมีน้ำใจนักกีฬาต่อกัน\n'),
                SizedBox(height: 10.0,),
                new Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    new RaisedButton(
                      child: new Text('ไม่ยอมรับ',
                          style: new TextStyle(
                            color: Color.fromARGB(255,255,255,255),
                            fontWeight: FontWeight.w700,
                          )
                      ),
                      color: Colors.red ,
                      onPressed:(){Navigator.of(context).pop();},
                    ),
                    new RaisedButton(
                      child: new Text('ยอมรับ',
                          style: new TextStyle(
                            color: Color.fromARGB(255,255,255,255),
                            fontWeight: FontWeight.w700,
                          )
                      ),
                      color: Colors.green ,
                      onPressed:() async {
                        var route = new MaterialPageRoute(
                            builder: (BuildContext context) => new MenuTPage(uid: widget.uid)
                        );
                        Navigator.of(context).pop();
                        Navigator.of(context).push(route);
                      },
                    ),
                  ],
                ),
                SizedBox(height: 10.0,),
              ]
          )
        ),
      );
    }
    // TODO: implement build
    return null;
  }

}