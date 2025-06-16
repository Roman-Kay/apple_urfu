import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garnetbook/bloc/client/additives/additive_data/additive_data_bloc.dart';
import 'package:garnetbook/bloc/client/additives/additive_queue/additive_queue_bloc.dart';
import 'package:garnetbook/bloc/client/additives/additives_cubit.dart';
import 'package:garnetbook/bloc/client/additives/additives_for_today/additives_for_today_cubit.dart';
import 'package:garnetbook/bloc/client/additives/additives_main/additives_main_cubit.dart';
import 'package:garnetbook/bloc/client/additives/slot_additive/slot_additive_bloc.dart';
import 'package:garnetbook/bloc/client/analysis/analysis_full_bloc/analysis_full_bloc.dart';
import 'package:garnetbook/bloc/client/analysis/analysis_list_bloc/analysis_list_bloc.dart';
import 'package:garnetbook/bloc/client/analysis/client_family_list/client_family_list_bloc.dart';
import 'package:garnetbook/bloc/client/analysis/family_member/analysis_family_member_bloc.dart';
import 'package:garnetbook/bloc/client/calendar/calendar_cubit.dart';
import 'package:garnetbook/bloc/client/calendar/calendar_for_day/calendar_for_day_bloc.dart';
import 'package:garnetbook/bloc/client/calendar/selected_date/selected_date_bloc.dart';
import 'package:garnetbook/bloc/client/claims/client_claims_bloc.dart';
import 'package:garnetbook/bloc/client/diets/diets_full_data/diets_full_data_bloc.dart';
import 'package:garnetbook/bloc/client/diets/diets_list_bloc.dart';
import 'package:garnetbook/bloc/client/food_diary/food_diary_bloc.dart';
import 'package:garnetbook/bloc/client/health/activated_sensors/activated_sensors_bloc.dart';
import 'package:garnetbook/bloc/client/health/blood_glucose/blood_glucose_bloc.dart';
import 'package:garnetbook/bloc/client/health/blood_oxygen/blood_oxygen_bloc.dart';
import 'package:garnetbook/bloc/client/health/main/health_main_cubit.dart';
import 'package:garnetbook/bloc/client/health/pressure/pressure_bloc.dart';
import 'package:garnetbook/bloc/client/health/pulse/pulse_bloc.dart';
import 'package:garnetbook/bloc/client/health/sleep/health_sleep_bloc.dart';
import 'package:garnetbook/bloc/client/health/sleep/week_sleep/week_sleep_bloc.dart';
import 'package:garnetbook/bloc/client/health/steps/health_step_bloc.dart';
import 'package:garnetbook/bloc/client/health/steps/step_list/step_list_bloc.dart';
import 'package:garnetbook/bloc/client/health/weight/weight_bloc.dart';
import 'package:garnetbook/bloc/client/health/workout/health_workout_bloc.dart';
import 'package:garnetbook/bloc/client/health/workout/today_workout/today_workout_cubit.dart';
import 'package:garnetbook/bloc/client/health/workout/workout_chart/workout_chart_bloc.dart';
import 'package:garnetbook/bloc/client/library/article/article_bloc.dart';
import 'package:garnetbook/bloc/client/library/categorises/categorises_cubit.dart';
import 'package:garnetbook/bloc/client/my_expert/my_expert_cubit.dart';
import 'package:garnetbook/bloc/client/physical_survey/physical_survey_bloc.dart';
import 'package:garnetbook/bloc/client/profile/client_profile_bloc.dart';
import 'package:garnetbook/bloc/client/recipes/recipes_all/recipes_all_cubit.dart';
import 'package:garnetbook/bloc/client/recipes/recipes_today/recipes_today_cubit.dart';
import 'package:garnetbook/bloc/client/recommendation/platform_recommendation/platform_recommendation_cubit.dart';
import 'package:garnetbook/bloc/client/recommendation/recommendation_cubit.dart';
import 'package:garnetbook/bloc/client/recommendation/single_expert_recommendation_bloc/single_expert_recommendation_bloc.dart';
import 'package:garnetbook/bloc/client/recommendation/single_recommendation/single_recommendation_bloc.dart';
import 'package:garnetbook/bloc/client/survey/balance_wheel/balance_wheel_bloc.dart';
import 'package:garnetbook/bloc/client/survey/q_type_list/q_type_list_cubit.dart';
import 'package:garnetbook/bloc/client/survey/subscribe_bloc/subscribe_bloc.dart';
import 'package:garnetbook/bloc/client/survey/survey_bloc.dart';
import 'package:garnetbook/bloc/client/survey/survey_branching/survey_branching_bloc.dart';
import 'package:garnetbook/bloc/client/survey/survey_list/survey_list_cubit.dart';
import 'package:garnetbook/bloc/client/target/target_bloc.dart';
import 'package:garnetbook/bloc/client/trackers/trackers_cubit.dart';
import 'package:garnetbook/bloc/client/version/version_cubit.dart';
import 'package:garnetbook/bloc/client/water_diary/water_diary_bloc.dart';
import 'package:garnetbook/bloc/client/water_diary/water_diary_chart/water_diary_chart_bloc.dart';
import 'package:garnetbook/bloc/client/woman_calendar/woman_calendar_for_day/woman_calendar_for_day_bloc.dart';
import 'package:garnetbook/bloc/client/woman_calendar/woman_calendar_for_period_bloc.dart';
import 'package:garnetbook/bloc/expert/client_card/client_survey/survey_data/survey_data_bloc.dart';
import 'package:garnetbook/bloc/expert/expert_data/expert_data_bloc.dart';
import 'package:garnetbook/bloc/expert/list/expert_list_bloc.dart';
import 'package:garnetbook/bloc/message/chat/chat_bloc/chat_bloc.dart';
import 'package:garnetbook/bloc/message/chat/list_chat_cubit/list_chat_cubit.dart';
import 'package:garnetbook/bloc/message/push/push_cubit.dart';
import 'package:garnetbook/bloc/user/notification_list/notification_list_cubit.dart';
import 'package:garnetbook/bloc/user/user_data_cubit.dart';
import 'package:intl/intl.dart';
import 'package:provider/single_child_widget.dart';

class BlocsProvider {
  List<SingleChildWidget> providersClient() {
    return [
      BlocProvider(create: (context) => TargetBloc()),
      BlocProvider(create: (context) => UserDataCubit()),
      BlocProvider(create: (context) => WaterDiaryBloc()),
      BlocProvider(create: (context) => FoodDiaryBloc()),
      BlocProvider(create: (context) => ClientProfileCubit()),
      BlocProvider(create: (context) => HealthMainCubit()),
      BlocProvider(create: (context) => HealthStepBloc()),
      BlocProvider(create: (context) => HealthSleepBloc()),
      BlocProvider(create: (context) => HealthWorkoutBloc()),
      BlocProvider(create: (context) => RecipesAllCubit()),
      BlocProvider(create: (context) => RecipesTodayCubit()),
      BlocProvider(create: (context) => CalendarCubit()..check()),
      BlocProvider(create: (context) => ClientClaimsBloc()),
      BlocProvider(create: (context) => AdditivesCubit()),
      BlocProvider(create: (context) => ExpertListBloc()),
      BlocProvider(create: (context) => ExpertDataBloc()),
      BlocProvider(create: (context) => ActivatedSensorsBloc()),
      BlocProvider(create: (context) => CalendarForDayBloc()..add(CalendarForDayGetEvent(DateFormat("yyyy-MM-dd").format(DateTime.now())))),
      BlocProvider(create: (context) => BloodOxygenBloc()),
      BlocProvider(create: (context) => BloodGlucoseBloc()),
      BlocProvider(create: (context) => WeightBloc()),
      BlocProvider(create: (context) => WeekSleepBloc()),
      BlocProvider(create: (context) => TodayWorkoutCubit()),
      BlocProvider(create: (context) => TrackersCubit()),
      BlocProvider(create: (context) => SurveyBloc()),
      BlocProvider(create: (context) => LibraryCategorisesCubit()),
      BlocProvider(create: (context) => LibraryArticleBloc()),
      BlocProvider(create: (context) => PhysicalSurveyBloc()),
      BlocProvider(create: (context) => ListChatCubit()..check()),
      BlocProvider(create: (context) => MyExpertCubit()),
      BlocProvider(create: (context) => ChatBloc()),
      BlocProvider(create: (context) => AdditiveDataBloc()),
      BlocProvider(create: (context) => AdditiveQueueBloc()),
      BlocProvider(create: (context) => RecommendationCubit()),
      BlocProvider(create: (context) => PressureBloc()),
      BlocProvider(create: (context) => PulseBloc()),
      BlocProvider(create: (context) => SurveyListCubit()),
      BlocProvider(create: (context) => WaterDiaryChartBloc()),
      BlocProvider(create: (context) => SurveyDataBloc()),
      BlocProvider(create: (context) => SelectedDateBloc()),
      BlocProvider(create: (context) => StepListBloc()),
      BlocProvider(create: (context) => WorkoutChartBloc()),
      BlocProvider(create: (context) => AdditivesForTodayCubit()),
      BlocProvider(create: (context) => AdditivesMainCubit()),
      BlocProvider(create: (context) => PushCubit()..check()),
      BlocProvider(create: (context) => QTypeListCubit()),
      BlocProvider(create: (context) => SubscribeBloc()),
      BlocProvider(create: (context) => PlatformRecommendationCubit()),
      BlocProvider(create: (context) => SingleRecommendationBloc()),
      BlocProvider(create: (context) => WomanCalendarForDayBloc()),
      BlocProvider(create: (context) => WomanCalendarForPeriodBloc()),
      BlocProvider(create: (context) => NotificationListCubit()),
      BlocProvider(create: (context) => SurveyBranchingBloc()),
      BlocProvider(create: (context) => SlotAdditiveBloc()),
      BlocProvider(create: (context) => AnalysisFullBloc()),
      BlocProvider(create: (context) => AnalysisListBloc()),
      BlocProvider(create: (context) => SingleExpertRecommendationBloc()),
      BlocProvider(create: (context) => ClientFamilyListBloc()),
      BlocProvider(create: (context) => AnalysisFamilyMemberBloc()),
      BlocProvider(create: (context) => VersionCubit()),
      BlocProvider(create: (context) => BalanceWheelBloc()),
      BlocProvider(create: (context) => DietListBloc()),
      BlocProvider(create: (context) => DietsFullDataBloc()),
    ];
  }
}
