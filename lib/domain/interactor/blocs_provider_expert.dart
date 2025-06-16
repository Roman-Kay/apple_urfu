import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garnetbook/bloc/client/additives/additive_data/additive_data_bloc.dart';
import 'package:garnetbook/bloc/client/additives/additive_queue/additive_queue_bloc.dart';
import 'package:garnetbook/bloc/client/additives/slot_additive/slot_additive_bloc.dart';
import 'package:garnetbook/bloc/client/analysis/analysis_full_bloc/analysis_full_bloc.dart';
import 'package:garnetbook/bloc/client/analysis/analysis_list_bloc/analysis_list_bloc.dart';
import 'package:garnetbook/bloc/client/analysis/client_family_list/client_family_list_bloc.dart';
import 'package:garnetbook/bloc/client/analysis/family_member/analysis_family_member_bloc.dart';
import 'package:garnetbook/bloc/client/calendar/calendar_cubit.dart';
import 'package:garnetbook/bloc/client/calendar/calendar_for_day/calendar_for_day_bloc.dart';
import 'package:garnetbook/bloc/client/diets/diets_full_data/diets_full_data_bloc.dart';
import 'package:garnetbook/bloc/client/diets/diets_list_bloc.dart';
import 'package:garnetbook/bloc/client/health/sleep/week_sleep/week_sleep_bloc.dart';
import 'package:garnetbook/bloc/client/health/steps/step_list/step_list_bloc.dart';
import 'package:garnetbook/bloc/client/health/workout/health_workout_bloc.dart';
import 'package:garnetbook/bloc/client/library/article/article_bloc.dart';
import 'package:garnetbook/bloc/client/library/categorises/categorises_cubit.dart';
import 'package:garnetbook/bloc/client/recipes/recipes_all/recipes_all_cubit.dart';
import 'package:garnetbook/bloc/client/recommendation/single_expert_recommendation_bloc/single_expert_recommendation_bloc.dart';
import 'package:garnetbook/bloc/client/version/version_cubit.dart';
import 'package:garnetbook/bloc/expert/calendar/expert_calendar_today_cubit.dart';
import 'package:garnetbook/bloc/expert/claims/claims_bloc.dart';
import 'package:garnetbook/bloc/expert/client_card/client_additives/client_additives_bloc.dart';
import 'package:garnetbook/bloc/expert/client_card/client_additives/client_additives_list_bloc/client_additives_list_bloc.dart';
import 'package:garnetbook/bloc/expert/client_card/client_food_diary/client_food_diary_bloc.dart';
import 'package:garnetbook/bloc/expert/client_card/client_food_diary_whole_data/client_food_diary_whole_data_bloc.dart';
import 'package:garnetbook/bloc/expert/client_card/client_personal_data/client_personal_data_bloc.dart';
import 'package:garnetbook/bloc/expert/client_card/client_recommendations/client_recommendation_bloc.dart';
import 'package:garnetbook/bloc/expert/client_card/client_sensors/all/all_sensors_bloc.dart';
import 'package:garnetbook/bloc/expert/client_card/client_sensors/blood_glucose/client_blood_glucose_bloc.dart';
import 'package:garnetbook/bloc/expert/client_card/client_sensors/blood_oxygen/client_blood_oxygen_bloc.dart';
import 'package:garnetbook/bloc/expert/client_card/client_sensors/pressure/client_pressure_bloc.dart';
import 'package:garnetbook/bloc/expert/client_card/client_sensors/pulse/client_pulse_bloc.dart';
import 'package:garnetbook/bloc/expert/client_card/client_sensors/sleep/client_sleep_bloc.dart';
import 'package:garnetbook/bloc/expert/client_card/client_sensors/steps/client_steps_bloc.dart';
import 'package:garnetbook/bloc/expert/client_card/client_sensors/water/client_sensors_water_bloc.dart';
import 'package:garnetbook/bloc/expert/client_card/client_sensors/weight/client_weight_bloc.dart';
import 'package:garnetbook/bloc/expert/client_card/client_survey/client_survey_bloc.dart';
import 'package:garnetbook/bloc/expert/client_card/client_survey/survey_data/survey_data_bloc.dart';
import 'package:garnetbook/bloc/expert/client_card/client_trackers/client_trackers_bloc.dart';
import 'package:garnetbook/bloc/expert/client_card/client_water_diary/client_water_diary_bloc.dart';
import 'package:garnetbook/bloc/expert/profile/achievement/achievement_bloc.dart';
import 'package:garnetbook/bloc/expert/profile/education/education_bloc.dart';
import 'package:garnetbook/bloc/expert/profile/experience/experience_bloc.dart';
import 'package:garnetbook/bloc/expert/profile/my_client/my_client_cubit.dart';
import 'package:garnetbook/bloc/expert/profile/profile/profile_cubit.dart';
import 'package:garnetbook/bloc/expert/profile/recommendation/recommendation_bloc.dart';
import 'package:garnetbook/bloc/expert/profile/tariffs/tariffs_bloc.dart';
import 'package:garnetbook/bloc/expert/selection/selection_list_cubit.dart';
import 'package:garnetbook/bloc/expert/selection/selection_single/selection_single_bloc.dart';
import 'package:garnetbook/bloc/message/chat/chat_bloc/chat_bloc.dart';
import 'package:garnetbook/bloc/message/chat/list_chat_cubit/list_chat_cubit.dart';
import 'package:garnetbook/bloc/message/push/push_cubit.dart';
import 'package:garnetbook/bloc/user/notification_list/notification_list_cubit.dart';
import 'package:garnetbook/bloc/user/user_data_cubit.dart';
import 'package:intl/intl.dart';
import 'package:provider/single_child_widget.dart';

class BlocsProvider {
  List<SingleChildWidget> providersExpert() {
    return [
      BlocProvider(create: (context) => ClaimsExpertBloc()),
      BlocProvider(create: (context) => UserDataCubit()),
      BlocProvider(create: (context) => AchievementsExpertBloc()),
      BlocProvider(create: (context) => EducationExpertBloc()),
      BlocProvider(create: (context) => ExperienceExpertBloc()),
      BlocProvider(create: (context) => MyClientCubit()..check()),
      BlocProvider(create: (context) => RecommendationExpertBloc()),
      BlocProvider(create: (context) => ProfileExpertCubit()),
      BlocProvider(create: (context) => TariffsExpertBloc()),
      BlocProvider(create: (context) => CalendarCubit()..check()),
      BlocProvider(create: (context) => CalendarForDayBloc()..add(CalendarForDayGetEvent(DateFormat("yyyy-MM-dd").format(DateTime.now())))),
      BlocProvider(create: (context) => ExpertCalendarTodayCubit()..check()),
      BlocProvider(create: (context) => ClientsCardFoodDiaryBloc()),
      BlocProvider(create: (context) => ClientCardPersonalDataBloc()),
      BlocProvider(create: (context) => ClientCardTrackersBloc()),
      BlocProvider(create: (context) => ClientsCardWaterDiaryBloc()),
      BlocProvider(create: (context) => ClientFoodDiaryWholeDataBloc()),
      BlocProvider(create: (context) => HealthWorkoutBloc()),
      BlocProvider(create: (context) => ClientBloodGlucoseBloc()),
      BlocProvider(create: (context) => ClientBloodOxygenBloc()),
      BlocProvider(create: (context) => ClientSleepBloc()),
      BlocProvider(create: (context) => ClientWeightBloc()),
      BlocProvider(create: (context) => ClientStepsBloc()),
      BlocProvider(create: (context) => LibraryCategorisesCubit()),
      BlocProvider(create: (context) => LibraryArticleBloc()),
      BlocProvider(create: (context) => ClientAdditivesBloc()),
      BlocProvider(create: (context) => ListChatCubit()..check()),
      BlocProvider(create: (context) => ChatBloc()),
      BlocProvider(create: (context) => AdditiveDataBloc()),
      BlocProvider(create: (context) => AdditiveQueueBloc()),
      BlocProvider(create: (context) => ClientCardRecommendationBloc()),
      BlocProvider(create: (context) => ClientPressureBloc()),
      BlocProvider(create: (context) => ClientPulseBloc()),
      BlocProvider(create: (context) => ClientCardSurveyBloc()),
      BlocProvider(create: (context) => SurveyDataBloc()),
      BlocProvider(create: (context) => WeekSleepBloc()),
      BlocProvider(create: (context) => StepListBloc()),
      BlocProvider(create: (context) => PushCubit()..check()),
      BlocProvider(create: (context) => SelectionListCubit()),
      BlocProvider(create: (context) => SelectionSingleBloc()),
      BlocProvider(create: (context) => NotificationListCubit()),
      BlocProvider(create: (context) => RecipesAllCubit()),
      BlocProvider(create: (context) => SlotAdditiveBloc()),
      BlocProvider(create: (context) => ClientAdditivesListBloc()),
      BlocProvider(create: (context) => AnalysisFullBloc()),
      BlocProvider(create: (context) => AnalysisListBloc()),
      BlocProvider(create: (context) => SingleExpertRecommendationBloc()),
      BlocProvider(create: (context) => AllSensorsBloc()),
      BlocProvider(create: (context) => ClientSensorsWaterBloc()),
      BlocProvider(create: (context) => ClientFamilyListBloc()),
      BlocProvider(create: (context) => AnalysisFamilyMemberBloc()),
      BlocProvider(create: (context) => DietListBloc()),
      BlocProvider(create: (context) => DietsFullDataBloc()),
    ];
  }
}
