import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:sleepwell/models/alarm_model.dart';
import 'dart:developer';

class AlarmsStatisticsController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? userId = FirebaseAuth.instance.currentUser?.uid;

  // Fetch last day's alarms
  Future<List<AlarmModelData>> fetchLastDayAlarms(String userId) async {
    final now = DateTime.now();
    final DateTime yesterdayStart = DateTime(now.year, now.month, now.day)
        .subtract(const Duration(days: 1));
    final DateTime yesterdayEnd = DateTime(now.year, now.month, now.day)
        .subtract(const Duration(seconds: 1));

    log("Fetching alarms from $yesterdayStart to $yesterdayEnd for user: $userId");

    QuerySnapshot querySnapshot = await _firestore
        .collection('alarms')
        .where('uid', isEqualTo: userId)
        .where('isForBeneficiary', isEqualTo: true)
        .where('timestamp', isGreaterThanOrEqualTo: yesterdayStart)
        .where('timestamp', isLessThanOrEqualTo: yesterdayEnd)
        .get();

    log("Fetched Daily ${querySnapshot.docs.length} alarms.");
    return querySnapshot.docs
        .map((doc) =>
            AlarmModelData.fromFirestore(doc.data() as Map<String, dynamic>))
        .toList();
  }

  // Calculate sleep duration
  Map<String, dynamic> calculateSleepDuration(
      DateTime actualBedtime, DateTime optimalWakeTime) {
    if (optimalWakeTime.isBefore(actualBedtime)) {
      optimalWakeTime = optimalWakeTime.add(const Duration(days: 1));
    }

    final sleepDuration = optimalWakeTime.difference(actualBedtime);
    int hours = sleepDuration.inHours;
    int minutes = sleepDuration.inMinutes % 60;

    return {
      "hours": hours,
      "minutes": minutes,
      "formatted": '$hours h $minutes m',
    };
  }

  // Fetch last week's alarms
  // Future<List<AlarmModelData>> fetchLastWeekAlarms(String userId) async {
  //   DateTime now = DateTime.now();
  //   DateTime weekStart = DateTime(now.year, now.month, now.day)
  //       .subtract(const Duration(days: 7));
  //   DateTime weekEnd = DateTime(now.year, now.month, now.day)
  //       .subtract(const Duration(days: 1))
  //       .add(const Duration(hours: 23, minutes: 59, seconds: 59));

  //   try {
  //     log("Fetching  alarms from $weekStart to $weekEnd for user: $userId");

  //     QuerySnapshot querySnapshot = await _firestore
  //         .collection('alarms')
  //         .where('uid', isEqualTo: userId)
  //         .where('isForBeneficiary', isEqualTo: true)
  //         .where('beneficiaryId', isEqualTo: userId)
  //         .where('timestamp', isGreaterThanOrEqualTo: weekStart)
  //         .where('timestamp', isLessThanOrEqualTo: weekEnd)
  //         .get();

  //     log("Fetched last week's alarms ${querySnapshot.docs.length} alarms.");
  //     return querySnapshot.docs
  //         .map((doc) =>
  //             AlarmModelData.fromFirestore(doc.data() as Map<String, dynamic>))
  //         .toList();
  //   } catch (e) {
  //     log("Error fetching alarms: $e");
  //     return [];
  //   }
  // }

  Future<List<AlarmModelData>> fetchLastWeekAlarms(String userId) async {
    DateTime now = DateTime.now();
    now.subtract(Duration(days: 7));
    final weekEnd = now.subtract(
        const Duration(days: 1)); // Today is the end of the 7-day period
    final weekStart = now.subtract(
        const Duration(days: 7)); // 6 days ago is the start of the 7-day period

    try {
      // طباعة معلومات التواريخ لأغراض التحقق
      print("Fetching alarms from $weekStart to $weekEnd for user: $userId");

      QuerySnapshot querySnapshot = await _firestore
          .collection('alarms')
          .where('uid', isEqualTo: userId)
          .where('isForBeneficiary', isEqualTo: true)
          .where('timestamp', isGreaterThanOrEqualTo: weekStart)
          .where('timestamp', isLessThanOrEqualTo: weekEnd)
          .get();

      log("Fetched ${querySnapshot.docs.length} alarms.");
      print(
          ":::::::::::::::::::::::::::::::::::::::fetchLastWeekAlarms::::::::::::::::::::::::::::::::::::::::::::::::::::::");
      // تحويل البيانات
      List<AlarmModelData> alarms = querySnapshot.docs
          .map((doc) =>
              AlarmModelData.fromFirestore(doc.data() as Map<String, dynamic>))
          .toList();

      // طباعة تفاصيل البيانات المسترجعة
      alarms.forEach((alarm) {
        print(
            "Alarm: Bedtime: ${alarm.bedtime}, Wakeup Time: ${alarm.wakeupTime}, Num of Cycles: ${alarm.numOfCycles}, Timestamp: ${alarm.timestamp}, Is for Beneficiary: ${alarm.isForBeneficiary}");
      });
      print(
          ":::::::::::::::::::::::::::::::::::::::fetchLastWeekAlarms::::::::::::::::::::::::::::::::::::::::::::::::::::::");
      update();
      return alarms;
    } catch (e) {
      // طباعة رسالة الخطأ في حالة حدوث مشكلة
      print("Error fetching alarms: $e");
      print(
          "::::::::::Error:::::::::::::::::::::::::::::fetchLastWeekAlarms::::::::::::::::::::::::::::::::::::::::::::::::::::::");

      return [];
    }
  }

  // Fetch current month's alarms
  Future<List<AlarmModelData>> fetchPreviousMonthAlarms(String userId) async {
    DateTime now = DateTime.now();
    DateTime firstDayCurrentMonth = DateTime(now.year, now.month, 1);
    DateTime lastDayCurrentMonth = DateTime(now.year, now.month + 1, 0);

    log("Fetching alarms from $firstDayCurrentMonth to $lastDayCurrentMonth for user: $userId");

    QuerySnapshot querySnapshot = await _firestore
        .collection('alarms')
        .where('uid', isEqualTo: userId)
        .where('isForBeneficiary', isEqualTo: true)
        .where('timestamp', isGreaterThanOrEqualTo: firstDayCurrentMonth)
        .where('timestamp', isLessThanOrEqualTo: lastDayCurrentMonth)
        .get();

    log("Fetched current month's ${querySnapshot.docs.length} alarms.");
    return querySnapshot.docs
        .map((doc) =>
            AlarmModelData.fromFirestore(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<List<AlarmModelData>> fetchBeneficiaryAlarms(
      String beneficiaryId) async {
    final now = DateTime.now();
    final DateTime yesterdayStart = DateTime(now.year, now.month, now.day)
        .subtract(const Duration(days: 1)); // بداية يوم أمس
    final DateTime yesterdayEnd = DateTime(now.year, now.month, now.day)
        .subtract(const Duration(seconds: 1)); // نهاية يوم أمس
    QuerySnapshot querySnapshot = await _firestore
        .collection('alarms')
        .where('beneficiaryId', isEqualTo: beneficiaryId)
        .where('isForBeneficiary', isEqualTo: false)
        .where('timestamp', isGreaterThanOrEqualTo: yesterdayStart)
        .where('timestamp', isLessThan: yesterdayEnd)
        .orderBy('timestamp', descending: true)
        .get();

    return querySnapshot.docs
        .map((doc) =>
            AlarmModelData.fromFirestore(doc.data() as Map<String, dynamic>))
        .toList();
  }

  // Fetch last week's beneficiary alarms
  Future<List<AlarmModelData>> fetchBeneficiaryLastWeekAlarms(
      String beneficiaryId) async {
    DateTime now = DateTime.now();
    DateTime weekStart = DateTime(now.year, now.month, now.day)
        .subtract(const Duration(days: 7));
    DateTime weekEnd = DateTime(now.year, now.month, now.day)
        .subtract(const Duration(days: 1))
        .add(const Duration(hours: 23, minutes: 59, seconds: 59));

    log("Fetching alarms for beneficiary from $weekStart to $weekEnd");

    QuerySnapshot querySnapshot = await _firestore
        .collection('alarms')
        .where('uid', isEqualTo: userId)
        .where('beneficiaryId', isEqualTo: beneficiaryId)
        .where('isForBeneficiary', isEqualTo: false)
        .where('timestamp', isGreaterThanOrEqualTo: weekStart)
        .where('timestamp', isLessThanOrEqualTo: weekEnd)
        .get();

    log("Fetched last week's alarms for beneficiary ${querySnapshot.docs.length}  alarms.");
    return querySnapshot.docs
        .map((doc) =>
            AlarmModelData.fromFirestore(doc.data() as Map<String, dynamic>))
        .toList();
  }

  // Fetch current month's beneficiary alarms
  Future<List<AlarmModelData>> fetchBeneficiaryCurrentMonthAlarms(
      String beneficiaryId) async {
    DateTime now = DateTime.now();
    DateTime firstDayCurrentMonth = DateTime(now.year, now.month, 1);
    DateTime lastDayCurrentMonth = DateTime(now.year, now.month + 1, 0);

    log("Fetching beneficiary alarms from $firstDayCurrentMonth to $lastDayCurrentMonth");

    QuerySnapshot querySnapshot = await _firestore
        .collection('alarms')
        .where('uid', isEqualTo: userId)
        .where('beneficiaryId', isEqualTo: beneficiaryId)
        .where('isForBeneficiary', isEqualTo: false)
        .where('timestamp', isGreaterThanOrEqualTo: firstDayCurrentMonth)
        .where('timestamp', isLessThanOrEqualTo: lastDayCurrentMonth)
        .get();

    log("Fetched current month's  ${querySnapshot.docs.length} beneficiary alarms.");
    return querySnapshot.docs
        .map((doc) =>
            AlarmModelData.fromFirestore(doc.data() as Map<String, dynamic>))
        .toList();
  }
}
