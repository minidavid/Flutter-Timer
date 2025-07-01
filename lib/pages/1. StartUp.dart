import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:tic80_mo/pages/start_up_controller.dart';

class StartUp extends StatefulWidget {
  const StartUp({super.key});

  @override
  State<StartUp> createState() => _StartUpState();
}

class _StartUpState extends State<StartUp> {

  bool pauseTimer = false;
  bool bigger = true;
  bool changeBigger = true;
  
  int _start = 0;
  int second = 0;
  int hour = 0;
  int minute = 0;

  //String _startStr  = _start.toString();
  late TextEditingController finalTime = TextEditingController();

  var controller = Get.find<start_up_controller>();


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
        ? BoxDecoration(color: Colors.black)
        : BoxDecoration(color: Colors.red);

    return Scaffold(
      resizeToAvoidBottomInset: true,

      appBar: AppBar(
        title: Text("Pomodoro Timer"),
      ),

      floatingActionButton: FloatingActionButton(
        child: Text(String.fromCharCode(5010)),

        onPressed: (){
          controller.count++;
          debugPrint("${controller.count}");
        },

      ),
    

      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(8.0),
          decoration: containerDecoration,
        
          child: Column(children: [
        
            Obx(
              ()=> Text("${controller.count}"),
            ),
        
            Padding(
              padding: const EdgeInsets.only(top: 120.0),
              child: TextField(
                controller: finalTime,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(filled: true, hintText: "Stop Time", label: Text("Stop At:"), alignLabelWithHint: true),
                style: TextStyle(fontSize: 48),
              ),
            ),
          
            Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: Text("Current Time in seconds: $_start", style: TextStyle(color: Colors.white38),),
            ),
        
            Text("Current Time: $hour : $minute : $second", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white70),),
        
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
                child: Text("Stop Time: $finalTimeHour : $finalTimeMin : $finalTimeSec", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
            ),
        
            Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: AnimatedContainer(
              
                width: bigger? 150 : 180,
                duration: Duration(seconds: 1),
                curve: Curves.bounceInOut,
                height: bigger? 40:50,
              
                child: TextButton.icon(
                    onPressed: (){
              
                      bigger = !bigger;
              
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
              
                      }
                      
                      );
              
                    },
              
                    label: Text("Restart Timer"),
                    icon: Icon(Icons.timer),
                    style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.white)),
              
                ),
              ),
            ),
        
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
        
              child: AnimatedContainer(
                width: pauseTimer? 160: 180,
                curve: Curves.bounceInOut,
                duration: Duration(seconds: 1),
              
                child: TextButton.icon(
                  onPressed: (){
                    setState(() {
                      pauseTimer = !pauseTimer;
                    });
                  },
                    label: Text(pauseTimer? "Paused Timer" : "Resumed Timer",
                      style: TextStyle(color: pauseTimer? Colors.white: Colors.blue[1000]),
                    ),
        
                    icon: Icon(pauseTimer? Icons.play_arrow : Icons.pause,
                      color: pauseTimer? Colors.white: Colors.blue[1000],
                    ),
                    
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(pauseTimer? Colors.redAccent : Colors.white),),
                ),
              ),
            ),
        
        
            //Text("TimerActive: $_timerActive"),
            //Text("Timer paused: $pauseTimer"),
        
            
            
            // AnimatedContainer(
        
            //   width: _start/int.parse(finalTime.text)*100,
            //   duration: Duration(seconds: 1),
        
            //   child: TextButton(onPressed: (){},
            //     child: Text("$_start"),
            //   ),
            // ),
        
        
          ],),
        ),
      ),


    );
  }
}

