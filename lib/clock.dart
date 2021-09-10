import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Clock extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ClockState();
}

class ClockState extends State<Clock> {

  final _divider = Container(
      alignment: Alignment.center,
      child: Text(":" ,style: TextStyle(fontSize: 18 , color: Colors.black , fontWeight: FontWeight.w700),),
      width: 25);

  final _normalSize = 35.0;

  var timeout = const Duration(seconds: 1);

  DateTime today = new DateTime.now();

  bool _isDispose = false;

  _startTimer() {
    Timer.periodic(timeout, (timer) {
      today = new DateTime.now();
      setState(() {});
      if(_isDispose){
        timer.cancel();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    var hourPrefix = [0 , 1, 2];
    var prefix = [0, 1, 2, 3, 4, 5];
    var suffix = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];

    DateTime today = new DateTime.now();
    print("当前时间 ： ${today.hour} ： ${today.minute} ： ${today.second}");

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Flutter Clock"),
      ),
      body: Container(
          alignment: Alignment.center,
          child: Row(
            // crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              _columnNumber(hourPrefix, today.hour ~/ 10),
              _columnNumber(suffix, today.hour % 10),

              _divider,

              _columnNumber(prefix, today.minute ~/ 10),
              _columnNumber(suffix, today.minute % 10),

              _divider,

              _columnNumber(prefix, today.second ~/ 10),
              _columnNumber(suffix, today.second % 10),
            ],
          )),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  _columnNumber(List<int> numbers, int current) {
    List<Widget> list = [];
    numbers.forEach((e) {
      list.add(_Number(e, e == current, numbers.length));
    });

    return Container(
      // color: Colors.white,
      child: Align(
        alignment: Alignment.topCenter,
        widthFactor: 1,
        heightFactor: (current *2 + 1)/numbers.length,
        child: Container(
          height: numbers.length * _normalSize,
          margin: EdgeInsets.only(left: 5, right: 5),
          child: Column(
            children: list,
          )),
      ),
    );
  }

  _Number(int number, bool isActive, int totalSize) {
    var backgroundColor;
    var numberSize;
    if (isActive) {
      backgroundColor = Colors.black;
      numberSize = 18.0;
    } else {
      backgroundColor = Colors.deepPurpleAccent;
      numberSize = 16.0;
    }

    BorderRadius borderRadius;
    if (number == 0) {
      borderRadius = BorderRadius.only(
          topLeft: Radius.circular(15), topRight: Radius.circular(15));
    } else if (number == (totalSize - 1)) {
      borderRadius = BorderRadius.only(
          bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15));
    } else {
      borderRadius = BorderRadius.all(Radius.zero);
    }

    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
      ),
      width: _normalSize,
      height: _normalSize,
      child: Text(
        "$number",
        style: TextStyle(color: Colors.white, fontSize: numberSize),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _isDispose = true;
  }
}