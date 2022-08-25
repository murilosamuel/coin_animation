import 'package:flutter/material.dart';

import 'flip_coin_widget.dart';

class JumpingFlipCoin extends StatefulWidget {
  final Duration duration;

  const JumpingFlipCoin({
    Key? key,
    required this.duration,
  }) : super(key: key);

  @override
  _JumpingFlipCoinState createState() => _JumpingFlipCoinState();
}

class _JumpingFlipCoinState extends State<JumpingFlipCoin>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> jumpAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    jumpAnimation = Tween<double>(
      begin: 0,
      end: -50,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(
        0.0,
        0.5,
        curve: Curves.easeInBack,
      ),
    ));
    animate();
  }

  Future<void> animate() async {
    do {
      await _controller.forward();
      await _controller.reverse();
    } while (true);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: jumpAnimation,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.all(2.5),
          child: Transform.translate(
            offset: Offset(0, jumpAnimation.value),
            child: FlipCoinWidget(duration: widget.duration),
          ),
        );
      },
    );
  }
}
