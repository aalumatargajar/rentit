import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rentit/src/common/const/app_images.dart';
import 'package:rentit/src/common/const/static_data.dart';
import 'package:rentit/src/features/bottom_nav/bottom_navbar_screen.dart';
import 'package:rentit/src/features/onboarding/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () => navigation());
  }

  navigation() {
    if (StaticData.isLoggedIn) {
      if (StaticData.id.isNotEmpty) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BottomNavbarScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => OnboardingScreen()),
        );
      }
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OnboardingScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Image.asset(AppImages.appLoggo),
        ),
      ),
    );
  }
}
