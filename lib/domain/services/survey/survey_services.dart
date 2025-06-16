
import 'package:flutter/material.dart';
import 'package:garnetbook/data/models/base/request_result_model.dart';
import 'package:garnetbook/data/models/client/recommendation/recommendation_data.dart';
import 'package:garnetbook/data/models/survey/physical_survey/physical_survey_model.dart';
import 'package:garnetbook/data/models/survey/physical_survey/physical_survey_request.dart';
import 'package:garnetbook/data/models/survey/q_type_view/q_type_view.dart';
import 'package:garnetbook/data/models/survey/q_type_view/subsribe_view.dart';
import 'package:garnetbook/data/models/survey/quiz_model.dart';
import 'package:garnetbook/data/models/survey/quiz_request.dart';
import 'package:garnetbook/data/models/survey/quiz_result.dart';
import 'package:garnetbook/data/models/survey/selection_model.dart';
import 'package:garnetbook/data/repository/shared_preference_data.dart';
import 'package:garnetbook/domain/services/api_client/custom_dio.dart';
import 'package:get_it/get_it.dart';

class SurveyServices{

  final client = GetIt.I.get<ApiClientProvider>().surveyClient;

  Future<RequestResultModel<List<AllQuizModel>>> getAllSurvey() async{
    try{
      final response = await client.getAllSurvey();

      if(response.isNotEmpty){
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

  Future<RequestResultModel<List<QTypeView>>> getListOfQTypes() async{
    try{
      final response = await client.getQTypes();

      if(response.isNotEmpty){
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

  Future<RequestResultModel<SubscribeStep>> getSubscribe(int id) async{
    try{

      final storage = SharedPreferenceData.getInstance();
      final userId = await storage.getUserId();

      int newUserId = userId != "" ? int.parse(userId) : 0;

      final response = await client.getSubscribeSurvey(id, newUserId);

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

  Future<RequestResultModel<SubscribeResultView>> saveSubscribeResult(int id, SubscribeResult result) async{
    try{
      final response = await client.saveSubscribeResult(id, result);

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


  Future<RequestResultModel<RecommendationData?>> getOneRecommendation(int id) async{
    try{

      final response = await client.getRecommendations(id);

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

  Future<RequestResultModel<ArticleItem?>> getOneArticle(int id) async{
    try{

      final response = await client.getArticles(id);

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

  Future<RequestResultModel<QuizItem>> getOneSurvey(int id, String? gender) async{
    try{

      final response = await client.getSurvey(id, gender);

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

  Future<RequestResultModel<List<Result>>> setSurveyResults(int id, QuizRequest request) async{
    try{

      final response = await client.saveSurveyAnswer(id, request);

      return RequestResultModel(result: true, value: response);

    }catch(error){
      return RequestResultModel(
          result: false,
          error: error.toString()
      );
    }
  }

  Future<RequestResultModel<FQuizItem>> getOnePhysicalSurvey(int id) async{
    try{

      final response = await client.getPhysicalSurvey(id);

      return RequestResultModel(
          result: true,
          value: response
      );

    } catch(error){
      debugPrint("AAAAAAAAAAAAA");
      debugPrint(error.toString());

      return RequestResultModel(
          result: false,
          error: error.toString()
      );
    }
  }

  Future<RequestResultModel<List<FQuestion>>> setPhysicalSurveyResults(int id, FQuizRequest request) async{
    try{

      final response = await client.savePhysicalSurveyAnswer(id, request);

      return RequestResultModel(result: true, value: response);

    }catch(error){
      return RequestResultModel(
          result: false,
          error: error.toString()
      );
    }
  }


  Future<RequestResultModel<List<SelectionListView>>> getSelectionList() async{
    try{

      final response = await client.getListOfSelections();

      return RequestResultModel(result: true, value: response);

    }catch(error){
      return RequestResultModel(
          result: false,
          error: error.toString()
      );
    }
  }

  Future<RequestResultModel<List<SelectionView>>> getOneSelectionList(int id) async{
    try{

      final response = await client.getOneSelectionList(id);

      return RequestResultModel(result: true, value: response);

    }catch(error){
      return RequestResultModel(
          result: false,
          error: error.toString()
      );
    }
  }

}