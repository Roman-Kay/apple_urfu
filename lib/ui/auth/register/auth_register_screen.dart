import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garnetbook/data/repository/shared_preference_data.dart';
import 'package:garnetbook/domain/services/auth/login_service.dart';
import 'package:garnetbook/domain/services/auth/register_service.dart';
import 'package:garnetbook/domain/services/auth/vk_sign_in_service.dart';
import 'package:garnetbook/ui/routing/app_router.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/utils/images.dart';
import 'package:garnetbook/widgets/buttons/auth_button.dart';
import 'package:garnetbook/widgets/buttons/widget_button.dart';
import 'package:garnetbook/widgets/containers/page_contoller_container.dart';
import 'package:garnetbook/widgets/text/text_auth.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

@RoutePage()
class AuthRegisterScreen extends StatefulWidget {
  const AuthRegisterScreen({super.key});

  @override
  State<AuthRegisterScreen> createState() => _AuthRegisterScreenState();
}

class _AuthRegisterScreenState extends State<AuthRegisterScreen> {
  bool _visible = true;
  bool validation = false;

  TextEditingController loginController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final vkLogin = VkSingInAuth();

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
            gradient: AppColors.backgroundgradientColor,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  Padding(
                      padding: EdgeInsets.only(top: 446.h, right: 260.h),
                      child: Image.asset(
                        'assets/images/dyga.webp',
                        height: 284.h,
                        width: 284.w,
                        fit: BoxFit.contain,
                      )),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 446.h,
                    ),
                    child: Image.asset(
                      'assets/images/ring.webp',
                      width: 350.w,
                      height: 381.h,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 270.w, top: 716.h),
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
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: EdgeInsets.only(top: 520.h),
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
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 108.w, top: 265.h),
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
                  ),
                  SafeArea(
                    child: Column(
                      children: [
                        SizedBox(height: 20.h),
                        SizedBox(
                          width: double.infinity,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Positioned(
                                left: 1,
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
                                ),
                              ),
                              PageControllerContainer(choosenIndex: 0, length: 4)
                            ],
                          ),
                        ),
                        SizedBox(height: 25.h),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: ShaderMask(
                            shaderCallback: (Rect rect) {
                              return AppColors.whitegradientColor.createShader(rect);
                            },
                            child: Text(
                              'Регистрация',
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
                          'Шаг 1/3',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Inter',
                            color: AppColors.rubinColor,
                          ),
                        ),
                        SizedBox(height: 32.h),
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
                        SizedBox(
                          child: TextField(
                            cursorColor: AppColors.darkGreenColor,
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              MaskTextInputFormatter(
                                  mask: '+7 (###) ###-##-##', filter: {"#": RegExp(r'[0-9]')}, type: MaskAutoCompletionType.lazy)
                            ],
                            controller: loginController,
                            textInputAction: TextInputAction.done,
                            onEditingComplete: () {
                              FocusScopeNode currentFocus = FocusScope.of(context);
                              if (!currentFocus.hasPrimaryFocus) {
                                currentFocus.focusedChild?.unfocus();
                              }
                            },
                            onChanged: (value) {
                              if (validation) {
                                setState(() {
                                  validation = false;
                                });
                              }
                            },
                            style: TextStyle(color: AppColors.basicblackColor),
                            decoration: InputDecoration(
                                fillColor: AppColors.basicwhiteColor,
                                filled: true,
                                hintText: 'Введите данные',
                                contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
                                hintStyle: TextStyle(
                                    fontFamily: 'Inter',
                                    color: validation && loginController.text.isEmpty ? AppColors.vivaMagentaColor : AppColors.seaColor,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: validation && loginController.text.isEmpty
                                            ? AppColors.vivaMagentaColor
                                            : AppColors.darkGreenColor,
                                        width: 2.w),
                                    borderRadius: BorderRadius.all(Radius.circular(8.r))),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: validation && loginController.text.isEmpty
                                            ? AppColors.vivaMagentaColor
                                            : Color.fromARGB(255, 211, 254, 213)),
                                    borderRadius: BorderRadius.all(Radius.circular(8.r)))),
                          ),
                        ),
                        SizedBox(height: 12.h),
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
                        SizedBox(height: 7.h),
                        SizedBox(
                          child: TextField(
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
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(8),
                            ],
                            obscuringCharacter: '*',
                            style: TextStyle(color: AppColors.basicblackColor),
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
                              contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
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
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8.r),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: validation && passwordController.text.isEmpty
                                      ? AppColors.vivaMagentaColor
                                      : Color.fromARGB(255, 211, 254, 213),
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8.r),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            width: double.infinity,
                            child: FittedBox(
                              child: Text(
                                'Пароль должен содержать не менее 8 символов',
                                maxLines: 2,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Inter',
                                  color: AppColors.darkGreenColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 30.h),
                        WidgetButton(
                          text: 'ДАЛЕЕ',
                          color: AppColors.darkGreenColor,
                          onTap: () async {
                            if (passwordController.text.isNotEmpty && loginController.text.isNotEmpty) {
                              if (passwordController.text.length < 8) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    duration: Duration(seconds: 3),
                                    content: Text(
                                      'Пароль должен содержать не менее 8 символов',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14.sp,
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                FocusScope.of(context).unfocus();
                                context.loaderOverlay.show();

                                final service = RegisterNetworkService();
                                final storage = SharedPreferenceData.getInstance();

                                //проверка на номер в базе
                                final response = await service.checkUserPhoneNumber(loginController.text);

                                if (response.result) {
                                  final userRole = await storage.getItem("auth_role");
                                  await storage.setItem(SharedPreferenceData.role, userRole.toString());
                                  await storage.setItem(SharedPreferenceData.userPasswordKey, passwordController.text);
                                  await storage.setItem(SharedPreferenceData.userPhoneKey, loginController.text);

                                  context.loaderOverlay.hide();
                                  context.router
                                      .push(AuthRegisterRouteSecond(phone: loginController.text, password: passwordController.text));
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
                        ),
                        SizedBox(height: 34.h),
                        TextButton(
                          onPressed: () => context.router.push(AuthLoginRoute()),
                          child: RichText(
                            textDirection: TextDirection.ltr,
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'Уже есть аккаунт? ',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    color: AppColors.rubinColor,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Войти',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    decorationColor: AppColors.rubinColor,
                                    color: AppColors.rubinColor,
                                    fontSize: 16.sp,
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
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
