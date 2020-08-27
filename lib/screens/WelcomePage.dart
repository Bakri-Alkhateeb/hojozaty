import 'package:flutter/material.dart';
import 'package:hojozaty/functions/globalState.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class WelcomePage extends StatefulWidget {

  WelcomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {

  GlobalState _globalState = GlobalState.instance;
  final GlobalKey<ScaffoldState> scaffoldState =  new GlobalKey<ScaffoldState>();

  _WelcomePageState(){
    checkConnection();
  }

  Future<void> checkConnection() async{
    http.get(GlobalState.CHECKCONNECTION).then((http.Response response){
      if(json.decode(response.body)['connected']){
        _globalState.set('isConnected', true);
      } else{
        _globalState.set('isConnected', false);
      }
    });
  }

  Future<void> loginBtn() async{
    Navigator.of(context).pushNamed('/login');
//
//    if(_globalState.get('isConnected') == true){
//      Navigator.of(context).pushNamed('/login');
//    }else{
//      setState(() {
//        scaffoldState.currentState.showSnackBar(
//            SnackBar(
//              duration: Duration(seconds: 2),
//              backgroundColor: Color(0xffe75480),
//              content: Row(
//                textDirection: TextDirection.rtl,
//                crossAxisAlignment: CrossAxisAlignment.start,
//                children: <Widget>[
//                  Text(
//                    'تحقق من اتصالك بالانترنت',
//                    style: TextStyle(
//                        fontSize: 15.0,
//                        fontWeight: FontWeight.bold,
//                        color: Color(0xff87ceeb)
//                    ),
//                  ),
//                ],
//              ),
//            )
//        );
//      });
//      checkConnection();
//    }
  }

  Future<void> signUpBtn() async{
    Navigator.of(context).pushNamed('/signup');

//    if(_globalState.get('isConnected') == true){
//      Navigator.of(context).pushNamed('/signup');
//    }else{
//      setState(() {
//        scaffoldState.currentState.showSnackBar(
//            SnackBar(
//              duration: Duration(seconds: 2),
//              backgroundColor: Color(0xffe75480),
//              content: Row(
//                textDirection: TextDirection.rtl,
//                crossAxisAlignment: CrossAxisAlignment.start,
//                children: <Widget>[
//                  Text(
//                    'تحقق من اتصالك بالانترنت',
//                    style: TextStyle(
//                        fontSize: 15.0,
//                        fontWeight: FontWeight.bold,
//                        color: Color(0xff87ceeb)
//                    ),
//                  ),
//                ],
//              ),
//            )
//        );
//      });
//      checkConnection();
//    }
  }

  Widget _logInButton() {
    var width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: loginBtn,
      child: Container(
        width: width,
        padding: EdgeInsets.symmetric(vertical: 13),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(50)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Color(0xff87ceeb).withAlpha(100),
                offset: Offset(2, 4),
                blurRadius: 8,
                spreadRadius: 2)
          ],
          color: Color(0xff87ceeb),
        ),
        child: Text(
          'سجل دخولك',
          style: TextStyle(
              fontSize: width * 4.8780487804878048780487804878049 / 100,
              color: Color(0xffe75480),
              fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }

  Widget _signUpButton() {
    var width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: signUpBtn,
      child: Container(
        width: width,
        padding: EdgeInsets.symmetric(vertical: 13),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(50)),
          border: Border.all(color: Color(0xff87ceeb), width: 2),
        ),
        child: Text(
          'أنشئ حساباً',
          style: TextStyle(
              fontSize: width * 4.8780487804878048780487804878049 / 100,
              color: Color(0xff87ceeb),
              fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }

  Widget _title() {
    return
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        textDirection: TextDirection.rtl,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width / 2,
                child: Column(
                  children: <Widget>[
                    Image(
                      image: AssetImage("assets/logo.png"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldState,
      body:SingleChildScrollView(
        child:Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            color: Color(0xff87ceeb),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 100,
              ),
              _title(),
              SizedBox(
                height: 100,
              ),
              Container(
                padding: EdgeInsets.all(30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Color(0xffe75480).withAlpha(100),
                      offset: Offset(2, 4),
                      blurRadius: 8,
                      spreadRadius: 10,
                    )
                  ],
                  color: Color(0xffe75480),
                ),
                child: Column(
                  children: <Widget>[
                    _logInButton(),
                    SizedBox(
                      height: 30,
                    ),
                    _signUpButton(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
