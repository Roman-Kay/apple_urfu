import 'package:garnetbook/data/models/auth/client_expert_auth.dart';
import 'package:garnetbook/data/models/auth/create_user.dart';
import 'package:garnetbook/data/models/auth/login_request.dart';
import 'package:garnetbook/data/models/auth/login_social.dart';
import 'package:garnetbook/data/models/auth/notification_model.dart';
import 'package:garnetbook/data/models/auth/recovery_password.dart';
import 'package:garnetbook/data/models/auth/sms_model.dart';
import 'package:garnetbook/data/models/base/base_response.dart';
import 'package:garnetbook/data/models/client/activity/activity_request.dart';
import 'package:garnetbook/data/models/client/activity/activity_response.dart';
import 'package:garnetbook/data/models/client/additives/additives_model.dart';
import 'package:garnetbook/data/models/client/additives/additives_request.dart';
import 'package:garnetbook/data/models/client/additives/additives_slot_model.dart';
import 'package:garnetbook/data/models/client/additives/protocols_model.dart';
import 'package:garnetbook/data/models/client/calendar/calendar_event_model.dart';
import 'package:garnetbook/data/models/client/calendar/calendar_request_model.dart';
import 'package:garnetbook/data/models/client/calendar/calendar_view_model.dart';
import 'package:garnetbook/data/models/client/claims/claims_model.dart';
import 'package:garnetbook/data/models/client/food_diary/diets_model.dart';
import 'package:garnetbook/data/models/client/food_diary/diets_request.dart';
import 'package:garnetbook/data/models/client/food_diary/food_create_model.dart';
import 'package:garnetbook/data/models/client/food_diary/food_diary_model.dart';
import 'package:garnetbook/data/models/client/library/library_categories_model.dart';
import 'package:garnetbook/data/models/client/library/library_favorites_model.dart';
import 'package:garnetbook/data/models/client/library/library_model.dart';
import 'package:garnetbook/data/models/client/profile/client_profile_model.dart';
import 'package:garnetbook/data/models/client/profile/client_profile_update_model.dart';
import 'package:garnetbook/data/models/client/recipes/recipes_favorites.dart';
import 'package:garnetbook/data/models/client/recipes/recipes_request.dart';
import 'package:garnetbook/data/models/client/recipes/recipes_response.dart';
import 'package:garnetbook/data/models/client/recommendation/platform_recommendation.dart';
import 'package:garnetbook/data/models/client/recommendation/recommendation_models.dart';
import 'package:garnetbook/data/models/client/recommendation/update_recommendation_models.dart';
import 'package:garnetbook/data/models/client/sensors/activated_sensors.dart';
import 'package:garnetbook/data/models/client/sensors/sensors_model.dart';
import 'package:garnetbook/data/models/client/sensors/sensors_request.dart';
import 'package:garnetbook/data/models/client/target/create_target_model.dart';
import 'package:garnetbook/data/models/client/target/target_view_model.dart';
import 'package:garnetbook/data/models/client/trackers/slot_view.dart';
import 'package:garnetbook/data/models/client/trackers/tracker_request.dart';
import 'package:garnetbook/data/models/client/trackers/tracker_response.dart';
import 'package:garnetbook/data/models/client/water_diary/water_diary_model.dart';
import 'package:garnetbook/data/models/client/water_diary/water_update_model.dart';
import 'package:garnetbook/data/models/client/woman_calendar/woman_calendar_request.dart';
import 'package:garnetbook/data/models/client/woman_calendar/woman_calendar_response.dart';
import 'package:garnetbook/data/models/client/woman_calendar/woman_calendar_view.dart';
import 'package:garnetbook/data/models/expert/appointment/appointment_model.dart';
import 'package:garnetbook/data/models/expert/appointment/create_appointment.dart';
import 'package:garnetbook/data/models/expert/card_info/card_info.dart';
import 'package:garnetbook/data/models/expert/card_info/food_diary.dart';
import 'package:garnetbook/data/models/expert/card_info/water_diary.dart';
import 'package:garnetbook/data/models/expert/client_claims/claims_model.dart';
import 'package:garnetbook/data/models/expert/client_claims/client_claim_operation.dart';
import 'package:garnetbook/data/models/expert/list/expert_data.dart';
import 'package:garnetbook/data/models/expert/list/expert_list.dart';
import 'package:garnetbook/data/models/expert/my_clients/clients_model.dart';
import 'package:garnetbook/data/models/expert/profile/achieves_model.dart';
import 'package:garnetbook/data/models/expert/profile/education_model.dart';
import 'package:garnetbook/data/models/expert/profile/experience_model.dart';
import 'package:garnetbook/data/models/expert/profile/expert_profile.dart';
import 'package:garnetbook/data/models/expert/profile/profile_model.dart';
import 'package:garnetbook/data/models/expert/recommendation/recommendation_model.dart';
import 'package:garnetbook/data/models/expert/tariffs/tarrifs_model.dart';
import 'package:garnetbook/data/models/others/file_view.dart';
import 'package:garnetbook/data/models/survey/balance_wheel/balance_wheel.dart';
import 'package:garnetbook/data/models/survey/questionnaire/questionnaire_request.dart';
import 'package:garnetbook/data/models/survey/questionnaire/questionnaire_response.dart';
import 'package:garnetbook/data/models/user/user_response.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart' hide Headers;

part 'client.g.dart';

@RestApi()
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  // auth
  @POST("ll/user/login/password")
  Future<UserResponse> loginByPassword(@Body() LoginPasswordRequest loginPasswordRequest);

  @POST("ll/user/login/social")
  Future<UserResponse> loginBySocial(@Body() LoginSocialRequest request);

  @POST("ll/user/login/social")
  Future<UserResponse> registerBySocial(@Body() RegisterSocialRequest request);

  @POST("ll/user/recovery/password")
  Future<UserResponse> changePassword(@Body() RecoveryPasswordRequest request);

  @GET("ll/aero/sms/confirm")
  Future<SMSSendResponse> getSms(@Query("phone") String phone);

  @GET("ll/aero/sms/status/{idSms}")
  Future<SMSStatusResponse> getSmsStatus(@Path("idSms") int idSms);

  @GET("ll/user/info/{userId}")
  Future<UserResponse> getUserInformation(@Path("userId") int id);

  @GET("ll/user/change/password/{newPassword}")
  Future<UserResponse> changeUserPassword(@Path("newPassword") String newPassword);

  @GET("ll/user/check/token/{userId}")
  Future<BaseResponse> checkTokenAlive(@Path("userId") int userId);

  @GET("ll/user/find/user/{numberPhone}")
  Future<BaseResponse> findUserByPhone(@Path("numberPhone") String phone);

  @POST("ll/user/create")
  Future<BaseResponse> createNewUser(@Body() UserCreateRequest request);

  @POST("ll/user/update")
  Future<BaseResponse> updateUser(@Body() UserUpdateRequest request);

  @GET("ll/aero/sms/reg/confirm")
  Future<SMSSendResponse> sendSmsRegistration(@Query("phone") String phone);

  @POST("ll/expert/clients/add")
  Future<BaseResponse> createClientByExpert(@Body() AddClientExpertRequest request);


  //notificaitons
  @POST("ll/user/note/subscribe")
  Future<BaseResponse> notificationControl(@Body() NotificationRequest request);

  @GET("/ll/user/note/subscribe/active")
  Future<List<NotificationModelType>> getUserNotificationList();

  @GET("ll/referenceBooks/notification_type")
  Future<List<NotificationTypeView>> getNotificationReferenceList();


  // profile client
  @GET('ll/client/profile/me')
  Future<ClientProfileResponse> getClientProfile();

  @POST('ll/client/profile/update')
  Future<BaseResponse> updateClientProfile(@Body() CreateClientRequest request);

  @POST("ll/client/claims")
  Future<ClientClaimResponse> getClaims(@Body() ClientClaimRequest request);

  @POST("ll/client/claims/create")
  Future<ClientClaimResponse> createClientClaims(@Body() CreateClientClaimRequest request);


  //goals
  @GET("ll/client/target/get")
  Future<List<ClientTargetsView>> getClientTarget();

  @PUT("ll/client/target/update")
  Future<ClientTargetsView> addTarget(@Body() ClientTargetsUpdateRequest request);


  //food diary
  @POST("ll/client/food/get")
  Future<ClientFoodResponse> getFoodDiaryForToday(@Body() ClientFoodRequest request);

  @PUT("ll/client/food/update")
  Future<ClientFoodView> addFoodDiaryForToday(@Body() ClientFoodCreateRequest request);

  @DELETE("ll/client/food/delete/{clientFoodId}")
  Future<BaseResponse> deleteFoodDiary(@Path("clientFoodId") int clientFoodId);

  @POST("ll/client/food/update/comment")
  Future<BaseResponse> writeCommentToFoodDiaryExpert(@Body() FoodEditCommentRequest request);


  // water diary
  @POST("ll/client/water/get")
  Future<List<ClientWaterView>?> getWaterDiary(@Body() ClientWaterRequest request);

  @POST("ll/client/water/update")
  Future<ClientWaterView> addWaterToDiary(@Body() ClientWaterUpdateRequest request);

  @DELETE("ll/client/water/delete/{id}")
  Future<BaseResponse> deleteWaterDiary(@Path("id") int id);


  //diets
  @GET("ll/diets/by-id/{id}")
  Future<Diets> getOneDiet(@Path("id") int id);

  @GET("ll/diets/client/list-by-client")
  Future<List<Diets>> getListOfDiets();

  @POST("ll/diets/create")
  Future<BaseResponse> createClientDiet(@Body() DietsCreate request);

  @GET("ll/diets/expert/list-by-client/{clientId}")
  Future<List<Diets>> getClientDiet(@Path("clientId") int id);




  // balance wheel
  @POST("ll/balance-wheel/create")
  Future<BaseResponse> addBalanceWheelCategory(@Body() BalanceWheelsCreateRequest request);

  @POST("ll/balance-wheel/filter")
  Future<List<BalanceWheel>> getBalanceWheel(@Body() BalanceWheelsRequest request);


  //recommendation
  @GET("ll/client/recommendation")
  Future<ClientRecommendationsResponse> getClientRecommendation();

  @PUT("ll/client/recommendation")
  Future<UpdateClientRecommendationsResponse> createClientRecommendation(@Body() UpdateClientRecommendationsRequest request);

  @GET("ll/client/recommendation/{id}")
  Future<ClientRecommendationView> getOneClientRecommendation(@Path("id") int id);


  //calendar
  @GET("ll/event")
  Future<EventResponse> getCalendarEvent();

  @PUT('ll/event')
  Future<EventResponse> putCalendarEvent(@Body() EventRequest request);

  @GET("ll/event/{day}")
  Future<EventsAndIndicatorsForDayResponse> getCalendarEventForNDay(@Path("day") String day);

  @DELETE('ll/event/{eventId}')
  Future<BaseResponse> deleteCalendarEvent(@Path('eventId') int eventId);


  //additives
  @POST("ll/medicine/clientAdditives")
  Future<CreateClientAdditivesResponse> createAdditives(@Body() ClientAdditivesRequest request);

  @DELETE("ll/medicine/clientAdditives/{id}")
  Future<BaseResponse> deleteAdditives(@Path("id") int id);

  @POST("ll/medicine/getAdditives")
  Future<Map<String, List<ClientAdditivesView>>> getQueueAdditives(@Body() ClientListAdditivesRequest request);

  @GET("ll/medicine/getAdditive/{id}")
  Future<ClientAdditivesView> getOneAdditives(@Path("id") int id);

  @POST("ll/medicine/rejectAdditives")
  Future<ClientAdditivesResponse> rejectFromAdditives(@Body() ClientRejectAdditivesRequest request);

  @POST("ll/medicine/slotAdditives")
  Future<ClientAdditivesResponse> getSlotAdditives(@Body() ClientSlotAdditivesRequest request);

  @POST("ll/medicine/clientAdditives/slot")
  Future<AdditiveSlotsView> checkAdditiveSlot(@Body() ClientAdditivesSlotCheckRequest request);

  @GET("ll/medicine/clientAdditives/slot/acceptToday")
  Future<List<AdditiveSlotsView>> getAdditivesForToday();

  @GET("ll/medicine/clientAdditives/slot/acceptDay/{date}")
  Future<List<AdditiveSlotsView>> getAdditivesForDay(@Path("date") String date);

  @POST("ll/medicine/clientAdditives/change/status")
  Future<BaseResponse> changeAdditivesStatus(@Body() ClientChangeStatusAdditivesRequest request);

  @GET("ll/medicine/clientAdditives/slot/{clientAdditiveId}")
  Future<List<AdditiveSlotsView>> getAdditiveSlots(@Path("clientAdditiveId") int clientAdditiveId);

  @PUT("ll/medicine/clientAdditives/protocol/create")
  Future<BaseResponse> createClientProtocol(@Body() ProtocolCreate request);


  //expert list
  @GET("ll/client/expert/list/{page}/{limit}")
  Future<ExpertShortCardResponse> getExpertList(@Path("page") int page, @Path("limit") int limit);

  @GET("ll/client/expert/list/my")
  Future<ExpertShortCardResponse> getMyExpertList();

  @GET("ll/client/expert/full/{expertId}")
  Future<ExpertFullCardResponse> getExpertData(@Path("expertId") int expertId);


  //woman calendar
  @PUT("ll/women/period/create")
  Future<List<ClientPeriodView>> createWomanCalendarForPeriod(@Query("dateStart") String dateStart, @Query("dateEnd") String dateEnd);

  @PUT("ll/women/period/create/{date}")
  Future<ClientPeriodView> createWomanCalendar(@Path("date") String date);

  @GET("ll/women/period/get/{monthNumber}")
  Future<ResponseWomenCalendarResponse> getWomanCalendarForPeriod(@Path("monthNumber") int monthNumber);

  @GET("ll/women/period/getDay")
  Future<ClientPeriodView> getWomanCalendar(@Query("date") String date);

  @POST("/ll/women/period/update")
  Future<ClientPeriodView> updateWomanCalendar(@Body() WomanCalendarRequest request);


  //recipes
  @GET("ll/recipes")
  Future<RecipesResponse> getAllRecipes();

  @PUT("ll/recipes")
  Future<RecipesResponse> addRecipes(@Body() RecipesRequest request);

  @GET("ll/recipes/day")
  Future<RecipesResponse> getRecipesForDay();

  @GET("ll/recipes/favorites")
  Future<RecipeFavoritesResponse> getFavoritesRecipes();

  @PUT("ll/recipes/favorites")
  Future<RecipeFavoritesResponse> addFavoritesRecipes(@Body() RecipeFavoritesRequest request);

  @DELETE("ll/recipes/favorites/{recipeFavoritesId}")
  Future<BaseResponse> deleteFavoritesRecipes(@Path("recipeFavoritesId") int recipeId);


  //sensors
  @GET("ll/client/sensor/activated")
  Future<ClientActivatedSensorsResponse> getActivatedSensors();

  @PUT("ll/client/sensor/activated")
  Future<ClientActivatedSensorsResponse> changeActivatedSensors(@Body() UpdateClientActivatedSensorsRequest request);

  @GET("ll/client/sensor/get")
  Future<ClientSensorsResponse> getClientSensors();

  @POST("ll/client/sensor/update")
  Future<ClientSensorsResponse> createSensorMeasurement(@Body() CreateClientSensorsRequest request);

  @POST("ll/client/sensor/getDay")
  Future<ClientSensorsResponse> getSensorsForDay(@Body() ClientSensorDayRequest request);

  @POST("ll/client/sensor/getHours")
  Future<ClientSensorsResponse> getSensorsForHours(@Body() ClientSensorHoursRequest request);

  @PUT("ll/client/activity")
  Future<ClientActivityResponse> createActivityMeasurement(@Body() ClientActivityRequest request);

  @GET("ll/client/activity")
  Future<ClientActivityResponse> getActivity(@Body() PeriodDateRequest request);

  @GET("ll/client/activity/{clientId}")
  Future<ClientActivityResponse> getActivityForExpert(
      @Path("clientId") int id,
      @Body() PeriodDateRequest request
      );


  //trackers
  @GET("ll/client/tracker")
  Future<ClientTrackerResponse> getClientTracker();

  @PUT("ll/client/tracker")
  Future<ClientTrackerResponse> setClientTracker(@Body() ClientTrackerRequest request);

  @DELETE("ll/client/tracker/{idTracker}")
  Future<BaseResponse> deleteClientTracker(@Path("idTracker") int id);

  @GET("ll/client/tracker/slot/{slotId}/{check}")
  Future<ClientTrackerSlotsView> getTrackerSlots(@Path("slotId") int slotId, @Path("check") bool check);



  //library
  @PUT("ll/library")
  Future<LibraryResponse> addArticle();

  @GET("ll/library/{favorites}")
  Future<LibraryResponse> getArticles(@Path('favorites') bool favorites);

  @DELETE("ll/library/{libId}")
  Future<BaseResponse> deleteArticle(@Path('libId') int libId);

  @GET("ll/library/category/{categoryId}")
  Future<LibraryResponse> getArticleByCategory(@Path("categoryId") int categoryId);

  @GET("ll/library/categories")
  Future<LibraryCategoriesResponse> getCategoriesLibrary();

  @PUT("ll/library/categories")
  Future<LibraryCategoriesResponse> addCategoriesLibrary(@Body() LibraryCategoriesRequest request);

  @DELETE("ll/library/categories/{categoryId}")
  Future<BaseResponse> deleteCategoriesLibrary(@Path('categoryId') int categoryId);

  @PUT("ll/library/favorites")
  Future<LibraryFavoritesResponse> addFavoritesArticle(@Body() LibraryFavoritesRequest request);

  @DELETE("ll/library/favorites/{favoriteId}")
  Future<BaseResponse> deleteFavoritesArticle(@Path('favoriteId') int favoriteId);


  //survey
  @GET("ll/questionnaire/client")
  Future<List<QuestionnaireShort>> getListOfClientsSurvey();

  @GET("ll/questionnaire/client/full/{id}")
  Future<Questionnaire> getSurveyData(@Path("id") int id);

  @PUT("ll/questionnaire/create")
  Future<Questionnaire> setSurveyToClient(@Body() QuestionnaireCreateRequest request);

  @GET("ll/questionnaire/expert/{clientId}")
  Future<List<QuestionnaireShort>> clientCardListOfSurvey(@Path("clientId") int clientId);

  @GET("ll/questionnaire/expert/report/{id}")
  Future<FileView> getSurveyReport(@Path("id") int id);

  @PUT("ll/questionnaire/update")
  Future<BaseResponse> setSurveyResult(@Body() QuestionnaireUpdateRequest request);

  @GET("ll/questionnaire/recommendations/map")
  Future<Map<String, List<Recommendation2>>> getPlatformRecommendations();


  // expert
  @GET("ll/expert/profile/me")
  Future<ExpertProfileResponse> getExpertProfile();

  @POST("ll/expert/profile/create")
  Future<ExpertProfileResponse> createProfileExpert(@Body() ExpertProfileCreateRequest request);

  @POST("ll/expert/tariff/create")
  Future<ExpertTariffResponse> addExpertsTariff(@Body() ExpertTariffCreateRequest request);

  @GET("ll/expert/tariff/get/{expertId}")
  Future<ExpertTariffResponse> getExpertTariff(@Path("expertId") int id);

  @DELETE("ll/expert/tariff/{id}")
  Future<BaseResponse> deleteExpertTariff(@Path("id") int id);

  @GET("ll/expert/education/")
  Future<ExpertEducationResponse> getExpertEducation();

  @PUT("ll/expert/education/")
  Future<ExpertEducationResponse> addExpertEducation(@Body() ExpertEducationRequest request);

  @DELETE("ll/expert/education/{id}")
  Future<BaseResponse> deleteExpertEducation(@Path("id") int id);

  @GET("ll/expert/experience/")
  Future<ExpertExperienceResponse> getExpertExperience();

  @PUT("ll/expert/experience/")
  Future<ExpertExperienceResponse> addExpertExperience(@Body() ExpertExperienceRequest request);

  @DELETE("ll/expert/experience/{id}")
  Future<BaseResponse> deleteExpertExperience(@Path("id") int id);

  @GET("ll/expert/achieves/")
  Future<ExpertAchievesResponse> getExpertAchieves();

  @PUT("ll/expert/achieves/")
  Future<ExpertAchievesResponse> addExpertAchieves(@Body() ExpertAchievesRequest request);

  @DELETE("ll/expert/achieves/{id}")
  Future<BaseResponse> deleteExpertAchieves(@Path("id") int id);

  @GET("ll/expert/recommendations/")
  Future<ExpertRecommendationsResponse> getExpertRecommendations();

  @PUT("ll/expert/recommendations/")
  Future<ExpertRecommendationsResponse> addExpertRecommendations(@Body() ExpertRecommendationsRequest request);

  @GET("ll/expert/clients")
  Future<ExpertClientsResponse> getListOfClients();

  @POST("ll/expert/clients/claims")
  Future<ClientClaimResponse> getListOfClaims(@Body() ClaimForExpertRequest request);

  @POST("ll/expert/clients/claims/operation")
  Future<BaseResponse> setClientClaimsOperation(@Body() ClaimOperationRequest request);

  @POST("ll/client/claims/edit/anamnesis")
  Future<CardClientInfoResponse> setClientAnamnesis(@Body() EditFieldRequest request);

  @POST("ll/client/claims/edit/diagnosis")
  Future<CardClientInfoResponse> setClientDiagnosis(@Body() EditFieldRequest request);

  @POST("ll/client/claims/edit/reason")
  Future<CardClientInfoResponse> setClientReason(@Body() EditFieldRequest request);


  // prescription - appointment
  @POST("ll/expert/clients/prescription/create")
  Future<ClientAppointmentsResponse> addExpertAppointment(@Body() CreateClientAppointmentsRequest request);

  @POST("ll/expert/clients/prescription/get")
  Future<ClientAppointmentsResponse> getExpertAppointment(@Body() ClientAppointmentsRequest request);

  @DELETE("ll/expert/clients/prescription/delete/{id}")
  Future<BaseResponse> deleteExpertAppointment(@Path("id") int id);


  //my client
  @GET("ll/expert/clients/card/info/{clientId}")
  Future<CardClientInfoResponse> getClientCardInfo(@Path("clientId") int id);

  @POST("ll/expert/clients/card/foodInfo")
  Future<ExpertClientFoodInfoResponse> getClientCardInfoFoodDiary(@Body() ClientFoodRequestExpert request);

  @POST("ll/expert/clients/card/waterInfo")
  Future<ExpertClientWaterInfoResponse> getClientCardInfoWaterDiary(@Body() ClientFoodRequestExpert request);

  @GET("ll/expert/clients/card/additives/{clientId}")
  Future<ClientAdditivesResponse> getClientCardAdditives(@Path("clientId") int id);

  @GET("ll/expert/clients/card/recommendation/{clientId}")
  Future<ClientRecommendationsResponse> getClientCardRecommendation(@Path("clientId") int id);


  //additives
  @GET("ll/medicine/clientAdditives/client/all")
  Future<ClientAdditivesResponse> getAllClientAdditives();

  @GET("ll/medicine/clientAdditives/expert/all")
  Future<ClientAdditivesResponse> getAllClientAdditivesByExpert();

  @GET("ll/medicine/clientAdditives/expert/{clientId}")
  Future<ClientAdditivesResponse> getClientAdditivesByExpert(@Path("clientId") int id);


  //clients trackers
  @GET("ll/expert/tracker/{clientId}")
  Future<ClientTrackerResponse> getClientTrackerFromExpert(@Path("clientId") int id);

  @PUT("ll/expert/tracker")
  Future<ClientTrackerResponse> setClientTrackerFromExpert(@Body() ClientTrackerRequest request);

  @DELETE("ll/expert/tracker/{idTracker}")
  Future<BaseResponse> deleteClientTrackerFromExpert(@Path("idTracker") int id);
}
