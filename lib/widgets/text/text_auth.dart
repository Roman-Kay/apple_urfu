import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/widgets/buttons/form_for_button.dart';

class TextAuth extends StatelessWidget {
  const TextAuth({super.key});

  @override
  Widget build(BuildContext context) {
    return FormForButton(
      onPressed: () {},
      borderRadius: BorderRadius.circular(4),
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            height: 1.2,
            fontSize: 10.sp,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
            color: AppColors.darkGreenColor,
            decorationColor: AppColors.darkGreenColor,
          ),
          children: [
            TextSpan(text: 'Нажимая кнопку «ДАЛЕЕ» я совершаю акцепт '),
            TextSpan(
              text: 'пользовательского соглашения Клиента',
              style: TextStyle(
                decorationColor: AppColors.darkGreenColor,
                decoration: TextDecoration.underline,
              ),
            ),
            TextSpan(
                text:
                    ' со всеми его неотъемлемыми частями, ознакомлен и полностью принимаю его, а также даю свое '),
            TextSpan(
              text: 'согласие',
              style: TextStyle(
                decorationColor: AppColors.darkGreenColor,
                decoration: TextDecoration.underline,
              ),
            ),
            TextSpan(
                text:
                    ' ООО «ЛОНГЛАЙФ» (ОГРН 1237700258619) на обработку моих персональных данных в соответствии с '),
            TextSpan(
              text: 'политикой конфиденциальности',
              style: TextStyle(
                decorationColor: AppColors.darkGreenColor,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
