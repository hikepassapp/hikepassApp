import 'package:flutter/material.dart';

class RoleSelectionHeroImageWidget extends StatelessWidget {
  const RoleSelectionHeroImageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.55,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/hiking_adventure.jpg'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.cyan.withOpacity(0.3),
            BlendMode.overlay,
          ),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.white.withOpacity(0.3),
              Colors.white,
            ],
            stops: [0.0, 0.7, 1.0],
          ),
        ),
      ),
    );
  }
}