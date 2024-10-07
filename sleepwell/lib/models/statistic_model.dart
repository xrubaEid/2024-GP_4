import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

class StatisticModel {
  final String? userId = FirebaseAuth.instance.currentUser?.uid;
  final String beneficiaryId; // معرف التابع

  StatisticModel({required this.beneficiaryId});

  Future<Map<String, dynamic>> fetchDayData() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    // هنا التأكد من أن البيانات تخص التابع فقط
    final snapshot = await FirebaseFirestore.instance
        .collection('alarms')
        .where('beneficiaryId',
            isEqualTo: beneficiaryId) // البحث بناءً على معرف التابع
        .where('timestamp', isGreaterThanOrEqualTo: startOfDay)
        .where('timestamp', isLessThan: endOfDay)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final alarm = snapshot.docs.first;

      // التحقق مما إذا كانت القيم موجودة وليست null
      String? bedtimeString =
          alarm.data().containsKey('bedtime') ? alarm['bedtime'] : null;
      String? wakeupTimeString =
          alarm.data().containsKey('wakeup_time') ? alarm['wakeup_time'] : null;
      String? cyclesString = alarm.data().containsKey('num_of_cycles')
          ? alarm['num_of_cycles']
          : '0';

      if (bedtimeString == null || wakeupTimeString == null) {
        throw Exception('Invalid data: bedtime or wakeup_time is null');
      }

      // تحويل bedtime و wakeupTime من String إلى DateTime باستخدام صيغة AM/PM
      DateTime bedtime = DateFormat('h:mm a').parse(bedtimeString);
      DateTime wakeupTime = DateFormat('h:mm a').parse(wakeupTimeString);

      // حساب عدد ساعات النوم
      if (wakeupTime.isBefore(bedtime)) {
        wakeupTime = wakeupTime.add(const Duration(days: 1));
      }

      double sleepDuration = wakeupTime.difference(bedtime).inHours.toDouble();
      double actualSleepTime = wakeupTime.difference(bedtime).inMinutes / 60.0;
      num cycles = int.tryParse(cyclesString!) ?? 0;

      return {
        'sleepHoursDuration': '${sleepDuration.toStringAsFixed(1)}h',
        'actualSleepTime': actualSleepTime.toStringAsFixed(1),
        'sleepCycles': '$cycles',
        'wakeupTime':
            DateFormat('h:mm a').format(wakeupTime), // العرض بصيغة AM/PM
        'bedtime': bedtime,
        'wakeupTimeObj': wakeupTime,
        'cycles': cycles
      };
    } else {
      throw Exception('No data found for today');
    }
  }
}
