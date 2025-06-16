import 'package:flutter/cupertino.dart';
import 'package:garnetbook/utils/colors.dart';

class BottomAlign extends StatelessWidget {
  final double heightOfChild;
  final double heightSafeArea;
  final Widget child;
  const BottomAlign({super.key, required this.child, required this.heightOfChild, required this.heightSafeArea});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return OverflowBox(
          maxHeight: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                height: heightSafeArea - heightOfChild,
              ),
              child,
            ],
          ),
        );
      },
    );
  }
}
