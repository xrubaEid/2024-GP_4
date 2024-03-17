import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AlarmScreen extends StatefulWidget {
  static String RouteScreen = 'alarm_screen';

  const AlarmScreen({super.key});

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Center(child: Center(child: Text("Wake Up time "))),
          DigitalClock(
            digitAnimationStyle: Curves.easeInOut,
            is24HourTimeFormat: false,
            areaDecoration: BoxDecoration(
              color: Colors.transparent,
            ),
            hourMinuteDigitTextStyle: TextStyle(
              color: Colors.blueGry,
              fontSize: 50,
            ),
          ),
        ],
      ),
    );
  }
}
