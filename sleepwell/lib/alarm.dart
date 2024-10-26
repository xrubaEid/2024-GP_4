import 'dart:async';
import 'dart:developer';

import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sleepwell/models/list_of_music.dart';
import 'package:sleepwell/screens/alarm/alarm_ring_screen.dart';
import 'package:sleepwell/screens/alarm/alarm_ring_with_equation_screen.dart';

class AppAlarm {
  static StreamSubscription<AlarmSettings>? subscription;
  static String _selectedSoundPath = musicList[0].musicPath;
  static String _selectedMission = 'Default';
  static String _selectedMath = 'easy';

  static Future<void> initAlarms() async {
    if (Alarm.android) {
      await checkAndroidNotificationPermission();
      await checkAndroidScheduleExactAlarmPermission();
    }

    final prefs = await SharedPreferences.getInstance();
    _loadSettings(prefs);

    subscription ??= Alarm.ringStream.stream.listen(
      (alarmSettings) {
        log("Alarm triggered for: ${alarmSettings.id}");
        if (_selectedMission == "Default") {
          Get.to(() => AlarmRingScreen(alarmSettings: alarmSettings));
        } else {
          Get.to(() => AlarmRingWithEquationScreen(
                alarmSettings: alarmSettings,
                showEasyEquation: _selectedMath == "easy",
              ));
        }
      },
    );
  }

  static void _loadSettings(SharedPreferences prefs) {
    _selectedSoundPath =
        prefs.getString("selectedSoundPath") ?? musicList[0].musicPath;
    _selectedMission = prefs.getString("selectedMission") ?? "Default";
    _selectedMath = prefs.getString("selectedMath") ?? "easy";
  }

  static Future<void> checkAndroidNotificationPermission() async {
    final status = await Permission.notification.status;
    if (status.isDenied) {
      log('Requesting notification permission...');
      final res = await Permission.notification.request();
      log('Notification permission: ${res.isGranted ? 'Granted' : 'Denied'}');
    }
  }

  static Future<void> checkAndroidScheduleExactAlarmPermission() async {
    final status = await Permission.scheduleExactAlarm.status;
    log('Schedule exact alarm permission: $status.');
    if (status.isDenied) {
      log('Requesting schedule exact alarm permission...');
      final res = await Permission.scheduleExactAlarm.request();
      log('Schedule exact alarm permission: ${res.isGranted ? 'Granted' : 'Denied'}');
    }
  }

  static AlarmSettings buildAlarmSettings(DateTime date) {
    const id = 1000;
    final alarmSettings = AlarmSettings(
      id: id,
      dateTime: date,
      loopAudio: true,
      vibrate: true,
      volume: 1,
      assetAudioPath: _selectedSoundPath,
      notificationTitle: 'Alarm',
      notificationBody: 'Optimal time to WAKE UP',
    );
    return alarmSettings;
  }

  static Future<void> saveAlarm(
    String bedtime, // String بتنسيق "HH:mm"
    String optimalWakeTime, // String بتنسيق "yyyy-MM-dd hh:mm a"
    String beneficiaryId,
  ) async {
    DateTime now = DateTime.now();

    // تحويل وقت النوم إلى كائن DateTime بناءً على اليوم الحالي
    DateTime bedtimeDate = DateFormat("HH:mm").parse(bedtime);
    bedtimeDate = DateTime(
        now.year, now.month, now.day, bedtimeDate.hour, bedtimeDate.minute);

    // تحويل وقت الاستيقاظ المثالي إلى كائن DateTime
    DateTime optimalWakeUpDate = DateFormat("yyyy-MM-dd hh:mm a").parse(
      "${DateTime.now().toString().split(' ')[0]} $optimalWakeTime",
    );

    // إذا كان وقت الاستيقاظ المثالي قبل وقت النوم، ضف يومًا إلى وقت الاستيقاظ المثالي
    if (optimalWakeUpDate.isBefore(bedtimeDate)) {
      optimalWakeUpDate = optimalWakeUpDate.add(const Duration(days: 1));
    }

    // إعداد المنبه باستخدام إعدادات التنبيه
    final alarmSettings = buildAlarmSettings(optimalWakeUpDate);
    await Alarm.set(alarmSettings: alarmSettings);

    // التوجيه إلى شاشة رنين المنبه بناءً على المستفيد أو المستخدم
    Get.to(() => AlarmRingScreen(alarmSettings: alarmSettings));

    // طباعة معلومات لأغراض تتبع التصحيح
    log("Alarm set for beneficiary ID: ${beneficiaryId ?? 'None (User)'}");
    log("Alarm set time: $optimalWakeUpDate");
  }

  static getAlarms() async {
    var alarms = await Alarm.getAlarms();
    for (var alarm in alarms) {
      log("Alarm ID: ${alarm.id}, Time: ${alarm.dateTime}");
    }
  }

  static updateStoredWakeUpAlarmSound() {
    AlarmSettings? alarmSettings = Alarm.getAlarm(1000);
    if (alarmSettings != null) {
      alarmSettings =
          alarmSettings.copyWith(assetAudioPath: _selectedSoundPath);
      Alarm.set(alarmSettings: alarmSettings);
      log("Alarm sound updated for Alarm ID: ${alarmSettings.id}");
    }
  }
}
