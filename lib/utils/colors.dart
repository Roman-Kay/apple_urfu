import 'package:flutter/material.dart';

abstract class AppColors {
  static const rubinColor = Color.fromRGBO(190, 52, 85, 1);
  static const basicwhiteColor = Color.fromRGBO(255, 255, 255, 1);
  static const basicblackColor = Color.fromRGBO(0, 0, 0, 1);
  static const seaColor = Color.fromRGBO(174, 229, 226, 1);
  static const limeColor = Color.fromRGBO(213, 244, 229, 1);
  static const pictoColor = Color.fromRGBO(0, 0, 0, 0.1);
  static const darkGreenColor = Color.fromRGBO(0, 129, 125, 1);
  static const darkWithOpacitygreenColor = Color.fromRGBO(0, 129, 125, 0.70);
  static const lightGreenColor = Color.fromRGBO(223, 249, 248, 1);
  static const lightGreyColor = Color.fromRGBO(135, 141, 150, 1);
  static const seaweedColor = Color.fromRGBO(82, 75, 42, 1);
  static const yellowColor = Color(0xFFF5EE3F);

  static const greenColor = Color(0xFF41CBAA);
  static const darkGreenSecondaryColor = Color(0xFF00817D);
  static const redBEColor = Color(0xFFBE3455);

  static const vivaMagentaColor = Color.fromRGBO(190, 52, 85, 1);
  static const grey10Color = Color(0xFFF2F4F8);
  static const grey20Color = Color.fromRGBO(221, 225, 230, 1);
  static const grey30Color = Color.fromRGBO(193, 199, 205, 1);
  static const grey40Color = Color.fromRGBO(193, 199, 205, 1);
  static const grey50Color = Color.fromRGBO(135, 141, 150, 1);
  static const grey60Color = Color.fromRGBO(105, 112, 119, 1);
  static const grey70Color = Color.fromRGBO(77, 83, 88, 1);
  static const grey80Color = Color.fromRGBO(52, 58, 63, 1);
  static const grey90Color = Color.fromRGBO(33, 39, 42, 1);
  static const grey100Color = Color.fromRGBO(18, 22, 25, 1);
  static const blueColor = Color.fromRGBO(98, 172, 252, 1);
  static const bluevkColor = Color.fromRGBO(0, 119, 255, 1);
  static const blueBasicColor = Color(0xFFDFF9F8);
  static const blueSecondaryColor = Color(0xFF62ACFC);
  static const blueSecondaryVKColor = Color(0xFF0077FF);
  static const tifannyColor = Color(0xFF41CBAA);

  static const softblueColor = Color.fromRGBO(98, 210, 252, 1);
  static const orangeColor = Color.fromRGBO(255, 159, 0, 1);
  static const redColor = Color(0xFFFF0000);
  static const ultralightgreenColor = Color.fromRGBO(0, 204, 0, 1);
  static const pinkLavenderColor = Color.fromRGBO(216, 178, 209, 1);
  static const greenLightColor = Color.fromRGBO(0, 204, 0, 1);
  static const tintaColor = Color.fromRGBO(230, 157, 166, 1);
  static const tintsColor = Color.fromRGBO(249, 222, 224, 1);
  static const tints2Color = Color.fromRGBO(240, 190, 195, 1);
  static const tints3Color = Color.fromRGBO(230, 157, 166, 1);
  static const crimsonColor = Color(0xFFDC143C);
  static const tints4Color = Color(0xFFDB7D8A);
  static const tangeloColor = Color.fromRGBO(255, 176, 119, 1);
  static const tintsDark5 = Color.fromRGBO(156, 46, 71, 1);
  static const purpleColor = Color.fromRGBO(124, 64, 140, 1);

  static const backgroundgradientColor = LinearGradient(colors: [
    Color.fromRGBO(223, 249, 248, 1),
    Color.fromRGBO(213, 244, 229, 1),
    Color.fromRGBO(174, 229, 226, 1),
  ]);

  static const gradientTurquoise = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFFDBFFFD),
      Color(0xFFD5F4E5),
      Color(0xFFAEE5E2),
    ],
  );

  static const gradientTurquoiseReverse = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFFAEE5E2),
      Color(0xFFD5F4E5),
      Color(0xFFDBFFFD),
    ],
  );

  static const gradientTurquoise2Reverse = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFFAEE5E2),
      Color(0xFFD5F4E5),
      Color(0xFFDFF9F8),
    ],
  );

  static const secondbackgroundgradientColor = LinearGradient(
    end: Alignment.centerLeft,
    begin: Alignment.centerRight,
    colors: [
      Color.fromRGBO(223, 249, 248, 1),
      Color.fromRGBO(213, 244, 229, 1),
      Color.fromRGBO(174, 229, 226, 1),
    ],
  );

  static final gradientSecond = LinearGradient(
    end: Alignment.centerRight,
    begin: Alignment.centerLeft,
    colors: [
      Color(0xFFDFF9F8),
      Color(0xFFD5F4E5),
      Color(0xFFAEE5E2),
    ],
  );

  static final gradientThird = LinearGradient(
    end: Alignment.centerLeft,
    begin: Alignment.centerRight,
    colors: [
      Color(0xFFAEE5E2),
      Color(0xFFD5F4E5),
      Color(0xFFDFF9F8),
      Color(0xFFDFF9F8),
      Color(0xFFD5F4E5),
    ],
  );

  static final gradientThird2 = LinearGradient(
    end: Alignment.centerLeft,
    begin: Alignment.centerRight,
    colors: [
      Color(0xFFD5F4E5),
      Color(0xFFDFF9F8),
      Color(0xFFDFF9F8),
      Color(0xFFD5F4E5),
    ],
  );

  static final gradientBasikWhite = LinearGradient(
    colors: [
      Color(0xFFFFFFFF),
      Color(0xFFFFFFFF),
    ],
  );

  static const thirdbackgroundgradientColor = LinearGradient(end: Alignment.bottomCenter, begin: Alignment.bottomLeft, colors: [
    Color.fromRGBO(223, 249, 248, 1),
    Color.fromRGBO(213, 244, 229, 1),
    Color.fromRGBO(174, 229, 226, 1),
  ]);


  static const backGradient = LinearGradient(end: Alignment.topCenter, begin: Alignment.bottomLeft, colors: [
    Color.fromRGBO(223, 249, 248, 1),
    Color.fromRGBO(213, 244, 229, 1),
    Color.fromRGBO(174, 229, 226, 1),
  ]);

  static const whitegradientColor = LinearGradient(colors: [
    Color.fromRGBO(174, 229, 226, 1),
    Color.fromRGBO(213, 244, 229, 1),
    Color.fromRGBO(223, 249, 248, 1),
    Color.fromRGBO(223, 249, 248, 1),
    Color.fromRGBO(213, 244, 229, 1),
  ]);

  static const multigradientColor = LinearGradient(end: Alignment.center, begin: Alignment.centerRight, colors: [
    Color(0xFFAEE5E2),
    Color(0xFFD5F4E5),
    Color(0xFFDFF9F8),
    Color(0xFFDFF9F8),
    Color(0xFFD5F4E5),
  ]);



  static const gradientBlack = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      grey60Color,
      grey50Color,
      grey40Color,
    ],
  );

  static var gradientSideStyle = BoxDecoration(
    gradient: AppColors.backgroundgradientColor,
    border: Border.all(
      color: AppColors.lightGreenColor,
    ),
    borderRadius: BorderRadius.all(Radius.circular(8)),
  );
}
