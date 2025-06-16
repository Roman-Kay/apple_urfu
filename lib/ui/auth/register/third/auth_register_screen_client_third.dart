import 'dart:convert';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker_bdaya/flutter_datetime_picker_bdaya.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:garnetbook/bloc/client/target/target_bloc.dart';
import 'package:garnetbook/data/models/auth/create_user.dart';
import 'package:garnetbook/data/models/auth/login_social.dart';
import 'package:garnetbook/data/repository/shared_preference_data.dart';
import 'package:garnetbook/domain/analytics/service_analytics.dart';
import 'package:garnetbook/domain/services/auth/profile_data.dart';
import 'package:garnetbook/domain/services/auth/register_service.dart';
import 'package:garnetbook/ui/routing/app_router.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/widgets/buttons/form_for_button.dart';
import 'package:garnetbook/widgets/buttons/widget_button.dart';
import 'package:garnetbook/widgets/containers/page_contoller_container.dart';
import 'package:garnetbook/widgets/modal_sheets/image_bottom_sheet.dart';
import 'package:garnetbook/widgets/text/text_auth.dart';
import 'package:garnetbook/widgets/text_field/custom_label_center_textfield.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';

@RoutePage()
class AuthRegisterScreenClientThird extends StatefulWidget {
  const AuthRegisterScreenClientThird({super.key, this.isLogin = false, this.withSocial = false, this.gUser});

  final bool isLogin;
  final bool withSocial;
  final dynamic gUser;

  @override
  State<AuthRegisterScreenClientThird> createState() => _AuthRegisterScreenThirdState();
}

class _AuthRegisterScreenThirdState extends State<AuthRegisterScreenClientThird> with SingleTickerProviderStateMixin {
  late TabController tabController;

  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerDate = TextEditingController();
  TextEditingController controllerWeight = TextEditingController();
  TextEditingController controllerHeight = TextEditingController();

  final emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  bool validation = false;
  File? image;
  DateTime dateBorn = DateTime(DateTime.now().year - 18, DateTime.now().month, DateTime.now().day);
  int gender = 2;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    tabController.index = 1;
    check();
    checkSocial();
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    controllerName.dispose();
    controllerHeight.dispose();
    controllerWeight.dispose();
    controllerDate.dispose();
    controllerEmail.dispose();
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
                SafeArea(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 14.w),
                        child: Column(
                          children: [
                            SizedBox(height: 20.h),
                            if (!widget.isLogin)
                              SizedBox(
                                width: double.infinity,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    PageControllerContainer(
                                      choosenIndex: 2,
                                      length: 4,
                                    ),
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
                                    'Настройте свой профиль:',
                                    maxLines: 1,
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
                            SizedBox(height: 24.h),
                            if (!widget.isLogin)
                              Padding(
                                padding: EdgeInsets.only(bottom: 16.h),
                                child: Text(
                                  'Шаг 3/3',
                                  style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Inter',
                                      color: AppColors.rubinColor
                                  ),
                                ),
                              ),
                            image != null && image?.isAbsolute == true
                                ? GestureDetector(
                                    onTap: () async {
                                      showModalBottomSheet(
                                          context: context,
                                          useSafeArea: true,
                                          backgroundColor: AppColors.basicwhiteColor,
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(16),
                                            ),
                                          ),
                                          builder: (builder) => ImagePickerBottomSheet()).then((value) {
                                        if (value != null && value?.isAbsolute == true) {
                                          setState(() {
                                            image = value;
                                          });
                                        }
                                      });
                                    },
                                    child: CircleAvatar(
                                      radius: 50,
                                      backgroundColor: Colors.transparent,
                                      backgroundImage: Image.file(image!).image,
                                    ),
                                  )
                                : Container(
                                    height: 65.h,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.r),
                                      gradient: AppColors.gradientTurquoiseReverse,
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
                                      onPressed: () async {
                                        showModalBottomSheet(
                                            context: context,
                                            useSafeArea: true,
                                            backgroundColor: AppColors.basicwhiteColor,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(16),
                                              ),
                                            ),
                                            builder: (builder) => ImagePickerBottomSheet()).then((value) {
                                          if (value != null && value?.isAbsolute == true) {
                                            setState(() {
                                              image = value;
                                            });
                                          }
                                        });
                                      },
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            SizedBox(width: 16.w),
                                            SvgPicture.asset(
                                              'assets/images/camera.svg',
                                              color: AppColors.darkGreenColor,
                                            ),
                                            SizedBox(width: 16.w),
                                            Text(
                                              'ЗАГРУЗИТЬ ФОТО',
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                color: AppColors.darkGreenColor,
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            SizedBox(width: 16.w),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                            SizedBox(height: 24.h),
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: validation && controllerName.text.isEmpty ? AppColors.vivaMagentaColor : AppColors.seaColor),
                                borderRadius: BorderRadius.circular(8.r),
                                color: AppColors.basicwhiteColor,
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 8.h,
                                ),
                                child: Center(
                                  child: TextField(
                                    cursorColor: AppColors.darkGreenColor,
                                    onChanged: (value) {
                                      if (validation) {
                                        setState(() {
                                          validation = false;
                                        });
                                      }
                                    },
                                    keyboardType: TextInputType.multiline,
                                    maxLines: 3,
                                    maxLength: 60,
                                    minLines: 1,
                                    textInputAction: TextInputAction.done,
                                    onEditingComplete: (){
                                      FocusScopeNode currentFocus = FocusScope.of(context);
                                      if (!currentFocus.hasPrimaryFocus) {
                                        currentFocus.focusedChild?.unfocus();
                                      }
                                    },
                                    controller: controllerName,
                                    style: TextStyle(
                                      color: AppColors.darkGreenColor,
                                      fontSize: 16.sp,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w400,
                                    ),
                                    decoration: InputDecoration(
                                      counterText: "",
                                      isDense: true,
                                      labelText: 'Ваше имя',
                                      labelStyle: TextStyle(
                                        color: AppColors.tints4Color,
                                        fontSize: 16.sp,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                      ),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 13.h),
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: validation && controllerDate.text.isEmpty ? AppColors.vivaMagentaColor : AppColors.seaColor),
                                borderRadius: BorderRadius.circular(8.r),
                                color: AppColors.basicwhiteColor,
                              ),
                              child: FormForButton(
                                borderRadius: BorderRadius.circular(8.r),
                                onPressed: () {
                                  DatePickerBdaya.showDatePicker(
                                    context,
                                    showTitleActions: true,
                                    minTime: DateTime(1900, 0, 0),
                                    maxTime: DateTime(DateTime.now().year - 18, DateTime.now().month, DateTime.now().day),
                                    onConfirm: (date) {
                                      setState(() {
                                        dateBorn = date;
                                        controllerDate.text = DateFormat("dd.MM.yyyy").format(date);
                                        if (validation) {
                                          validation = false;
                                        }
                                      });
                                    },
                                    currentTime: dateBorn,
                                    locale: LocaleType.ru,
                                  );
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 200.w,
                                        child: TextField(
                                          cursorColor: AppColors.darkGreenColor,
                                          textInputAction: TextInputAction.done,
                                          onEditingComplete: (){
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
                                          controller: controllerDate,
                                          enabled: false,
                                          maxLines: null,
                                          style: TextStyle(
                                            color: AppColors.darkGreenColor,
                                            fontSize: 16.sp,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w400,
                                          ),
                                          decoration: InputDecoration(
                                            isDense: true,
                                            labelText: 'Дата рождения',
                                            labelStyle: TextStyle(
                                              color: AppColors.tints4Color,
                                              fontSize: 16.sp,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w400,
                                            ),
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      SvgPicture.asset(
                                        'assets/images/calendar.svg',
                                        color: AppColors.vivaMagentaColor,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 13.h),
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: validation && controllerEmail.text.isEmpty ? AppColors.vivaMagentaColor : AppColors.seaColor),
                                borderRadius: BorderRadius.circular(8.r),
                                color: AppColors.basicwhiteColor,
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                                child: Center(
                                  child: TextFormField(
                                    cursorColor: AppColors.darkGreenColor,
                                    onChanged: (value) {
                                      if (validation) {
                                        setState(() {
                                          validation = false;
                                        });
                                      }
                                    },
                                    keyboardType: TextInputType.multiline,
                                    maxLines: 3,
                                    maxLength: 60,
                                    minLines: 1,
                                    textInputAction: TextInputAction.done,
                                    onEditingComplete: (){
                                      FocusScopeNode currentFocus = FocusScope.of(context);
                                      if (!currentFocus.hasPrimaryFocus) {
                                        currentFocus.focusedChild?.unfocus();
                                      }
                                    },
                                    controller: controllerEmail,
                                    style: TextStyle(
                                      color: AppColors.darkGreenColor,
                                      fontSize: 16.sp,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w400,
                                    ),
                                    decoration: InputDecoration(
                                      counterText: "",
                                      isDense: true,
                                      labelText: 'Почта',
                                      labelStyle: TextStyle(
                                        color: AppColors.tints4Color,
                                        fontSize: 16.sp,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                      ),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 32.h),
                      Center(
                        child: SizedBox(
                          width: double.infinity,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              'Личные данные',
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.vivaMagentaColor,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 14.w),
                        child: Center(
                          child: Text(
                            'Чтобы дать вам персональные рекомендации, нам нужно знать ваш пол, рост и вес',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.vivaMagentaColor,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 24.h),
                      Container(
                        width: double.infinity,
                        height: 56.h,
                        decoration: BoxDecoration(
                          color: AppColors.basicwhiteColor,
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 14.w),
                          child: TabBar(
                            indicatorColor: AppColors.vivaMagentaColor,
                            controller: tabController,
                            labelColor: AppColors.vivaMagentaColor,
                            unselectedLabelColor: AppColors.tints4Color,
                            indicatorSize: TabBarIndicatorSize.label,
                            labelPadding: EdgeInsets.only(bottom: 3.5.h),
                            labelStyle: TextStyle(
                              fontSize: 16.sp,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                            ),
                            onTap: (id) {
                              setState(() {
                                gender = id + 1;
                              });
                            },
                            tabs: [
                              SizedBox(
                                width: 155.5.w,
                                height: 56.h,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Tab(
                                    height: 56.h,
                                    text: 'Мужской',
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 155.5.w,
                                height: 56.h,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Tab(
                                    height: 56.h,
                                    text: 'Женский',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 24.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 14.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomLabelCenterTextField(
                              maxLength: 4,
                              onChanged: (value) {
                                if (validation) {
                                  setState(() {
                                    validation = false;
                                  });
                                }
                              },
                              listMaskTextInputFormatter: [FilteringTextInputFormatter.allow(RegExp(r'^[0-9]*$'))],
                              controller: controllerHeight,
                              label: 'Ваш рост, см',
                              labelColor: AppColors.tints4Color,
                              borderColor: validation && controllerHeight.text.isEmpty ? AppColors.vivaMagentaColor : null,
                            ),
                            CustomLabelCenterTextField(
                              maxLength: 4,
                              onChanged: (value) {
                                if (validation) {
                                  setState(() {
                                    validation = false;
                                  });
                                }
                              },
                              listMaskTextInputFormatter: [FilteringTextInputFormatter.allow(RegExp(r'^[0-9]*$'))],
                              controller: controllerWeight,
                              label: 'Ваш вес, кг',
                              labelColor: AppColors.tints4Color,
                              borderColor: validation && controllerWeight.text.isEmpty ? AppColors.vivaMagentaColor : null,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 40.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 14.w),
                        child: WidgetButton(
                          onTap: () async {
                            FocusScope.of(context).unfocus();

                            if (controllerName.text.isNotEmpty &&
                                controllerHeight.text.isNotEmpty &&
                                controllerDate.text.isNotEmpty &&
                                controllerWeight.text.isNotEmpty &&
                                controllerEmail.text.isNotEmpty) {
                              if (!emailValid.hasMatch(controllerEmail.text)) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    duration: Duration(seconds: 3),
                                    content: Text(
                                      'Введите коректное значение: почта',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14.sp,
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                  ),
                                );
                              }
                              else if (!RegExp(r'[а-яА-ЯЁё]').hasMatch(controllerName.text)) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    duration: Duration(seconds: 3),
                                    content: Text(
                                      'Имя должно быть на русском языке',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14.sp,
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                  ),
                                );
                              } else {

                                context.loaderOverlay.show();

                                final service = RegisterNetworkService();
                                final storage = await SharedPreferenceData.getInstance();

                                final phone = await storage.getItem(SharedPreferenceData.userPhoneKey);
                                final password = await storage.getItem(SharedPreferenceData.userPasswordKey);

                                String format = "";
                                String imageBase64 = "";

                                if (image != null && image?.isAbsolute == true) {
                                  Uint8List? result = await FlutterImageCompress.compressWithFile(
                                    image!.absolute.path,
                                    minHeight: 1080,
                                    minWidth: 1080,
                                    quality: 96,
                                    format: CompressFormat.webp,
                                  );

                                  if (result != null) {
                                    imageBase64 = base64Encode(result);
                                    String s = image!.path;
                                    var pos = s.lastIndexOf('.');
                                    String resultName = (pos != -1) ? s.substring(pos) : s;

                                    format = resultName.substring(1);
                                  }
                                }

                                // регистрация через соц сети
                                if (widget.withSocial && widget.gUser != null) {
                                  final response = await service.registerSocialMedia(RegisterSocialRequest(
                                    userName: controllerName.text,
                                    email: controllerEmail.text.isNotEmpty ? controllerEmail.text : null,
                                    birthDate: DateFormat("yyyy-MM-dd").format(dateBorn),
                                    socProviderId: widget.gUser.runtimeType == GoogleSignInAccount ? widget.gUser!.id : widget.gUser['userId'],
                                    genderId: gender,
                                    providerId: widget.gUser.runtimeType == GoogleSignInAccount ? 1 : 2,
                                    roleId: 1,
                                  ));

                                  if (response.result == true) {
                                    GetIt.I.get<ServiceAnalytics>().setEvent(AnalyticsEvents.registerClientGoogle);

                                    context.loaderOverlay.hide();
                                    context.router.replaceAll([ClientSetPersonalPlanRoute(
                                          weight: int.parse(controllerWeight.text),
                                        height: int.parse(controllerHeight.text))
                                    ]);
                                    context.read<TargetBloc>().add(TargetSetEvent(controllerHeight.text, controllerWeight.text));
                                  }

                                  else {
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

                                // обычная регистрация
                                else {

                                  // создаем пользователя
                                  final response = await service.createNewUser(UserCreateRequest(
                                      email: controllerEmail.text.isNotEmpty ? controllerEmail.text : null,
                                      socProfile: false,
                                      passwordMd5: password,
                                      roleId: 1,
                                      phone: phone));

                                  if (response.result) {
                                    // обновляем пользователя, создаем клиента
                                    updateUser(format, imageBase64);
                                  }

                                  else {
                                    if (response.error != null &&
                                        response.error!.contains("уже зарегистрирован.") &&
                                        !response.error!.contains("адресом")) {

                                      // обновляем пользователя, создаем клиента
                                      updateUser(format, imageBase64);
                                    }

                                    else {
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
                                }
                              }
                            }

                            else {
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
                          color: AppColors.darkGreenColor,
                          text: 'ДАЛЕЕ',
                        ),
                      ),
                      SizedBox(height: 34.h),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 14.w), child: TextAuth()),
                      SizedBox(height: 10.h),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  updateUser(String format, String imageBase64) async {
    final storage = await SharedPreferenceData.getInstance();
    final profileDataService = ProfileDataService();
    final userId = await storage.getUserId();

    final updateUser = await profileDataService.updateUser(UserUpdateRequest(
      firstName: controllerName.text,
      lastName: controllerName.text,
      birthDate: DateFormat("yyyy-MM-dd").format(dateBorn),
      socProfile: false,
      userId: userId != "" ? int.parse(userId) : null,
      avatar: image != null && image?.isAbsolute == true ? ImageView(
          name: 'user_avatar',
          format: format,
          base64: imageBase64) : null,
      genderId: gender,
    ));

    if (updateUser.result) {
      GetIt.I.get<ServiceAnalytics>().setEvent(AnalyticsEvents.registerClient);

      context.loaderOverlay.hide();
      context.router.replaceAll([ClientSetPersonalPlanRoute(
          weight: int.parse(controllerWeight.text),
          height: int.parse(controllerHeight.text))]
      );
      context.read<TargetBloc>().add(TargetSetEvent(controllerHeight.text, controllerWeight.text));
    }
    else {
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

  checkSocial() {
    if (widget.withSocial && widget.gUser != null) {
      if (widget.gUser.runtimeType == GoogleSignInAccount) {
        if (widget.gUser?.email != null) {
          setState(() {
            controllerEmail.text = widget.gUser!.email;
          });
        }
      } else {
        if (widget.gUser['email'] != null) {
          setState(() {
            controllerEmail.text = widget.gUser['email'];
          });
        }
        if (widget.gUser['name'] != null) {
          setState(() {
            controllerName.text = widget.gUser['name'];
          });
        }
      }
    }
  }

  check() async {
    final storage = SharedPreferenceData.getInstance();

    final storageName = await storage.getItem(SharedPreferenceData.userNameKey);
    final storageEmail = await storage.getItem(SharedPreferenceData.userEmailKey);
    final storageGender = await storage.getItem(SharedPreferenceData.userGenderKey);
    final storageBday = await storage.getItem(SharedPreferenceData.userBdayKey);

    if (storageName != "") {
      setState(() {
        controllerName.text = storageName;
      });
    }

    if (storageGender != "") {
      if (storageGender == "male") {
        setState(() {
          gender = 1;
        });
      }
    }

    if (storageEmail != "") {
      setState(() {
        controllerEmail.text = storageEmail;
      });
    }

    if (storageBday != "") {
      DateTime newDate = DateTime.parse(storageBday);
      setState(() {
        controllerDate.text = DateFormat("dd.MM.yyyy").format(newDate);
      });
    }
  }
}
