import 'dart:async';

import 'package:flutter/material.dart';

class StartUp extends StatefulWidget {
  const StartUp({super.key});

  @override
  State<StartUp> createState() => _StartUpState();
}

class _StartUpState extends State<StartUp> {

  bool pauseTimer = false;

  int _start = 0;
  int second = 0;
  int hour = 0;
  int minute = 0;
  //String _startStr  = _start.toString();
  late TextEditingController finalTime = TextEditingController();

  late int finalTimeSec = 0;
  late int finalTimeMin = 0;
  late int finalTimeHour = 0;

 Timer _timer = Timer(Duration(),(){});
  
  late bool _timerActive = false;


  void startTimer(){
    if (_timerActive) return;

    _timer = Timer.periodic(Duration(seconds: 1), (timer){
      if (finalTime.text== "")
      { 
        finalTime.text = "1000";
        finalTimeSec = 16;
        finalTimeMin = 0;
        finalTimeHour = 0;
      }

      if (_start == int.parse(finalTime.text))
      {

        setState(() {
          timer.cancel();
          _timerActive = false;
          pauseTimer = true;
        });
      }
      else {
        setState((){

          if (!pauseTimer){
            _start++;
          }

          finalTimeSec = (int.parse(finalTime.text)%60).floor();
          finalTimeMin = ((int.parse(finalTime.text)/60)%60).floor();
          finalTimeHour = ((int.parse(finalTime.text)/(60*60))%24).floor();

          if ((_start%60==0)
          && (!pauseTimer))
          {
            second = 0;
            minute++;
          }

          else if ((_start%(60*60)==0)&& (!pauseTimer)){
            second = 0;
            minute = 0;
            hour++;
          }

          else {
            if (!pauseTimer){
              second++;
            }
          }

          _timerActive = true;
        });
      }

    });

  }

  @override
  void dispose()
  {
    _timer.cancel();
    super.dispose();
  }

  @override
  void initState() {

    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {

    final BoxDecoration containerDecoration = _timerActive
        ? BoxDecoration(color: Colors.blue)
        : BoxDecoration(color: Colors.red);

    return Scaffold(
      resizeToAvoidBottomInset: true,

      appBar: AppBar(
        title: Text("Pomodoro Timer"),
      ),


      body: Container(
          padding: EdgeInsets.all(8.0),
          decoration: containerDecoration,

        child: Column(children: [


          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: TextField(
              controller: finalTime,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(filled: true, hintText: "Stop Time", label: Text("Stop At:"), alignLabelWithHint: true),
              style: TextStyle(fontSize: 100),
            ),
          ),
        
          Text("Current Time in seconds: $_start"),
        
          Text("Current Time: $hour : $minute : $second"),
          Text("Stop Time: $finalTimeHour : $finalTimeMin : $finalTimeSec"),
        
          TextButton.icon(
              onPressed: (){

                //if (!(pauseTimer)) {
                //startTimer();
                //}
                setState(() {
                  _timer.cancel();
                  _start = 0;
                  second = 0;
                  hour = 0;
                  minute = 0;
                  _timerActive = false;

                  startTimer();

                });

              },
              label: Text("Restart Timer"),
              icon: Icon(Icons.timer),
              style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.white)),
          ),

          TextButton.icon(
            onPressed: (){
              setState(() {
                pauseTimer = !pauseTimer;
              });
            },
              label: Text(pauseTimer? "Paused Timer" : "Resumed Timer"),
              icon: Icon(pauseTimer? Icons.play_arrow : Icons.pause),
            style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(pauseTimer? Colors.grey : Colors.white)),
          ),


          Text("TimerActive: $_timerActive"),
          Text("Timer paused: $pauseTimer"),

        ],),
      ),


    );
  }
}
