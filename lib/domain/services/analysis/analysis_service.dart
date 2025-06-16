

import 'package:garnetbook/data/models/analysis/analysis.dart';
import 'package:garnetbook/data/models/analysis/analysis_request.dart';
import 'package:garnetbook/data/models/analysis/family_member.dart';
import 'package:garnetbook/data/models/base/request_result_model.dart';
import 'package:garnetbook/domain/services/api_client/custom_dio.dart';
import 'package:get_it/get_it.dart';

class AnalysisService{
  final analysisClient = GetIt.I.get<ApiClientProvider>().analysisClient;

  Future<RequestResultModel<HeaderResponse?>> addNewAnalysis(CreateAnalysisData request) async {
    try{
      final response = await analysisClient.addNewAnalysis(request);

      return RequestResultModel(result: true);
    } catch(error){
      return RequestResultModel(result: false);
    }
  }

  Future<RequestResultModel<ClientTestDto?>> getAnalysisById(int id) async {
    try{
      final response = await analysisClient.getAnalysisById(id);

      return RequestResultModel(result: true, value: response);
    } catch(error){
      return RequestResultModel(result: false);
    }
  }

  Future<RequestResultModel<List<ClientTestShort>?>> getClientAnalysis(int id) async {
    try{
      final response = await analysisClient.getClientAnalysis(id);

      return RequestResultModel(result: true, value: response);
    } catch(error){
      return RequestResultModel(result: false);
    }
  }

  //family member
  Future<RequestResultModel<List<FamilyProfile>?>> getClientFamilyMember(int id) async {
    try{
      final response = await analysisClient.getClientFamilyMember(id);

      return RequestResultModel(result: true, value: response);
    } catch(error){
      return RequestResultModel(result: false);
    }
  }

  Future<RequestResultModel<List<ClientTestShort>?>> getOneFamilyMember(int id) async {
    try{
      final response = await analysisClient.getOneFamilyMember(id);

      return RequestResultModel(result: true, value: response);
    } catch(error){
      return RequestResultModel(result: false);
    }
  }

  Future<RequestResultModel<HeaderResponse?>> createFamilyProfile(FamilyProfile request) async {
    try{
      final response = await analysisClient.createFamilyProfile(request);

      return RequestResultModel(result: true, value: response);
    } catch(error){
      return RequestResultModel(result: false);
    }
  }

  Future<RequestResultModel<HeaderResponse?>> updateFamilyProfile(FamilyProfile request) async {
    try{
      final response = await analysisClient.updateFamilyProfile(request);

      return RequestResultModel(result: true, value: response);
    } catch(error){
      return RequestResultModel(result: false);
    }
  }
}