
import 'package:dio/dio.dart';
import 'package:garnetbook/data/models/analysis/analysis.dart';
import 'package:garnetbook/data/models/analysis/analysis_request.dart';
import 'package:garnetbook/data/models/analysis/family_member.dart';
import 'package:retrofit/retrofit.dart';

part "analysis.g.dart";

@RestApi()
abstract class RestAnalysis {
  factory RestAnalysis(Dio dio, {String baseUrl}) = _RestAnalysis;

  @PUT("api/v1/analysis/add-new")
  Future<HeaderResponse> addNewAnalysis(@Body() CreateAnalysisData request);

  @GET("api/v1/analysis/by-analysis-id")
  Future<ClientTestDto> getAnalysisById(@Query("analysisId") int analysisId);

  @GET("api/v1/analysis/by-client-id")
  Future<List<ClientTestShort>> getClientAnalysis(@Query("clientId") int clientId);

  // family profile

  @GET("api/v1/family-profile/by-client")
  Future<List<FamilyProfile>> getClientFamilyMember(@Query("clientId") int clientId);

  @GET("api/v1/analysis/by-family-id")
  Future<List<ClientTestShort>> getOneFamilyMember(@Query("profileId") int id);

  @POST("api/v1/family-profile/create")
  Future<HeaderResponse> createFamilyProfile(@Body() FamilyProfile familyProfile);

  @POST("api/v1/family-profile/update")
  Future<HeaderResponse> updateFamilyProfile(@Body() FamilyProfile familyProfile);

}