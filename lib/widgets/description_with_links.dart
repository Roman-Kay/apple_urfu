import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class DescriptionWithLinks extends StatelessWidget {
  final String text;

  const DescriptionWithLinks({super.key, required this.text});

  static const String linkText = '(ССЫЛКА)';
  static const String url = 'https://www.youtube.com/watch?v=SUiMr3h50_g';

  @override
  Widget build(BuildContext context) {
    final parts = text.split(linkText);
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 14.sp,
          fontFamily: 'Inter',
          color: AppColors.darkGreenColor,
        ),
        children: [
          for (int i = 0; i < parts.length; i++) ...[
            TextSpan(text: parts[i]),
            if (i < parts.length - 1)
              TextSpan(
                text: linkText,
                style: TextStyle(
                  color: AppColors.vivaMagentaColor,
                  fontWeight: FontWeight.w400,
                  fontSize: 14.sp,
                  fontFamily: 'Inter',
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.vivaMagentaColor,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () async {
                    final uri = Uri.parse(url);
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri, mode: LaunchMode.platformDefault);
                    }
                  },
              ),
          ]
        ],
      ),
    );
  }
}
