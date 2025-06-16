import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garnetbook/domain/services/auth/register_service.dart';
import 'package:garnetbook/ui/routing/app_router.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/utils/images.dart';
import 'package:garnetbook/widgets/buttons/buttons.dart';
import 'package:garnetbook/widgets/containers/page_contoller_container.dart';
import 'package:garnetbook/widgets/text/text_auth.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

@RoutePage()
class AuthRegisterScreenSecond extends StatefulWidget {
  const AuthRegisterScreenSecond({required this.phone, required this.password, super.key});
  final String phone;
  final String password;

  @override
  State<AuthRegisterScreenSecond> createState() => _AuthRegisterScreenSecondState();
}

class _AuthRegisterScreenSecondState extends State<AuthRegisterScreenSecond> {
  final interval = const Duration(seconds: 1);
  final int timerMaxSeconds = 177;
  int currentSeconds = 0;
  Timer? periodicTimer;
  bool isNotCorrect = false;

  StreamController<ErrorAnimationType>? errorController;

  String verificationCode = "";
  TextEditingController textEditingController = TextEditingController();
  String currentText = "";
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    sendSms();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      startTimeout();
    });
    super.initState();
  }

  @override
  void dispose() {
    periodicTimer?.cancel();
    textEditingController.dispose();
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
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 99.w, top: 381.h),
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
                padding: EdgeInsets.only(top: 168.h, left: 12.w),
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
                padding: EdgeInsets.only(left: 252.w, top: 49.h),
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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                child: SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 56.h,
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
                              PageControllerContainer(choosenIndex: 1, length: 4)
                            ],
                          ),
                        ),
                        SizedBox(height: 35.h),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Center(
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
                        ),
                        SizedBox(height: 8.h),
                        Center(
                          child: Text(
                            'Шаг 2/3',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Inter',
                              color: AppColors.rubinColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              'Для регистрации в приложении введите \nпроверочный код из SMS:',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                                color: AppColors.darkGreenColor,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 24.h),
                        Form(
                          key: formKey,
                          child: PinCodeTextField(
                            appContext: context,
                            length: 4,
                            textStyle: TextStyle(
                              fontSize: 26.sp,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                              color: AppColors.darkGreenColor,
                            ),
                            useExternalAutoFillGroup: true,
                            enableActiveFill: true,
                            errorAnimationController: errorController,
                            pinTheme: PinTheme(
                              borderRadius: BorderRadius.circular(8.r),
                              shape: PinCodeFieldShape.box,
                              selectedFillColor: AppColors.basicwhiteColor,
                              activeFillColor: AppColors.basicwhiteColor,
                              inactiveFillColor: AppColors.basicwhiteColor,
                              activeColor: AppColors.basicwhiteColor,
                              selectedColor: AppColors.darkGreenColor,
                              inactiveColor: AppColors.basicwhiteColor,
                              disabledColor: AppColors.basicwhiteColor,
                              errorBorderColor: AppColors.vivaMagentaColor,
                              fieldHeight: 64.h,
                              fieldWidth: 48.w,
                            ),
                            separatorBuilder: (context, index) {
                              return SizedBox(width: 15.w);
                            },
                            mainAxisAlignment: MainAxisAlignment.center,
                            blinkWhenObscuring: true,
                            animationType: AnimationType.fade,
                            cursorColor: AppColors.darkGreenColor,
                            controller: textEditingController,
                            keyboardType: TextInputType.number,
                            onCompleted: (value) {
                              validate(context);
                            },
                            onChanged: (value) => setState(() {
                              currentText = value;
                              isNotCorrect = false;
                            }),
                          ),
                        ),
                        SizedBox(height: 34.5.h),
                        AnimatedOpacity(
                          opacity: getTimerText() == '00:00' ? 1 : 0.25,
                          duration: Duration(milliseconds: 250),
                          child: InkWell(
                            onTap: getTimerText() != '00:00'
                                ? null
                                : () {
                                    if (currentSeconds == timerMaxSeconds) {
                                      setState(() {
                                        currentSeconds = 0;
                                      });
                                      sendSms();
                                      startTimeout();
                                    }
                                  },
                            child: SizedBox(
                              width: double.infinity,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Center(
                                  child: Text(
                                    'ОТПРАВИТЬ ПОВТОРНО >',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.vivaMagentaColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 18.5.h),
                        Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'через  ',
                                style: TextStyle(
                                    fontSize: 12.sp, fontWeight: FontWeight.w500, fontFamily: 'Inter', color: AppColors.lightGreyColor),
                              ),
                              Text(
                                getTimerText(),
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Inter',
                                  color: AppColors.lightGreyColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height / 5),
                        Button(
                          onPressed: () async {
                            validate(context);
                          },
                          height: 64.h,
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.h),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                'ДАЛЕЕ',
                                style: TextStyle(
                                  height: 1,
                                  fontFamily: 'Inter',
                                  color: AppColors.basicwhiteColor,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(8.r)),
                              ),
                            ),
                            backgroundColor: const MaterialStatePropertyAll(AppColors.darkGreenColor),
                          ),
                        ),
                        SizedBox(height: 35.h),
                        TextAuth(),
                        SizedBox(height: 10.h),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  sendSms() async {
    final service = RegisterNetworkService();
    final response = await service.sendSmsRegistration(widget.phone);

    if (response.result && response.value?.verificationCode != null) {
      setState(() {
        verificationCode = response.value!.verificationCode!;
      });
    }
  }

  String getTimerText() {
    int minutes = (timerMaxSeconds - currentSeconds) ~/ 60;
    int seconds = (timerMaxSeconds - currentSeconds) % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  startTimeout([int? milliseconds]) {
    var duration = interval;
    periodicTimer = Timer.periodic(duration, (timer) {
      setState(() {
        currentSeconds = timer.tick;
        if (timer.tick == timerMaxSeconds) timer.cancel();
        if (timer.tick >= timerMaxSeconds) timer.isActive;
      });
    });
  }

  validate(BuildContext context) async {
    // проверка что вели код полностью
    if (currentText.length == 4) {
      // если код верен то переход на следющие экраны
      if (currentText == verificationCode) {
        context.router.popAndPush(AuthRegisterRouteClientThird());
      } else {
        // код не верен
        setState(() => isNotCorrect = true);
        errorController!.add(ErrorAnimationType.shake);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: Duration(seconds: 1),
            content: Text(
              'Код введен неправильно',
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
      // код введен не полностью
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 1),
          content: Text(
            'Введите код',
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
}
