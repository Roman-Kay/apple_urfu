

import 'package:garnetbook/data/models/base/request_result_model.dart';
import 'package:garnetbook/data/models/client/woman_calendar/woman_calendar_request.dart';
import 'package:garnetbook/data/models/client/woman_calendar/woman_calendar_response.dart';
import 'package:garnetbook/data/models/client/woman_calendar/woman_calendar_view.dart';
import 'package:garnetbook/domain/services/api_client/custom_dio.dart';
import 'package:get_it/get_it.dart';

class WomanCalendarService{
  final client = GetIt.I.get<ApiClientProvider>().client;

  Future<RequestResultModel<ResponseWomenCalendarResponse?>> getWomanCalendarForMonth(int monthNumber) async{
    try{

      final response = await client.getWomanCalendarForPeriod(monthNumber);

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

  Future<RequestResultModel<ClientPeriodView?>> getWomanCalendarForDay(String date) async{
    try{

      final response = await client.getWomanCalendar(date);

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

  Future<RequestResultModel<List<ClientPeriodView>?>> createWomanCalendarForPeriod(String dateStart, String dateEnd) async{
    try{

      final response = await client.createWomanCalendarForPeriod(dateStart, dateEnd);

      return RequestResultModel(
          result: true,
          value: response
      );


    }catch(error){
      return RequestResultModel(
          result: false,
          error: error.toString()
      );
    }
  }

  Future<RequestResultModel<ClientPeriodView?>> createWomanCalendarForDay(String date) async{
    try{

      final response = await client.createWomanCalendar(date);

      return RequestResultModel(
          result: true,
          value: response
      );


    }catch(error){
      return RequestResultModel(
          result: false,
          error: error.toString()
      );
    }
  }

  Future<RequestResultModel<ClientPeriodView?>> updateWomanCalendarForDay(WomanCalendarRequest request) async{
    try{

      final response = await client.updateWomanCalendar(request);

      return RequestResultModel(
          result: true,
          value: response
      );


    }catch(error){
      return RequestResultModel(
          result: false,
          error: error.toString()
      );
    }
  }
}