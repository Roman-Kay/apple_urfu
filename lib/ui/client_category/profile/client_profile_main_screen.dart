import 'package:auto_route/auto_route.dart';
import 'package:cached_memory_image/cached_memory_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:garnetbook/bloc/client/version/version_cubit.dart';
import 'package:garnetbook/bloc/user/user_data_cubit.dart';
import 'package:garnetbook/data/repository/shared_preference_data.dart';
import 'package:garnetbook/domain/controllers/auth/auth_controller.dart';
import 'package:garnetbook/ui/routing/app_router.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/widgets/buttons/form_for_button.dart';

@RoutePage()
class ClientProfileMainScreen extends StatefulWidget {
  const ClientProfileMainScreen({super.key});

  @override
  State<ClientProfileMainScreen> createState() => _ClientProfileMainScreenState();
}

class _ClientProfileMainScreenState extends State<ClientProfileMainScreen> {
  String name = "";
  var avatar;
  int _counterValue = 0;

  final CounterService _counterService = CounterService();

  @override
  void initState() {
    if (BlocProvider.of<UserDataCubit>(context).state is UserDataLoadedState) {
    } else {
      context.read<UserDataCubit>().check();
    } // Загрузка счётчика из памяти
    _loadCounter();
    super.initState();
  }

  Future<void> _loadCounter() async {
    await _counterService.init();
    setState(() {
      _counterValue = _counterService.counter;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserDataCubit, UserDataState>(builder: (context, state) {
      check(state);

      return Scaffold(
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
                Align(
                  alignment: Alignment.topRight,
                  child: Image.asset(
                    'assets/images/Ellipse 4.webp',
                  ),
                ),
                RefreshIndicator(
                  color: AppColors.darkGreenColor,
                  onRefresh: () {
                    context.read<UserDataCubit>().check();
                    return Future.delayed(const Duration(seconds: 1));
                  },
                  child: ListView(
                    children: [
                      SizedBox(height: 56.h + 20.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 14.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  avatar != null && avatar != ""
                                      ? CircleAvatar(
                                          radius: 25, backgroundImage: CachedMemoryImageProvider("app://client_avatar", base64: avatar!))
                                      : CircleAvatar(
                                          backgroundColor: Colors.white,
                                          child: Icon(
                                            Icons.person,
                                            color: AppColors.seaColor,
                                          ),
                                          radius: 25,
                                        ),
                                  SizedBox(width: 16.w),
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          name,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18.sp,
                                            fontFamily: 'Inter',
                                            color: AppColors.darkGreenColor,
                                          ),
                                        ),
                                        SizedBox(height: 4.h),
                                        GestureDetector(
                                          behavior: HitTestBehavior.translucent,
                                          onTap: () {
                                            context.router.push(ClientProfileEditRoute());
                                          },
                                          child: Text(
                                            'Редактировать профиль',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14.sp,
                                              fontFamily: 'Inter',
                                              color: AppColors.darkGreenColor.withOpacity(0.5),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 6.w),
                                ],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.r),
                                color: AppColors.basicwhiteColor,
                              ),
                              child: FormForButton(
                                onPressed: () {
                                  context.router.push(ClientProfileEditRoute());
                                },
                                borderRadius: BorderRadius.circular(8.r),
                                child: Padding(
                                  padding: const EdgeInsets.all(6),
                                  child: SvgPicture.asset(
                                    'assets/images/settings.svg',
                                    width: 28.w,
                                    height: 28.h,
                                    color: AppColors.vivaMagentaColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 30.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 14.w),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(12.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: SizedBox(
                            height: 64.h,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.countertops_outlined,
                                  color: AppColors.vivaMagentaColor,
                                  size: 28.sp,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  'Текущие сумма баллов:',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.darkGreenColor,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  '$_counterValue',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.darkGreenColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      ProfilePagesCard(
                        text: 'О платформе',
                        title: 'Узнать больше о нас',
                        push: () {
                          context.router.push(ClientProfileAboutPlatformRoute());
                        },
                      ),
                      SizedBox(height: 30.h),
                    ],
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
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14.w),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () async {
                                AuthController().logout();
                                context.router.replaceAll([DashboardContainerRoute()]);
                              },
                              child: Text(
                                'Выйти'.toUpperCase(),
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14.sp,
                                  fontFamily: 'Inter',
                                  color: AppColors.darkGreenColor,
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: Text(
                              'Профиль',
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
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  check(state) async {
    if (state is UserDataLoadedState && state.user != null) {
      if (state.user?.firstName != null) {
        name = state.user!.firstName!;
      } else if (state.user?.lastName != null) {
        name = state.user!.lastName!;
      }

      if (state.user?.avatarBase64 != null && state.user?.avatarBase64?.fileBase64 != null) {
        avatar = state.user!.avatarBase64!.fileBase64!;
      }
    }
  }

  Widget ProfilePagesCard({
    required String text,
    required String title,
    required Function() push,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        left: 14.w,
        right: 14.w,
        top: 16.h,
      ),
      child: Container(
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
          onPressed: push,
          child: Center(
              child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 16.h,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        text,
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
                SvgPicture.asset(
                  'assets/images/arrow_black.svg',
                  width: 26.w,
                  height: 26.h,
                  color: AppColors.vivaMagentaColor,
                ),
              ],
            ),
          )),
        ),
      ),
    );
  }
}
