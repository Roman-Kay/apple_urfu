
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:garnetbook/data/models/base/request_result_model.dart';
import 'package:garnetbook/data/models/client/calendar/calendar_event_model.dart';
import 'package:garnetbook/data/models/client/calendar/calendar_request_model.dart';
import 'package:garnetbook/data/models/client/calendar/calendar_view_model.dart';
import 'package:garnetbook/domain/services/api_client/custom_dio.dart';
import 'package:get_it/get_it.dart';

class CalendarNetworkService{
  final client = GetIt.I.get<ApiClientProvider>().client;

  FutureOr<RequestResultModel<List<EventView>?>> getCalendarEvent() async{
    try{
      final response = await client.getCalendarEvent();

      if(response.code == 0){
        return RequestResultModel(
          result: true,
          value: response.events
        );
      }
      else{
        return RequestResultModel(
            result: false
        );
      }

    }catch(error){
      return RequestResultModel(
        result: false,
        error: error.toString()
      );
    }
  }

  FutureOr<RequestResultModel<List<EventView>?>> putCalendarEvent(EventRequest request) async{
    try{
      final response = await client.putCalendarEvent(request);
      if(response.code == 0){
        return RequestResultModel(
            result: true,
            value: response.events
        );
      }
      else{
        return RequestResultModel(
            result: false
        );
      }

    }catch(error){
      return RequestResultModel(
          result: false,
          error: error.toString()
      );
    }
  }

  FutureOr<RequestResultModel<EventView?>> deleteCalendarEvent(int eventId) async{
    try{
      final response = await client.deleteCalendarEvent(eventId);
      if(response.code == 0){
        return RequestResultModel(result: true);
      }
      else{
        return RequestResultModel(result: false);
      }
    }catch(error){
      return RequestResultModel(result: false, error: error.toString());
    }
  }

  Future<RequestResultModel<EventsAndIndicatorsForDayResponse>> getCalendarEventForDay(String day) async{
    try{
      final response = await client.getCalendarEventForNDay(day);

      if(response.code == 0){
        return RequestResultModel(
            result: true,
            value: response
        );
      }
      else{
        return RequestResultModel(
            result: false
        );
      }

    }catch(error){
      return RequestResultModel(
          result: false,
          error: error.toString()
      );
    }
  }
}