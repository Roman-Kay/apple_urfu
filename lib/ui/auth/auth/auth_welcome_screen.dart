// import 'dart:ui';
// import 'package:auto_route/auto_route.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:garnetbook/data/repository/shared_preference_data.dart';
// import 'package:garnetbook/utils/colors.dart';

// @RoutePage()
// class AuthWelcomeScreen extends StatefulWidget {
//   const AuthWelcomeScreen({super.key});

//   @override
//   State<AuthWelcomeScreen> createState() => _AuthWelcomeScreenState();
// }

// class _AuthWelcomeScreenState extends State<AuthWelcomeScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return ScreenUtilInit(
//         designSize: const Size(375, 812),
//         builder: (context, child) {
//           return Scaffold(
//             body: Stack(
//               fit: StackFit.expand,
//               children: [
//                 Image.asset(
//                   "assets/images/gif_splash.gif",
//                   fit: BoxFit.cover,
//                   height: 375.h,
//                   width: 812.w,
//                 ),
//                 FutureBuilder<String>(
//                     future: SharedPreferenceData.getInstance().getItem(SharedPreferenceData.userNameKey),
//                     builder: (context, snapshot) {
//                       if (snapshot.hasData && snapshot.data != null && snapshot.data != '') {
//                         return SafeArea(
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                               SizedBox(height: 32.h),
//                               Container(
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(20.r),
//                                   color: AppColors.basicwhiteColor.withOpacity(0.4),
//                                 ),
//                                 child: ClipRRect(
//                                   clipBehavior: Clip.hardEdge,
//                                   borderRadius: BorderRadius.circular(20.r),
//                                   child: ClipRect(
//                                     child: BackdropFilter(
//                                       filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
//                                       child: Padding(
//                                         padding: EdgeInsets.symmetric(horizontal: 60, vertical: 15),
//                                         child: Column(
//                                           mainAxisAlignment: MainAxisAlignment.center,
//                                           children: [
//                                             Text(
//                                               getTime(),
//                                               textAlign: TextAlign.center,
//                                               style: TextStyle(
//                                                 fontFamily: 'Inter',
//                                                 color: AppColors.darkGreenColor,
//                                                 fontSize: 24.sp,
//                                                 fontWeight: FontWeight.w700,
//                                               ),
//                                             ),
//                                             Text(
//                                               snapshot.data!.toString(),
//                                               textAlign: TextAlign.center,
//                                               style: TextStyle(
//                                                 fontFamily: 'Inter',
//                                                 color: AppColors.vivaMagentaColor,
//                                                 fontSize: 24.sp,
//                                                 fontWeight: FontWeight.w700,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         );
//                       }
//                       else {
//                         return SafeArea(
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                               SizedBox(height: 32.h),
//                               Container(
//                                   decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(20.r), color: AppColors.basicwhiteColor.withOpacity(0.4)),
//                                   child: ClipRRect(
//                                     clipBehavior: Clip.hardEdge,
//                                     borderRadius: BorderRadius.circular(20.r),
//                                     child: ClipRect(
//                                       child: new BackdropFilter(
//                                         filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
//                                         child: Padding(
//                                           padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
//                                           child: Column(
//                                             mainAxisAlignment: MainAxisAlignment.center,
//                                             children: [
//                                               Text(
//                                                 'Добро пожаловать!',
//                                                 textAlign: TextAlign.center,
//                                                 style: TextStyle(
//                                                   fontFamily: 'Inter',
//                                                   color: AppColors.darkGreenColor,
//                                                   fontSize: 24.sp,
//                                                   fontWeight: FontWeight.w700,
//                                                 ),
//                                               ),
//                                               Image.asset(
//                                                 "assets/images/Garnetbook.webp",
//                                                 height: 85.h,
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   )),
//                             ],
//                           ),
//                         );
//                       }
//                     }),
//               ],
//             ),
//           );
//         });
//   }

//   getTime() {
//     if (DateTime.now().hour < 4) {
//       return 'Доброй ночи,';
//     } else if (DateTime.now().hour < 12) {
//       return 'Доброе утро,';
//     } else if (DateTime.now().hour < 18) {
//       return 'Добрый день,';
//     } else if (DateTime.now().hour < 23) {
//       return 'Добрый вечер,';
//     } else {
//       return 'Доброй ночи,';
//     }
//   }
// }
