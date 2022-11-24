import 'dart:math';

import 'package:flutter/material.dart';

class CustomSplash extends StatefulWidget {
  final String text;
  final Widget? image;
  final String? imageAsset;
  final Color textColor;
  final Color? color;
  final double height;
  final double width;

  const CustomSplash({
    Key? key,
    this.text = '',
    this.image,
    this.imageAsset,
    this.textColor = Colors.black,
    this.color,
    this.height = 80.0,
    this.width = 80.0,
  }) : super(key: key);

  @override
  State<CustomSplash> createState() => _CustomSplashState();
}

class _CustomSplashState extends State<CustomSplash> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _flipAnim;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _flipAnim = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 1.0),
      ),
    );

    _controller.addListener(() {
      if (_controller.isCompleted) {
        _controller.repeat();
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller.forward();
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedBuilder(
                animation: _controller,
                builder: (context, snapshot) {
                  return Transform(
                    transform: Matrix4.identity()..rotateY(2 * pi * _flipAnim.value),
                    alignment: Alignment.center,
                    child: widget.image ??
                        Image.asset(
                          widget.imageAsset ?? '',
                          height: widget.height,
                          width: widget.width,
                          color: widget.color,
                        ),
                  );
                },
              ),
              if (widget.text.isNotEmpty)
                Container(
                  margin: const EdgeInsets.all(10),
                  constraints: const BoxConstraints(
                    maxWidth: 250,
                  ),
                  child: Text(
                    widget.text,
                    maxLines: 5,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: widget.textColor,
                      fontWeight: widget.textColor == Colors.black ? FontWeight.w600 : FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
