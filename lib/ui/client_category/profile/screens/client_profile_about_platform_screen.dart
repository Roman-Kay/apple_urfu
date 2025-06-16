import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/utils/images.dart';
import 'package:garnetbook/widgets/buttons/form_for_button.dart';
import 'package:package_info_plus/package_info_plus.dart';

@RoutePage()
class ClientProfileAboutPlatformScreen extends StatefulWidget {
  const ClientProfileAboutPlatformScreen({super.key});

  @override
  State<ClientProfileAboutPlatformScreen> createState() => _ClientProfileAboutPlatformScreenState();
}

class _ClientProfileAboutPlatformScreenState extends State<ClientProfileAboutPlatformScreen> {
  String currentVersion = "";

  @override
  void initState() {
    check();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.basicwhiteColor,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          color: AppColors.basicwhiteColor,
        ),
        child: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14.w),
                  child: Column(
                    children: [
                      SizedBox(height: 56.h + 10.h),
                      Center(
                        child: Text(
                          "Версия 1.0.0 + 56",
                          //getCurrentVersion(),
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12.sp,
                            fontFamily: 'Inter',
                            color: AppColors.darkGreenColor,
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      divText('Общие сведения'),
                      SizedBox(height: 16.h),
                      rowContainer(
                            () {},
                        'assets/images/reload.svg',
                        'Синхронизировать данные',
                        null,
                      ),
                      SizedBox(height: 16.h),
                      rowContainer(
                            () {},
                        'assets/images/trash.svg',
                        'Удалить все данные',
                        null,
                      ),
                      SizedBox(height: 32.h),
                      divText('Юридическая информация'),
                      SizedBox(height: 16.h),
                      rowContainer(
                            () {},
                        'assets/images/eye.svg',
                        'Политика конфиденциальности',
                        null,
                      ),
                      SizedBox(height: 32.h),
                      divText('Поддержите нас'),
                      SizedBox(height: 16.h),
                      rowContainer(
                            () {},
                        'assets/images/share.svg',
                        'Поделиться с друзьями',
                        'Напишите нам сообщение',
                      ),
                      SizedBox(height: 16.h),
                      rowContainer(
                            () {},
                        'assets/images/mail.svg',
                        'Обратная связь',
                        'Напишите нам сообщение',
                      ),
                      SizedBox(height: 30.h),
                    ],
                  ),
                ),
              ),
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
                        child: Text(
                          'О платформе',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20.sp,
                            fontFamily: 'Inter',
                            color: AppColors.darkGreenColor,
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
    );
  }

  check() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      currentVersion = packageInfo.version;
    });
  }

  String getCurrentVersion() {
    if (currentVersion.isNotEmpty) {
      return "Версия $currentVersion";
    }
    return "";
  }

  SizedBox rowContainer(
      Function() onTap,
      String svgName,
      String text,
      String? seocondText,
      ) {
    return SizedBox(
      child: FormForButton(
        borderRadius: BorderRadius.zero,
        onPressed: onTap,
        child: Row(
          children: [
            SvgPicture.asset(
              svgName,
              width: 24.w,
              height: 24.h,
              color: AppColors.vivaMagentaColor,
            ),
            SizedBox(width: 16.w),
            SizedBox(
              width: 263.w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18.sp,
                      fontFamily: 'Inter',
                      color: AppColors.darkGreenColor,
                    ),
                  ),
                  seocondText == null
                      ? const SizedBox()
                      : Text(
                    seocondText,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 13.sp,
                      fontFamily: 'Inter',
                      color: AppColors.darkGreenColor,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            SvgPicture.asset(
              'assets/images/arrow_black.svg',
              width: 24.w,
              height: 24.h,
              color: AppColors.vivaMagentaColor,
            )
          ],
        ),
      ),
    );
  }

  Column divText(String text) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 3.w),
          child: Row(
            children: [
              Text(
                text,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14.sp,
                  fontFamily: 'Inter',
                  color: AppColors.darkGreenColor,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10.h),
        Stack(
          children: [
            Container(
              width: double.infinity,
              height: 1,
              color: AppColors.basicwhiteColor,
            ),
            Container(
              width: double.infinity,
              height: 1,
              decoration: BoxDecoration(
                gradient: AppColors.gradientSecond,
              ),
            ),
          ],
        ),
      ],
    );
  }

}


