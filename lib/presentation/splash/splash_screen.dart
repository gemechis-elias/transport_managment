import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transport_app/presentation/auth/pinScreen.dart';
import 'package:transport_app/data/bus_data.dart';
import 'package:transport_app/models/bus.dart';
import 'package:transport_app/models/queue_model.dart';
import '../home.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    checkFirstVisit();
  }


  Future<void> checkFirstVisit() async {
    final prefs = await SharedPreferences.getInstance();
    final visitedBefore = prefs.getBool('visited_before') ?? false;

    Future.delayed(
      const Duration(seconds: 3),
      () {
        if (visitedBefore) {
          // If visited before, navigate to Home()
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Pininput()),
          );
        } else {
          // If first visit, navigate to OnBoardingScreen()
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Pininput()),
          );

          // Set visited_before flag to true for future visits
          prefs.setBool('visited_before', true);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: const BoxDecoration(color: Colors.white70),
        child: Center(
          child: Container(
            width: 450,
            height: 200,
            margin: const EdgeInsets.only(bottom: 50),
            child: Image.asset('assets/images/bus.png'),
          ),
        ),
      ),
    );
  }
}
