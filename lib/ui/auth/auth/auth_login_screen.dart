import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garnetbook/data/repository/shared_preference_data.dart';
import 'package:garnetbook/domain/analytics/service_analytics.dart';
import 'package:garnetbook/domain/services/auth/login_service.dart';
import 'package:garnetbook/domain/services/auth/vk_sign_in_service.dart';
import 'package:garnetbook/ui/routing/app_router.dart';
import 'package:garnetbook/utils/colors.dart';

import 'package:garnetbook/widgets/buttons/form_for_button.dart';
import 'package:garnetbook/widgets/buttons/widget_button.dart';
import 'package:get_it/get_it.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

@RoutePage()
class AuthLoginScreen extends StatefulWidget {
  const AuthLoginScreen({super.key});

  @override
  State<AuthLoginScreen> createState() => _AuthLoginScreenState();
}

class _AuthLoginScreenState extends State<AuthLoginScreen> {
  bool _visible = true;
  final vkLogin = VkSingInAuth();
  final storage = SharedPreferenceData.getInstance();
  bool validation = false;

  TextEditingController loginController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    // vkLogin.initSdk();
    super.initState();
  }

  @override
  void dispose() {
    loginController.dispose();
    passwordController.dispose();
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
      },
      child: Scaffold(
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: AppColors.gradientTurquoiseReverse,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  Image.asset(
                    'assets/images/Ellipse_4.webp',
                    color: Color(0x7BFFFFFF),
                    width: MediaQuery.of(context).size.width,
                  ),
                  SafeArea(
                    child: Column(
                      children: [
                        SizedBox(height: 50.h),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'Вход\nв личный кабинет',
                            style: TextStyle(
                              fontSize: 50.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.darkGreenColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            width: 240.w,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  'Номер телефона',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.darkGreenColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 6.h),
                        TextField(
                          cursorColor: AppColors.darkGreenColor,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            MaskTextInputFormatter(
                                mask: '+7 (###) ###-##-##', filter: {"#": RegExp(r'[0-9]')}, type: MaskAutoCompletionType.lazy)
                          ],
                          onChanged: (value) {
                            if (validation) {
                              setState(() {
                                validation = false;
                              });
                            }
                          },
                          controller: loginController,
                          textInputAction: TextInputAction.done,
                          onEditingComplete: () {
                            FocusScopeNode currentFocus = FocusScope.of(context);
                            if (!currentFocus.hasPrimaryFocus) {
                              currentFocus.focusedChild?.unfocus();
                            }
                          },
                          style: TextStyle(color: AppColors.basicblackColor),
                          decoration: InputDecoration(
                            fillColor: AppColors.basicwhiteColor,
                            filled: true,
                            hintText: 'Введите данные',
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 24.h,
                            ),
                            hintStyle: TextStyle(
                              fontFamily: 'Inter',
                              color: validation && loginController.text.isEmpty ? AppColors.vivaMagentaColor : AppColors.seaColor,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color:
                                        validation && loginController.text.isEmpty ? AppColors.vivaMagentaColor : AppColors.darkGreenColor,
                                    width: 2.w),
                                borderRadius: BorderRadius.all(Radius.circular(8.r))),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: validation && loginController.text.isEmpty ? AppColors.vivaMagentaColor : Color(0xFFD3FED5),
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.r),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: SizedBox(
                                width: 120.w,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      'Пароль',
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Inter',
                                        color: AppColors.darkGreenColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        TextFormField(
                          cursorColor: AppColors.darkGreenColor,
                          controller: passwordController,
                          textInputAction: TextInputAction.done,
                          onEditingComplete: () {
                            FocusScopeNode currentFocus = FocusScope.of(context);
                            if (!currentFocus.hasPrimaryFocus) {
                              currentFocus.focusedChild?.unfocus();
                            }
                          },
                          obscureText: _visible,
                          obscuringCharacter: '*',
                          style: TextStyle(color: AppColors.basicblackColor),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(8),
                          ],
                          onChanged: (value) {
                            if (validation) {
                              setState(() {
                                validation = false;
                              });
                            }
                          },
                          decoration: InputDecoration(
                            fillColor: AppColors.basicwhiteColor,
                            filled: true,
                            suffixIcon: IconButton(
                              highlightColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              onPressed: () {
                                setState(() {
                                  _visible = !_visible;
                                });
                              },
                              icon: _visible
                                  ? Image.asset('assets/icons/eye.png', height: 20.h, width: 20.w)
                                  : Image.asset('assets/icons/eye_open.png', height: 20.h, width: 20.w),
                            ),
                            hintText: 'Введите пароль',
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 24.h,
                            ),
                            hintStyle: TextStyle(
                                fontFamily: 'Inter',
                                color: validation && passwordController.text.isEmpty ? AppColors.vivaMagentaColor : AppColors.seaColor,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color:
                                    validation && passwordController.text.isEmpty ? AppColors.vivaMagentaColor : AppColors.darkGreenColor,
                                width: 2.w,
                              ),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: validation && loginController.text.isEmpty ? AppColors.vivaMagentaColor : Color(0xFFD3FED5),
                              ),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                        ),
                        SizedBox(height: 30.h),
                        WidgetButton(
                          onTap: () async {
                            FocusScope.of(context).unfocus();

                            if (loginController.text.isNotEmpty && passwordController.text.isNotEmpty) {
                              context.loaderOverlay.show();

                              final response = await LoginNetworkService().makeLoginRequest(loginController.text, passwordController.text);

                              if (response.result) {
                                context.loaderOverlay.hide();
                                if (response.value?.firstName != null && response.value?.email != null) {
                                  if (response.value?.birthDate != null) {
                                    GetIt.I.get<ServiceAnalytics>().setEvent(AnalyticsEvents.loginClient);

                                    await context.router.pushAndPopUntil(
                                      const DashboardContainerRoute(),
                                      predicate: (_) => false,
                                    );
                                  } else {
                                    context.router.push(AuthRegisterRouteClientThird(isLogin: true));
                                  }
                                } else {
                                  context.router.push(AuthRegisterRouteClientThird(isLogin: true));
                                }
                              } else {
                                context.loaderOverlay.hide();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    duration: Duration(seconds: 3),
                                    content: Text(
                                      response.error ?? 'Произошла ошибка. Попробуйте повторить позже',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14.sp,
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                  ),
                                );
                              }
                            } else {
                              setState(() {
                                validation = true;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  duration: Duration(seconds: 3),
                                  content: Text(
                                    'Заполните все поля',
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
                          color: AppColors.darkGreenColor,
                          text: 'ДАЛЕЕ',
                        ),
                        SizedBox(height: 34.h),
                        Row(
                          children: [
                            Text(
                              'Нет аккаунта? ',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                color: AppColors.darkGreenColor,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Spacer(),
                            FormForButton(
                              borderRadius: BorderRadius.circular(4.r),
                              onPressed: () {
                                context.router.push(AuthRegisterRoute());
                              },
                              child: Text(
                                "Зарегистрируйтесь",
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  color: AppColors.darkGreenColor,
                                  decorationColor: AppColors.darkGreenColor,
                                  fontSize: 16.sp,
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 34.h),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
