import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SleepCycleController extends GetxController {
  Rx<DateTime> bedtime = DateTime.now().obs;
  Rx<DateTime> wakeUpTime = DateTime.now().obs;

  void setBedtime(DateTime selectedTime) {
    bedtime.value = selectedTime;
  }

  void setWakeUpTime(DateTime selectedTime) {
    wakeUpTime.value = selectedTime;
  }

  void saveTimes() {
    print('bedtime  ${bedtime.value} wakuptime  ${wakeUpTime.value}');
  }
}
