import 'dart:async';

import 'package:garnetbook/data/models/base/request_result_model.dart';
import 'package:garnetbook/data/models/client/additives/additives_model.dart';
import 'package:garnetbook/data/models/client/additives/additives_request.dart';
import 'package:garnetbook/data/models/client/additives/additives_slot_model.dart';
import 'package:garnetbook/data/models/client/additives/protocols_model.dart';
import 'package:garnetbook/domain/services/api_client/custom_dio.dart';
import 'package:get_it/get_it.dart';

class AdditivesNetworkService{
  final client = GetIt.I.get<ApiClientProvider>().client;


  FutureOr<RequestResultModel<ClientAdditivesView?>> createAdditives(ClientAdditivesRequest request) async{
    try{
      final response = await client.createAdditives(request);
      if(response.code == 0){
        return RequestResultModel(
            result: true,
            value: response.additive
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

  FutureOr<RequestResultModel<int?>> createProtocols(ProtocolCreate request) async{
    try{
      final response = await client.createClientProtocol(request);
      if(response.code == 0){
        return RequestResultModel(
            result: true,
            value: response.id
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

  FutureOr<RequestResultModel<ClientAdditivesResponse?>> deleteAdditives(int id) async{
    try{
      final response = await client.deleteAdditives(id);
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

  FutureOr<RequestResultModel<ClientAdditivesResponse?>> rejectAdditives(ClientRejectAdditivesRequest request) async{
    try{
      final response = await client.rejectFromAdditives(request);
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

  FutureOr<RequestResultModel<ClientAdditivesResponse?>> getAdditives() async{
    try{
      final response = await client.getAllClientAdditives();
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

  FutureOr<RequestResultModel<ClientAdditivesView?>> getOneAdditives(int id) async{
    try{
      final response = await client.getOneAdditives(id);

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

  FutureOr<RequestResultModel<List<ClientAdditivesView>?>> setAdditivesSlots(ClientSlotAdditivesRequest request) async{
    try{
      final response = await client.getSlotAdditives(request);

      if(response.code == 0){
        return RequestResultModel(
            result: true,
            value: response.additives
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

  FutureOr<RequestResultModel<List<AdditiveSlotsView>?>> getAdditivesForToday() async{
    try{
      final response = await client.getAdditivesForToday();

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

  FutureOr<RequestResultModel<List<AdditiveSlotsView>?>> getAdditivesForDay(String date) async{
    try{
      final response = await client.getAdditivesForDay(date);

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

  FutureOr<RequestResultModel<AdditiveSlotsView?>> checkAdditiveSlots({
    required int slotId,
    required bool check,
    required int clientAdditiveId
}) async{
    try{
      final response = await client.checkAdditiveSlot(ClientAdditivesSlotCheckRequest(
        slotId: slotId,
        checked: check,
        clientAdditiveId: clientAdditiveId
      ));

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


  FutureOr<RequestResultModel<Map<String, List<ClientAdditivesView>>?>> getQueueAdditives(ClientListAdditivesRequest request) async{
    try{
      final response = await client.getQueueAdditives(request);

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

  FutureOr<RequestResultModel> changeAdditivesStatus(ClientChangeStatusAdditivesRequest request) async{
    try{
      final response = await client.changeAdditivesStatus(request);

      if(response.code == 0){
        return RequestResultModel(
            result: true
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

  FutureOr<RequestResultModel<List<AdditiveSlotsView>>> getAdditiveSlot(int id) async{
    try{
      final response = await client.getAdditiveSlots(id);

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