import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:sleepwell/screens/signin_screen.dart';
import 'package:sleepwell/widget/iconwidget.dart';

import 'aboutyou_screen.dart';

class ProfileScreen extends StatefulWidget {
  static const String RouteScreen = 'profile_screen';

  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _auth = FirebaseAuth.instance;
  late User signInUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        signInUser = user;
        print(signInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    Color myColor = const Color.fromARGB(255, 0, 74, 173);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 16, 95, 199),
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF004AAD), Color(0xFF040E3B)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Container(
                color: const Color(0xffd5defe),
                child: SettingsGroup(
                  title: 'Personal',
                  titleTextStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  children: <Widget>[
                    Account(),
                    AboutYou(),
                  ],
                ),
              ),
              Container(
                color: const Color(0xffd5defe),
                child: SettingsGroup(
                  title: 'Alarm',
                  titleTextStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  children: <Widget>[
                    AlarmSound(),
                    Snooze(),
                  ],
                ),
              ),
              Container(
                color: const Color(0xffd5defe),
                child: SettingsGroup(
                  title: 'Setting',
                  titleTextStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  children: <Widget>[
                    Sleepgoal(),
                  ],
                ),
              ),
              Container(
                color: const Color(0xffd5defe),
                child: SettingsGroup(
                  title: 'Account Actions',
                  titleTextStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  children: <Widget>[
                    buildLogOut(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLogOut() => SimpleSettingsTile(
        title: 'Sign Out',
        leading: const IconWidget(
            icon: Icons.logout, color: Color.fromARGB(241, 230, 158, 3)),
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text(
                  'Confirm Sign Out',
                  style: TextStyle(
                    color: Color.fromARGB(255, 152, 15, 5),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                content: const Text(
                  'Are you sure you want to sign out?',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                  ),
                  TextButton(
                    child: const Text('Sign Out'),
                    onPressed: () {
                      _auth.signOut();
                      Navigator.pushNamed(context, SignInScreen.RouteScreen);
                    },
                  ),
                ],
              );
            },
          );
        },
      );

  Widget Account() => SimpleSettingsTile(
        title: 'Account',
        leading: const IconWidget(icon: Icons.person, color: Color(0xFF040E3B)),
        onTap: () {
          // Handle account logic here
        },
      );

  Widget AboutYou() => SimpleSettingsTile(
        title: 'About You',
        leading: const IconWidget(
            icon: Icons.assessment_outlined, color: Color(0xFF040E3B)),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const aboutyou_screen()),
          );
        },
      );

  Widget AlarmSound() => SimpleSettingsTile(
        title: 'Alarm Sound',
        leading: const IconWidget(
            icon: Icons.music_note_outlined, color: Color(0xFF040E3B)),
        onTap: () {
          // Handle alarm sound logic here
        },
      );

  Widget Snooze() => SimpleSettingsTile(
        title: 'Snooze',
        leading: const IconWidget(icon: Icons.snooze, color: Color(0xFF040E3B)),
        onTap: () {
          // Handle snooze logic here
        },
      );

  Widget Sleepgoal() => SimpleSettingsTile(
        title: 'Sleep Goal',
        leading: const IconWidget(
            icon: Icons.location_searching_sharp,
            color: Color(0xFF040E3B)),
        onTap: () {
          // Handle sign out logic here
        },
      );
}