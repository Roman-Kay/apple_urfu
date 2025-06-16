import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:garnetbook/utils/colors.dart';

class ProgressIndicatorWidget extends StatelessWidget {
  final bool? isSmall;
  final bool? isImage;
  final bool? isWhite;

  ProgressIndicatorWidget({super.key, this.isSmall, this.isImage, this.isWhite});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: isImage == true ? 20 : 30,
        height: isImage == true ? 20 : 30,
        child: Platform.isIOS
            ? CupertinoActivityIndicator(
          color: isWhite == true ? AppColors.basicwhiteColor : AppColors.darkGreenColor,
          radius: 15,
        )
        : CircularProgressIndicator(
          strokeWidth: isImage == true ? 2 : 4, //isSmall == true ? 3 : 4,
          color: isWhite == true ? AppColors.basicwhiteColor : AppColors.darkGreenColor,
        ),
      ),
    );
  }
}
