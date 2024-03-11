import 'package:flutter/material.dart';

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

      body:  Center(child:Text("Alarms")),
    );
  }
}