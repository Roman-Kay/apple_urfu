import 'package:auto_route/auto_route.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:garnetbook/bloc/client/target/target_bloc.dart';
import 'package:garnetbook/bloc/user/user_data_cubit.dart';
import 'package:garnetbook/data/models/client/target/target_view_model.dart';
import 'package:garnetbook/ui/routing/app_router.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/widgets/error_handler/error_reload.dart';
import 'package:garnetbook/widgets/graphics/target_line_chart.dart';
import 'package:garnetbook/widgets/percents/prosent_bar_second.dart';
import 'package:garnetbook/widgets/percents/target_prosent_item.dart';

@RoutePage()
class AuthRegisterClientFourthScreen extends StatefulWidget {
  const AuthRegisterClientFourthScreen({super.key});

  @override
  State<AuthRegisterClientFourthScreen> createState() => _AuthRegisterClientFourthScreenState();
}

class _AuthRegisterClientFourthScreenState extends State<AuthRegisterClientFourthScreen> with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserDataCubit()..check(),
      child: BlocBuilder<UserDataCubit, UserDataState>(builder: (context, userState) {
        return Scaffold(
          body: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(gradient: AppColors.backgroundgradientColor),
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 7.w, top: 199.h),
                    child: SizedBox(
                      height: 83.h,
                      width: 65.w,
                      child: Image.asset(
                        'assets/images/ananas.webp',
                        fit: BoxFit.fill,
                        color: Colors.white24,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 200.h, left: 246.w),
                    child: SizedBox(
                      height: 83.h,
                      width: 83.w,
                      child: Image.asset(
                        'assets/images/ananas2.webp',
                        fit: BoxFit.fill,
                        color: Color(0xFFFFFFFF),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 566.h, left: 246.w),
                    child: SizedBox(
                      height: 83.h,
                      width: 65.w,
                      child: Image.asset(
                        'assets/images/ananas1.webp',
                        fit: BoxFit.fill,
                        color: Colors.white24,
                      ),
                    ),
                  ),
                  BlocBuilder<TargetBloc, TargetState>(builder: (context, state) {
                    if (state is TargetLoadedState) {
                      if (state.view != null && state.view!.isNotEmpty) {
                        if (state.view!.first.target != null && state.view!.first.target!.name == "Удерживать вес") {
                          return Column(
                            children: [
                              SizedBox(height: 60.h),
                              Container(
                                height: 90,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  gradient: AppColors.gradientTurquoiseReverse,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                                  child: ShaderMask(
                                    shaderCallback: (Rect rect) {
                                      return AppColors.whitegradientColor.createShader(rect);
                                    },
                                    child: FittedBox(
                                      child: Text(
                                        userState is UserDataLoadedState && userState.user?.firstName != null
                                            ? '${userState.user?.firstName}, персональный\nпуть к здоровью готов!'
                                            : 'Ваш персональный путь\nк здоровью готов!',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 24.sp,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.darkGreenColor,
                                          fontFamily: 'Inter',
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 26.h),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: Text(
                                  'Поздравляем, у вас отличные показатели!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.darkGreenColor,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ),
                              SizedBox(height: 25.h),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 14.w),
                                child: Column(
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8.r),
                                        color: AppColors.basicwhiteColor,
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(16.r),
                                        child: Text(
                                          'Для успешного достижения и удержания цели, формирования полезных привычек, рекомендуем:',
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w400,
                                            color: Color(0xFF00817D),
                                            fontFamily: 'Inter',
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 16.h),
                                    Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8.r),
                                        color: AppColors.lightGreenColor,
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.grey50Color.withOpacity(0.2),
                                            spreadRadius: 5,
                                            blurRadius: 7,
                                            offset: Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(16.r),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Получить персональную\nрекомендацию',
                                              style: TextStyle(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFF00817D),
                                                fontFamily: 'Inter',
                                              ),
                                            ),
                                            Icon(
                                              Icons.arrow_forward_ios,
                                              size: 20.r,
                                              color: AppColors.darkGreenColor,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 16.h),
                                    Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8.r),
                                        color: AppColors.limeColor,
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.grey50Color.withOpacity(0.2),
                                            spreadRadius: 5,
                                            blurRadius: 7,
                                            offset: Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          minimumSize: Size.zero,
                                          padding: EdgeInsets.zero,
                                          side: BorderSide(
                                            width: 0,
                                            color: Color(0x000000),
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8.r),
                                          ),
                                        ),
                                        onPressed: () {
                                          context.router.push(AuthPaidSubscriptionRoute());
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.all(16.r),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Отслеживать приёмы пищи',
                                                    style: TextStyle(
                                                      fontSize: 16.sp,
                                                      fontWeight: FontWeight.w600,
                                                      color: Color(0xFF00817D),
                                                      fontFamily: 'Inter',
                                                    ),
                                                  ),
                                                  Text(
                                                    'Опция доступна по подписке',
                                                    style: TextStyle(
                                                      fontSize: 14.sp,
                                                      fontWeight: FontWeight.w500,
                                                      color: AppColors.vivaMagentaColor,
                                                      fontFamily: 'Inter',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Icon(
                                                Icons.arrow_forward_ios,
                                                size: 20.r,
                                                color: AppColors.darkGreenColor,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 16.h),
                                    Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8.r),
                                        color: AppColors.seaColor,
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.grey50Color.withOpacity(0.2),
                                            spreadRadius: 5,
                                            blurRadius: 7,
                                            offset: Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(16.r),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Отслеживать потребление воды\nпо персональной формуле',
                                              style: TextStyle(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFF00817D),
                                                fontFamily: 'Inter',
                                              ),
                                            ),
                                            Icon(
                                              Icons.arrow_forward_ios,
                                              size: 20.r,
                                              color: AppColors.darkGreenColor,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 16.h),
                                    Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8.r),
                                        color: AppColors.lightGreenColor,
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.grey50Color.withOpacity(0.2),
                                            spreadRadius: 5,
                                            blurRadius: 7,
                                            offset: Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(16.r),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Соблюдать персональные\nрекомендациипо расчёту КБМ',
                                              style: TextStyle(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFF00817D),
                                                fontFamily: 'Inter',
                                              ),
                                            ),
                                            Icon(
                                              Icons.arrow_forward_ios,
                                              size: 20.r,
                                              color: AppColors.darkGreenColor,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 16.h),
                                    Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8.r),
                                        color: AppColors.limeColor,
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.grey50Color.withOpacity(0.2),
                                            spreadRadius: 5,
                                            blurRadius: 7,
                                            offset: Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(16.r),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Используйте трекеры для\nсоблюдения и поддержания\nрежима',
                                              style: TextStyle(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFF00817D),
                                                fontFamily: 'Inter',
                                              ),
                                            ),
                                            Icon(
                                              Icons.arrow_forward_ios,
                                              size: 20.r,
                                              color: AppColors.darkGreenColor,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 28.h),
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Источники рекомендаций',
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w400,
                                            color: AppColors.darkGreenColor,
                                            decoration: TextDecoration.underline,
                                            fontFamily: 'Inter',
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 40.h),
                                    SizedBox(
                                      height: 260.w,
                                      child: Image.asset(
                                        'assets/images/chart.webp',
                                        width: 260.w,
                                      ),
                                    ),
                                    SizedBox(height: 16.h),
                                    if (state.view?.first.calories != null)
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Калории',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 16.sp,
                                                fontFamily: 'Inter',
                                                color: AppColors.darkGreenColor,
                                              ),
                                            ),
                                            Text(
                                              state.view?.first.calories.toString() ?? "",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 18.sp,
                                                fontFamily: 'Inter',
                                                color: AppColors.darkGreenColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    SizedBox(height: 8.h),
                                    Container(
                                      width: double.infinity,
                                      height: 1.h,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Color(0xFFFFFFFF),
                                            Color(0xFFE3FFF2),
                                            Color(0xFFAEE5E2),
                                          ],
                                        ),
                                      ),
                                    ),
                                    TargetPercentItem(
                                      text: 'Углеводы',
                                      percent: 50,
                                      colorCircleAvatar: AppColors.darkGreenColor,
                                    ),
                                    TargetPercentItem(
                                      text: 'Жиры',
                                      percent: 30,
                                      colorCircleAvatar: AppColors.vivaMagentaColor,
                                    ),
                                    TargetPercentItem(
                                      text: 'Белки',
                                      percent: 20,
                                      colorCircleAvatar: AppColors.basicwhiteColor,
                                    ),
                                    SizedBox(height: 24.h),
                                    Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8.r),
                                        gradient: AppColors.gradientTurquoiseReverse,
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(16.w),
                                        child: Text(
                                          'Для достижения здорового веса и поддержания его необходимо соблюдать правильное питание и регулярно заниматься физическими упражнениями.\n\nВажно помнить, что похудение должно быть постепенным и основываться на здоровом подходе к снижению веса.',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14.sp,
                                            fontFamily: 'Inter',
                                            color: AppColors.darkGreenColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 24.h),
                                    Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8.r),
                                        color: AppColors.basicwhiteColor,
                                      ),
                                      child: OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          minimumSize: Size.zero,
                                          padding: EdgeInsets.zero,
                                          side: BorderSide(
                                            width: 0,
                                            color: Color(0x000000),
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8.r),
                                          ),
                                        ),
                                        onPressed: () {
                                          // context.router.push(AdvertisingMainRoute());
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 16.w,
                                            vertical: 8.h,
                                          ),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 100.w,
                                                height: 83.h,
                                                child: Image.asset(
                                                  'assets/images/granat_photo.webp',
                                                ),
                                              ),
                                              SizedBox(width: 20.w),
                                              SizedBox(
                                                width: 193.w,
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      'С нами вы можете больше!',
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: 20.sp,
                                                        fontFamily: 'Inter',
                                                        color: AppColors.darkGreenColor,
                                                      ),
                                                    ),
                                                    SizedBox(height: 8.h),
                                                    Text(
                                                      'Подписки - это возможность получить доступ ко всем преимуществам',
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.w400,
                                                        fontSize: 10.sp,
                                                        fontFamily: 'Inter',
                                                        color: AppColors.grey60Color,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 24.h),
                                    SizedBox(
                                      height: 64.h,
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor: const MaterialStatePropertyAll(
                                            AppColors.darkGreenColor,
                                          ),
                                          shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.r)))),
                                        ),
                                        onPressed: () async {
                                          await context.router.pushAndPopUntil(
                                            const DashboardContainerRoute(),
                                            predicate: (_) => false,
                                          );
                                          // context.router.replaceAll([
                                          //   DashboardContainerPageRoute()
                                          // ]);
                                        },
                                        child: Text(
                                          'Готово'.toUpperCase(),
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            color: AppColors.basicwhiteColor,
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 32.h),
                                  ],
                                ),
                              ),
                            ],
                          );
                        } else {
                          List<FlSpot> userSpots = getTable(state.view?.first);

                          return Column(
                            children: [
                              SizedBox(height: 60.h),
                              Container(
                                height: 90,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  gradient: AppColors.gradientTurquoiseReverse,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 14.h, vertical: 8.h),
                                  child: ShaderMask(
                                    shaderCallback: (Rect rect) {
                                      return AppColors.whitegradientColor.createShader(rect);
                                    },
                                    child: FittedBox(
                                      child: Text(
                                        userState is UserDataLoadedState && userState.user?.firstName != null
                                            ? '${userState.user!.firstName}, персональный\nпуть к здоровью готов!'
                                            : 'Ваш персональный путь\nк здоровью готов!',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 24.sp,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.darkGreenColor,
                                          fontFamily: 'Inter',
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 26.h),
                              Text(
                                'Путь к цели',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.darkGreenColor,
                                  fontFamily: 'Inter',
                                ),
                              ),
                              SizedBox(height: 18.h),
                              TargetLineChart(
                                dateStart: state.view?[0].dateA,
                                dateEnd: state.view?[0].dateB,
                                pointA: state.view?[0].pointA ?? 0,
                                pointB: state.view?[0].pointB ?? 0,
                                userSpots: userSpots,
                              ),
                              SizedBox(height: 31.h),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 14.w),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                              'Рекомендация по\n${state.view?.first.target?.name == "Сбросить вес" ? 'по снижению веса:' : 'по набору веса:'}',
                                              style: TextStyle(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w500,
                                                color: AppColors.darkGreenColor,
                                                fontFamily: 'Inter',
                                              ),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          '0.50 кг в неделю',
                                          style: TextStyle(
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF00817D),
                                            fontFamily: 'Inter',
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8.h),
                                    Container(
                                      width: double.infinity,
                                      height: 1.h,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Color(0xFFFFFFFF),
                                            Color(0xFFE3FFF2),
                                            Color(0xFFAEE5E2),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 25.h),
                                    Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8.r),
                                        color: AppColors.basicwhiteColor,
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(16.r),
                                        child: Text(
                                          'Для успешного достижения и удержания цели, формирования полезных привычек, рекомендуем:',
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w400,
                                            color: Color(0xFF00817D),
                                            fontFamily: 'Inter',
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 16.h),
                                    Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8.r),
                                        color: AppColors.lightGreenColor,
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.grey50Color.withOpacity(0.2),
                                            spreadRadius: 5,
                                            blurRadius: 7,
                                            offset: Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(16.r),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  child: Text(
                                                    'Получить персональную\nрекомендацию',
                                                    style: TextStyle(
                                                      fontSize: 16.sp,
                                                      fontWeight: FontWeight.w600,
                                                      color: Color(0xFF00817D),
                                                      fontFamily: 'Inter',
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Icon(
                                              Icons.arrow_forward_ios,
                                              size: 20.r,
                                              color: AppColors.darkGreenColor,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 16.h),
                                    Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8.r),
                                        color: AppColors.limeColor,
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.grey50Color.withOpacity(0.2),
                                            spreadRadius: 5,
                                            blurRadius: 7,
                                            offset: Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          minimumSize: Size.zero,
                                          padding: EdgeInsets.zero,
                                          side: BorderSide(
                                            width: 0,
                                            color: Color(0x000000),
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8.r),
                                          ),
                                        ),
                                        onPressed: () {
                                          //context.router.push(AdvertisingMainScreensRoute());
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.all(16.r),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: FittedBox(
                                                    fit: BoxFit.scaleDown,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          'Отслеживать приёмы пищи',
                                                          style: TextStyle(
                                                            fontSize: 16.sp,
                                                            fontWeight: FontWeight.w600,
                                                            color: Color(0xFF00817D),
                                                            fontFamily: 'Inter',
                                                          ),
                                                        ),
                                                        Text(
                                                          'Опция доступна по подписке',
                                                          style: TextStyle(
                                                            fontSize: 14.sp,
                                                            fontWeight: FontWeight.w500,
                                                            color: AppColors.vivaMagentaColor,
                                                            fontFamily: 'Inter',
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Icon(
                                                Icons.arrow_forward_ios,
                                                size: 20.r,
                                                color: AppColors.darkGreenColor,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 16.h),
                                    Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8.r),
                                        color: AppColors.seaColor,
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.grey50Color.withOpacity(0.2),
                                            spreadRadius: 5,
                                            blurRadius: 7,
                                            offset: Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(16.r),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Text(
                                                    'Отслеживать потребление воды\nпо персональной формуле',
                                                    style: TextStyle(
                                                      fontSize: 16.sp,
                                                      fontWeight: FontWeight.w600,
                                                      color: Color(0xFF00817D),
                                                      fontFamily: 'Inter',
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Icon(
                                              Icons.arrow_forward_ios,
                                              size: 20.r,
                                              color: AppColors.darkGreenColor,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 16.h),
                                    Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8.r),
                                        color: AppColors.lightGreenColor,
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.grey50Color.withOpacity(0.2),
                                            spreadRadius: 5,
                                            blurRadius: 7,
                                            offset: Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(16.r),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Text(
                                                    'Соблюдать персональные\nрекомендациипо расчёту КБМ',
                                                    style: TextStyle(
                                                      fontSize: 16.sp,
                                                      fontWeight: FontWeight.w600,
                                                      color: Color(0xFF00817D),
                                                      fontFamily: 'Inter',
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Icon(
                                              Icons.arrow_forward_ios,
                                              size: 20.r,
                                              color: AppColors.darkGreenColor,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 16.h),
                                    Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8.r),
                                        color: AppColors.limeColor,
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.grey50Color.withOpacity(0.2),
                                            spreadRadius: 5,
                                            blurRadius: 7,
                                            offset: Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(16.r),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Text(
                                                    'Используйте трекеры для\nсоблюдения и поддержания\nрежима',
                                                    style: TextStyle(
                                                      fontSize: 16.sp,
                                                      fontWeight: FontWeight.w600,
                                                      color: Color(0xFF00817D),
                                                      fontFamily: 'Inter',
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Icon(
                                              Icons.arrow_forward_ios,
                                              size: 20.r,
                                              color: AppColors.darkGreenColor,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 28.h),
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Источники рекомендаций',
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w400,
                                            color: AppColors.darkGreenColor,
                                            decoration: TextDecoration.underline,
                                            fontFamily: 'Inter',
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 40.h),
                                    Text(
                                      'Путь к цели',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 24.sp,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.darkGreenColor,
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                    SizedBox(height: 24.h),
                                    Row(
                                      children: [
                                        Text(
                                          state.view?.first.pointA != null ? "${state.view?.first.pointA}" : "",
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            color: AppColors.darkGreenColor,
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(width: 2.w),
                                        Text(
                                          state.view?.first.pointA != null ? "кг" : "",
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            color: AppColors.darkGreenColor,
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        Spacer(),
                                        PercentSecondBar(percent: 0),
                                        Spacer(),
                                        Text(
                                          state.view?.first.pointB != null ? "${state.view?.first.pointB}" : "",
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            color: AppColors.darkGreenColor,
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(width: 2.w),
                                        Text(
                                          state.view?.first.pointB != null ? "кг" : "",
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            color: AppColors.darkGreenColor,
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 40.h),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Осталось до цели:',
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.darkGreenColor,
                                            fontFamily: 'Inter',
                                          ),
                                        ),
                                        SizedBox(width: 12.w),
                                        Text(
                                          state.view?.first.totalDays != null ? "${state.view?.first.totalDays} дней" : "",
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.darkGreenColor,
                                            fontFamily: 'Inter',
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 30.h),
                                    SizedBox(
                                      height: 260.w,
                                      child: Image.asset(
                                        'assets/images/chart.webp',
                                        width: 260.w,
                                      ),
                                    ),
                                    SizedBox(height: 16.h),
                                    if (state.view?.first.calories != null)
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Калории',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 16.sp,
                                                fontFamily: 'Inter',
                                                color: AppColors.darkGreenColor,
                                              ),
                                            ),
                                            Text(
                                              state.view?.first.calories.toString() ?? "",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 18.sp,
                                                fontFamily: 'Inter',
                                                color: AppColors.darkGreenColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    SizedBox(height: 8.h),
                                    Container(
                                      width: double.infinity,
                                      height: 1.h,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Color(0xFFFFFFFF),
                                            Color(0xFFE3FFF2),
                                            Color(0xFFAEE5E2),
                                          ],
                                        ),
                                      ),
                                    ),
                                    TargetPercentItem(
                                      text: 'Углеводы',
                                      percent: 50,
                                      colorCircleAvatar: AppColors.darkGreenColor,
                                    ),
                                    TargetPercentItem(
                                      text: 'Жиры',
                                      percent: 30,
                                      colorCircleAvatar: AppColors.vivaMagentaColor,
                                    ),
                                    TargetPercentItem(
                                      text: 'Белки',
                                      percent: 20,
                                      colorCircleAvatar: AppColors.basicwhiteColor,
                                    ),
                                    SizedBox(height: 24.h),
                                    Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8.r),
                                        gradient: AppColors.gradientTurquoiseReverse,
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(16.w),
                                        child: Text(
                                          'Для достижения здорового веса и поддержания его необходимо соблюдать правильное питание и регулярно заниматься физическими упражнениями.\n\nВажно помнить, что похудение должно быть постепенным и основываться на здоровом подходе к снижению веса.',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14.sp,
                                            fontFamily: 'Inter',
                                            color: AppColors.darkGreenColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 24.h),
                                    Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8.r),
                                        color: AppColors.basicwhiteColor,
                                      ),
                                      child: OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          minimumSize: Size.zero,
                                          padding: EdgeInsets.zero,
                                          side: BorderSide(
                                            width: 0,
                                            color: Color(0x000000),
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8.r),
                                          ),
                                        ),
                                        onPressed: () {
                                          //context.router.push(AdvertisingMainScreensRoute());
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 16.w,
                                            vertical: 8.h,
                                          ),
                                          child: Column(
                                            children: [
                                              Text(
                                                'С нами вы можете больше!',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 20.sp,
                                                  fontFamily: 'Inter',
                                                  color: AppColors.darkGreenColor,
                                                ),
                                              ),
                                              SizedBox(height: 8.h),
                                              Text(
                                                'Подписки - это возможность получить доступ ко всем преимуществам',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 10.sp,
                                                  fontFamily: 'Inter',
                                                  color: AppColors.darkGreenColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 24.h),
                                    SizedBox(
                                      height: 64.h,
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor: const MaterialStatePropertyAll(
                                            AppColors.darkGreenColor,
                                          ),
                                          shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.r)))),
                                        ),
                                        onPressed: () async {
                                          await context.router.pushAndPopUntil(
                                            const DashboardContainerRoute(),
                                            predicate: (_) => false,
                                          );
                                          // context.router.replaceAll([
                                          //   DashboardContainerPageRoute()
                                          // ]);
                                        },
                                        child: Text(
                                          'Готово'.toUpperCase(),
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            color: AppColors.basicwhiteColor,
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 32.h),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }
                      } else {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height / 1.2,
                          child: ErrorWithReload(
                            callback: () {
                              context.read<TargetBloc>().add(TargetCheckEvent());
                            },
                          ),
                        );
                      }
                    } else if (state is TargetErrorState) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height / 1.2,
                        child: ErrorWithReload(
                          callback: () {
                            context.read<TargetBloc>().add(TargetCheckEvent());
                          },
                        ),
                      );
                    } else if (state is TargetLoadingState) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height / 1.2,
                        child: SpinKitCircle(
                          size: 70.0,
                          controller: controller,
                          color: AppColors.darkGreenColor,
                        ),
                      );
                    }
                    return Container();
                  })
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  List<FlSpot> getTable(ClientTargetsView? view) {
    if (view != null && view.pointA != null && view.pointB != null && view.dateA != null && view.dateB != null) {
      if (view.pointA! < view.pointB!) {
        return [FlSpot(1, 3), FlSpot(2, 3), FlSpot(8, 7), FlSpot(9, 7)];
      } else {
        return [FlSpot(1, 7), FlSpot(2, 7), FlSpot(8, 3), FlSpot(9, 3)];
      }
    }
    return [];
  }
}
