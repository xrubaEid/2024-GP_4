import 'dart:async';
import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sleepwell/alarm.dart';
import 'package:sleepwell/screens/alarm_screen.dart';

import 'package:sleepwell/screens/settings_screen.dart';
import 'package:sleepwell/screens/statistic/user_statistics_screen.dart';
import 'beneficiaries_screen.dart';
 
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _auth = FirebaseAuth.instance;
  late User signInUser;
  late String userid;
  StreamSubscription<AlarmSettings>? subscription;

  @override
  void initState() {
    super.initState();
    AppAlarm.initAlarms();
    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        signInUser = user;
        userid = user.uid;
        print(signInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  int index = 2;
  final pages = [
    const SettingsScreen(),
    const UserStatisticsScreen(),
    const AlarmScreen(),
      BeneficiariesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment:
          MainAxisAlignment.end, // يضمن ظهور الـ NavigationBar في الأسفل

      children: [
        Expanded(
          child: pages[index], // يعرض الصفحة المحددة بناءً على الفهرس
        ),
        Theme(
          data: ThemeData(
            // تخصيص لون النصوص والأيقونات في NavigationBar
            navigationBarTheme: NavigationBarThemeData(
              labelTextStyle: MaterialStateProperty.resolveWith<TextStyle?>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.selected)) {
                    return const TextStyle(
                        color: Color(0xFF21D4F3), fontSize: 12);
                  }
                  return const TextStyle(color: Colors.white, fontSize: 10);
                },
              ),
              indicatorColor: Colors.white,
            ),
          ),
          child: NavigationBar(
            selectedIndex: index,
            onDestinationSelected: (index) =>
                setState(() => this.index = index),
            backgroundColor: const Color(0xFF040E3B),
            height: 65,
            shadowColor: Colors.blue,
            destinations: [
              NavigationDestination(
                icon: const Icon(Icons.person_outlined, color: Colors.white),
                selectedIcon: const Icon(Icons.person, color: Colors.blue),
                label: 'Profile'.tr,
              ),
              NavigationDestination(
                icon: const Icon(Icons.align_vertical_bottom_outlined,
                    color: Colors.white),
                selectedIcon:
                    const Icon(Icons.align_vertical_bottom, color: Colors.blue),
                label: 'Statistic'.tr,
              ),
              NavigationDestination(
                icon: const Icon(Icons.access_alarm_outlined,
                    color: Colors.white),
                selectedIcon:
                    const Icon(Icons.access_alarm, color: Colors.blue),
                label: 'Alarm'.tr,
              ),
              NavigationDestination(
                icon: const Icon(Icons.dashboard_customize_outlined,
                    color: Colors.white),
                selectedIcon:
                    const Icon(Icons.dashboard_customize, color: Colors.blue),
                label: 'Beneficiaries'.tr,
              ),
            ],
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            overlayColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) {
                  return Colors.blue.withOpacity(0.2); // لون الطبقة عند الضغط
                } else if (states.contains(MaterialState.selected)) {
                  return Colors.blue; // اللون عند التحديد
                }
                return null; // اللون في الحالة العادية
              },
            ),
          ),
        ),
      ],
    );
  }
}
