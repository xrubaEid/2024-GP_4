import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpSteepsScreen extends StatefulWidget {
   static String RouteScreen = 'signup_steps';
@override
_SignUpSteepsScreenState createState() => _SignUpSteepsScreenState();
}

class _SignUpSteepsScreenState extends State<SignUpSteepsScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
// why late because i well not give  it a value new
  late String name;
  late String Lname;
  late String email;
  late String password;
  late String cpassword;
int _currentStep = 0;

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: Text(''),
backgroundColor: Color.fromARGB(255, 0, 74, 173),
),
body: Container(
   height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF004AAD), Color(0xFF040E3B)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
  child: Stepper(
  currentStep: _currentStep,
  onStepContinue: () {
  setState(() {
  _currentStep < 2 ? _currentStep += 1 : null;
  });
  },
  onStepCancel: () {
  setState(() {
  _currentStep > 0 ? _currentStep -= 1 : null;
  });
  },
  steps: [
  Step(
  title: Text('Sign Up'),
  content: Text('Step 1: Sign up details'),
  isActive: _currentStep == 0,
  ),
  Step(
  title: Text('More about you '),
  content: Text('Step 2: Answer some questions'),
  isActive: _currentStep == 1,
  ),
  Step(
  title: Text('Default Time'),
  content: Text('Step 3: Set default time'),
  isActive: _currentStep == 2,
  ),
  ],
  ),
),
);
}
}