import 'package:flutter/material.dart';

class FormForButton extends StatelessWidget {
  final BorderRadiusGeometry borderRadius;
  void Function()? onPressed;
  final Widget child;
  final Color? borderColor;

  FormForButton({
    super.key,
    required this.borderRadius,
    required this.onPressed,
    required this.child,
    this.borderColor
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        minimumSize: Size.zero,
        padding: EdgeInsets.zero,
        side: BorderSide(
          width: 0,
          color: borderColor ?? Color(0x000000),
        ),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius,
        ),
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}
