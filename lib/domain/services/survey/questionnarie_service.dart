
import 'package:flutter/material.dart';
import 'package:garnetbook/data/models/base/request_result_model.dart';
import 'package:garnetbook/data/models/client/recommendation/platform_recommendation.dart';
import 'package:garnetbook/data/models/others/file_view.dart';
import 'package:garnetbook/data/models/survey/questionnaire/questionnaire_request.dart';
import 'package:garnetbook/data/models/survey/questionnaire/questionnaire_response.dart';
import 'package:garnetbook/domain/services/api_client/custom_dio.dart';
import 'package:get_it/get_it.dart';

class QuestionnaireService{
  final client = GetIt.I.get<ApiClientProvider>().client;

  Future<RequestResultModel<List<QuestionnaireShort>?>> getListOfClientsSurvey() async{
    try{
      final response = await client.getListOfClientsSurvey();

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

  Future<RequestResultModel<Questionnaire?>> getSurveyData(int id) async{
    try{
      final response = await client.getSurveyData(id);

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

  Future<RequestResultModel<int?>> setSurveyToClient(QuestionnaireCreateRequest request) async{
    try{
      final response = await client.setSurveyToClient(request);

      if(response.code == 0){
        return RequestResultModel(
            result: true,
            value: response.id
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

  Future<RequestResultModel<List<QuestionnaireShort>?>> clientCardListOfSurvey(int clientId) async{
    try{
      final response = await client.clientCardListOfSurvey(clientId);

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

  Future<RequestResultModel<FileView?>> getSurveyReport(int id) async{
    try{
      final response = await client.getSurveyReport(id);

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

  Future<RequestResultModel> setSurveyResult(QuestionnaireUpdateRequest request) async{
    try{
      final response = await client.setSurveyResult(request);

      if(response.code == 0){
        return RequestResultModel(result: true);
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

  Future<RequestResultModel<Map<String, List<Recommendation2>>?>> getListOfPlatformRecommendations() async{
    try{
      final response = await client.getPlatformRecommendations();

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