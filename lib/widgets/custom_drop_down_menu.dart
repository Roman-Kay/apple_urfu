import 'package:flutter/material.dart';

class CustomDropDownMenu extends StatefulWidget {
  final Widget child;
  final BorderRadiusGeometry borderRadius;
  final bool isOpen;

  const CustomDropDownMenu({
    super.key,
    required this.child,
    this.borderRadius = BorderRadius.zero,
    required this.isOpen,
  });

  @override
  State<CustomDropDownMenu> createState() => _CustomDropDownMenuState();
}

class _CustomDropDownMenuState extends State<CustomDropDownMenu> with TickerProviderStateMixin {
  // controller анимации
  late final AnimationController controllerTransition = AnimationController(
    duration: const Duration(milliseconds: 150),
    vsync: this,
    value: 0,
    lowerBound: 0,
    upperBound: 1,
  );
  late final Animation<double> animation = CurvedAnimation(
    parent: controllerTransition,
    curve: Curves.ease,
  );

  @override
  void dispose() {
    controllerTransition.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // слушаем значение и если оно меняется запускаем анимацию открытия и закрытия
    if (widget.isOpen) {
      controllerTransition.forward();
    } else {
      controllerTransition.reverse();
    }
    return AnimatedOpacity(
      opacity: widget.isOpen ? 1 : 0,
      duration: Duration(milliseconds: 150),
      child: ClipRRect(
        borderRadius: widget.borderRadius,
        child: SizeTransition(
          sizeFactor: animation,
          child: Container(
            color: Colors.transparent,
            child: !widget.isOpen ? const SizedBox() : widget.child,
          ),
        ),
      ),
    );
  }
}
