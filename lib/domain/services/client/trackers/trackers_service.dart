
import 'package:garnetbook/data/models/base/base_response.dart';
import 'package:garnetbook/data/models/base/request_result_model.dart';
import 'package:garnetbook/data/models/client/trackers/slot_view.dart';
import 'package:garnetbook/data/models/client/trackers/tracker_request.dart';
import 'package:garnetbook/data/models/client/trackers/tracker_response.dart';
import 'package:garnetbook/domain/services/api_client/custom_dio.dart';
import 'package:get_it/get_it.dart';

class TrackersService{
  final client = GetIt.I.get<ApiClientProvider>().client;

  Future<RequestResultModel<List<ClientTrackerView>?>> getTracker() async{
    try{

      final response = await client.getClientTracker();

      if(response.code == 0){
        return RequestResultModel(
            result: true,
            value: response.trackers
        );
      }
      else{
        return RequestResultModel(result: false);
      }


    }catch(error){
      return RequestResultModel(
          result: false,
          error: error.toString()
      );
    }
  }

  Future<RequestResultModel<List<ClientTrackerView>?>> setTracker(ClientTrackerRequest request) async{
    try{

      final response = await client.setClientTracker(request);

      if(response.code == 0){
        return RequestResultModel(
            result: true,
            value: response.trackers
        );
      }
      else{
        return RequestResultModel(result: false);
      }


    }catch(error){
      return RequestResultModel(
          result: false,
          error: error.toString()
      );
    }
  }

  Future<RequestResultModel<BaseResponse?>> deleteTracker(int id) async{
    try{

      final response = await client.deleteClientTracker(id);

      if(response.code == 0){
        return RequestResultModel(
            result: true,
            value: response
        );
      }
      else{
        return RequestResultModel(result: false);
      }


    }catch(error){
      return RequestResultModel(
          result: false,
          error: error.toString()
      );
    }
  }

  Future<RequestResultModel<ClientTrackerSlotsView?>> getTrackersSlot(int slotId, bool check) async{
    try{

      final response = await client.getTrackerSlots(slotId, check);

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