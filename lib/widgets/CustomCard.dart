import 'package:hojozaty/functions/globalState.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class CustomCard extends StatefulWidget{
  String name;
  String image;
  int id;
  int rate;
  String location;
  String description;
  int rooms;
  String userId;
  String tableName;

  CustomCard(this.userId ,this.name, this.image, this.id, this.rate, this.location,
      this.description, this.rooms, this.tableName);

  @override
  State<StatefulWidget> createState() {
    return _CustomCardState(userId, name, image, id, rate, location, description, rooms, tableName);
  }
}

class _CustomCardState extends State<CustomCard> with SingleTickerProviderStateMixin{

  final GlobalKey<ScaffoldState> scaffoldState =  new GlobalKey<ScaffoldState>();
  final GlobalState _globalState = GlobalState.instance;
  double width;
  int count = 0;
  String userId;
  String name;
  String image;
  int id;
  int rate;
  String location;
  String description;
  int rooms;
  String tableName;

  _CustomCardState(this.userId, this.name, this.image, this.id, this.rate,
      this.location, this.description, this.rooms, this.tableName);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget buildTitle(String title) {
    return Center(
      child: Container(
        child: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: width * 4.8780487804878048780487804878049 / 100,
          ),
        ),
        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
        decoration: BoxDecoration(
            border: Border.all(
                width: width * 4.8780487804878048780487804878049 / 1000,
                color: Colors.white,
                style: BorderStyle.solid
            )
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return InkWell(
      child: Container(
        child: Card(
          elevation: 2,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(5.0),
              child: Container(
                child: Container(
                  color: Color.fromRGBO(0, 0, 0, 0.3),
                  child: buildTitle(name),
                ),
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(image),
                      fit: BoxFit.fill
                  ),
                ),
              )
          ),
        ),
      ),
      onTap: () {
        _globalState.set('name', name);
        _globalState.set('rate', rate);
        _globalState.set('description', description);
        _globalState.set('id', id);
        _globalState.set('location', location);
        _globalState.set('rooms', rooms);
        _globalState.set('image', image);
        _globalState.set('userId', userId);
        _globalState.set('tableName', tableName);
        Navigator.of(context).pushNamed('/details');
      },
    );
  }
}