import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// 数字时钟 Widget
class DigitalClock extends StatelessWidget {
  final DateTime time;

  const DigitalClock({Key? key, required this.time}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}",
      style: TextStyle(
        fontSize: 48,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
        letterSpacing: 4,
      ),
    );
  }
}

class Clock extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ClockState();
}

class ClockState extends State<Clock> with TickerProviderStateMixin {

  final _divider = Container(width: 25);

  final _normalSize = 35.0;

  var timeout = const Duration(seconds: 1);

  DateTime today = new DateTime.now();
  DateTime previousTime = new DateTime.now();

  bool _isDispose = false;

  late AnimationController _animationController;
  late Animation<double> _animation;

  _startTimer() {
    Timer.periodic(timeout, (timer) {
      setState(() {
        previousTime = today;
        today = new DateTime.now();
      });
      _animationController.forward(from: 0);
      if(_isDispose){
        timer.cancel();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    var hourPrefix = [0 , 1, 2];
    var prefix = [0, 1, 2, 3, 4, 5];
    var suffix = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];

    return Scaffold(
      appBar: AppBar(
        title: Text("Creative Clock"),
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 数字时钟显示
              DigitalClock(time: today),
              SizedBox(height: 40),
              // 动画时钟
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  _columnNumber(hourPrefix, today.hour ~/ 10, previousTime.hour ~/ 10),
                  _columnNumber(suffix, today.hour % 10, previousTime.hour % 10),

                  _divider,

                  _columnNumber(prefix, today.minute ~/ 10, previousTime.minute ~/ 10),
                  _columnNumber(suffix, today.minute % 10, previousTime.minute % 10),

                  _divider,

                  _columnNumber(prefix, today.second ~/ 10, previousTime.second ~/ 10),
                  _columnNumber(suffix, today.second % 10, previousTime.second % 10),
                ],
              ),
            ],
          )),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  _columnNumber(List<int> numbers, int current, int previous) {
    List<Widget> list = [];
    numbers.forEach((e) {
      list.add(_Number(e, e == current, numbers.length));
    });

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        // 计算动画插值
        double animatedPosition = previous + (current - previous) * _animation.value;
        
        return Container(
          child: Align(
            alignment: Alignment.topCenter,
            widthFactor: 1,
            heightFactor: (animatedPosition * 2 + 1) / numbers.length,
            child: Container(
              height: numbers.length * _normalSize,
              margin: EdgeInsets.only(left: 5, right: 5),
              child: Column(
                children: list,
              )),
          ),
        );
      },
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
    _animationController.dispose();
    super.dispose();
    _isDispose = true;
  }
}