import 'dart:async';

import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
//import 'package:get/get_connect/http/src/utils/utils.dart';
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
        finalTime.text = "0";
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

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    
    final BoxDecoration containerDecoration = _timerActive
        ? BoxDecoration(color: Colors.black)
        : BoxDecoration(color: Colors.red);

    //final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: true,

      appBar: AppBar(
        title: Text("Timer"),
      ),

      floatingActionButton: Stack(
        children: [
            


            Obx(()=>
              Positioned(
                bottom: 96,
                right: 0,
              
                child: Column(children: 
                [
              
                  Visibility(
                    visible: controller.textFieldMap['isVisible']!.value,
              
                    child: TextButton(onPressed: ()
                    {
                      controller.textFieldMap['isSelected']!.value = true;
                      controller.buttonMap['isSelected']!.value = false;
                    },
                        
                        style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(controller.textFieldMap['isSelected']!.value? Colors.red : Colors.white),
                          shape: WidgetStateProperty.all<BeveledRectangleBorder>(BeveledRectangleBorder(borderRadius: BorderRadius.zero),
                        ),
              
                        minimumSize: WidgetStatePropertyAll(Size(85,30)),
                        maximumSize: WidgetStatePropertyAll(Size(85,40)),
                      ),
              
                      child: Text("TextField",
                        style: TextStyle(color: controller.textFieldMap['isSelected']!.value? Colors.white : Colors.blue[1000]),
                      ),
                    ),
                  ),
              
                  ],),
              
                ),
            ),


            Obx(()=>
              Positioned(
                bottom: 58,
                right: 0,
              
                child: Column(children: 
                [
              
                  Visibility(
                    visible: controller.buttonMap['isVisible']!.value,
                    child: TextButton(onPressed: ()
                    {
                      controller.textFieldMap['isSelected']!.value = false;
                      controller.buttonMap['isSelected']!.value = true;
                    },
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(controller.buttonMap['isSelected']!.value? Colors.red : Colors.white),
                        shape: WidgetStateProperty.all<BeveledRectangleBorder>(BeveledRectangleBorder(borderRadius: BorderRadius.zero),),
                        minimumSize: WidgetStatePropertyAll(Size(85,30)),
                        maximumSize: WidgetStatePropertyAll(Size(85,40)),
              
                      ), 
                      
                      child: Text("Buttons",
                        style: TextStyle(color: controller.buttonMap['isSelected']!.value? Colors.white : Colors.blue[1000])
                      ),
                      
                    ),
                  ),
                ],),
              ),
            ),
              



          Positioned(
            bottom: 5,
            right: 12,

            child: FloatingActionButton(
              tooltip: 'Choose how you want to enter time',
              shape: BeveledRectangleBorder(side: BorderSide(color: Colors.white)),
              onPressed: (){
                controller.count++;
                debugPrint("${controller.count}");
                controller.buttonMap['isVisible']!.value = !controller.buttonMap['isVisible']!.value;
                controller.textFieldMap['isVisible']!.value = !controller.textFieldMap['isVisible']!.value;
              },
              
            
                child: Text(String.fromCharCode(5010)),
              ),
          ),
        ],
      ),
    

      body: SingleChildScrollView(
        
        child: Container(
          padding: EdgeInsets.all(8.0),
          decoration: containerDecoration,
        
      
          child: Column(children: [
            Text("textfield: ${controller.textFieldMap['isVisible']!.value}"),
            Text("buttonview: ${controller.buttonMap['isVisible']!.value}"),

            Obx(
              ()=> Text("${controller.count}"),
            ),

            //////This is the TextField that appears\\\\\\\
            
            Stack(
              children: [
                Obx(()=>
                  Padding(
                    padding: const EdgeInsets.only(top: 120.0),
                    
                  
                    child: Visibility(
                      visible: controller.textFieldMap['isSelected']!.value,
                  
                      child: TextField(
                        controller: finalTime,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(filled: true, hintText: "Stop Time", label: Text("Stop At:"), alignLabelWithHint: true),
                        style: TextStyle(fontSize: 48),
                      ),
                    ),
                
                
                  ),
                ),
              
              

              ///// \\\\\\
              Obx(()=>
                Padding(
                  padding: const EdgeInsets.only(top: 108.0),
                  
                  child: Visibility(
                    visible: controller.buttonMap['isSelected']!.value,
                                 
                    child: Column(
                      children: [
                        
                        Row(children: [
                          Text("Hours"),
                          Text("Minutes"),
                          Text("Seconds"),
                        ],),

                        Row(
                          spacing: 100.0,
                          children: [
                            for (var listing in [controller.hoursList, controller.minutesList, controller.secondsList])
                            Expanded(
                              child: SizedBox(
                                height: 116,
                        
                                child: Transform(
                                  alignment: Alignment.center,
                                  transform: MatrixUtils.createCylindricalProjectionTransform(
                                    radius: 0.001,
                                    angle: 0.0,
                                    perspective: 0.04,
                                    
                                  ),
                        
                                  child: ListView.builder(
                                    itemCount: listing.length,
                                    scrollDirection: Axis.vertical,
                                  
                                    itemBuilder: (_, index){
                                      final value = num.tryParse(listing[index].toString()) ?? 0;
                        
                        
                                      return TextButton(
                                        onPressed: (){
                                          if (listing == controller.hoursList){ finalTime.text = (value*3600).toString();}
                                          else if(listing == controller.minutesList){ finalTime.text = (value*60).toString();}
                                          else if(listing == controller.secondsList){ finalTime.text = value.toString();}
                                        },
                                  
                                        style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.white)),
                                        child: Text(listing[index].toString()),
                                      );
                                    }
                                  
                                  ),
                                ),
                              ), 
                            ),
                            
                            
                        
                        
                          ],
                        ),
                      ],
                    ),
                  ),


                ),
              ),
          ],),
            ///

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
              padding: EdgeInsets.only(top: 8.0, bottom: screenHeight-570),
        
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

