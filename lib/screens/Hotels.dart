import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:hojozaty/functions/globalState.dart';
import 'package:hojozaty/widgets/CustomCard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Hotels extends StatefulWidget {
  Hotels({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HotelsState createState() => _HotelsState();
}

class _HotelsState extends State<Hotels> {

  final GlobalKey<InnerDrawerState> _innerDrawerKey = GlobalKey<InnerDrawerState>();
  bool _onTapToClose = false;
  bool _swipe = true;
  bool _tapScaffold = true;
  double _offset = 0.4;
  InnerDrawerDirection _direction = InnerDrawerDirection.start;
  InnerDrawerAnimation _animationType = InnerDrawerAnimation.static;
  String pageTitle;
  int count;

  List<String> hotelsNames = [];
  List<String> hotelsImages = [];
  List<int> hotelsIds = [];
  List<int> hotelsRates = [];
  List<int> hotelsRooms = [];
  List<String> hotelsDescriptions = [];
  List<String> hotelsLocations = [];

  GlobalState _globalState = GlobalState.instance;

  _HotelsState(){
    fetchHotels();
  }

  @override
  void initState() {
    super.initState();
    pageTitle = "الفنادق";
    count = 0;
  }

  Future<void> fetchHotels() async{
    http.get(GlobalState.HOTELS).then((http.Response response){
      if(response.statusCode == 201){
        setState(() {
          count = json.decode(response.body)['count'];
          for(int i = 0; i < count; i++){
            hotelsIds.add(json.decode(response.body)['hotelsIds'][i]);
            hotelsNames.add(json.decode(response.body)['hotelsNames'][i]);
            hotelsImages.add(json.decode(response.body)['hotelsImages'][i]);
            hotelsRates.add(json.decode(response.body)['hotelsRates'][i]);
            hotelsRooms.add(json.decode(response.body)['hotelsTables'][i]);
            hotelsDescriptions.add(json.decode(response.body)['hotelsDescriptions'][i]);
            hotelsLocations.add(json.decode(response.body)['hotelsLocations'][i]);
          }
        });
      }
    });
  }

  Widget _header(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return ClipRRect(
      borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
      child: Container(
          height: 100,
          width: width,
          decoration: BoxDecoration(
            color: Color(0xff87ceeb),
          ),
          child: Stack(
            fit: StackFit.expand,
            alignment: Alignment.center,
            children: <Widget>[
              Positioned(
                  top: 50,
                  left: 0,
                  child: Container(
                      width: width,
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Stack(
                        children: <Widget>[
                          Align(
                              alignment: Alignment.topCenter,
                              child: Text(
                                pageTitle,
                                style: TextStyle(
                                    color: Color(0xffe75480),
                                    fontSize: width * 4.8780487804878048780487804878049 / 100,
                                    fontWeight: FontWeight.bold),
                              )
                          )
                        ],
                      )
                  )
              ),
              Positioned(
                top: 55,
                right: 12,
                child: InkWell(
                  onTap: () => _innerDrawerKey.currentState.toggle(),
                  child: Row(
                    textDirection: TextDirection.rtl,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Icon(
                          Icons.menu,
                          color: Color(0xffe75480),
                          size: 30
                      ),
                    ],
                  ),
                ),
              )
            ],
          )
      ),
    );
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
          body:  Container(
              decoration: BoxDecoration(color: Colors.white),
              child: ListView(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      SingleChildScrollView(
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              SizedBox(
                                height: 100,
                              ),
                              GridView.builder(
                                  shrinkWrap: true,
                                  physics: BouncingScrollPhysics(),
                                  itemCount: hotelsNames.length,
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                                  itemBuilder: (context, index) {
                                    return CustomCard(
                                        _globalState.get('userId').toString(),
                                        hotelsNames[index],
                                        "${GlobalState.HOTELS_IMAGES}/${hotelsImages[index]}",
                                        hotelsIds[index],
                                        hotelsRates[index],
                                        hotelsLocations[index],
                                        hotelsDescriptions[index],
                                        hotelsRooms[index],
                                        "hotels"
                                    );
                                  }
                              )
                            ]
                        ),
                      ),
                      _header(context),
                    ],
                  ),
                ],
              )
          ),
        ),
      ),
    );
  }
}