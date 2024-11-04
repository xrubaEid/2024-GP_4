import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controllers/alarms_statistics_controller.dart';
import '../../models/alarm_model.dart';
import '../../widget/statistic_weekly_widget.dart';

class StatisticsWeekly extends StatefulWidget {
  StatisticsWeekly({super.key});

  @override
  State<StatisticsWeekly> createState() => _StatisticsWeeklyState();
}

class _StatisticsWeeklyState extends State<StatisticsWeekly> {
  String? userId = FirebaseAuth.instance.currentUser?.uid;
  String weekRange = '';

  @override
  void initState() {
    super.initState();
    getWeekRange();
  }

  void getWeekRange() {
    final now = DateTime.now();
    final weekEnd = now.subtract(const Duration(days: 1));
    final weekStart = now.subtract(const Duration(days: 7));

    weekRange =
        '${DateFormat('d MMM').format(weekStart)} - ${DateFormat('d MMM').format(weekEnd)}';
  }

  @override
  Widget build(BuildContext context) {
    AlarmsStatisticsController alarmsController =
        Get.put(AlarmsStatisticsController());

    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF004AAD),
          title: const Text(
            "Statistics",
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: 'Day'),
              Tab(text: 'Week'),
              Tab(text: 'Month'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // First tab: Day view
            SingleChildScrollView(
              child: FutureBuilder<List<AlarmModelData>>(
                future: alarmsController.fetchLastWeekAlarms(userId!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text("Error loading data"));
                  } else {
                    final alarms = snapshot.data ?? [];
                    List<double> sleepHours = List.filled(7, 0.0);
                    List<double> sleepCycles = List.filled(7, 0.0);

                    for (var alarm in alarms) {
                      DateTime alarmDate = alarm.timestamp is Timestamp
                          ? (alarm.timestamp as Timestamp).toDate()
                          : DateTime.parse(alarm.timestamp.toString());

                      final differenceInDays =
                          DateTime.now().difference(alarmDate).inDays;

                      if (differenceInDays >= 0 && differenceInDays <= 7) {
                        sleepHours[7 - differenceInDays] =
                            alarm.sleepDuration.inHours.toDouble();
                        sleepCycles[7 - differenceInDays] =
                            alarm.sleepCycles.toDouble();
                      }
                    }

                    final barGroups = List.generate(7, (index) {
                      return BarChartGroupData(
                        x: index,
                        barRods: [
                          BarChartRodData(
                            toY: sleepHours[index],
                            color: Colors.blue,
                            width: 16,
                          ),
                        ],
                      );
                    });

                    List<Color> weekColors = [
                      const Color(0xFF26C6DA),
                      const Color.fromRGBO(223, 30, 233, 1),
                      const Color(0xFF81C784),
                      const Color(0xFF53C3E9),
                      Colors.blue,
                      const Color.fromARGB(255, 10, 227, 147),
                      const Color(0xFF53C3E9),
                    ];

                    final pieSections = List.generate(7, (index) {
                      return PieChartSectionData(
                        value: sleepCycles[index],
                        color: weekColors[index],
                        title: '${sleepCycles[index]}',
                        radius: 60,
                      );
                    });

                    const double chartMaxYweek = 20;
                    final double averageSleepHours =
                        sleepHours.reduce((a, b) => a + b) / sleepHours.length;

                    return StatisticsWeeklyWidget(
                      barGroups: barGroups,
                      pieSections: pieSections,
                      chartMaxYweek: chartMaxYweek,
                      averageSleepHours: averageSleepHours,
                      weekRange: weekRange,
                    );
                  }
                },
              ),
            ),
            // Second tab: Week view
            Container(),
            // Third tab: Month view
            Container(),
          ],
        ),
      ),
    );
  }
}
