import 'package:flutter/material.dart';
<<<<<<< HEAD

=======
>>>>>>> a5772954afbe167ad5addf62c64194358466bcd6
class AlarmScreen extends StatefulWidget {
static String RouteScreen ='alarm_screen';

  const AlarmScreen({super.key});

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(

<<<<<<< HEAD
      body:  Center(child:Text("Alarms")),
=======
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Center(child:Center(child: Text("Wake Up time "))),
          /*DigitalClock(
            digitAnimationStyle: Curves.easeInOut,
            is24HourTimeFormat: false,
            areaDecoration: BoxDecoration(
              color: Colors.transparent,
            ),
            hourMinuteDigitTextStyle: TextStyle(
              color: Colors.blueGry,
              fontSize: 50,
            ),
          ),*/
        ],
      ),
>>>>>>> a5772954afbe167ad5addf62c64194358466bcd6
    );
  }
}