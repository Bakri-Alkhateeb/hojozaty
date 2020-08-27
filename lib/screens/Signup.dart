import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hojozaty/functions/globalState.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class Signup extends StatefulWidget {

  Signup({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {

  GlobalState _globalState = GlobalState.instance;
  final GlobalKey<ScaffoldState> scaffoldState =  new GlobalKey<ScaffoldState>();
  TextEditingController name = new TextEditingController();
  TextEditingController username = new TextEditingController();
  TextEditingController password = new TextEditingController();
  final nameFocus = FocusNode();
  final usernameFocus = FocusNode();
  final passwordFocus = FocusNode();
  final _formKey = GlobalKey<FormState>();

  _SignupState(){
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

  void signUpBtn() async{
    if(!_formKey.currentState.validate()){
      scaffoldState.currentState.showSnackBar(
          SnackBar(
            duration: Duration(seconds: 1),
            backgroundColor: Color(0xffe75480),
            content: Row(
              textDirection: TextDirection.rtl,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'رجاءً أدخل معلوماتك',
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
    }
    else{
      http.post(GlobalState.SIGNUP, body: {
        'username': username.text,
        'password': password.text,
        'name': name.text
      }).then((http.Response response){
        if(response.statusCode == 201){
          Navigator.of(context).pushNamedAndRemoveUntil('/login',(Route <dynamic> route) => false);
          username.text = '';
          password.text = '';
          name.text = '';
        } else if(response.statusCode == 202){
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
                        'اسم المستخدم أو رقم الهاتف موجود مسبقاً',
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
          'تسجيل حساب جديد',
          style: TextStyle(
              fontSize: width * 4.8780487804878048780487804878049 / 100,
              color: Color(0xffe75480),
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
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: scaffoldState,
      body: SingleChildScrollView(
        child: Container(
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
            child: ListView(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 70,
                    ),
                    _title(),
                    SizedBox(
                      height: 50,
                    ),
                    Container(
                      padding: EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Color(0xffe75480),
                      ),
                      child: Column(
                        children: <Widget>[
                          Form(
                            child: Column(
                              children: <Widget>[
                                Text(
                                  "اسمك الكامل",
                                  style: TextStyle(
                                      fontSize: width * 4.8780487804878048780487804878049 / 100
                                  ),
                                ),
                                TextFormField(
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'الرجاء إدخال اسمك الكامل';
                                    }
                                    return null;
                                  },
                                  obscureText: false,
                                  textInputAction: TextInputAction.next,
                                  onFieldSubmitted: (v){
                                    FocusScope.of(context).requestFocus(usernameFocus);
                                  },
                                  focusNode: nameFocus,
                                  controller: name,
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(
                                          Icons.label
                                      ),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(50)
                                      ),
                                      fillColor: Color(0xffFFFFFF),
                                      filled: true
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "اسم المستخدم",
                                  style: TextStyle(
                                      fontSize: width * 4.8780487804878048780487804878049 / 100
                                  ),
                                ),
                                TextFormField(
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'الرجاء إدخال اسم المستخدم';
                                    }
                                    return null;
                                  },
                                  obscureText: false,
                                  textInputAction: TextInputAction.next,
                                  onFieldSubmitted: (v){
                                    FocusScope.of(context).requestFocus(passwordFocus);
                                  },
                                  focusNode: usernameFocus,
                                  controller: username,
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(
                                          Icons.person
                                      ),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(50)
                                      ),
                                      fillColor: Color(0xffFFFFFF),
                                      filled: true
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "كلمة المرور",
                                  style: TextStyle(
                                      fontSize: width * 4.8780487804878048780487804878049 / 100
                                  ),
                                ),
                                TextFormField(
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'الرجاء إدخال كلمة المرور';
                                    }
                                    return null;
                                  },
                                  obscureText: true,
                                  textInputAction: TextInputAction.go,
                                  onFieldSubmitted: (v){
                                    signUpBtn();
                                  },
                                  focusNode: passwordFocus,
                                  controller: password,
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(
                                          Icons.lock
                                      ),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(50)
                                      ),
                                      fillColor: Color(0xffFFFFFF),
                                      filled: true
                                  ),
                                ),
                              ],
                            ),
                            key: _formKey,
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          _signUpButton(),
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                )
              ],
            )
        ),
      ),
    );
  }
}
