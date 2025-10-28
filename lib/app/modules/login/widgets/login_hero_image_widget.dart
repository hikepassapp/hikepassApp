import 'package:flutter/material.dart';

class LoginHeroImageWidget extends StatelessWidget {
  const LoginHeroImageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/imgonBoarding.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
