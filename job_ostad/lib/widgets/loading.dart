import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CustomLoadingIndicator extends StatelessWidget {
  const CustomLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 200,
        height: 200,
        child: Lottie.asset(
          'assets/animation/Interwind@1x-1.0s-200px-200px.json',
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
