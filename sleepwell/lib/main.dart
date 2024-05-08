//import 'dart:html';
import 'package:alarm/alarm.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sleepwell/feedback/feedback_page.dart';
import 'package:sleepwell/firebase_options.dart';
import 'package:sleepwell/screens/alarm_screen.dart';
import 'package:sleepwell/screens/home_screen.dart';
import 'package:sleepwell/screens/onboarding_screen.dart';
import 'package:sleepwell/screens/profile_screen.dart';
import 'package:sleepwell/screens/signin_screen.dart';
import 'package:sleepwell/screens/signup_screen.dart';
import 'package:sleepwell/screens/splash_screen.dart';
import 'package:sleepwell/screens/welcoming_screen.dart';
import 'package:sleepwell/signup/question.dart';

late SharedPreferences prefs;
Future<void> main() async {
//
  //final WidgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  // GetX local storege
  //await GetStorage.init();
  prefs = await SharedPreferences.getInstance();

  await Alarm.init(showDebugLogs: true);

// GetX local storege
  // await GetStorage.init();
//coenact to fire base
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    bool loginStatus = prefs.getBool("isLogin") ?? false;
    return GetMaterialApp(
      title: 'SleepWell',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute:
          loginStatus ? MyHomePage.RouteScreen : SplashScreen.RouteScreen,
      //initialRoute: SplashScreen.RouteScreen,
      //initialRoute: FeedbackPage.RouteScreen,
      routes: {
        SignInScreen.RouteScreen: (context) => const SignInScreen(),
        MyHomePage.RouteScreen: (context) => const MyHomePage(),
        SignUpScreen.RouteScreen: (context) => const SignUpScreen(),
        SplashScreen.RouteScreen: (context) => const SplashScreen(),
        AlarmScreen.RouteScreen: (context) => const AlarmScreen(),
        ProfileScreen.RouteScreen: (context) => const ProfileScreen(),
        welcome.RouteScreen: (context) => const welcome(),
        OnboardingScreen.RouteScreen: (context) => const OnboardingScreen(),
        FeedbackPage.RouteScreen: (context) => FeedbackPage(),
        QuestionScreen.RouteScreen: (context) => const QuestionScreen(),
       // MoreAboutYou.RouteScreen: (context) =>  MoreAboutYou(documentId:userId),
      },
    );
  }
}
