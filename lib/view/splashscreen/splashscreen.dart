import 'dart:async';
import 'package:janin/theme.dart';
import 'package:flutter/material.dart';
import 'package:janin/view/signin/signin.dart';
import 'package:janin/view/signin/wrapper.dart';
import 'package:janin/view/splashscreen/onboardingpage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../provider/auth.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  void initState() {
    super.initState();
    splashStart();
  }

  splashStart() async {
    var duration = const Duration(seconds: 2);
    return Timer(
      duration,
      () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OnBoardingPage(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pinkColor,
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 200,
                width: 300,
                child: Image.asset('assets/image/logo.png'),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
