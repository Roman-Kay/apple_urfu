
import 'package:dio/dio.dart';
import 'package:garnetbook/data/models/client/recommendation/recommendation_data.dart';
import 'package:garnetbook/data/models/survey/physical_survey/physical_survey_model.dart';
import 'package:garnetbook/data/models/survey/physical_survey/physical_survey_request.dart';
import 'package:garnetbook/data/models/survey/q_type_view/q_type_view.dart';
import 'package:garnetbook/data/models/survey/q_type_view/subsribe_view.dart';
import 'package:garnetbook/data/models/survey/quiz_model.dart';
import 'package:garnetbook/data/models/survey/quiz_request.dart';
import 'package:garnetbook/data/models/survey/quiz_result.dart';
import 'package:garnetbook/data/models/survey/selection_model.dart';
import 'package:retrofit/retrofit.dart';

part "survey_client.g.dart";

@RestApi()
abstract class RestSurveyClient{
  factory RestSurveyClient(Dio dio, {String baseUrl}) = _RestSurveyClient;

  @GET("quizzes")
  Future<List<AllQuizModel>> getAllSurvey();

  @GET("quizzes/{id}")
  Future<QuizItem> getSurvey(@Path("id") int id, @Query("gender") String? gender);

  @POST("quizzes/{id}")
  Future<List<Result>> saveSurveyAnswer(@Path("id") int id, @Body() QuizRequest request);


  //physical survey
  @GET("fquizzes/{id}")
  Future<FQuizItem> getPhysicalSurvey(@Path("id") int id);

  @POST("fquizzes/{id}")
  Future<List<FQuestion>> savePhysicalSurveyAnswer(@Path("id") int id, @Body() FQuizRequest request);


  //selections
  @GET("selections")
  Future<List<SelectionListView>> getListOfSelections();

  @GET("selections/{id}")
  Future<List<SelectionView>> getOneSelectionList(@Path("id") int id);


  //subscribe
  @GET("qtypes")
  Future<List<QTypeView>> getQTypes();

  @GET("subscribe/{step_id}")
  Future<SubscribeStep> getSubscribeSurvey(@Path("step_id") int id, @Query("user_id") int userId);

  @POST("subscribe/{step_id}")
  Future<SubscribeResultView> saveSubscribeResult(@Path("step_id") int id, @Body() SubscribeResult result);


  //recommendations
  @GET("recommendations/{id}")
  Future<RecommendationData> getRecommendations(@Path("id") int id);


  //articles
  @GET("articles/{id}")
  Future<ArticleItem> getArticles(@Path("id") int id);


}
