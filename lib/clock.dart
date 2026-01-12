import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// 翻页记分牌数字时钟 Widget
class DigitalClock extends StatefulWidget {
  final DateTime time;
  final DateTime previousTime;

  const DigitalClock({Key? key, required this.time, required this.previousTime}) : super(key: key);

  @override
  State<DigitalClock> createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock> with TickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
  }

  @override
  void didUpdateWidget(DigitalClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.time != widget.time) {
      _animationController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String hour = widget.time.hour.toString().padLeft(2, '0');
    String minute = widget.time.minute.toString().padLeft(2, '0');
    String second = widget.time.second.toString().padLeft(2, '0');
    
    String prevHour = widget.previousTime.hour.toString().padLeft(2, '0');
    String prevMinute = widget.previousTime.minute.toString().padLeft(2, '0');
    String prevSecond = widget.previousTime.second.toString().padLeft(2, '0');

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _FlipDigit(digit: hour[0], prevDigit: prevHour[0], animation: _animationController),
        _FlipDigit(digit: hour[1], prevDigit: prevHour[1], animation: _animationController),
        _Separator(),
        _FlipDigit(digit: minute[0], prevDigit: prevMinute[0], animation: _animationController),
        _FlipDigit(digit: minute[1], prevDigit: prevMinute[1], animation: _animationController),
        _Separator(),
        _FlipDigit(digit: second[0], prevDigit: prevSecond[0], animation: _animationController),
        _FlipDigit(digit: second[1], prevDigit: prevSecond[1], animation: _animationController),
      ],
    );
  }
}

// 分隔符
class _Separator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: Colors.black87,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(height: 12),
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: Colors.black87,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}

// 翻页数字
class _FlipDigit extends StatelessWidget {
  final String digit;
  final String prevDigit;
  final AnimationController animation;

  const _FlipDigit({
    required this.digit,
    required this.prevDigit,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    // 只有数字变化时才显示动画
    final bool hasChanged = digit != prevDigit;
    
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2),
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          final animValue = hasChanged ? Curves.easeInOut.transform(animation.value) : 0.0;
          final offset = -80.0 * animValue;
          
          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 60,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                clipBehavior: Clip.hardEdge,
                children: [
                  // 数字滚动
                  Positioned(
                    top: offset,
                    left: 0,
                    right: 0,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _DigitCard(digit: hasChanged ? prevDigit : digit),
                        _DigitCard(digit: digit),
                      ],
                    ),
                  ),
                  // 中间分割线
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 39,
                    child: Container(
                      height: 2,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// 数字卡片
class _DigitCard extends StatelessWidget {
  final String digit;

  const _DigitCard({required this.digit});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 80,
      alignment: Alignment.center,
      child: Text(
        digit,
        style: TextStyle(
          fontSize: 56,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          height: 1,
        ),
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
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 翻页记分牌数字时钟
              DigitalClock(time: today, previousTime: previousTime),
              SizedBox(height: 20),
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