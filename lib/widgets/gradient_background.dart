import 'dart:ui';
import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  final bool showLogo;
  
  const GradientBackground({super.key, this.showLogo = false});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -150,
          left: MediaQuery.of(context).size.width / 2 - 270,
          child: Container(
            width: 550,
            height: 550,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Color(0xFF94BCEB),
                  Colors.white,
                ],
                radius: 0.55,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -150,
          left: MediaQuery.of(context).size.width / 2 - 270,
          child: Container(
            width: 550,
            height: 550,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Color(0xFFA49EF4),
                  Colors.white,
                ],
                radius: 0.55,
              ),
            ),
          ),
        ),
        if (showLogo)
          Positioned(
            top: 35,
            left: 0,
            right: 0,
            child: Center(
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 0.5),
                child: const Text(
                  'LifeLog',
                  style: TextStyle(
                    fontFamily: 'AnticDidone',
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}