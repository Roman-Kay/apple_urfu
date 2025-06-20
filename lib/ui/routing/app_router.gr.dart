// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    AuthContainerRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AuthContainerPage(),
      );
    },
    AuthLoginRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AuthLoginScreen(),
      );
    },
    AuthPaidSubscriptionRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AuthPaidSubscriptionScreen(),
      );
    },
    AuthRegisterClientFourthRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AuthRegisterClientFourthScreen(),
      );
    },
    AuthRegisterRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AuthRegisterScreen(),
      );
    },
    AuthRegisterRouteClientThird.name: (routeData) {
      final args = routeData.argsAs<AuthRegisterRouteClientThirdArgs>(orElse: () => const AuthRegisterRouteClientThirdArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: AuthRegisterScreenClientThird(
          key: args.key,
          isLogin: args.isLogin,
          withSocial: args.withSocial,
          gUser: args.gUser,
        ),
      );
    },
    AuthRegisterRouteSecond.name: (routeData) {
      final args = routeData.argsAs<AuthRegisterRouteSecondArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: AuthRegisterScreenSecond(
          phone: args.phone,
          password: args.password,
          key: args.key,
        ),
      );
    },
    BottomNavigationBarClientRoute.name: (routeData) {
      final args = routeData.argsAs<BottomNavigationBarClientRouteArgs>(orElse: () => const BottomNavigationBarClientRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: BottomNavigationBarClientPage(
          key: args.key,
          startPageIndex: args.startPageIndex,
        ),
      );
    },
    ClientAddActivityRoute.name: (routeData) {
      final args = routeData.argsAs<ClientAddActivityRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ClientAddActivityScreen(
          key: args.key,
          date: args.date,
        ),
      );
    },
    ClientAddFoodRoute.name: (routeData) {
      final args = routeData.argsAs<ClientAddFoodRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ClientAddFoodScreen(
          key: args.key,
          currentFoodPeriod: args.currentFoodPeriod,
          date: args.date,
          selectedDate: args.selectedDate,
        ),
      );
    },
    ClientCalendarAddNewEventRoute.name: (routeData) {
      final args = routeData.argsAs<ClientCalendarAddNewEventRouteArgs>(orElse: () => const ClientCalendarAddNewEventRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ClientCalendarAddNewEventScreen(
          key: args.key,
          selectedDate: args.selectedDate,
        ),
      );
    },
    ClientCalendarCheckEventRoute.name: (routeData) {
      final args = routeData.argsAs<ClientCalendarCheckEventRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ClientCalendarCheckEventScreen(
          key: args.key,
          fullDay: args.fullDay,
          description: args.description,
          title: args.title,
          endTime: args.endTime,
          startTime: args.startTime,
          id: args.id,
          expertName: args.expertName,
          expertId: args.expertId,
        ),
      );
    },
    ClientCalendarContainerRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ClientCalendarContainerScreen(),
      );
    },
    ClientCalendarMainRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ClientCalendarMainScreen(),
      );
    },
    ClientFoodDiaryAddDrinkRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ClientFoodDiaryAddDrinkScreen(),
      );
    },
    ClientFoodDiaryAddDrinkSecondRoute.name: (routeData) {
      final args = routeData.argsAs<ClientFoodDiaryAddDrinkSecondRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ClientFoodDiaryAddDrinkSecondScreen(
          key: args.key,
          view: args.view,
          indexChosenDrink: args.indexChosenDrink,
        ),
      );
    },
    ClientFoodDiaryDietMainRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ClientFoodDiaryDietMainScreen(),
      );
    },
    ClientFoodDiaryEditFoodRoute.name: (routeData) {
      final args = routeData.argsAs<ClientFoodDiaryEditFoodRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ClientFoodDiaryEditFoodScreen(
          key: args.key,
          view: args.view,
          numberOfMeal: args.numberOfMeal,
          selectedDate: args.selectedDate,
        ),
      );
    },
    ClientFoodDiaryMainRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ClientFoodDiaryMainScreen(),
      );
    },
    ClientFoodDiarySingleDietRoute.name: (routeData) {
      final args = routeData.argsAs<ClientFoodDiarySingleDietRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ClientFoodDiarySingleDietScreen(
          key: args.key,
          id: args.id,
        ),
      );
    },
    ClientMainContainerRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ClientMainContainerScreen(),
      );
    },
    ClientMainMainRoute.name: (routeData) {
      final args = routeData.argsAs<ClientMainMainRouteArgs>(orElse: () => const ClientMainMainRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ClientMainMainScreen(key: args.key),
      );
    },
    ClientMessageNewMessageRoute.name: (routeData) {
      final args = routeData.argsAs<ClientMessageNewMessageRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ClientMessageNewMessageScreen(
          listOfUsers: args.listOfUsers,
          key: args.key,
        ),
      );
    },
    ClientMessagesChatRoute.name: (routeData) {
      final args = routeData.argsAs<ClientMessagesChatRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ClientMessagesChatScreen(
          key: args.key,
          chatId: args.chatId,
          isNew: args.isNew,
          expertId: args.expertId,
          view: args.view,
          senderName: args.senderName,
        ),
      );
    },
    ClientMessagesContainerRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ClientMessagesContainerScreen(),
      );
    },
    ClientMessagesMainRoute.name: (routeData) {
      final args = routeData.argsAs<ClientMessagesMainRouteArgs>(orElse: () => const ClientMessagesMainRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ClientMessagesMainScreen(
          key: args.key,
          tabIndex: args.tabIndex,
        ),
      );
    },
    ClientMyDayContainerRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ClientMyDayContainerScreen(),
      );
    },
    ClientMyDayMainRoute.name: (routeData) {
      final args = routeData.argsAs<ClientMyDayMainRouteArgs>(orElse: () => const ClientMyDayMainRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ClientMyDayMainScreen(key: args.key),
      );
    },
    ClientPhysicalSurveyRoute.name: (routeData) {
      final args = routeData.argsAs<ClientPhysicalSurveyRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ClientPhysicalSurveyScreen(
          key: args.key,
          stepId: args.stepId,
        ),
      );
    },
    ClientProfileAboutPlatformRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ClientProfileAboutPlatformScreen(),
      );
    },
    ClientProfileEditRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ClientProfileEditScreen(),
      );
    },
    ClientProfileMainRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ClientProfileMainScreen(),
      );
    },
    ClientProfileRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ClientProfileScreen(),
      );
    },
    ClientRecipesCardInfoRoute.name: (routeData) {
      final args = routeData.argsAs<ClientRecipesCardInfoRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ClientRecipesCardInfoScreen(
          key: args.key,
          recipeId: args.recipeId,
          isFromExpert: args.isFromExpert,
        ),
      );
    },
    ClientRecipesMainRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ClientRecipesMainScreen(),
      );
    },
    ClientRecipesSavedListRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ClientRecipesSavedListScreen(),
      );
    },
    ClientRecommendationMainRoute.name: (routeData) {
      final args = routeData.argsAs<ClientRecommendationMainRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ClientRecommendationMainScreen(
          key: args.key,
          isFormSurvey: args.isFormSurvey,
        ),
      );
    },
    ClientRecommendationPlatformSingleRoute.name: (routeData) {
      final args = routeData.argsAs<ClientRecommendationPlatformSingleRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ClientRecommendationPlatformSingleScreen(
          key: args.key,
          id: args.id,
          name: args.name,
          type: args.type,
        ),
      );
    },
    ClientRecommendationWatchRoute.name: (routeData) {
      final args = routeData.argsAs<ClientRecommendationWatchRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ClientRecommendationWatchScreen(
          id: args.id,
          name: args.name,
          key: args.key,
        ),
      );
    },
    ClientSensorsActivityRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ClientSensorsActivityScreen(),
      );
    },
    ClientSensorsOxygenInBloodRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ClientSensorsOxygenInBloodScreen(),
      );
    },
    ClientSensorsPressureMainRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ClientSensorsPressureMainScreen(),
      );
    },
    ClientSensorsSleepRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ClientSensorsSleepScreen(),
      );
    },
    ClientSensorsStepsRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ClientSensorsStepsScreen(),
      );
    },
    ClientSensorsSugarInBloodRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ClientSensorsSugarInBloodScreen(),
      );
    },
    ClientSensorsWeightRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ClientSensorsWeightScreen(),
      );
    },
    ClientSetPersonalPlanRoute.name: (routeData) {
      final args = routeData.argsAs<ClientSetPersonalPlanRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ClientSetPersonalPlanScreen(
          key: args.key,
          height: args.height,
          weight: args.weight,
        ),
      );
    },
    ClientSetTargetRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ClientSetTargetScreen(),
      );
    },
    ClientSetTargetWeightRoute.name: (routeData) {
      final args = routeData.argsAs<ClientSetTargetWeightRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ClientSetTargetWeightScreen(
          key: args.key,
          nextStep: args.nextStep,
        ),
      );
    },
    ClientSurveyAllInfoRoute.name: (routeData) {
      final args = routeData.argsAs<ClientSurveyAllInfoRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ClientSurveyAllInfoScreen(
          stepId: args.stepId,
          quizzes: args.quizzes,
          resultIds: args.resultIds,
          isFromBranching: args.isFromBranching,
          targetType: args.targetType,
          branchingCurrentStep: args.branchingCurrentStep,
          key: args.key,
        ),
      );
    },
    ClientSurveyBalanceWheelRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ClientSurveyBalanceWheelScreen(),
      );
    },
    ClientSurveyBranchingRoute.name: (routeData) {
      final args = routeData.argsAs<ClientSurveyBranchingRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ClientSurveyBranchingScreen(
          key: args.key,
          stepId: args.stepId,
          targetType: args.targetType,
        ),
      );
    },
    ClientSurveyDoneRoute.name: (routeData) {
      final args = routeData.argsAs<ClientSurveyDoneRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ClientSurveyDoneScreen(
          key: args.key,
          questions: args.questions,
          surveyId: args.surveyId,
        ),
      );
    },
    ClientSurveyMainRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ClientSurveyMainScreen(),
      );
    },
    ClientSurveyWatchRoute.name: (routeData) {
      final args = routeData.argsAs<ClientSurveyWatchRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ClientSurveyWatchScreen(
          surveyId: args.surveyId,
          id: args.id,
          expertId: args.expertId,
          key: args.key,
        ),
      );
    },
    ClientTargetMainRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ClientTargetMainScreen(),
      );
    },
    ClientWaterMainRoute.name: (routeData) {
      final args = routeData.argsAs<ClientWaterMainRouteArgs>(orElse: () => const ClientWaterMainRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ClientWaterMainScreen(
          key: args.key,
          isFromFoodDiary: args.isFromFoodDiary,
        ),
      );
    },
    DashboardContainerExpertRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const DashboardContainerExpertPage(),
      );
    },
    DashboardContainerRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const DashboardContainerPage(),
      );
    },
    ImageViewerRoute.name: (routeData) {
      final args = routeData.argsAs<ImageViewerRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ImageViewerScreen(
          key: args.key,
          type: args.type,
          fileId: args.fileId,
          name: args.name,
          isDownload: args.isDownload,
          file: args.file,
        ),
      );
    },
    PdfViewerRoute.name: (routeData) {
      final args = routeData.argsAs<PdfViewerRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: PdfViewerScreen(
          key: args.key,
          pathPDF: args.pathPDF,
          name: args.name,
          fileId: args.fileId,
          type: args.type,
          isDownload: args.isDownload,
        ),
      );
    },
    RootRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const RootScreen(),
      );
    },
    SplashMotivationRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SplashMotivationScreen(),
      );
    },
  };
}

/// generated route for
/// [AuthContainerPage]
class AuthContainerRoute extends PageRouteInfo<void> {
  const AuthContainerRoute({List<PageRouteInfo>? children})
      : super(
          AuthContainerRoute.name,
          initialChildren: children,
        );

  static const String name = 'AuthContainerRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [AuthLoginScreen]
class AuthLoginRoute extends PageRouteInfo<void> {
  const AuthLoginRoute({List<PageRouteInfo>? children})
      : super(
          AuthLoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'AuthLoginRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [AuthPaidSubscriptionScreen]
class AuthPaidSubscriptionRoute extends PageRouteInfo<void> {
  const AuthPaidSubscriptionRoute({List<PageRouteInfo>? children})
      : super(
          AuthPaidSubscriptionRoute.name,
          initialChildren: children,
        );

  static const String name = 'AuthPaidSubscriptionRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [AuthRegisterClientFourthScreen]
class AuthRegisterClientFourthRoute extends PageRouteInfo<void> {
  const AuthRegisterClientFourthRoute({List<PageRouteInfo>? children})
      : super(
          AuthRegisterClientFourthRoute.name,
          initialChildren: children,
        );

  static const String name = 'AuthRegisterClientFourthRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [AuthRegisterScreen]
class AuthRegisterRoute extends PageRouteInfo<void> {
  const AuthRegisterRoute({List<PageRouteInfo>? children})
      : super(
          AuthRegisterRoute.name,
          initialChildren: children,
        );

  static const String name = 'AuthRegisterRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [AuthRegisterScreenClientThird]
class AuthRegisterRouteClientThird extends PageRouteInfo<AuthRegisterRouteClientThirdArgs> {
  AuthRegisterRouteClientThird({
    Key? key,
    bool isLogin = false,
    bool withSocial = false,
    dynamic gUser,
    List<PageRouteInfo>? children,
  }) : super(
          AuthRegisterRouteClientThird.name,
          args: AuthRegisterRouteClientThirdArgs(
            key: key,
            isLogin: isLogin,
            withSocial: withSocial,
            gUser: gUser,
          ),
          initialChildren: children,
        );

  static const String name = 'AuthRegisterRouteClientThird';

  static const PageInfo<AuthRegisterRouteClientThirdArgs> page = PageInfo<AuthRegisterRouteClientThirdArgs>(name);
}

class AuthRegisterRouteClientThirdArgs {
  const AuthRegisterRouteClientThirdArgs({
    this.key,
    this.isLogin = false,
    this.withSocial = false,
    this.gUser,
  });

  final Key? key;

  final bool isLogin;

  final bool withSocial;

  final dynamic gUser;

  @override
  String toString() {
    return 'AuthRegisterRouteClientThirdArgs{key: $key, isLogin: $isLogin, withSocial: $withSocial, gUser: $gUser}';
  }
}

/// generated route for
/// [AuthRegisterScreenSecond]
class AuthRegisterRouteSecond extends PageRouteInfo<AuthRegisterRouteSecondArgs> {
  AuthRegisterRouteSecond({
    required String phone,
    required String password,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          AuthRegisterRouteSecond.name,
          args: AuthRegisterRouteSecondArgs(
            phone: phone,
            password: password,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'AuthRegisterRouteSecond';

  static const PageInfo<AuthRegisterRouteSecondArgs> page = PageInfo<AuthRegisterRouteSecondArgs>(name);
}

class AuthRegisterRouteSecondArgs {
  const AuthRegisterRouteSecondArgs({
    required this.phone,
    required this.password,
    this.key,
  });

  final String phone;

  final String password;

  final Key? key;

  @override
  String toString() {
    return 'AuthRegisterRouteSecondArgs{phone: $phone, password: $password, key: $key}';
  }
}

/// generated route for
/// [BottomNavigationBarClientPage]
class BottomNavigationBarClientRoute extends PageRouteInfo<BottomNavigationBarClientRouteArgs> {
  BottomNavigationBarClientRoute({
    Key? key,
    int startPageIndex = 2,
    List<PageRouteInfo>? children,
  }) : super(
          BottomNavigationBarClientRoute.name,
          args: BottomNavigationBarClientRouteArgs(
            key: key,
            startPageIndex: startPageIndex,
          ),
          initialChildren: children,
        );

  static const String name = 'BottomNavigationBarClientRoute';

  static const PageInfo<BottomNavigationBarClientRouteArgs> page = PageInfo<BottomNavigationBarClientRouteArgs>(name);
}

class BottomNavigationBarClientRouteArgs {
  const BottomNavigationBarClientRouteArgs({
    this.key,
    this.startPageIndex = 2,
  });

  final Key? key;

  final int startPageIndex;

  @override
  String toString() {
    return 'BottomNavigationBarClientRouteArgs{key: $key, startPageIndex: $startPageIndex}';
  }
}

/// generated route for
/// [ClientAddActivityScreen]
class ClientAddActivityRoute extends PageRouteInfo<ClientAddActivityRouteArgs> {
  ClientAddActivityRoute({
    Key? key,
    required DateTime date,
    List<PageRouteInfo>? children,
  }) : super(
          ClientAddActivityRoute.name,
          args: ClientAddActivityRouteArgs(
            key: key,
            date: date,
          ),
          initialChildren: children,
        );

  static const String name = 'ClientAddActivityRoute';

  static const PageInfo<ClientAddActivityRouteArgs> page = PageInfo<ClientAddActivityRouteArgs>(name);
}

class ClientAddActivityRouteArgs {
  const ClientAddActivityRouteArgs({
    this.key,
    required this.date,
  });

  final Key? key;

  final DateTime date;

  @override
  String toString() {
    return 'ClientAddActivityRouteArgs{key: $key, date: $date}';
  }
}

/// generated route for
/// [ClientAddFoodScreen]
class ClientAddFoodRoute extends PageRouteInfo<ClientAddFoodRouteArgs> {
  ClientAddFoodRoute({
    Key? key,
    required int currentFoodPeriod,
    DateTime? date,
    required DateTime selectedDate,
    List<PageRouteInfo>? children,
  }) : super(
          ClientAddFoodRoute.name,
          args: ClientAddFoodRouteArgs(
            key: key,
            currentFoodPeriod: currentFoodPeriod,
            date: date,
            selectedDate: selectedDate,
          ),
          initialChildren: children,
        );

  static const String name = 'ClientAddFoodRoute';

  static const PageInfo<ClientAddFoodRouteArgs> page = PageInfo<ClientAddFoodRouteArgs>(name);
}

class ClientAddFoodRouteArgs {
  const ClientAddFoodRouteArgs({
    this.key,
    required this.currentFoodPeriod,
    this.date,
    required this.selectedDate,
  });

  final Key? key;

  final int currentFoodPeriod;

  final DateTime? date;

  final DateTime selectedDate;

  @override
  String toString() {
    return 'ClientAddFoodRouteArgs{key: $key, currentFoodPeriod: $currentFoodPeriod, date: $date, selectedDate: $selectedDate}';
  }
}

/// generated route for
/// [ClientCalendarAddNewEventScreen]
class ClientCalendarAddNewEventRoute extends PageRouteInfo<ClientCalendarAddNewEventRouteArgs> {
  ClientCalendarAddNewEventRoute({
    Key? key,
    DateTime? selectedDate,
    List<PageRouteInfo>? children,
  }) : super(
          ClientCalendarAddNewEventRoute.name,
          args: ClientCalendarAddNewEventRouteArgs(
            key: key,
            selectedDate: selectedDate,
          ),
          initialChildren: children,
        );

  static const String name = 'ClientCalendarAddNewEventRoute';

  static const PageInfo<ClientCalendarAddNewEventRouteArgs> page = PageInfo<ClientCalendarAddNewEventRouteArgs>(name);
}

class ClientCalendarAddNewEventRouteArgs {
  const ClientCalendarAddNewEventRouteArgs({
    this.key,
    this.selectedDate,
  });

  final Key? key;

  final DateTime? selectedDate;

  @override
  String toString() {
    return 'ClientCalendarAddNewEventRouteArgs{key: $key, selectedDate: $selectedDate}';
  }
}

/// generated route for
/// [ClientCalendarCheckEventScreen]
class ClientCalendarCheckEventRoute extends PageRouteInfo<ClientCalendarCheckEventRouteArgs> {
  ClientCalendarCheckEventRoute({
    Key? key,
    bool? fullDay,
    String? description,
    String? title,
    String? endTime,
    String? startTime,
    required int id,
    String? expertName,
    int? expertId,
    List<PageRouteInfo>? children,
  }) : super(
          ClientCalendarCheckEventRoute.name,
          args: ClientCalendarCheckEventRouteArgs(
            key: key,
            fullDay: fullDay,
            description: description,
            title: title,
            endTime: endTime,
            startTime: startTime,
            id: id,
            expertName: expertName,
            expertId: expertId,
          ),
          initialChildren: children,
        );

  static const String name = 'ClientCalendarCheckEventRoute';

  static const PageInfo<ClientCalendarCheckEventRouteArgs> page = PageInfo<ClientCalendarCheckEventRouteArgs>(name);
}

class ClientCalendarCheckEventRouteArgs {
  const ClientCalendarCheckEventRouteArgs({
    this.key,
    this.fullDay,
    this.description,
    this.title,
    this.endTime,
    this.startTime,
    required this.id,
    this.expertName,
    this.expertId,
  });

  final Key? key;

  final bool? fullDay;

  final String? description;

  final String? title;

  final String? endTime;

  final String? startTime;

  final int id;

  final String? expertName;

  final int? expertId;

  @override
  String toString() {
    return 'ClientCalendarCheckEventRouteArgs{key: $key, fullDay: $fullDay, description: $description, title: $title, endTime: $endTime, startTime: $startTime, id: $id, expertName: $expertName, expertId: $expertId}';
  }
}

/// generated route for
/// [ClientCalendarContainerScreen]
class ClientCalendarContainerRoute extends PageRouteInfo<void> {
  const ClientCalendarContainerRoute({List<PageRouteInfo>? children})
      : super(
          ClientCalendarContainerRoute.name,
          initialChildren: children,
        );

  static const String name = 'ClientCalendarContainerRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ClientCalendarMainScreen]
class ClientCalendarMainRoute extends PageRouteInfo<void> {
  const ClientCalendarMainRoute({List<PageRouteInfo>? children})
      : super(
          ClientCalendarMainRoute.name,
          initialChildren: children,
        );

  static const String name = 'ClientCalendarMainRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ClientFoodDiaryAddDrinkScreen]
class ClientFoodDiaryAddDrinkRoute extends PageRouteInfo<void> {
  const ClientFoodDiaryAddDrinkRoute({List<PageRouteInfo>? children})
      : super(
          ClientFoodDiaryAddDrinkRoute.name,
          initialChildren: children,
        );

  static const String name = 'ClientFoodDiaryAddDrinkRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ClientFoodDiaryAddDrinkSecondScreen]
class ClientFoodDiaryAddDrinkSecondRoute extends PageRouteInfo<ClientFoodDiaryAddDrinkSecondRouteArgs> {
  ClientFoodDiaryAddDrinkSecondRoute({
    Key? key,
    DrinkView? view,
    required int indexChosenDrink,
    List<PageRouteInfo>? children,
  }) : super(
          ClientFoodDiaryAddDrinkSecondRoute.name,
          args: ClientFoodDiaryAddDrinkSecondRouteArgs(
            key: key,
            view: view,
            indexChosenDrink: indexChosenDrink,
          ),
          initialChildren: children,
        );

  static const String name = 'ClientFoodDiaryAddDrinkSecondRoute';

  static const PageInfo<ClientFoodDiaryAddDrinkSecondRouteArgs> page = PageInfo<ClientFoodDiaryAddDrinkSecondRouteArgs>(name);
}

class ClientFoodDiaryAddDrinkSecondRouteArgs {
  const ClientFoodDiaryAddDrinkSecondRouteArgs({
    this.key,
    this.view,
    required this.indexChosenDrink,
  });

  final Key? key;

  final DrinkView? view;

  final int indexChosenDrink;

  @override
  String toString() {
    return 'ClientFoodDiaryAddDrinkSecondRouteArgs{key: $key, view: $view, indexChosenDrink: $indexChosenDrink}';
  }
}

/// generated route for
/// [ClientFoodDiaryDietMainScreen]
class ClientFoodDiaryDietMainRoute extends PageRouteInfo<void> {
  const ClientFoodDiaryDietMainRoute({List<PageRouteInfo>? children})
      : super(
          ClientFoodDiaryDietMainRoute.name,
          initialChildren: children,
        );

  static const String name = 'ClientFoodDiaryDietMainRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ClientFoodDiaryEditFoodScreen]
class ClientFoodDiaryEditFoodRoute extends PageRouteInfo<ClientFoodDiaryEditFoodRouteArgs> {
  ClientFoodDiaryEditFoodRoute({
    Key? key,
    required ItemMeal view,
    required int numberOfMeal,
    required DateTime selectedDate,
    List<PageRouteInfo>? children,
  }) : super(
          ClientFoodDiaryEditFoodRoute.name,
          args: ClientFoodDiaryEditFoodRouteArgs(
            key: key,
            view: view,
            numberOfMeal: numberOfMeal,
            selectedDate: selectedDate,
          ),
          initialChildren: children,
        );

  static const String name = 'ClientFoodDiaryEditFoodRoute';

  static const PageInfo<ClientFoodDiaryEditFoodRouteArgs> page = PageInfo<ClientFoodDiaryEditFoodRouteArgs>(name);
}

class ClientFoodDiaryEditFoodRouteArgs {
  const ClientFoodDiaryEditFoodRouteArgs({
    this.key,
    required this.view,
    required this.numberOfMeal,
    required this.selectedDate,
  });

  final Key? key;

  final ItemMeal view;

  final int numberOfMeal;

  final DateTime selectedDate;

  @override
  String toString() {
    return 'ClientFoodDiaryEditFoodRouteArgs{key: $key, view: $view, numberOfMeal: $numberOfMeal, selectedDate: $selectedDate}';
  }
}

/// generated route for
/// [ClientFoodDiaryMainScreen]
class ClientFoodDiaryMainRoute extends PageRouteInfo<void> {
  const ClientFoodDiaryMainRoute({List<PageRouteInfo>? children})
      : super(
          ClientFoodDiaryMainRoute.name,
          initialChildren: children,
        );

  static const String name = 'ClientFoodDiaryMainRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ClientFoodDiarySingleDietScreen]
class ClientFoodDiarySingleDietRoute extends PageRouteInfo<ClientFoodDiarySingleDietRouteArgs> {
  ClientFoodDiarySingleDietRoute({
    Key? key,
    required int id,
    List<PageRouteInfo>? children,
  }) : super(
          ClientFoodDiarySingleDietRoute.name,
          args: ClientFoodDiarySingleDietRouteArgs(
            key: key,
            id: id,
          ),
          initialChildren: children,
        );

  static const String name = 'ClientFoodDiarySingleDietRoute';

  static const PageInfo<ClientFoodDiarySingleDietRouteArgs> page = PageInfo<ClientFoodDiarySingleDietRouteArgs>(name);
}

class ClientFoodDiarySingleDietRouteArgs {
  const ClientFoodDiarySingleDietRouteArgs({
    this.key,
    required this.id,
  });

  final Key? key;

  final int id;

  @override
  String toString() {
    return 'ClientFoodDiarySingleDietRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for
/// [ClientMainContainerScreen]
class ClientMainContainerRoute extends PageRouteInfo<void> {
  const ClientMainContainerRoute({List<PageRouteInfo>? children})
      : super(
          ClientMainContainerRoute.name,
          initialChildren: children,
        );

  static const String name = 'ClientMainContainerRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ClientMainMainScreen]
class ClientMainMainRoute extends PageRouteInfo<ClientMainMainRouteArgs> {
  ClientMainMainRoute({
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          ClientMainMainRoute.name,
          args: ClientMainMainRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'ClientMainMainRoute';

  static const PageInfo<ClientMainMainRouteArgs> page = PageInfo<ClientMainMainRouteArgs>(name);
}

class ClientMainMainRouteArgs {
  const ClientMainMainRouteArgs({this.key});

  final Key? key;

  @override
  String toString() {
    return 'ClientMainMainRouteArgs{key: $key}';
  }
}

/// generated route for
/// [ClientMessageNewMessageScreen]
class ClientMessageNewMessageRoute extends PageRouteInfo<ClientMessageNewMessageRouteArgs> {
  ClientMessageNewMessageRoute({
    required List<int> listOfUsers,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          ClientMessageNewMessageRoute.name,
          args: ClientMessageNewMessageRouteArgs(
            listOfUsers: listOfUsers,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'ClientMessageNewMessageRoute';

  static const PageInfo<ClientMessageNewMessageRouteArgs> page = PageInfo<ClientMessageNewMessageRouteArgs>(name);
}

class ClientMessageNewMessageRouteArgs {
  const ClientMessageNewMessageRouteArgs({
    required this.listOfUsers,
    this.key,
  });

  final List<int> listOfUsers;

  final Key? key;

  @override
  String toString() {
    return 'ClientMessageNewMessageRouteArgs{listOfUsers: $listOfUsers, key: $key}';
  }
}

/// generated route for
/// [ClientMessagesChatScreen]
class ClientMessagesChatRoute extends PageRouteInfo<ClientMessagesChatRouteArgs> {
  ClientMessagesChatRoute({
    Key? key,
    required String chatId,
    required bool isNew,
    int? expertId,
    FileView? view,
    required String senderName,
    List<PageRouteInfo>? children,
  }) : super(
          ClientMessagesChatRoute.name,
          args: ClientMessagesChatRouteArgs(
            key: key,
            chatId: chatId,
            isNew: isNew,
            expertId: expertId,
            view: view,
            senderName: senderName,
          ),
          initialChildren: children,
        );

  static const String name = 'ClientMessagesChatRoute';

  static const PageInfo<ClientMessagesChatRouteArgs> page = PageInfo<ClientMessagesChatRouteArgs>(name);
}

class ClientMessagesChatRouteArgs {
  const ClientMessagesChatRouteArgs({
    this.key,
    required this.chatId,
    required this.isNew,
    this.expertId,
    this.view,
    required this.senderName,
  });

  final Key? key;

  final String chatId;

  final bool isNew;

  final int? expertId;

  final FileView? view;

  final String senderName;

  @override
  String toString() {
    return 'ClientMessagesChatRouteArgs{key: $key, chatId: $chatId, isNew: $isNew, expertId: $expertId, view: $view, senderName: $senderName}';
  }
}

/// generated route for
/// [ClientMessagesContainerScreen]
class ClientMessagesContainerRoute extends PageRouteInfo<void> {
  const ClientMessagesContainerRoute({List<PageRouteInfo>? children})
      : super(
          ClientMessagesContainerRoute.name,
          initialChildren: children,
        );

  static const String name = 'ClientMessagesContainerRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ClientMessagesMainScreen]
class ClientMessagesMainRoute extends PageRouteInfo<ClientMessagesMainRouteArgs> {
  ClientMessagesMainRoute({
    Key? key,
    int tabIndex = 0,
    List<PageRouteInfo>? children,
  }) : super(
          ClientMessagesMainRoute.name,
          args: ClientMessagesMainRouteArgs(
            key: key,
            tabIndex: tabIndex,
          ),
          initialChildren: children,
        );

  static const String name = 'ClientMessagesMainRoute';

  static const PageInfo<ClientMessagesMainRouteArgs> page = PageInfo<ClientMessagesMainRouteArgs>(name);
}

class ClientMessagesMainRouteArgs {
  const ClientMessagesMainRouteArgs({
    this.key,
    this.tabIndex = 0,
  });

  final Key? key;

  final int tabIndex;

  @override
  String toString() {
    return 'ClientMessagesMainRouteArgs{key: $key, tabIndex: $tabIndex}';
  }
}

/// generated route for
/// [ClientMyDayContainerScreen]
class ClientMyDayContainerRoute extends PageRouteInfo<void> {
  const ClientMyDayContainerRoute({List<PageRouteInfo>? children})
      : super(
          ClientMyDayContainerRoute.name,
          initialChildren: children,
        );

  static const String name = 'ClientMyDayContainerRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ClientMyDayMainScreen]
class ClientMyDayMainRoute extends PageRouteInfo<ClientMyDayMainRouteArgs> {
  ClientMyDayMainRoute({
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          ClientMyDayMainRoute.name,
          args: ClientMyDayMainRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'ClientMyDayMainRoute';

  static const PageInfo<ClientMyDayMainRouteArgs> page = PageInfo<ClientMyDayMainRouteArgs>(name);
}

class ClientMyDayMainRouteArgs {
  const ClientMyDayMainRouteArgs({this.key});

  final Key? key;

  @override
  String toString() {
    return 'ClientMyDayMainRouteArgs{key: $key}';
  }
}

/// generated route for
/// [ClientPhysicalSurveyScreen]
class ClientPhysicalSurveyRoute extends PageRouteInfo<ClientPhysicalSurveyRouteArgs> {
  ClientPhysicalSurveyRoute({
    Key? key,
    required int stepId,
    List<PageRouteInfo>? children,
  }) : super(
          ClientPhysicalSurveyRoute.name,
          args: ClientPhysicalSurveyRouteArgs(
            key: key,
            stepId: stepId,
          ),
          initialChildren: children,
        );

  static const String name = 'ClientPhysicalSurveyRoute';

  static const PageInfo<ClientPhysicalSurveyRouteArgs> page = PageInfo<ClientPhysicalSurveyRouteArgs>(name);
}

class ClientPhysicalSurveyRouteArgs {
  const ClientPhysicalSurveyRouteArgs({
    this.key,
    required this.stepId,
  });

  final Key? key;

  final int stepId;

  @override
  String toString() {
    return 'ClientPhysicalSurveyRouteArgs{key: $key, stepId: $stepId}';
  }
}

/// generated route for
/// [ClientProfileAboutPlatformScreen]
class ClientProfileAboutPlatformRoute extends PageRouteInfo<void> {
  const ClientProfileAboutPlatformRoute({List<PageRouteInfo>? children})
      : super(
          ClientProfileAboutPlatformRoute.name,
          initialChildren: children,
        );

  static const String name = 'ClientProfileAboutPlatformRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ClientProfileEditScreen]
class ClientProfileEditRoute extends PageRouteInfo<void> {
  const ClientProfileEditRoute({List<PageRouteInfo>? children})
      : super(
          ClientProfileEditRoute.name,
          initialChildren: children,
        );

  static const String name = 'ClientProfileEditRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ClientProfileMainScreen]
class ClientProfileMainRoute extends PageRouteInfo<void> {
  const ClientProfileMainRoute({List<PageRouteInfo>? children})
      : super(
          ClientProfileMainRoute.name,
          initialChildren: children,
        );

  static const String name = 'ClientProfileMainRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ClientProfileScreen]
class ClientProfileRoute extends PageRouteInfo<void> {
  const ClientProfileRoute({List<PageRouteInfo>? children})
      : super(
          ClientProfileRoute.name,
          initialChildren: children,
        );

  static const String name = 'ClientProfileRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ClientRecipesCardInfoScreen]
class ClientRecipesCardInfoRoute extends PageRouteInfo<ClientRecipesCardInfoRouteArgs> {
  ClientRecipesCardInfoRoute({
    Key? key,
    required int recipeId,
    bool isFromExpert = false,
    List<PageRouteInfo>? children,
  }) : super(
          ClientRecipesCardInfoRoute.name,
          args: ClientRecipesCardInfoRouteArgs(
            key: key,
            recipeId: recipeId,
            isFromExpert: isFromExpert,
          ),
          initialChildren: children,
        );

  static const String name = 'ClientRecipesCardInfoRoute';

  static const PageInfo<ClientRecipesCardInfoRouteArgs> page = PageInfo<ClientRecipesCardInfoRouteArgs>(name);
}

class ClientRecipesCardInfoRouteArgs {
  const ClientRecipesCardInfoRouteArgs({
    this.key,
    required this.recipeId,
    this.isFromExpert = false,
  });

  final Key? key;

  final int recipeId;

  final bool isFromExpert;

  @override
  String toString() {
    return 'ClientRecipesCardInfoRouteArgs{key: $key, recipeId: $recipeId, isFromExpert: $isFromExpert}';
  }
}

/// generated route for
/// [ClientRecipesMainScreen]
class ClientRecipesMainRoute extends PageRouteInfo<void> {
  const ClientRecipesMainRoute({List<PageRouteInfo>? children})
      : super(
          ClientRecipesMainRoute.name,
          initialChildren: children,
        );

  static const String name = 'ClientRecipesMainRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ClientRecipesSavedListScreen]
class ClientRecipesSavedListRoute extends PageRouteInfo<void> {
  const ClientRecipesSavedListRoute({List<PageRouteInfo>? children})
      : super(
          ClientRecipesSavedListRoute.name,
          initialChildren: children,
        );

  static const String name = 'ClientRecipesSavedListRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ClientRecommendationMainScreen]
class ClientRecommendationMainRoute extends PageRouteInfo<ClientRecommendationMainRouteArgs> {
  ClientRecommendationMainRoute({
    Key? key,
    required bool isFormSurvey,
    List<PageRouteInfo>? children,
  }) : super(
          ClientRecommendationMainRoute.name,
          args: ClientRecommendationMainRouteArgs(
            key: key,
            isFormSurvey: isFormSurvey,
          ),
          initialChildren: children,
        );

  static const String name = 'ClientRecommendationMainRoute';

  static const PageInfo<ClientRecommendationMainRouteArgs> page = PageInfo<ClientRecommendationMainRouteArgs>(name);
}

class ClientRecommendationMainRouteArgs {
  const ClientRecommendationMainRouteArgs({
    this.key,
    required this.isFormSurvey,
  });

  final Key? key;

  final bool isFormSurvey;

  @override
  String toString() {
    return 'ClientRecommendationMainRouteArgs{key: $key, isFormSurvey: $isFormSurvey}';
  }
}

/// generated route for
/// [ClientRecommendationPlatformSingleScreen]
class ClientRecommendationPlatformSingleRoute extends PageRouteInfo<ClientRecommendationPlatformSingleRouteArgs> {
  ClientRecommendationPlatformSingleRoute({
    Key? key,
    required int id,
    required String name,
    required String type,
    List<PageRouteInfo>? children,
  }) : super(
          ClientRecommendationPlatformSingleRoute.name,
          args: ClientRecommendationPlatformSingleRouteArgs(
            key: key,
            id: id,
            name: name,
            type: type,
          ),
          initialChildren: children,
        );

  static const String name = 'ClientRecommendationPlatformSingleRoute';

  static const PageInfo<ClientRecommendationPlatformSingleRouteArgs> page = PageInfo<ClientRecommendationPlatformSingleRouteArgs>(name);
}

class ClientRecommendationPlatformSingleRouteArgs {
  const ClientRecommendationPlatformSingleRouteArgs({
    this.key,
    required this.id,
    required this.name,
    required this.type,
  });

  final Key? key;

  final int id;

  final String name;

  final String type;

  @override
  String toString() {
    return 'ClientRecommendationPlatformSingleRouteArgs{key: $key, id: $id, name: $name, type: $type}';
  }
}

/// generated route for
/// [ClientRecommendationWatchScreen]
class ClientRecommendationWatchRoute extends PageRouteInfo<ClientRecommendationWatchRouteArgs> {
  ClientRecommendationWatchRoute({
    required int id,
    required String name,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          ClientRecommendationWatchRoute.name,
          args: ClientRecommendationWatchRouteArgs(
            id: id,
            name: name,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'ClientRecommendationWatchRoute';

  static const PageInfo<ClientRecommendationWatchRouteArgs> page = PageInfo<ClientRecommendationWatchRouteArgs>(name);
}

class ClientRecommendationWatchRouteArgs {
  const ClientRecommendationWatchRouteArgs({
    required this.id,
    required this.name,
    this.key,
  });

  final int id;

  final String name;

  final Key? key;

  @override
  String toString() {
    return 'ClientRecommendationWatchRouteArgs{id: $id, name: $name, key: $key}';
  }
}

/// generated route for
/// [ClientSensorsActivityScreen]
class ClientSensorsActivityRoute extends PageRouteInfo<void> {
  const ClientSensorsActivityRoute({List<PageRouteInfo>? children})
      : super(
          ClientSensorsActivityRoute.name,
          initialChildren: children,
        );

  static const String name = 'ClientSensorsActivityRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ClientSensorsOxygenInBloodScreen]
class ClientSensorsOxygenInBloodRoute extends PageRouteInfo<void> {
  const ClientSensorsOxygenInBloodRoute({List<PageRouteInfo>? children})
      : super(
          ClientSensorsOxygenInBloodRoute.name,
          initialChildren: children,
        );

  static const String name = 'ClientSensorsOxygenInBloodRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ClientSensorsPressureMainScreen]
class ClientSensorsPressureMainRoute extends PageRouteInfo<void> {
  const ClientSensorsPressureMainRoute({List<PageRouteInfo>? children})
      : super(
          ClientSensorsPressureMainRoute.name,
          initialChildren: children,
        );

  static const String name = 'ClientSensorsPressureMainRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ClientSensorsSleepScreen]
class ClientSensorsSleepRoute extends PageRouteInfo<void> {
  const ClientSensorsSleepRoute({List<PageRouteInfo>? children})
      : super(
          ClientSensorsSleepRoute.name,
          initialChildren: children,
        );

  static const String name = 'ClientSensorsSleepRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ClientSensorsStepsScreen]
class ClientSensorsStepsRoute extends PageRouteInfo<void> {
  const ClientSensorsStepsRoute({List<PageRouteInfo>? children})
      : super(
          ClientSensorsStepsRoute.name,
          initialChildren: children,
        );

  static const String name = 'ClientSensorsStepsRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ClientSensorsSugarInBloodScreen]
class ClientSensorsSugarInBloodRoute extends PageRouteInfo<void> {
  const ClientSensorsSugarInBloodRoute({List<PageRouteInfo>? children})
      : super(
          ClientSensorsSugarInBloodRoute.name,
          initialChildren: children,
        );

  static const String name = 'ClientSensorsSugarInBloodRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ClientSensorsWeightScreen]
class ClientSensorsWeightRoute extends PageRouteInfo<void> {
  const ClientSensorsWeightRoute({List<PageRouteInfo>? children})
      : super(
          ClientSensorsWeightRoute.name,
          initialChildren: children,
        );

  static const String name = 'ClientSensorsWeightRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ClientSetPersonalPlanScreen]
class ClientSetPersonalPlanRoute extends PageRouteInfo<ClientSetPersonalPlanRouteArgs> {
  ClientSetPersonalPlanRoute({
    Key? key,
    required int height,
    required int weight,
    List<PageRouteInfo>? children,
  }) : super(
          ClientSetPersonalPlanRoute.name,
          args: ClientSetPersonalPlanRouteArgs(
            key: key,
            height: height,
            weight: weight,
          ),
          initialChildren: children,
        );

  static const String name = 'ClientSetPersonalPlanRoute';

  static const PageInfo<ClientSetPersonalPlanRouteArgs> page = PageInfo<ClientSetPersonalPlanRouteArgs>(name);
}

class ClientSetPersonalPlanRouteArgs {
  const ClientSetPersonalPlanRouteArgs({
    this.key,
    required this.height,
    required this.weight,
  });

  final Key? key;

  final int height;

  final int weight;

  @override
  String toString() {
    return 'ClientSetPersonalPlanRouteArgs{key: $key, height: $height, weight: $weight}';
  }
}

/// generated route for
/// [ClientSetTargetScreen]
class ClientSetTargetRoute extends PageRouteInfo<void> {
  const ClientSetTargetRoute({List<PageRouteInfo>? children})
      : super(
          ClientSetTargetRoute.name,
          initialChildren: children,
        );

  static const String name = 'ClientSetTargetRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ClientSetTargetWeightScreen]
class ClientSetTargetWeightRoute extends PageRouteInfo<ClientSetTargetWeightRouteArgs> {
  ClientSetTargetWeightRoute({
    Key? key,
    required List<NextStep> nextStep,
    List<PageRouteInfo>? children,
  }) : super(
          ClientSetTargetWeightRoute.name,
          args: ClientSetTargetWeightRouteArgs(
            key: key,
            nextStep: nextStep,
          ),
          initialChildren: children,
        );

  static const String name = 'ClientSetTargetWeightRoute';

  static const PageInfo<ClientSetTargetWeightRouteArgs> page = PageInfo<ClientSetTargetWeightRouteArgs>(name);
}

class ClientSetTargetWeightRouteArgs {
  const ClientSetTargetWeightRouteArgs({
    this.key,
    required this.nextStep,
  });

  final Key? key;

  final List<NextStep> nextStep;

  @override
  String toString() {
    return 'ClientSetTargetWeightRouteArgs{key: $key, nextStep: $nextStep}';
  }
}

/// generated route for
/// [ClientSurveyAllInfoScreen]
class ClientSurveyAllInfoRoute extends PageRouteInfo<ClientSurveyAllInfoRouteArgs> {
  ClientSurveyAllInfoRoute({
    required int stepId,
    QuizItem? quizzes,
    List<int>? resultIds,
    bool isFromBranching = false,
    required String targetType,
    int? branchingCurrentStep,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          ClientSurveyAllInfoRoute.name,
          args: ClientSurveyAllInfoRouteArgs(
            stepId: stepId,
            quizzes: quizzes,
            resultIds: resultIds,
            isFromBranching: isFromBranching,
            targetType: targetType,
            branchingCurrentStep: branchingCurrentStep,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'ClientSurveyAllInfoRoute';

  static const PageInfo<ClientSurveyAllInfoRouteArgs> page = PageInfo<ClientSurveyAllInfoRouteArgs>(name);
}

class ClientSurveyAllInfoRouteArgs {
  const ClientSurveyAllInfoRouteArgs({
    required this.stepId,
    this.quizzes,
    this.resultIds,
    this.isFromBranching = false,
    required this.targetType,
    this.branchingCurrentStep,
    this.key,
  });

  final int stepId;

  final QuizItem? quizzes;

  final List<int>? resultIds;

  final bool isFromBranching;

  final String targetType;

  final int? branchingCurrentStep;

  final Key? key;

  @override
  String toString() {
    return 'ClientSurveyAllInfoRouteArgs{stepId: $stepId, quizzes: $quizzes, resultIds: $resultIds, isFromBranching: $isFromBranching, targetType: $targetType, branchingCurrentStep: $branchingCurrentStep, key: $key}';
  }
}

/// generated route for
/// [ClientSurveyBalanceWheelScreen]
class ClientSurveyBalanceWheelRoute extends PageRouteInfo<void> {
  const ClientSurveyBalanceWheelRoute({List<PageRouteInfo>? children})
      : super(
          ClientSurveyBalanceWheelRoute.name,
          initialChildren: children,
        );

  static const String name = 'ClientSurveyBalanceWheelRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ClientSurveyBranchingScreen]
class ClientSurveyBranchingRoute extends PageRouteInfo<ClientSurveyBranchingRouteArgs> {
  ClientSurveyBranchingRoute({
    Key? key,
    required int stepId,
    required String targetType,
    List<PageRouteInfo>? children,
  }) : super(
          ClientSurveyBranchingRoute.name,
          args: ClientSurveyBranchingRouteArgs(
            key: key,
            stepId: stepId,
            targetType: targetType,
          ),
          initialChildren: children,
        );

  static const String name = 'ClientSurveyBranchingRoute';

  static const PageInfo<ClientSurveyBranchingRouteArgs> page = PageInfo<ClientSurveyBranchingRouteArgs>(name);
}

class ClientSurveyBranchingRouteArgs {
  const ClientSurveyBranchingRouteArgs({
    this.key,
    required this.stepId,
    required this.targetType,
  });

  final Key? key;

  final int stepId;

  final String targetType;

  @override
  String toString() {
    return 'ClientSurveyBranchingRouteArgs{key: $key, stepId: $stepId, targetType: $targetType}';
  }
}

/// generated route for
/// [ClientSurveyDoneScreen]
class ClientSurveyDoneRoute extends PageRouteInfo<ClientSurveyDoneRouteArgs> {
  ClientSurveyDoneRoute({
    Key? key,
    required List<QuestionItem> questions,
    required int surveyId,
    List<PageRouteInfo>? children,
  }) : super(
          ClientSurveyDoneRoute.name,
          args: ClientSurveyDoneRouteArgs(
            key: key,
            questions: questions,
            surveyId: surveyId,
          ),
          initialChildren: children,
        );

  static const String name = 'ClientSurveyDoneRoute';

  static const PageInfo<ClientSurveyDoneRouteArgs> page = PageInfo<ClientSurveyDoneRouteArgs>(name);
}

class ClientSurveyDoneRouteArgs {
  const ClientSurveyDoneRouteArgs({
    this.key,
    required this.questions,
    required this.surveyId,
  });

  final Key? key;

  final List<QuestionItem> questions;

  final int surveyId;

  @override
  String toString() {
    return 'ClientSurveyDoneRouteArgs{key: $key, questions: $questions, surveyId: $surveyId}';
  }
}

/// generated route for
/// [ClientSurveyMainScreen]
class ClientSurveyMainRoute extends PageRouteInfo<void> {
  const ClientSurveyMainRoute({List<PageRouteInfo>? children})
      : super(
          ClientSurveyMainRoute.name,
          initialChildren: children,
        );

  static const String name = 'ClientSurveyMainRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ClientSurveyWatchScreen]
class ClientSurveyWatchRoute extends PageRouteInfo<ClientSurveyWatchRouteArgs> {
  ClientSurveyWatchRoute({
    required int surveyId,
    required int id,
    int? expertId,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          ClientSurveyWatchRoute.name,
          args: ClientSurveyWatchRouteArgs(
            surveyId: surveyId,
            id: id,
            expertId: expertId,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'ClientSurveyWatchRoute';

  static const PageInfo<ClientSurveyWatchRouteArgs> page = PageInfo<ClientSurveyWatchRouteArgs>(name);
}

class ClientSurveyWatchRouteArgs {
  const ClientSurveyWatchRouteArgs({
    required this.surveyId,
    required this.id,
    this.expertId,
    this.key,
  });

  final int surveyId;

  final int id;

  final int? expertId;

  final Key? key;

  @override
  String toString() {
    return 'ClientSurveyWatchRouteArgs{surveyId: $surveyId, id: $id, expertId: $expertId, key: $key}';
  }
}

/// generated route for
/// [ClientTargetMainScreen]
class ClientTargetMainRoute extends PageRouteInfo<void> {
  const ClientTargetMainRoute({List<PageRouteInfo>? children})
      : super(
          ClientTargetMainRoute.name,
          initialChildren: children,
        );

  static const String name = 'ClientTargetMainRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ClientWaterMainScreen]
class ClientWaterMainRoute extends PageRouteInfo<ClientWaterMainRouteArgs> {
  ClientWaterMainRoute({
    Key? key,
    String? isFromFoodDiary,
    List<PageRouteInfo>? children,
  }) : super(
          ClientWaterMainRoute.name,
          args: ClientWaterMainRouteArgs(
            key: key,
            isFromFoodDiary: isFromFoodDiary,
          ),
          initialChildren: children,
        );

  static const String name = 'ClientWaterMainRoute';

  static const PageInfo<ClientWaterMainRouteArgs> page = PageInfo<ClientWaterMainRouteArgs>(name);
}

class ClientWaterMainRouteArgs {
  const ClientWaterMainRouteArgs({
    this.key,
    this.isFromFoodDiary,
  });

  final Key? key;

  final String? isFromFoodDiary;

  @override
  String toString() {
    return 'ClientWaterMainRouteArgs{key: $key, isFromFoodDiary: $isFromFoodDiary}';
  }
}

/// generated route for
/// [DashboardContainerExpertPage]
class DashboardContainerExpertRoute extends PageRouteInfo<void> {
  const DashboardContainerExpertRoute({List<PageRouteInfo>? children})
      : super(
          DashboardContainerExpertRoute.name,
          initialChildren: children,
        );

  static const String name = 'DashboardContainerExpertRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [DashboardContainerPage]
class DashboardContainerRoute extends PageRouteInfo<void> {
  const DashboardContainerRoute({List<PageRouteInfo>? children})
      : super(
          DashboardContainerRoute.name,
          initialChildren: children,
        );

  static const String name = 'DashboardContainerRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ImageViewerScreen]
class ImageViewerRoute extends PageRouteInfo<ImageViewerRouteArgs> {
  ImageViewerRoute({
    Key? key,
    required String type,
    String? fileId,
    required String name,
    dynamic isDownload = false,
    required Uint8List? file,
    List<PageRouteInfo>? children,
  }) : super(
          ImageViewerRoute.name,
          args: ImageViewerRouteArgs(
            key: key,
            type: type,
            fileId: fileId,
            name: name,
            isDownload: isDownload,
            file: file,
          ),
          initialChildren: children,
        );

  static const String name = 'ImageViewerRoute';

  static const PageInfo<ImageViewerRouteArgs> page = PageInfo<ImageViewerRouteArgs>(name);
}

class ImageViewerRouteArgs {
  const ImageViewerRouteArgs({
    this.key,
    required this.type,
    this.fileId,
    required this.name,
    this.isDownload = false,
    required this.file,
  });

  final Key? key;

  final String type;

  final String? fileId;

  final String name;

  final dynamic isDownload;

  final Uint8List? file;

  @override
  String toString() {
    return 'ImageViewerRouteArgs{key: $key, type: $type, fileId: $fileId, name: $name, isDownload: $isDownload, file: $file}';
  }
}

/// generated route for
/// [PdfViewerScreen]
class PdfViewerRoute extends PageRouteInfo<PdfViewerRouteArgs> {
  PdfViewerRoute({
    Key? key,
    required String? pathPDF,
    required String name,
    String? fileId,
    required String type,
    bool isDownload = false,
    List<PageRouteInfo>? children,
  }) : super(
          PdfViewerRoute.name,
          args: PdfViewerRouteArgs(
            key: key,
            pathPDF: pathPDF,
            name: name,
            fileId: fileId,
            type: type,
            isDownload: isDownload,
          ),
          initialChildren: children,
        );

  static const String name = 'PdfViewerRoute';

  static const PageInfo<PdfViewerRouteArgs> page = PageInfo<PdfViewerRouteArgs>(name);
}

class PdfViewerRouteArgs {
  const PdfViewerRouteArgs({
    this.key,
    required this.pathPDF,
    required this.name,
    this.fileId,
    required this.type,
    this.isDownload = false,
  });

  final Key? key;

  final String? pathPDF;

  final String name;

  final String? fileId;

  final String type;

  final bool isDownload;

  @override
  String toString() {
    return 'PdfViewerRouteArgs{key: $key, pathPDF: $pathPDF, name: $name, fileId: $fileId, type: $type, isDownload: $isDownload}';
  }
}

/// generated route for
/// [RootScreen]
class RootRoute extends PageRouteInfo<void> {
  const RootRoute({List<PageRouteInfo>? children})
      : super(
          RootRoute.name,
          initialChildren: children,
        );

  static const String name = 'RootRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SplashMotivationScreen]
class SplashMotivationRoute extends PageRouteInfo<void> {
  const SplashMotivationRoute({List<PageRouteInfo>? children})
      : super(
          SplashMotivationRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashMotivationRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}
