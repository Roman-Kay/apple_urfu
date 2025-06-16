
import 'package:flutter/material.dart';
import 'package:garnetbook/utils/colors.dart';

class Divider extends StatelessWidget {
  const Divider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 1,
          width: double.infinity,
          color: AppColors.basicwhiteColor,
        ),
        Container(
          height: 1,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: AppColors.gradientSecond,
          ),
        ),
      ],
    );
  }
}
