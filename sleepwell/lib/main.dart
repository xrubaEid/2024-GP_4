//import 'dart:html';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sleepwell/firebase_options.dart';
import 'package:sleepwell/screens/alarm_screen.dart';
import 'package:sleepwell/screens/home_screen.dart';
import 'package:sleepwell/screens/profile_screen.dart';
import 'package:sleepwell/screens/signin_screen.dart';
import 'package:sleepwell/screens/signup_screen.dart';
import 'package:sleepwell/screens/onboarding_screen.dart';
import 'package:sleepwell/screens/welcoming_screen.dart';

Future<void> main() async {
//
  final WidgetsBinding = WidgetsFlutterBinding.ensureInitialized();
// GetX local storege
  await GetStorage.init();
//coenact to fire base
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//.then( (FirebaseApp value ) => Get.put(AuthenticationRepository()),)

// await Splash until other items loaded
//flutterNativeSplash.preserve(WidgetsBinding:WidgetsBinding);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SleepWell',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: OnboardingScreen.RouteScreen,
      routes: {
        SignInScreen.RouteScreen: (context) => const SignInScreen(),
        MyHomePage.RouteScreen: (context) => const MyHomePage(),
        SignUpScreen.RouteScreen: (context) => const SignUpScreen(),
        OnboardingScreen.RouteScreen: (context) => const OnboardingScreen(),
        AlarmScreen.RouteScreen: (context) => const AlarmScreen(),
        ProfileScreen.RouteScreen: (context) => const ProfileScreen(),
        welcome.RouteScreen: (context) => const welcome(),
      },
    );
  }
}
