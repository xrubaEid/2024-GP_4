//import 'dart:html';
import 'package:flutter/material.dart';
import 'package:sleepwell/screens/home_screen.dart';
import 'package:sleepwell/screens/signin_screen.dart';
import 'package:sleepwell/screens/signup_screen.dart';
import 'package:sleepwell/screens/splash_screen.dart';

 main() async {
  //coenact to fire base 
//WidgetsFlutterBinding.ensureInitialized();
//await Firebase.initializeApp();
/*await Firebase.initializeApp( options: DefaultFirebaseOptions.s).then(
(FirebaseApp value ) => Get.put(AuthenticationRepository()),
);*/


  runApp(const MyApp());
}

class AuthenticationRepository {}

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
     initialRoute:SplashScreen.RouteScreen,
     routes:{
      SignInScreen.RouteScreen : (context)=> SignInScreen(),
      MyHomePage.RouteScreen : (context)=> MyHomePage(),
      SignUpScreen.RouteScreen : (context)=> SignUpScreen(),
      SplashScreen.RouteScreen : (context)=> SplashScreen(),

     
     },

    );
  }
}
