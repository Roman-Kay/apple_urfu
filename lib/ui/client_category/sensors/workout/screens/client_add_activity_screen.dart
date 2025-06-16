import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garnetbook/bloc/client/profile/client_profile_bloc.dart';
import 'package:garnetbook/data/models/client/activity/activity_request.dart';
import 'package:garnetbook/domain/analytics/service_analytics.dart';
import 'package:garnetbook/domain/services/sensors/sensors_sevice.dart';
import 'package:garnetbook/widgets/bottom_align.dart/bottom_align.dart';
import 'package:garnetbook/widgets/buttons/form_for_button.dart';
import 'package:garnetbook/widgets/buttons/widget_button.dart';
import 'package:garnetbook/widgets/loaders/progress_indicator.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter_svg/svg.dart';
import 'package:garnetbook/data/repository/health_repository.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/utils/images.dart';
import 'package:garnetbook/widgets/text_field/custom_textfiled_label.dart';

@RoutePage()
class ClientAddActivityScreen extends StatefulWidget {
  const ClientAddActivityScreen({super.key, required this.date});
  final DateTime date;

  @override
  State<ClientAddActivityScreen> createState() => _ClientAddActivityScreenState();
}

class _ClientAddActivityScreenState extends State<ClientAddActivityScreen> {
  bool activityListShow = false;
  String chooseActivity = '';
  final List<String> activityNames = HealthRepository().activity;
  List<String> sortedFromSearchList = [];
  String chooseWellBeing = 'Нормальное';
  int calorieBurned = 0;
  bool validation = false;
  DateTime selectDate = DateTime.now();
  final healthRepository = HealthRepository();

  int weight = 1;
  double heightTopBar = 0;
  String activity = "";
  bool isCategoryOpen = false;

  TextEditingController durationController = TextEditingController();
  TextEditingController activityController = TextEditingController();
  double heightSafeArea = 0;

  @override
  void initState() {
    sortedFromSearchList = activityNames;
    if (BlocProvider.of<ClientProfileCubit>(context).state is ClientProfileLoadedState) {
    } else {
      context.read<ClientProfileCubit>().check();
    }
    super.initState();
  }

  @override
  void dispose() {
    durationController.dispose();
    activityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.focusedChild?.unfocus();
        }
        if (isCategoryOpen) {
          setState(() {
            isCategoryOpen = false;
          });
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.basicwhiteColor,
        body: SafeArea(
          child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
            if (heightSafeArea < constraints.maxHeight) {
              heightSafeArea = constraints.maxHeight;
            }
              return Stack(
                children: [
                  BlocBuilder<ClientProfileCubit, ClientProfileState>(builder: (context, state) {
                    if (state is ClientProfileLoadingState) {
                      return SizedBox(height: MediaQuery.of(context).size.height / 1.2, child: ProgressIndicatorWidget());
                    }
                    getUserWeight(state);

                    return RefreshIndicator(
                      color: AppColors.darkGreenColor,
                      onRefresh: () {
                        context.read<ClientProfileCubit>().check();
                        return Future.delayed(const Duration(seconds: 1));
                      },
                      child: SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 14.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 56.h + 20.h),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Введите данные',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14.sp,
                                    fontFamily: 'Inter',
                                    color: AppColors.darkGreenColor,
                                  ),
                                ),
                              ),
                              SizedBox(height: 16.h),
                              CustomTextFieldLabel(
                                controller: activityController,
                                onTap: () {
                                  FocusScope.of(context).requestFocus(FocusNode());
                                  setState(() {
                                    isCategoryOpen = !isCategoryOpen;
                                  });
                                },
                                enabled: false,
                                labelText: 'Выбрать активность',
                                labelColor: AppColors.vivaMagentaColor,
                                borderColor: validation && activityController.text.isEmpty ? AppColors.vivaMagentaColor : AppColors.grey30Color,
                                backGroudColor: AppColors.grey10Color,
                                icon: SvgPicture.asset(
                                  'assets/images/search.svg',
                                  color: AppColors.vivaMagentaColor,
                                ),
                              ),
                              Visibility(
                                visible: isCategoryOpen,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 12),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Material(
                                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                                      elevation: 2,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(
                                            width: 1,
                                            color: AppColors.grey30Color,
                                          ),
                                          color: AppColors.grey10Color,
                                        ),
                                        child: ConstrainedBox(
                                          constraints: BoxConstraints(
                                              maxHeight: 250,
                                              minHeight: 50,
                                              maxWidth: 375.w - 28.w
                                          ),
                                          child: ListView.builder(
                                            scrollDirection: Axis.vertical,
                                            shrinkWrap: true,
                                            itemCount: activityNames.length,
                                            itemBuilder: (context, index) {
                                              return FormForButton(
                                                borderRadius: BorderRadius.only(
                                                  topRight: index == 0 ? Radius.circular(10) : Radius.zero,
                                                  topLeft: index == 0 ? Radius.circular(10) : Radius.zero,
                                                  bottomRight: index + 1 == activityNames.length ? Radius.circular(10) : Radius.zero,
                                                  bottomLeft: index + 1 == activityNames.length ? Radius.circular(10) : Radius.zero,
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    activityController.text = activityNames[index];
                                                    isCategoryOpen = false;
                                                    if (validation) {
                                                      validation = false;
                                                    }
                                                  });
                                                  calculateCalorie(durationController, activityController);
                                                },
                                                child: Column(
                                                  children: [
                                                    SizedBox(height: 12.h),
                                                    Padding(
                                                      padding: EdgeInsets.symmetric(horizontal: 14.w),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Flexible(
                                                            child: Text(
                                                              activityNames[index],
                                                              style: TextStyle(
                                                                fontFamily: 'Inter',
                                                                color: activityController.text == activityNames[index] ? AppColors.vivaMagentaColor : AppColors.darkGreenColor,
                                                                fontSize: 16.sp,
                                                                fontWeight: FontWeight.w400,
                                                              ),
                                                            ),
                                                          ),
                                                          if (activityController.text == activityNames[index])
                                                            CircleAvatar(
                                                              radius: 10.r,
                                                              backgroundColor: AppColors.vivaMagentaColor,
                                                              child: Center(
                                                                child: SvgPicture.asset(
                                                                  'assets/images/checkmark.svg',
                                                                  color: AppColors.basicwhiteColor,
                                                                  height: 14.h,
                                                                ),
                                                              ),
                                                            ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(height: 12.h),
                                                    if(index + 1 != activityNames.length)
                                                      Container(
                                                        color: AppColors.seaColor,
                                                        height: 1,
                                                      ),
                                                  ],
                                                ),
                                              );
                                            },

                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 16.h),
                              CustomTextFieldLabel(
                                controller: durationController,
                                labelText: 'Продолжительность, мин',
                                enabled: true,
                                maxLength: 4,
                                listMaskTextInputFormatter: [FilteringTextInputFormatter.allow(RegExp(r'^[0-9]*$'))],
                                onChanged: (value) {
                                  if (validation) {
                                    setState(() {
                                      validation = false;
                                    });
                                  }
                                  calculateCalorie(durationController, activityController);
                                },
                                keyboardType: TextInputType.number,
                                borderColor: validation && durationController.text.isEmpty ? AppColors.vivaMagentaColor : AppColors.grey30Color,
                                backGroudColor: AppColors.grey10Color,
                                labelColor: AppColors.vivaMagentaColor,
                              ),
                              SizedBox(height: 40.h),
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/images/energy.svg',
                                    width: 40.w,
                                    height: 40.h,
                                  ),
                                  SizedBox(width: 8.w),
                                  Text(
                                    'Затраченная энергия',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      color: AppColors.basicblackColor,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    calorieBurned.toString() + " ккал",
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      color: AppColors.vivaMagentaColor,
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(width: 6.w),
                                ],
                              ),
                              SizedBox(height: 8.h),
                              Container(
                                width: double.infinity,
                                height: 1,
                                color: AppColors.grey40Color,
                              ),
                              SizedBox(height: 10.h),
                              Text(
                                'Количество израсходованной энергии рассчитывается \nавтоматически',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  color: AppColors.darkGreenColor,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(height: 36.h),
                              Text(
                                'Оцените своё самочувствие:',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  color: AppColors.darkGreenColor,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 20.h),
                              Container(
                                height: 44.h,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.r),
                                  gradient: AppColors.gradientSecond,
                                ),
                                child: Stack(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                                      child: AnimatedAlign(
                                        duration: Duration(milliseconds: 100),
                                        alignment: chooseWellBeing == 'Плохое'
                                            ? Alignment.centerLeft
                                            : chooseWellBeing == 'Нормальное'
                                                ? Alignment.center
                                                : Alignment.centerRight,
                                        child: Container(
                                          height: 36.h,
                                          width: (375.w - 28.w - 8.w) / 3,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(9.r),
                                            color: AppColors.basicwhiteColor,
                                            boxShadow: [
                                              BoxShadow(
                                                blurRadius: 10,
                                                color: AppColors.basicblackColor.withOpacity(0.1),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: (375.w - 28.w - 8.w) / 3,
                                            height: 36.h,
                                            child: FormForButton(
                                              borderRadius: BorderRadius.circular(8.r),
                                              onPressed: () => setState(() {
                                                chooseWellBeing == 'Плохое' ? chooseWellBeing = '' : chooseWellBeing = 'Плохое';
                                              }),
                                              child: Center(
                                                child: Text(
                                                  'Плохое',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 14.sp,
                                                    height: 1,
                                                    fontFamily: 'Inter',
                                                    color: AppColors.darkGreenColor,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: (375.w - 28.w - 8.w) / 3,
                                            height: 36.h,
                                            child: FormForButton(
                                              borderRadius: BorderRadius.circular(8.r),
                                              onPressed: () => setState(() {
                                                chooseWellBeing == 'Нормальное' ? chooseWellBeing = '' : chooseWellBeing = 'Нормальное';
                                              }),
                                              child: Center(
                                                child: Text(
                                                  'Нормальное',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 14.sp,
                                                    height: 1,
                                                    fontFamily: 'Inter',
                                                    color: AppColors.darkGreenColor,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: (375.w - 28.w - 8.w) / 3,
                                            height: 36.h,
                                            child: FormForButton(
                                              borderRadius: BorderRadius.circular(8.r),
                                              onPressed: () => setState(() {
                                                chooseWellBeing == 'Отличное' ? chooseWellBeing = '' : chooseWellBeing = 'Отличное';
                                              }),
                                              child: Center(
                                                child: Text(
                                                  'Отличное',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 14.sp,
                                                    height: 1,
                                                    fontFamily: 'Inter',
                                                    color: AppColors.darkGreenColor,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 70.h),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                  Container(
                    width: double.infinity,
                    height: 56.h,
                    color: AppColors.basicwhiteColor,
                    child: Container(
                      width: double.infinity,
                      height: 56.h,
                      decoration: BoxDecoration(
                        gradient: AppColors.gradientTurquoise,
                      ),
                      child: Center(
                        child: SizedBox(
                          width: double.infinity,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: IconButton(
                                  onPressed: () => context.router.maybePop(),
                                  icon: Image.asset(
                                    AppImeges.arrow_back_png,
                                    color: AppColors.darkGreenColor,
                                    height: 25.h,
                                    width: 25.w,
                                  ),
                                ),
                              ),
                              Text(
                                'Добавить активность',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20.sp,
                                  fontFamily: 'Inter',
                                  color: AppColors.darkGreenColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  BottomAlign(
                    child: Container(
                      color: AppColors.basicwhiteColor,
                      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 16.h),
                      child: WidgetButton(
                        onTap: () async {
                          FocusScope.of(context).unfocus();

                          if (activityController.text.isNotEmpty && durationController.text.isNotEmpty) {
                            int time = int.parse(durationController.text);

                            if (time == 0) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  duration: Duration(seconds: 3),
                                  content: Text(
                                    'Введите коректное значение: продолжительность',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14.sp,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                ),
                              );
                              return;
                            }
                            else {
                              context.loaderOverlay.show();

                              int? activityId;

                              DateTime startDate = DateTime(widget.date.year, widget.date.month, widget.date.day);

                              for (var element in healthRepository.activityFromServer) {
                                if (element.name == activityController.text) {
                                  activityId = element.id;
                                  break;
                                }
                              }

                              final response = await SensorsService().setSensorsActivity(ClientActivityRequest(
                                  calories: calorieBurned,
                                  activityDate: DateFormat("yyyy-MM-dd").format(startDate),
                                  activityId: activityId,
                                  health: chooseWellBeing,
                                  durationMi: int.parse(durationController.text)));

                              if (response.result) {
                                GetIt.I.get<ServiceAnalytics>().setEvent(AnalyticsEvents.addWorkoutActivityClient);

                                context.loaderOverlay.hide();
                                context.router.maybePop(true);
                              } else {
                                context.loaderOverlay.hide();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    duration: Duration(seconds: 3),
                                    content: Text(
                                      'Произошла ошибка. Попробуйте повторить позже',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14.sp,
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                  ),
                                );
                              }
                            }
                          } else {
                            setState(() {
                              validation = true;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                duration: Duration(seconds: 3),
                                content: Text(
                                  'Введите значения',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14.sp,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                        boxShadow: true,
                        color: AppColors.darkGreenColor,
                        child: Text(
                          'готово'.toUpperCase(),
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Inter',
                            color: AppColors.basicwhiteColor,
                          ),
                        ),
                      ),
                    ),
                    heightOfChild: 96.h,
                    heightSafeArea: heightSafeArea,
                  ),
                ],
              );
            }
          ),
        ),
      ),
    );
  }

  getUserWeight(state) {
    if (state is ClientProfileLoadedState) {
      if (state.response?.weight != null) {
        weight = state.response!.weight!;
      }
    }
  }

  calculateCalorie(userTime, activity) {
    if (userTime.text.isNotEmpty && activity.text.isNotEmpty) {
      int time = int.parse(userTime.text);
      double loadIndex = healthRepository.getLoadIndex(activity.text);

      setState(() {
        calorieBurned = (loadIndex * weight * time).toInt();
      });
    } else if (calorieBurned != 0) {
      setState(() {
        calorieBurned = 0;
      });
    }
  }

  Widget container(String text, Color color) {
    return Container(
      child: Container(
        height: 36.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.r),
          color: color,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 12.sp,
                fontFamily: 'Inter',
                color: AppColors.basicwhiteColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
