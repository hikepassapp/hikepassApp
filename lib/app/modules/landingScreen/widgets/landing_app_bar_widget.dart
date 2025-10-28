import 'package:flutter/material.dart';

class LandingAppBar extends StatelessWidget {
  final VoidCallback onSkip;

  const LandingAppBar({
    super.key,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: TextButton(
        onPressed: onSkip,
        child: const Text(
          'Lewati',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}