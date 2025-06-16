import 'package:flutter/material.dart';

import '../../utils/colors.dart';

class PageControllerContainer extends StatelessWidget {
  final int choosenIndex;
  final int length;
  const PageControllerContainer({
    super.key,
    required this.choosenIndex,
    required this.length,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: AppColors.seaColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.5),
        child: Wrap(
          spacing: 4,
          children: List.generate(
            length,
            (int index) {
              return choosenIndex == index
                  ? Container(
                      width: 11,
                      height: 5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(11),
                        color: AppColors.darkGreenColor,
                      ),
                    )
                  : CircleAvatar(
                      backgroundColor: AppColors.basicwhiteColor,
                      radius: 5 / 2,
                    );
            },
          ),
        ),
      ),
    );
  }
}
