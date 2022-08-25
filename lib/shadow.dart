import 'package:flutter/material.dart';

class ShadowWidget extends StatefulWidget {
  final num size;
  final Duration duration;
  const ShadowWidget({
    Key? key,
    required this.duration,
    this.size = 180,
  }) : super(key: key);

  @override
  _ShadowState createState() => _ShadowState();
}

class _ShadowState extends State<ShadowWidget> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation shadowAnimation;
  bool touchedFloor = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    shadowAnimation = Tween(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        curve: Curves.easeIn,
        parent: _animationController,
      ),
    );

    _animationController.addListener(() => setState(() {}));
    _animationController.forward();

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reverse();
        touchedFloor = !touchedFloor;
      } else if (status == AnimationStatus.dismissed) {
        touchedFloor = !touchedFloor;
        _animationController.forward(from: 0.0);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: widget.duration,
      opacity: shadowAnimation.value,
      child: AnimatedContainer(
        height: touchedFloor ? 0.005 : 0.25,
        width: widget.size / (touchedFloor ? 5 : 2.5),
        duration: widget.duration,
        decoration: _decoration,
      ),
    );
  }

  BoxDecoration get _decoration {
    Color shadowColor = Colors.black.withOpacity(touchedFloor ? 0.3 : 0.1);
    return BoxDecoration(
      color: shadowColor,
      borderRadius: BorderRadius.circular(360),
      boxShadow: [
        BoxShadow(
          color: shadowColor,
          blurRadius: touchedFloor ? 5 : 8,
          spreadRadius: touchedFloor ? 5 : 8,
        )
      ],
    );
  }
}
