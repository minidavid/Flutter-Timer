import 'package:get/get.dart';

class start_up_controller
{
  var count = 0.obs;
  
  var textFieldMap = {'isVisible' : false.obs, 'isSelected': false.obs}; 
  var buttonMap = {'isVisible' : false.obs, 'isSelected' : false.obs};

  List<dynamic> hoursList = [];
  List<dynamic> minutesList = [];
  List<dynamic> secondsList = [];
  
  start_up_controller()
    {
      for (int i = 0; i < 60; i++){
        minutesList.add(i);
        secondsList.add(i);
      }

      for (int i = 0; i < 24; i++){
        hoursList.add(i);
      }

    }

}
