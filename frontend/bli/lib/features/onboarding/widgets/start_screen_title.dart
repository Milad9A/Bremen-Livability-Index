import 'package:bli/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class StartScreenTitle extends StatelessWidget {
  final Animation<Offset> textSlide;
  final Animation<double> textOpacity;

  const StartScreenTitle({
    super.key,
    required this.textSlide,
    required this.textOpacity,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      top: 0,
      bottom: MediaQuery.of(context).size.height * 0.7,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SlideTransition(
            position: textSlide,
            child: FadeTransition(
              opacity: textOpacity,
              child: const Text(
                'Bremen Livability Index',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                  letterSpacing: 0.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
