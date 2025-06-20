import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garnetbook/utils/colors.dart';

@RoutePage()
class SplashMotivationScreen extends StatefulWidget {
  const SplashMotivationScreen({super.key});

  @override
  State<SplashMotivationScreen> createState() => _SplashMotivationScreenState();
}

class _SplashMotivationScreenState extends State<SplashMotivationScreen> {
  final List<String> motivationalPhrases = [
    "Ты способен на большее, чем думаешь!",
    "Одно маленькое действие — и ты уже лучше, чем вчера.",
    "Двигайся вперёд, даже если шаг маленький!",
    "Сегодня — отличный день, чтобы стать сильнее.",
    "Здоровье — твоя главная инвестиция!",
  ];

  late String phrase;

  @override
  void initState() {
    super.initState();
    phrase = (motivationalPhrases..shuffle()).first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkGreenColor,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: AppColors.gradientTurquoise2Reverse),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              phrase,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.darkGreenColor,
                fontSize: 24.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
