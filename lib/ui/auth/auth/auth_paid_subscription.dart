import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/utils/images.dart';
import 'package:garnetbook/widgets/containers/paid_chek_item.dart';
import 'package:garnetbook/widgets/containers/paid_item_wrap.dart';

@RoutePage()
class AuthPaidSubscriptionScreen extends StatefulWidget {
  const AuthPaidSubscriptionScreen({super.key});

  @override
  State<AuthPaidSubscriptionScreen> createState() => _AuthPaidSubscriptionScreenState();
}

class _AuthPaidSubscriptionScreenState extends State<AuthPaidSubscriptionScreen> {
  int set = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(gradient: AppColors.backgroundgradientColor),
          child: Stack(
            children: [
              SingleChildScrollView(
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
                    Column(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 56.h,
                          decoration: BoxDecoration(
                            gradient: AppColors.gradientTurquoiseReverse,
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
                                        onPressed: () {
                                          context.router.maybePop();
                                        },
                                        icon: Image.asset(
                                          AppImeges.arrow_back_png,
                                          color: AppColors.darkGreenColor,
                                          height: 25.h,
                                          width: 25.w,
                                        ),
                                      )),
                                  Text(
                                    'Подписки',
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
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.0.w),
                          child: Column(
                            children: [
                              SizedBox(height: 24.h),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                child: ShaderMask(
                                  shaderCallback: (Rect rect) {
                                    return AppColors.whitegradientColor.createShader(rect);
                                  },
                                  child: Text(
                                    'Получить доступ ко всем преимуществам',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 24.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.darkGreenColor,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                'возможно при оформлении любой\nудобной для вас подписки',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.greenColor,
                                  fontFamily: 'Inter',
                                ),
                              ),
                              PaidCheckItem(),
                              PaidCheckItem(),
                              PaidCheckItem(),
                              PaidCheckItem(),
                              SizedBox(height: 32.h),
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        onTap: () => setState(() {
                                          set = 1;
                                        }),
                                        child: PaidItemWrap(
                                          text_1: 'Базовая',
                                          text_2: 'Бесплатно',
                                          isSet: 1 == set,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () => setState(() {
                                          set = 2;
                                        }),
                                        child: PaidItemWrap(
                                          text_1: '1 месяц',
                                          text_2: '100 ₽',
                                          isSet: 2 == set,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 24.h),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        onTap: () => setState(() {
                                          set = 3;
                                        }),
                                        child: PaidItemWrap(
                                          text_1: '3 месяца',
                                          text_2: '500 ₽',
                                          isSet: 3 == set,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () => setState(() {
                                          set = 4;
                                        }),
                                        child: PaidItemWrap(
                                          isSet: 4 == set,
                                          text_1: '6 месяцев',
                                          text_2: '900 ₽',
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 24.h),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        onTap: () => setState(() {
                                          set = 5;
                                        }),
                                        child: PaidItemWrap(
                                          text_1: '9 месяцев',
                                          text_2: '1 200 ₽',
                                          isSet: 5 == set,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () => setState(() {
                                          set = 6;
                                        }),
                                        child: PaidItemWrap(
                                          isSet: 6 == set,
                                          text_1: '12 месяцев',
                                          text_2: '1 500 ₽',
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              // PaidSubscriptionScreen(),
                              SizedBox(height: 48.h),
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
                                  onPressed: () {
                                    // Route route = MaterialPageRoute(
                                    //     builder: (context) =>
                                    //         PaidSubscriptionScreen());
                                    // Navigator.push(context, route);
                                  },
                                  child: Text(
                                    'оплатить'.toUpperCase(),
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      color: AppColors.basicwhiteColor,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 16.h),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'При оплате подписки вы можете подключить\nавтоплатеж.',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.greenColor,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ),
                              SizedBox(height: 30.h),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
