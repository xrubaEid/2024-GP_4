import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
//import 'package:get/utils.dart';
import 'package:sleepwell/screens/clockview.dart';
import 'package:intl/intl.dart';

class AlarmScreen extends StatefulWidget {
  static String RouteScreen = 'alarm_screen';

  const AlarmScreen({super.key});

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    var formattedDate = DateFormat('EEE, d MMM').format(now);
    var formattedTime = DateFormat('hh:mm').format(now);

    var white = Colors.white;
    const color = Color.fromARGB(255, 255, 255, 255);
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 16, 95, 199),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF004AAD), Color(0xFF040E3B)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(30),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'SleepWell Cycle',
                      style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 20),
                    ),
                    SizedBox(height: 15),
                    Text(
                      formattedTime,
                      style: const TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 40),
                    ),
                    Text(
                      formattedDate,
                      style: const TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 15),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: ClockView(),
              ),
            ], //<widget>[]
          ), //row
        ), //container
      ),
    );
  }
}
