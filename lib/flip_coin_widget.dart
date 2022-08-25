import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter_svg/svg.dart';

class FlipCoinWidget extends StatefulWidget {
  final Duration duration;

  const FlipCoinWidget({
    Key? key,
    required this.duration,
  }) : super(key: key);

  @override
  _FlipCoinWidgetState createState() => _FlipCoinWidgetState();
}

class _FlipCoinWidgetState extends State<FlipCoinWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _frontScale;
  late Animation<double> _backScale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _frontScale = Tween(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(
        0.0,
        0.7,
        curve: Curves.easeIn,
      ),
    ));
    _backScale = CurvedAnimation(
      parent: _controller,
      curve: const Interval(
        0.7,
        1.0,
        curve: Curves.easeOut,
      ),
    );
    repeat();
  }

  Future<void> repeat() async {
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
    return Center(
      child: Stack(
        children: <Widget>[
          AnimatedBuilder(
            animation: _backScale,
            builder: (context, child) {
              final Matrix4 transform =
                  Matrix4.rotationY(math.pi) //,Matrix4.identity()
                    ..scale(_backScale.value, 1.0, 1.0);
              return Transform(
                transform: transform,
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  'assets/images/coin.svg',
                  height: 100,
                  width: 100,
                  alignment: Alignment.center,
                ),
              );
            },
          ),
          AnimatedBuilder(
            animation: _frontScale,
            builder: (context, child) {
              final Matrix4 transform = Matrix4.identity()
                ..scale(_frontScale.value, 1.0, 1.0);
              return Transform(
                transform: transform,
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  'assets/images/coin.svg',
                  height: 100,
                  width: 100,
                  alignment: Alignment.center,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
