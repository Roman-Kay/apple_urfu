import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:garnetbook/data/models/client/food_diary/food_diary_model.dart';

import 'package:garnetbook/data/models/others/file_view.dart';
import 'package:garnetbook/data/models/survey/q_type_view/subsribe_view.dart';
import 'package:garnetbook/data/models/survey/quiz_model.dart';
import 'package:garnetbook/data/models/survey/survey_branching_store/survey_branching_store.dart';

import 'package:garnetbook/ui/auth/auth/auth_container.dart';
import 'package:garnetbook/ui/auth/auth/auth_login_screen.dart';
import 'package:garnetbook/ui/auth/auth/auth_paid_subscription.dart';
import 'package:garnetbook/ui/auth/register/auth_register_screen.dart';
import 'package:garnetbook/ui/auth/register/auth_register_screen_second.dart';
import 'package:garnetbook/ui/auth/register/fourth/auth_register_screen_client_fourth.dart';
import 'package:garnetbook/ui/auth/register/third/auth_register_screen_client_third.dart';
import 'package:garnetbook/ui/auth/auth/auth_splash_screen.dart';

import 'package:garnetbook/ui/client_category/food_diary/components/client_food_diary_list_meal.dart';
import 'package:garnetbook/ui/client_category/food_diary/diets/client_food_diary_diet_main_screen.dart';
import 'package:garnetbook/ui/client_category/food_diary/diets/screens/client_food_diary_single_diet_screen.dart';
import 'package:garnetbook/ui/client_category/food_diary/screens/client_food_diary_add_drink_second_screen.dart';
import 'package:garnetbook/ui/client_category/food_diary/screens/client_food_diary_edit_food_screen.dart';
import 'package:garnetbook/ui/client_category/profile/client_profile_container_screen.dart';

import 'package:garnetbook/ui/client_category/recomendation/screens/client_recommendation_platform_single_screen.dart';
import 'package:garnetbook/ui/client_category/survey/balance_wheel/client_survey_balance_wheel_screen.dart';
import 'package:garnetbook/ui/client_category/survey/client_survey_main_screen.dart';
import 'package:garnetbook/ui/client_category/survey/screens/client_physical_survey_screen.dart';
import 'package:garnetbook/ui/client_category/survey/screens/client_survey_all_info_screen.dart';
import 'package:garnetbook/ui/client_category/survey/screens/client_survey_branching_screen.dart';
import 'package:garnetbook/ui/client_category/survey/screens/client_survey_done_screen.dart';
import 'package:garnetbook/ui/client_category/survey/screens/client_survey_watch_screen.dart';

import 'package:garnetbook/ui/client_category/target/screens/client_set_personal_plan_screen.dart';
import 'package:garnetbook/ui/client_category/target/screens/client_set_target_screen.dart';
import 'package:garnetbook/ui/client_category/target/screens/client_set_target_weight_screen.dart';
import 'package:garnetbook/ui/client_category/calendar/screens/client_calendar_add_new_event_screen.dart';
import 'package:garnetbook/ui/client_category/calendar/client_calendar_container.dart';
import 'package:garnetbook/ui/client_category/calendar/client_calendar_main_screen.dart';
import 'package:garnetbook/ui/client_category/calendar/screens/client_calendar_check_event_screen.dart';
import 'package:garnetbook/ui/client_category/food_diary/screens/client_food_diary_add_drink_screen.dart';
import 'package:garnetbook/ui/client_category/food_diary/screens/client_food_diary_add_food_screen.dart';
import 'package:garnetbook/ui/client_category/food_diary/client_food_diary_main_screen.dart';
import 'package:garnetbook/ui/client_category/main/client_main_container.dart';
import 'package:garnetbook/ui/client_category/main/client_main_main_screen.dart';
import 'package:garnetbook/ui/client_category/message/client_messages_container.dart';
import 'package:garnetbook/ui/client_category/message/client_messages_main_screen.dart';
import 'package:garnetbook/ui/client_category/message/screens/client_message_new_message_screen.dart';
import 'package:garnetbook/ui/client_category/message/screens/client_messages_%D1%81hat_screen.dart';
import 'package:garnetbook/ui/client_category/my_day/client_my_day_main_screen.dart';
import 'package:garnetbook/ui/client_category/my_day/my_day_container.dart';

import 'package:garnetbook/ui/client_category/profile/screens/client_profile_about_platform_screen.dart';
import 'package:garnetbook/ui/client_category/profile/screens/client_profile_edit_screen.dart';
import 'package:garnetbook/ui/client_category/profile/client_profile_main_screen.dart';

import 'package:garnetbook/ui/client_category/recipes/client_recipes_main_screen.dart';
import 'package:garnetbook/ui/client_category/recipes/screens/client_recipes_card_info_screen.dart';
import 'package:garnetbook/ui/client_category/recipes/screens/client_recipes_saved_list_screen.dart';
import 'package:garnetbook/ui/client_category/recomendation/client_recomendation_main_screen.dart';
import 'package:garnetbook/ui/client_category/recomendation/screens/client_recomendation_watch_screen.dart';
import 'package:garnetbook/ui/client_category/sensors/blood_glucose/client_sensors_sugar_in_blood_screen.dart';
import 'package:garnetbook/ui/client_category/sensors/blood_oxygen/client_sensors_oxygen_in_blood_screen.dart';
import 'package:garnetbook/ui/client_category/sensors/pressure/client_sensors_pressure_main_screen.dart';
import 'package:garnetbook/ui/client_category/sensors/sleep/client_sensors_sleep_screen.dart';
import 'package:garnetbook/ui/client_category/sensors/steps/client_sensors_steps_screen.dart';
import 'package:garnetbook/ui/client_category/sensors/weight/client_sensors_weight_screen.dart';
import 'package:garnetbook/ui/client_category/sensors/workout/screens/client_add_activity_screen.dart';
import 'package:garnetbook/ui/client_category/sensors/workout/client_sensors_activity_screen.dart';

import 'package:garnetbook/ui/client_category/target/client_target_main_screen.dart';

import 'package:garnetbook/ui/client_category/water/client_water_main_screen.dart';

import 'package:garnetbook/ui/routing/auth_guard.dart';
import 'package:garnetbook/widgets/bottom_navigation/bottom_navigation_client_bar_widget.dart';
import 'package:garnetbook/widgets/bottom_navigation/dashboard_container.dart';
import 'package:garnetbook/widgets/bottom_navigation/dashboard_container_expert.dart';
import 'package:garnetbook/widgets/bottom_navigation/root_screen.dart';
import 'package:garnetbook/widgets/pdf/image_viewer.dart';
import 'package:garnetbook/widgets/pdf/pdf_viewer.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  //AppRouter({required super.authGuard, required super.authGuardExpert});

  //AppRouter() : super(authGuard: AuthGuard(), authGuardExpert: AuthGuardExpert());

  @override
  RouteType get defaultRouteType => RouteType.cupertino();

  List<AutoRouteGuard> get guards => [AuthGuard()];

  @override
  List<AutoRoute> get routes => <AutoRoute>[
        //tab bar client
        CustomRoute(
          page: DashboardContainerRoute.page,
          initial: true,
          guards: [AuthGuard()],
          children: [
            CustomRoute(
              page: BottomNavigationBarClientRoute.page,
              initial: true,
              children: [
                AutoRoute(page: ClientMainContainerRoute.page, children: [
                  AutoRoute(page: ClientMainMainRoute.page, initial: true),

                  //target
                  AutoRoute(page: ClientTargetMainRoute.page),

                  //set target
                  AutoRoute(page: ClientSetTargetRoute.page),
                  AutoRoute(page: ClientSetTargetWeightRoute.page),

                  //list of specialists
                  AutoRoute(page: PdfViewerRoute.page),
                  AutoRoute(page: ImageViewerRoute.page),

                  //recommendations
                  AutoRoute(page: ClientRecommendationMainRoute.page),
                  AutoRoute(page: ClientRecommendationWatchRoute.page),
                  AutoRoute(page: ClientRecommendationPlatformSingleRoute.page),

                  //recipes
                  AutoRoute(page: ClientRecipesMainRoute.page),
                  AutoRoute(page: ClientRecipesSavedListRoute.page),
                  AutoRoute(page: ClientRecipesCardInfoRoute.page),
                ]),
                AutoRoute(page: ClientCalendarContainerRoute.page, children: [
                  AutoRoute(page: ClientCalendarMainRoute.page, initial: true),
                  AutoRoute(page: ClientCalendarAddNewEventRoute.page),
                  AutoRoute(page: ClientCalendarCheckEventRoute.page),
                ]),
                AutoRoute(
                  page: ClientMyDayContainerRoute.page,
                  initial: true,
                  children: [
                    AutoRoute(page: ClientMyDayMainRoute.page, initial: true),

                    //set target
                    AutoRoute(page: ClientSetTargetRoute.page),
                    AutoRoute(page: ClientSetTargetWeightRoute.page),

                    //food - water diary
                    AutoRoute(page: ClientFoodDiaryMainRoute.page),
                    AutoRoute(page: ClientWaterMainRoute.page),
                    AutoRoute(page: ClientAddFoodRoute.page),
                    AutoRoute(page: ClientFoodDiaryAddDrinkRoute.page),
                    AutoRoute(page: ClientFoodDiaryEditFoodRoute.page),
                    AutoRoute(page: ClientFoodDiaryAddDrinkSecondRoute.page),
                    AutoRoute(page: ClientFoodDiarySingleDietRoute.page),
                    AutoRoute(page: ClientFoodDiaryDietMainRoute.page),

                    //recipes
                    AutoRoute(page: ClientRecipesMainRoute.page),
                    AutoRoute(page: ClientRecipesSavedListRoute.page),
                    AutoRoute(page: ClientRecipesCardInfoRoute.page),

                    //sensors
                    AutoRoute(page: ClientSensorsSugarInBloodRoute.page),
                    AutoRoute(page: ClientSensorsOxygenInBloodRoute.page),
                    AutoRoute(page: ClientSensorsSleepRoute.page),
                    AutoRoute(page: ClientSensorsStepsRoute.page),
                    AutoRoute(page: ClientSensorsWeightRoute.page),
                    AutoRoute(page: ClientSensorsActivityRoute.page),
                    AutoRoute(page: ClientAddActivityRoute.page),
                    AutoRoute(page: ClientSensorsPressureMainRoute.page),
                  ],
                ),
                AutoRoute(page: ClientMessagesContainerRoute.page, children: [
                  AutoRoute(page: ClientMessagesMainRoute.page, initial: true),
                  AutoRoute(page: ClientMessagesChatRoute.page),
                  AutoRoute(page: ClientMessageNewMessageRoute.page),
                  AutoRoute(page: PdfViewerRoute.page),
                  AutoRoute(page: ImageViewerRoute.page),
                ]),
                AutoRoute(page: ClientProfileRoute.page, children: [
                  AutoRoute(page: ClientProfileMainRoute.page, initial: true),
                  AutoRoute(page: ClientProfileAboutPlatformRoute.page),
                  AutoRoute(page: ClientProfileEditRoute.page),
                ]),
              ],
            ),
          ],
        ),

        //auth
        CustomRoute(
          page: AuthContainerRoute.page,
          children: [
            AutoRoute(page: AuthLoginRoute.page),
            AutoRoute(page: AuthPaidSubscriptionRoute.page),
            AutoRoute(page: SplashMotivationRoute.page, initial: true),

            AutoRoute(page: AuthRegisterRouteSecond.page),
            AutoRoute(page: AuthRegisterRouteClientThird.page),
            AutoRoute(page: AuthRegisterRoute.page),
            AutoRoute(page: AuthRegisterClientFourthRoute.page),

            AutoRoute(page: ClientSetPersonalPlanRoute.page),
            //AutoRoute(page: AdvertisingMainRoute.page),
          ],
        ),
      ];
}
