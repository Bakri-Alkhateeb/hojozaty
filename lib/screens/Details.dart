import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:hojozaty/functions/globalState.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Details extends StatefulWidget {
  Details({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {

  GlobalKey bottomNavigationKey = GlobalKey();
  int currentPage = 0;
  final GlobalKey<InnerDrawerState> _innerDrawerKey = GlobalKey<InnerDrawerState>();
  bool _onTapToClose = false;
  bool _swipe = true;
  bool _tapScaffold = true;
  double _offset = 0.4;
  InnerDrawerDirection _direction = InnerDrawerDirection.start;
  InnerDrawerAnimation _animationType = InnerDrawerAnimation.static;
  GlobalState _globalState = GlobalState.instance;
  int rate, rooms, id;
  String name, location, description, image, userId, tableName;
  final GlobalKey<ScaffoldState> scaffoldState =  new GlobalKey<ScaffoldState>();


  _DetailsState(){
    Timer.periodic(new Duration(milliseconds: 2500), (timer) {
      detectPlacesChanges();
    });
  }

  @override
  void initState() {
    super.initState();
    rate = _globalState.get('rate');
    rooms = _globalState.get('rooms');
    id = _globalState.get('id');
    name = _globalState.get('name');
    location = _globalState.get('location');
    description = _globalState.get('description');
    image = _globalState.get('image');
    userId = _globalState.get('userId');
    tableName = _globalState.get('tableName');
  }

  Future<void> detectPlacesChanges() async{
    http.post(GlobalState.DETECT_PLACES_CHANGES, body: {
      "Id": id.toString(),
      "tableName": tableName,
    }).then((http.Response response){
      if(response.statusCode == 201){
        setState(() {
          rooms = json.decode(response.body)['availablePlaces'];
        });
      }
    });
  }

  Future<void> reserveBtn() async{
    http.post(GlobalState.RESERVATION, body: {
      "Id": id.toString(),
      "tableName": tableName,
      "userId": userId
    }).then((http.Response response){
      if(response.statusCode == 201){
        setState(() {
          rooms = json.decode(response.body)['availablePlaces'];
        });
      }else{
        setState(() {
          rooms = 0;
        });
        setState(() {
          scaffoldState.currentState.showSnackBar(
              SnackBar(
                duration: Duration(seconds: 2),
                backgroundColor: Color(0xffe75480),
                content: Row(
                  textDirection: TextDirection.rtl,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'عذراً لا يوجد أماكن متاحة حاليأ للحجز, حاول في وقت آخر',
                      style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff87ceeb)
                      ),
                    ),
                  ],
                ),
              )
          );
        });
      }
    });
  }

  void logOutConfirm(){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            textDirection: TextDirection.rtl,
            children: <Widget>[
              Text('هل تريد تسجيل الخروج؟')
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: new Text("لا"),
              onPressed: () => Navigator.pop(context),
            ),
            FlatButton(
              child: new Text("نعم"),
              onPressed: logOutBtn,
            ),
          ],
        );
      },
    );
  }

  Future<void> logOutBtn() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', false);
    prefs.setString('token', null);
    Navigator.of(context).pushNamedAndRemoveUntil('/main', (Route <dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return InnerDrawer(
      key: _innerDrawerKey,
      onTapClose: _onTapToClose,
      tapScaffoldEnabled: _tapScaffold,
      offset: IDOffset.horizontal(_offset),
      swipe: _swipe,
      boxShadow: _direction == InnerDrawerDirection.start && _animationType == InnerDrawerAnimation.linear ? [] : null,
      colorTransitionChild: Color(0xff87ceeb),
      rightAnimationType: InnerDrawerAnimation.quadratic,

      rightChild: Material(
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                  left: BorderSide(width: 1, color: Colors.grey[200]),
                  right: BorderSide(width: 1, color: Colors.grey[200])),
            ),
            child: Column(
              textDirection: TextDirection.rtl,
              children: <Widget>[
                Container(
                  height: 100,
                  width: width,
                  color: Color(0xff87ceeb),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  textDirection: TextDirection.rtl,
                  children: <Widget>[
                    InkWell(
                      onTap: logOutConfirm,
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          textDirection: TextDirection.rtl,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Icon(
                              Icons.exit_to_app,
                              size: 25,
                              color: Color(0xff555555),
                            ),
                            SizedBox(width: 10),
                            Text(
                              'تسجيل خروج',
                              style: TextStyle(
                                fontSize: width * 4.8780487804878048780487804878049 / 100,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
      ),

      scaffold: SafeArea(
        child: Scaffold(
            key: scaffoldState,
            body: ListView(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(color: Color(0xffEEEEEE)),
                  child: Stack(
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(top: 0),
                          child: Column(
                            children: <Widget>[
                              Container(
                                child: Image(
                                  image: NetworkImage(image),
                                  fit: BoxFit.cover,
                                ),
                                height: MediaQuery.of(context).size.height / 2.5,
                                width: MediaQuery.of(context).size.width,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Column(
                                children: <Widget>[
                                  Text(
                                    name,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff000000)
                                    ),
                                  ),
                                  Divider(
                                    indent: 5,
                                    endIndent: 5,
                                    thickness: 1,
                                    color: Color(0xff555555),
                                  ),
                                  GridView.builder(
                                      shrinkWrap: true,
                                      physics: BouncingScrollPhysics(),
                                      itemCount: 2,
                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                                      itemBuilder: (context, index) {
                                        return Container(
                                          margin: EdgeInsets.all(30),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              border: Border.all(width: 2)
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              Icon(
                                                  index == 0 ? Icons.star : Icons.home,
                                                  size: 50,
                                                  color: Color(0xff87ceeb)
                                              ),
                                              Divider(
                                                indent: 15,
                                                endIndent: 15,
                                                thickness: 2,
                                                color: Colors.black,
                                              ),
                                              Text(
                                                index == 0 ? rate.toString() : rooms.toString(),
                                                style: TextStyle(
                                                    fontSize: 50,
                                                    color: Color(0xffe75480)
                                                ),
                                              )
                                            ],
                                          ),
                                        );
                                      }
                                  ),
                                  Container(
                                    child: Text(
                                      "الموقع",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xff000000)
                                      ),
                                    ),
                                  ),
                                  Divider(
                                    indent: 15,
                                    endIndent: 15,
                                    thickness: 2,
                                    color: Color(0xffAAAAAA),
                                  ),
                                  Container(
                                    child: Text(
                                      location,
                                      style: TextStyle(
                                        fontSize: 24,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Divider(
                                    indent: 15,
                                    endIndent: 15,
                                    thickness: 2,
                                    color: Color(0xffAAAAAA),
                                  ),
                                  Container(
                                    child: Text(
                                      "الوصف",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xff000000)
                                      ),
                                    ),
                                  ),
                                  Divider(
                                    indent: 15,
                                    endIndent: 15,
                                    thickness: 2,
                                    color: Color(0xffAAAAAA),
                                  ),
                                  Container(
                                    child: Text(
                                      description,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 24,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    textDirection: TextDirection.rtl,
                                    children: <Widget>[
                                      SizedBox(
                                        width: 10,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  RaisedButton(
                                    onPressed: reserveBtn,
                                    color: Color(0xffe75480),
                                    child: Container(
                                      width: width / 1.5,
                                      height: 60,
                                      child: Center(
                                        child: Text(
                                          "حجز",
                                          style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xff87ceeb)
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 50,
                                  )
                                ],
                              ),
                            ],
                          )
                      ),
                    ],
                  ),
                ),
              ],
            )
        ),
      ),
    );
  }
}