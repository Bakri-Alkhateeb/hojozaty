import 'package:hojozaty/functions/globalState.dart';
import 'package:hojozaty/screens/Cafes.dart';
import 'package:hojozaty/screens/Details.dart';
import 'package:hojozaty/screens/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hojozaty/screens/Hotels.dart';
import 'package:hojozaty/screens/Login.dart';
import 'package:hojozaty/screens/Restaurants.dart';
import 'package:hojozaty/screens/Signup.dart';
import 'package:hojozaty/screens/Splash.dart';
import 'package:hojozaty/screens/WelcomePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyApp extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {

    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  bool isLoggedIn = false;
  bool isConnected = false;
  @override
  void initState() {
    auth();
    checkConnection();
    super.initState();
  }

  void auth() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    if(token != null){
      setState(() {
        isLoggedIn = true;
      });
    }
  }

  Future<void> checkConnection() async{
    http.get(GlobalState.CHECKCONNECTION).then((http.Response response){
      setState(() {
        if(response.statusCode == 201){
          isConnected = true;
        } else{
          isConnected = false;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    return MaterialApp(
      title: 'حجوزاتي',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: Splash(),
      routes: <String, WidgetBuilder>{
        '/main': (BuildContext context) => MyApp(),
        '/home': (BuildContext context) => isLoggedIn && isConnected ? MyHomePage() : WelcomePage(),
        '/login': (BuildContext context) => Login(),
        '/signup': (BuildContext context) => Signup(),
        '/main_page': (BuildContext context) => MyHomePage(),
        '/hotels': (BuildContext context) => Hotels(),
        '/restaurants': (BuildContext context) => Restaurants(),
        '/cafes': (BuildContext context) => Cafes(),
        '/details': (BuildContext context) => Details(),
      },
    );
  }
}

void main() {
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp,DeviceOrientation.portraitDown])
      .then((_) => runApp(MyApp()));
}