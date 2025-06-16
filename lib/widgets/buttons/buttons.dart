import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class Button extends StatelessWidget {
  const Button(
      {required this.height,
      required this.style,
      required this.child,
      required this.onPressed,
      super.key});

  final double? height;
  final ButtonStyle? style;
  final Widget child;
  final Function()? onPressed;

  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: style,
        child: child,
      ),
    );
  }
}


class ButtonSecond extends StatelessWidget {
  const ButtonSecond(
      {required this.height,
      required this.style,
      required this.child,
      required this.onPressed,
      super.key});

  final double? height;
  final ButtonStyle? style;
  final Widget child;
  final Function()? onPressed;

  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: style,
        child: child,
      ),
    );
  }
}