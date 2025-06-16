import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:auto_route/auto_route.dart';
import 'package:cached_memory_image/cached_memory_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker_bdaya/flutter_datetime_picker_bdaya.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:garnetbook/bloc/client/profile/client_profile_bloc.dart';
import 'package:garnetbook/bloc/user/user_data_cubit.dart';
import 'package:garnetbook/data/models/auth/create_user.dart';
import 'package:garnetbook/data/models/user/user_model.dart';
import 'package:garnetbook/data/repository/shared_preference_data.dart';
import 'package:garnetbook/domain/analytics/service_analytics.dart';
import 'package:garnetbook/domain/services/auth/profile_data.dart';
import 'package:garnetbook/domain/services/message/message_service.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/utils/functions/date_formating_functions.dart';
import 'package:garnetbook/utils/images.dart';
import 'package:garnetbook/widgets/buttons/form_for_button.dart';
import 'package:garnetbook/widgets/buttons/widget_button.dart';
import 'package:garnetbook/widgets/error_handler/error_reload.dart';
import 'package:garnetbook/widgets/loaders/progress_indicator.dart';
import 'package:garnetbook/widgets/modal_sheets/image_bottom_sheet.dart';
import 'package:garnetbook/widgets/modal_sheets/modal_sheet.dart';
import 'package:garnetbook/widgets/text_field/custom_label_center_textfield.dart';
import 'package:garnetbook/widgets/text_field/custom_textfiled_label.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

@RoutePage()
class ClientProfileEditScreen extends StatefulWidget {
  const ClientProfileEditScreen({super.key});

  @override
  State<ClientProfileEditScreen> createState() => _ClientProfileEditScreenState();
}

class _ClientProfileEditScreenState extends State<ClientProfileEditScreen> {
  TextEditingController controllerWeight = TextEditingController();
  TextEditingController controllerHeight = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController dateBornController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  final emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  File? image;
  var avatar;
  DateTime selectDate = DateTime.now();
  bool isAvatarChanged = false;
  bool isInit = false;
  bool isHeightInit = false;

  String initialName = "";
  String initialDate = "";
  String initialPhone = "";
  String initialEmail = "";
  String initialHeight = "";
  String initialWeight = "";

  @override
  void initState() {
    if (BlocProvider.of<UserDataCubit>(context).state is UserDataLoadedState) {
    } else {
      context.read<UserDataCubit>().check();
    }
    super.initState();
  }

  @override
  void dispose() {
    controllerWeight.dispose();
    controllerHeight.dispose();
    nameController.dispose();
    emailController.dispose();
    dateBornController.dispose();
    phoneController.dispose();
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
        backgroundColor: AppColors.basicwhiteColor,
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: AppColors.gradientTurquoiseReverse,
          ),
          child: SafeArea(
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 235.h),
                  child: Image.asset(
                    'assets/images/Group 25_profile.webp',
                    width: 375.w,
                  ),
                ),
                BlocBuilder<UserDataCubit, UserDataState>(builder: (context, userState) {
                  if (userState is UserDataLoadedState) {
                    check(userState.user);

                    return RefreshIndicator(
                      color: AppColors.darkGreenColor,
                      onRefresh: () {
                        isInit = false;
                        isHeightInit = false;
                        context.read<UserDataCubit>().check();
                        return Future.delayed(const Duration(seconds: 1));
                      },
                      child: ListView(
                        children: [
                          SizedBox(height: 56.h),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppColors.basicwhiteColor,
                              borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(16.r),
                              ),
                            ),
                            child: Column(
                              children: [
                                SizedBox(height: 20.h),
                                SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: FormForButton(
                                    borderRadius: BorderRadius.circular(20),
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
                                            avatar = null;
                                            isAvatarChanged = true;
                                          });
                                        }
                                      });
                                    },
                                    child: Stack(
                                      children: [
                                        avatar != null && avatar != ""
                                            ? CircleAvatar(
                                                radius: 50,
                                                backgroundImage: CachedMemoryImageProvider("app://client_avatar", base64: avatar!),
                                              )
                                            : CircleAvatar(
                                                radius: 50,
                                                backgroundColor: AppColors.seaColor,
                                                backgroundImage:
                                                    image != null && image?.isAbsolute == true ? Image.file(image!).image : null,
                                                child: image != null && image?.isAbsolute == true
                                                    ? Container()
                                                    : Icon(
                                                        Icons.add_photo_alternate_rounded,
                                                        size: 30,
                                                        color: AppColors.darkGreenColor,
                                                      ),
                                              ),
                                        Align(
                                          alignment: Alignment.bottomRight,
                                          child: SvgPicture.asset(
                                            'assets/images/edit.svg',
                                            color: AppColors.vivaMagentaColor,
                                            width: 22,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20.h),
                              ],
                            ),
                          ),
                          SizedBox(height: 24.h),
                          BlocBuilder<ClientProfileCubit, ClientProfileState>(builder: (context, state) {
                            getUserHeight(state);

                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 14.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Настройки профиля',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20.sp,
                                      fontFamily: 'Inter',
                                      color: AppColors.darkGreenColor,
                                    ),
                                  ),
                                  SizedBox(height: 16.h),
                                  CustomTextFieldLabel(
                                    controller: nameController,
                                    labelText: "ФИО",
                                    keyboardType: TextInputType.multiline,
                                    maxLines: 3,
                                    maxLength: 60,
                                    labelColor: AppColors.vivaMagentaColor,
                                    borderColor: AppColors.seaColor,
                                  ),
                                  SizedBox(height: 16.h),
                                  CustomTextFieldLabel(
                                    controller: dateBornController,
                                    labelText: "Дата рождения",
                                    labelColor: AppColors.vivaMagentaColor,
                                    borderColor: AppColors.seaColor,
                                    enabled: false,
                                    icon: SvgPicture.asset(
                                      'assets/images/calendar.svg',
                                      color: AppColors.vivaMagentaColor,
                                    ),
                                    onTap: () {
                                      DatePickerBdaya.showDatePicker(
                                        context,
                                        showTitleActions: true,
                                        minTime: DateTime(1900, 0, 0),
                                        maxTime: DateTime(DateTime.now().year - 18, DateTime.now().month, DateTime.now().day),
                                        onConfirm: (date) {
                                          setState(() {
                                            selectDate = date;
                                            dateBornController.text = DateFormat("dd.MM.yyyy").format(selectDate);
                                          });
                                        },
                                        currentTime: selectDate,
                                        locale: LocaleType.ru,
                                      );
                                    },
                                  ),
                                  SizedBox(height: 16.h),
                                  CustomTextFieldLabel(
                                    controller: phoneController,
                                    labelText: "Номер телефона",
                                    keyboardType: TextInputType.phone,
                                    labelColor: AppColors.vivaMagentaColor,
                                    borderColor: AppColors.seaColor,
                                    listMaskTextInputFormatter: [
                                      MaskTextInputFormatter(
                                          mask: '+7 (###) ###-##-##', filter: {"#": RegExp(r'[0-9]')}, type: MaskAutoCompletionType.lazy)
                                    ],
                                  ),
                                  SizedBox(height: 16.h),
                                  CustomTextFieldLabel(
                                    controller: emailController,
                                    labelText: "Электронная почта",
                                    keyboardType: TextInputType.multiline,
                                    labelColor: AppColors.vivaMagentaColor,
                                    borderColor: AppColors.seaColor,
                                    maxLines: 3,
                                    maxLength: 60,
                                  ),
                                  SizedBox(height: 16.h),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      CustomLabelCenterTextField(
                                        label: 'Ваш рост, см',
                                        labelColor: AppColors.vivaMagentaColor,
                                        controller: controllerHeight,
                                      ),
                                      CustomLabelCenterTextField(
                                        label: 'Ваш вес, кг',
                                        labelColor: AppColors.vivaMagentaColor,
                                        controller: controllerWeight,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20.h),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: WidgetButton(
                                          onTap: () {
                                            context.router.maybePop();
                                          },
                                          color: AppColors.basicwhiteColor,
                                          child: Text(
                                            'отмена'.toUpperCase(),
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: 'Inter',
                                              color: AppColors.darkGreenColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 24.w),
                                      Expanded(
                                        child: WidgetButton(
                                          onTap: () async {
                                            FocusScope.of(context).unfocus();

                                            if (controllerWeight.text.isNotEmpty &&
                                                controllerHeight.text.isNotEmpty &&
                                                nameController.text.isNotEmpty &&
                                                phoneController.text.isNotEmpty &&
                                                emailController.text.isNotEmpty &&
                                                dateBornController.text.isNotEmpty &&
                                                checkButtonEnabled()) {
                                              if (!emailValid.hasMatch(emailController.text)) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    duration: Duration(seconds: 1),
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
                                              } else {
                                                final service = ProfileDataService();

                                                FocusScope.of(context).unfocus();
                                                context.loaderOverlay.show();

                                                String format = "";
                                                String imageBase64 = "";
                                                bool isHeightResponseActivate = false;
                                                bool isProfileResponseActivate = false;

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

                                                if (controllerHeight.text != initialHeight || controllerWeight.text != initialWeight) {
                                                  final responseClientProfile =
                                                      await service.updateClientProfile(controllerWeight.text, controllerHeight.text);

                                                  if (responseClientProfile.result) {
                                                    isHeightResponseActivate = true;
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
                                                    return;
                                                  }
                                                }

                                                if (nameController.text != initialName ||
                                                    dateBornController.text != initialDate ||
                                                    phoneController.text != initialPhone ||
                                                    emailController.text != initialEmail ||
                                                    isAvatarChanged) {
                                                  String date = DateFormatting().formatISODate(dateBornController.text);

                                                  final userProfileResponse = await service.updateUser(UserUpdateRequest(
                                                    firstName: nameController.text,
                                                    email: emailController.text == initialEmail ? null : emailController.text,
                                                    birthDate: date,
                                                    userId: userState.user?.id,
                                                    phone: phoneController.text == initialPhone ? null : phoneController.text,
                                                    avatar: image != null
                                                        ? ImageView(name: 'user_avatar', format: format, base64: imageBase64)
                                                        : null,
                                                  ));

                                                  if (userProfileResponse.result) {
                                                    isProfileResponseActivate = true;
                                                  } else {
                                                    context.loaderOverlay.hide();
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(
                                                        duration: Duration(seconds: 3),
                                                        content: Text(
                                                          userProfileResponse.error ?? 'Произошла ошибка. Попробуйте повторить позже',
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
                                                }

                                                if (nameController.text != initialName) {
                                                  await MessageService().updateUserName(nameController.text);
                                                }

                                                if (isAvatarChanged && imageBase64 != "") {
                                                  final cachedImageManager = CachedImageBase64Manager.instance();
                                                  cachedImageManager.clearCache();
                                                }

                                                if (isProfileResponseActivate || isHeightResponseActivate) {
                                                  GetIt.I.get<ServiceAnalytics>().setEvent(AnalyticsEvents.changeProfileClient);

                                                  context.loaderOverlay.hide();
                                                  isInit = false;
                                                  isHeightInit = false;
                                                  context.read<UserDataCubit>().check();
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(
                                                      duration: Duration(seconds: 3),
                                                      content: Text(
                                                        'Данные сохранены',
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.w400,
                                                          fontSize: 14.sp,
                                                          fontFamily: 'Inter',
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                  context.read<ClientProfileCubit>().check();
                                                } else {
                                                  context.loaderOverlay.hide();
                                                }
                                              }
                                            } else {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  duration: Duration(seconds: 3),
                                                  content: Text(
                                                    'Введите новые значения',
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
                                            'сохранить'.toUpperCase(),
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: 'Inter',
                                              color: AppColors.basicwhiteColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 30.h),
                                ],
                              ),
                            );
                          })
                        ],
                      ),
                    );
                  } else if (userState is UserDataErrorState) {
                    return Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 235.h),
                          child: Image.asset(
                            'assets/images/Group 25_profile.webp',
                            width: 375.w,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 8.h),
                            Container(
                              width: double.infinity,
                              height: 56.h,
                              decoration: BoxDecoration(
                                gradient: AppColors.gradientTurquoise,
                              ),
                              child: Stack(
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
                                  Center(
                                    child: SizedBox(
                                      width: 290.w,
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          'Редактировать профиль',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 20.sp,
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
                            SizedBox(height: 15.h),
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 1.3,
                              child: ErrorWithReload(
                                callback: () {
                                  context.read<UserDataCubit>().check();
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  } else if (userState is UserDataLoadingState) {
                    return Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 235.h),
                          child: Image.asset(
                            'assets/images/Group 25_profile.webp',
                            width: 375.w,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 8.h),
                            Container(
                              width: double.infinity,
                              height: 56.h,
                              decoration: BoxDecoration(
                                gradient: AppColors.gradientTurquoise,
                              ),
                              child: Stack(
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
                                  Center(
                                    child: SizedBox(
                                      width: 290.w,
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          'Редактировать профиль',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 20.sp,
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
                            SizedBox(height: 15.h),
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 1.3,
                              child: ProgressIndicatorWidget(),
                            ),
                          ],
                        ),
                      ],
                    );
                  }
                  return Container();
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
                    child: Stack(
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
                        Center(
                          child: SizedBox(
                            width: 290.w,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                'Редактировать профиль',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20.sp,
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  check(UserView? user) async {
    if (!isInit) {
      if (user != null) {
        if (user.avatarBase64 != null && user.avatarBase64?.fileBase64 != null) {
          avatar = user.avatarBase64!.fileBase64!;
        }

        if (user.firstName != null) {
          nameController.text = user.firstName!;
          initialName = user.firstName!;
        }

        if (user.email != null) {
          emailController.text = user.email!;
          initialEmail = user.email!;
        }

        if (user.phone != null) {
          String phone = user.phone!;

          phoneController.text =
              "+7 (${phone[1]}${phone[2]}${phone[3]}) ${phone[4]}${phone[5]}${phone[6]}-${phone[7]}${phone[8]}-${phone[9]}${phone[10]}";
          initialPhone = phoneController.text;
        }

        if (user.birthDate != null) {
          var date1 = DateTime.parse(user.birthDate!);
          var newDate = DateFormat("dd.MM.yyyy").format(date1);

          selectDate = date1;
          dateBornController.text = newDate;
          initialDate = newDate;
        }
      }

      final storage = SharedPreferenceData.getInstance();
      final weight = await storage.getItem(SharedPreferenceData.userWeightKey);
      final height = await storage.getItem(SharedPreferenceData.userHeightKey);

      if (weight != "") {
        setState(() {
          controllerWeight = TextEditingController(text: weight);
          initialWeight = weight;
        });
      }

      if (height != "") {
        setState(() {
          controllerHeight = TextEditingController(text: height);
          initialHeight = height;
        });
      }

      isInit = true;
    }
  }

  getUserHeight(state) {
    if (state is ClientProfileLoadedState && !isHeightInit) {
      if (state.response?.height != null) {
        String tempHeight = state.response!.height.toString();
        controllerHeight = TextEditingController(text: tempHeight);
      }
      isHeightInit = true;
    }
  }

  bool checkButtonEnabled() {
    if (initialName != nameController.text) return true;
    if (initialDate != dateBornController.text) return true;
    if (initialPhone != phoneController.text) return true;
    if (initialEmail != emailController.text) return true;
    if (initialHeight != controllerHeight.text) return true;
    if (initialWeight != controllerWeight.text) return true;
    if (isAvatarChanged) return true;
    return false;
  }
}
