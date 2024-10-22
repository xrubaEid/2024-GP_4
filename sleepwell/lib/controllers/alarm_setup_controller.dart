import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

import '../alarm.dart';

class SleepCycleController extends GetxController {
  Rx<DateTime> bedtime = DateTime.now().obs;
  Rx<DateTime> wakeUpTime = DateTime.now().obs;
  RxInt numOfCycles = 0.obs;
  RxString optimalWakeUpTime = "".obs;
  String? userId = FirebaseAuth.instance.currentUser?.uid;
  void setBedtime(DateTime selectedTime) {
    bedtime.value = selectedTime;
  }

  void setWakeUpTime(DateTime selectedTime) {
    wakeUpTime.value = selectedTime;
  }

  TimeOfDay timeOfDayFromDateTime(DateTime dateTime) {
    return TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
  }

  // تعديل دالة الحفظ لحساب وقت الاستيقاظ المثالي
  void saveTimes()
  // List<Map<String, int>> myHourList, String beneficiaryId)
  async {
    // if (myHourList.isEmpty) {
    //   // التعامل مع حالة القائمة الفارغة
    //   print("myHourList is empty.");
    //   return;
    // }

    // int bedtimeIndex = 0;
    // int bedtimeMinutes = 0;
    // int sleepCycleMinutes = 90;

    // // التحقق من وجود 'heartRate' في العنصر الأول
    // if (myHourList.isNotEmpty && myHourList[0].containsKey('heartRate')) {
    //   int? firstRead = myHourList[0]['heartRate'];
    //   int? diff = (firstRead! * 0.2).toInt();
    //   int? toComp = firstRead - diff;

    //   // إيجاد الفهرس الذي يكون فيه معدل نبضات القلب أقل من toComp
    //   for (int i = 0; i < myHourList.length; i++) {
    //     if (myHourList[i]['heartRate']! < toComp) {
    //       bedtimeIndex = i;
    //       break;
    //     }
    //   }

    //   // حساب وقت النوم بناءً على الفهرس
    //   if (bedtimeIndex > 0) {
    //     if (myHourList[bedtimeIndex].containsKey('hour') &&
    //         myHourList[bedtimeIndex].containsKey('minute')) {
    //       bedtimeMinutes = myHourList[bedtimeIndex]['hour']! * 60 +
    //           myHourList[bedtimeIndex]['minute']!;
    //     } else {
    //       // التعامل مع حالة نقص البيانات
    //       print("Missing 'hour' or 'minute' key in myHourList.");
    //       return;
    //     }
    //   } else {
    //     if (myHourList[myHourList.length - 1].containsKey('hour') &&
    //         myHourList[myHourList.length - 1].containsKey('minute')) {
    //       bedtimeMinutes = myHourList[myHourList.length - 1]['hour']! * 60 +
    //           myHourList[myHourList.length - 1]['minute']!;
    //     } else {
    //       print(
    //           "Missing 'hour' or 'minute' key in the last element of myHourList.");
    //       return;
    //     }
    //   }

    //   int wakeUpTimeMinutes =
    //       wakeUpTime.value.hour * 60 + wakeUpTime.value.minute;
    //   if (wakeUpTimeMinutes < bedtimeMinutes) {
    //     wakeUpTimeMinutes += 24 * 60;
    //   }

    //   int totalSleepTimeMinutes = wakeUpTimeMinutes - bedtimeMinutes;
    //   numOfCycles.value = (totalSleepTimeMinutes / 90).floor();

    //   int optimalWakeUpMinutes =
    //       bedtimeMinutes + (numOfCycles.value * sleepCycleMinutes);

    //   // حساب وقت الاستيقاظ المثالي
    //   optimalWakeUpTime.value =
    //       "${(optimalWakeUpMinutes ~/ 60) % 24}:${optimalWakeUpMinutes % 60}";

    //   // حفظ المنبه باستخدام AppAlarm
    //   await AppAlarm.saveAlarm(
    //     timeOfDayFromDateTime(bedtime.value), // تحويل DateTime إلى TimeOfDay
    //     optimalWakeUpTime.value,
    //     beneficiaryId,
    //   );
    //   await AppAlarm.getAlarms();
    // } else {
    //   // التعامل مع حالة نقص البيانات
    //   print("Invalid or empty myHourList.");
    //   return;
    // }
    await AppAlarm.saveAlarm(
      timeOfDayFromDateTime(bedtime.value), // تحويل DateTime إلى TimeOfDay
      optimalWakeUpTime.value,
      userId!,
    );
    await AppAlarm.getAlarms();
    print(
        'timeOfDayFromDateTime(bedtime.value)${timeOfDayFromDateTime(bedtime.value)}');
  }
}
