
import 'package:flutter/material.dart';
import 'package:garnetbook/data/models/client/calendar/calendar_request_model.dart';
import 'package:garnetbook/data/repository/shared_preference_data.dart';
import 'package:garnetbook/domain/services/client/calendar/calendar_service.dart';

class CalendarController{
  final networkService = CalendarNetworkService();
  final storage = SharedPreferenceData.getInstance();

  Future<bool> addEventToCalendar(EventRequest request) async{

    final response = await networkService.putCalendarEvent(request);

    if(response.result == true){
      return true;
    }
    else if(response.error != null && response.error != ""){
      debugPrint(response.error);
      return false;
    }
    else {
      return false;
    }
  }
}
