import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../alarm.dart';
import '../services/firebase_auth_service.dart';
import '../services/firebase_firestore_service.dart';
import '../services/sensor_service.dart';

class SleepCycleController extends GetxController {
  var bedtime = DateTime.now().obs;
  var wakeUpTime = DateTime.now().obs;
  var numOfCycles = 2.obs; // Default number of sleep cycles
  var remainingMinutes = 0.obs;
  var loading = false.obs;

  final FirebaseAuthService authService = FirebaseAuthService();
  final FirebaseFirestoreService firestoreService = FirebaseFirestoreService();
  late TextEditingController bedtimeController;
  late TextEditingController wakeUpTimeController;

  String printedNumOfCycles = '';
  RxString userId = ''.obs;
  RxString selectedBeneficiaryId = ''.obs;
  RxString selectedBeneficiaryName = ''.obs;
  final sensorService = Get.find<SensorService>();

  @override
  void onInit() {
    super.onInit();
    bedtimeController = TextEditingController();
    wakeUpTimeController = TextEditingController();
    userId.value = authService.getUserId() ?? '';
    update();
  }

  void setBedtime(DateTime selectedTime) {
    bedtime.value = selectedTime;
  }

  void setWakeUpTime(DateTime selectedTime) {
    wakeUpTime.value = selectedTime;
  }

  void setBeneficiary(String id, String name) {
    selectedBeneficiaryId.value = id;
    selectedBeneficiaryName.value = name;
  }

  int calculateSleepDuration() {
    // Handle crossing midnight by adding a day to wakeUpTime if it's earlier than bedtime
    DateTime adjustedWakeUpTime = wakeUpTime.value;
    if (wakeUpTime.value.isBefore(bedtime.value)) {
      adjustedWakeUpTime = wakeUpTime.value.add(const Duration(days: 1));
    }

    int duration = adjustedWakeUpTime.difference(bedtime.value).inMinutes;
    int cycleDurationMinutes = 90;

    int hours = duration ~/ 60;
    int minutes = duration % 60;

    numOfCycles.value = duration ~/ cycleDurationMinutes;
    remainingMinutes.value = duration % cycleDurationMinutes;

    print('$hours hours and $minutes minutes');
    print('Number of cycles: ${numOfCycles.value}');
    print('Remaining minutes: $remainingMinutes');

    return numOfCycles.value;
  }

  Future<void> saveTimes() async {
    try {
      loading.value = true;
      numOfCycles.value = calculateSleepDuration();
      await firestoreService.saveAlarm(
        DateFormat('hh:mm a').format(bedtime.value),
        DateFormat('hh:mm a').format(wakeUpTime.value),
        numOfCycles.value.toString(),
        userId.value,
        selectedBeneficiaryId.value,
        userId.value == selectedBeneficiaryId.value,
        sensorService.selectedSensor.value,
      );

      await AppAlarm.saveAlarm(
        bedtime: DateFormat('hh:mm a').format(bedtime.value).toString(),
        optimalWakeTime: DateFormat('hh:mm a').format(wakeUpTime.value),
        userId: selectedBeneficiaryId.value,
        usertype: userId.value == selectedBeneficiaryId.value,
        name: selectedBeneficiaryName.value,
        sensorId: sensorService.selectedSensor.value,
      );

      await AppAlarm.getAlarms();
      loading.value = false;
      Future.delayed(const Duration(seconds: 1), () {
        Get.back();
      });
    } catch (e) {
      print("Error saving times: $e");
      loading.value = false;
    }
    Get.back();
  }

  void resetSleepCycle() {
    bedtime.value = DateTime.now();
    wakeUpTime.value = DateTime.now();
    numOfCycles.value = 2;
  }

  Future<List<Map<String, dynamic>>> getAlarmDataForTodayBySensorId(
      String sensorId, DateTime userTime) async {
    try {
      final now = DateTime.now();
      final todayStart = DateTime(now.year, now.month, now.day);
      final todayEnd = todayStart
          .add(const Duration(days: 1))
          .subtract(const Duration(seconds: 1));

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('alarms')
          .where('uid', isEqualTo: userId.value)
          .where('sensorId', isEqualTo: sensorId)
          .where('timestamp', isGreaterThanOrEqualTo: todayStart)
          .where('timestamp', isLessThanOrEqualTo: todayEnd)
          .get();

      List<Map<String, dynamic>> data = [];

      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> alarmData = doc.data() as Map<String, dynamic>;

        // Parsing wakeup_time and bed_time from the document
        DateTime wakeupTime =
            DateFormat('hh:mm a').parse(alarmData['wakeup_time']);
        DateTime bedTime = DateFormat('hh:mm a').parse(alarmData['bedtime']);

        // Check if userTime is between bedTime and wakeupTime
        if (userTime.isAfter(bedTime) && userTime.isBefore(wakeupTime)) {
          data.add(alarmData);
        }
      }

      print(' :::::::::::-----------Data for today: ${todayStart} ${todayEnd}');
      return data;
    } catch (e) {
      print(":::::::::::::::::-----------Error fetching data for today: $e");
      return [];
    }
  }
}
