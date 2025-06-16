import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter/material.dart';
import 'package:garnetbook/domain/config/environment.dart';

class ServiceAnalytics {
  Future initTracker() async {
    AppMetrica.activate(AppMetricaConfig(Environment().config.appMetricaApiKey, logs: true));
  }

  setEvent(String event) async {
    try {
      AppMetrica.reportEvent(event);

    } catch (error) {
      debugPrint("APPMETRICA ERROR $error");
    }
  }

  Future setUserProperties(String userId) async {
    AppMetrica.setUserProfileID(userId);
  }

}

class AnalyticsEvents {

  static const androidUser = "androidUser";
  static const iosUser = "iosUser";

  //Client
  static const String loginClient = "loginClient";  //
  static const String loginClientGoogle = "loginClientGoogle"; //
  static const String loginClientVk = "loginClientVk"; //
  static const String registerClient = "registerClient";  //
  static const String registerClientGoogle = "registerClientGoogle"; //
  static const String registerClientVk = "registerClientVk";

  static const String addNewAdditiveClient = "addNewAdditiveClient"; //
  static const String changeAdditiveClient = "changeAdditiveClient"; //
  static const String rejectExpertAdditiveClient = "rejectExpertAdditiveClient"; //

  static const String addNewAnalysisClient = "addNewAnalysisClient";

  static const String addNewTrackerClient = "addNewTrackerClient"; //
  static const String changeTrackerClient = "changeTrackerClient"; //
  static const String deleteTrackerClient = "deleteTrackerClient"; //
  static const String finishTrackerClient = "finishTrackerClient"; //

  static const String signUpForExpertConsultationClient = "signUpForExpertConsultationClient"; //

  static const String openLoseWeightTargetClient = "openLoseWeightTargetClient";
  static const String openGainWeightTargetClient = "openGainWeightTargetClient";
  static const String openKeepWeightTargetClient = "openKeepWeightTargetClient";
  static const String openRaiseEnergyTargetClient = "openRaiseEnergyTargetClient";
  static const String openStomachHealthTargetClient = "openStomachHealthTargetClient";
  static const String openAntiAgeTargetClient = "openAntiAgeTargetClient";
  static const String openMentalHealthTargetClient = "openMentalHealthTargetClient";
  static const String openWomanHealthTargetClient = "openWomanHealthTargetClient";
  static const String openManHealthTargetClient = "openManHealthTargetClient";

  static const String passSurveyClient = "passSurveyClient"; //
  static const String passExpertSurveyClient = "passExpertSurveyClient"; //
  static const String passExpertHealthTreeSurveyClient = "passExpertHealthTreeSurveyClient"; //

  static const String addNewEventClient = "addNewEventClient"; //
  static const String changeEventClient = "changeEventClient"; //
  static const String deleteEventClient = "deleteEventClient"; //

  static const String addWaterClient = "addWaterClient"; //
  static const String changeWaterGoalClient = "changeWaterGoalClient"; //

  static const String addWeightClient = "addWeightClient"; //
  static const String addSleepClient = "addSleepClient"; //
  static const String addPressureClient = "addPressureClient"; //
  static const String addBloodSugarClient = "addBloodSugarClient"; //
  static const String addBloodOxygenClient = "addBloodOxygenClient"; //
  static const String addWorkoutActivityClient = "addWorkoutActivityClient"; //
  static const String addStepClient = "addStepClient"; //

  static const String addFoodDiaryClient = "addFoodDiaryClient"; //
  static const String changeFoodDiaryClient = "changeFoodDiaryClient"; //
  static const String deleteFoodDiaryClient = "deleteFoodDiaryClient"; //

  static const String openReceiptsClient = "openReceiptsClient"; //
  static const String makeFavoriteReceiptClient = "makeFavoriteReceiptClient"; //
  static const String deleteFavoriteReceiptClient = "deleteFavoriteReceiptClient"; //

  static const String changeProfileClient = "changeProfileClient"; //

  static const String changeSystemNotificationClient = "changeSystemNotificationClient"; //

  //Expert
  static const String loginExpert = "loginExpert"; //
  static const String loginExpertGoogle = "loginExpertGoogle"; //
  static const String loginExpertVk = "loginExpertVk"; //
  static const String registerExpert = "registerExpert"; //
  static const String registerExpertGoogle = "registerExpertGoogle"; //
  static const String registerExpertVk = "registerExpertVk";

  static const String addNewEventExpert = "addNewEventExpert"; //
  static const String changeEventExpert = "changeEventExpert"; //
  static const String deleteEventExpert = "deleteEventExpert"; //

  static const String acceptClientClaimExpert = "acceptClientClaimExpert"; //
  static const String rejectClientClaimExpert = "rejectClientClaimExpert"; //

  static const writeClientAnamnesExpert = "writeClientAnamnesExpert"; //
  static const writeClientDiagnosExpert = "writeClientDiagnosExpert"; //
  static const writeClientComplaintsExpert = "writeClientComplaintsExpert"; //

  static const createNewClient = "createNewClient";

  static const appointClientSurveyExpert = "appointClientSurveyExpert"; //
  static const appointClientHealthTreeSurveyExpert = "appointClientHealthTreeSurveyExpert"; //

  static const addNewClientRecommendationExpert = "addNewClientRecommendationExpert"; //
  static const changeClientRecommendationExpert = "changeClientRecommendationExpert"; //

  static const openClientFoodDiaryExpert = "openClientFoodDiaryExpert"; //
  static const openClientWaterExpert = "openClientWaterExpert"; //
  static const openClientSensorsExpert = "openClientSensorsExpert"; //

  static const String addNewTrackerExpert = "addNewTrackerExpert"; //
  static const String changeTrackerExpert = "changeTrackerExpert"; //

  static const String addNewAdditiveExpert = "addNewAdditiveExpert"; //
  static const String addNewProtocolExpert = "addNewProtocolExpert"; //
  static const String changeAdditiveExpert = "changeAdditiveExpert"; //
  static const String rejectAdditiveExpert = "rejectAdditiveExpert"; //
  static const String shareAdditiveExpert = "shareAdditiveExpert"; //

  static const String calculateWaterExpert = "calculateWaterExpert"; //
  static const String calculateIMTExpert = "calculateIMTExpert"; //

  static const changeProfileExpert = "changeProfileExpert"; //
  static const changeLocationExpert = "changeLocationExpert"; //
  static const changeSpecialisationExpert = "changeSpecialisationExpert";
  static const changeCategoryExpert = "changeCategoryExpert"; //
  static const changePositionExpert = "changePositionExpert"; //
  static const changeTypeReceptionExpert = "changeTypeReceptionExpert"; // тип приема //
  static const changeExperienceYearsExpert = "changeExperienceYearsExpert"; // стаж //

  static const addTariffsExpert = "addTariffsExpert"; //
  static const changeTariffsExpert = "changeTariffsExpert"; //
  static const deleteTariffsExpert = "deleteTariffsExpert"; //

  static const addEducationExpert = "addEducationExpert"; //
  static const changeEducationExpert = "changeEducationExpert"; //
  static const deleteEducationExpert = "deleteEducationExpert"; //
  static const addFileEducationExpert = "addFileEducationExpert"; //
  static const addImageEducationExpert = "addImageEducationExpert"; //
  static const deleteFileEducationExpert = "deleteFileEducationExpert"; //
  static const deleteImageEducationExpert = "deleteImageEducationExpert"; //

  static const addAchievementsExpert = "addAchievementsExpert"; //
  static const changeAchievementsExpert = "changeAchievementsExpert"; //
  static const deleteAchievementsExpert = "deleteAchievementsExpert"; //
  static const addFileAchievementsExpert = "addFileAchievementsExpert"; //
  static const addImageAchievementsExpert = "addImageAchievementsExpert"; //
  static const deleteFileAchievementsExpert = "deleteFileAchievementsExpert"; //
  static const deleteImageAchievementsExpert = "deleteImageAchievementsExpert"; //

  static const addExperienceExpert = "addExperienceExpert"; //
  static const changeExperienceExpert = "changeExperienceExpert"; //
  static const deleteExperienceExpert = "deleteExperienceExpert"; //

  static const changeSystemNotificationExpert = "changeSystemNotificationExpert"; //
}

// GetIt.I
//     .get<ServiceAnalytics>()
//     .setEvent(AnalyticsEvents.mainLookArticle);


