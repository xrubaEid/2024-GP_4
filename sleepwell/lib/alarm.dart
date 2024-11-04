import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:alarm/alarm.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sleepwell/models/alarm_data.dart';
import 'package:sleepwell/models/list_of_music.dart';
import 'package:sleepwell/screens/alarm/alarm_ring_screen.dart';
import 'package:sleepwell/screens/alarm/alarm_ring_with_equation_screen.dart';

class AppAlarm {
  static StreamSubscription<AlarmSettings>? subscription;
  static String _selectedSoundPath = musicList[0].musicPath;
  static String _selectedMission = 'Default';
  static String _selectedMath = 'easy';
  static late AlarmData alarmsData;

  static Future<void> initAlarms() async {
    if (Alarm.android) {
      await checkAndroidNotificationPermission();
      await checkAndroidScheduleExactAlarmPermission();
    }

    final prefs = await SharedPreferences.getInstance();
    _loadSettings(prefs);
    String? jsonData = prefs.getString("alarms");
    if (jsonData != null) {
      Map<String, dynamic> rawData = jsonDecode(jsonData);
      alarmsData = AlarmData.fromJson(rawData);
    }

    subscription ??= Alarm.ringStream.stream.listen((alarmSettings) {
      log("Alarm triggered for: ${alarmSettings.id}");
      if (_selectedMission == "Default") {
        Get.to(() => AlarmRingScreen(
              alarmSettings: alarmSettings,
              alarmsData: alarmsData,
            ));
      } else {
        Get.to(() => AlarmRingWithEquationScreen(
              alarmSettings: alarmSettings,
              showEasyEquation: _selectedMath == "easy",
              alarmsData: alarmsData,
            ));
      }
    });
  }

  static void _loadSettings(SharedPreferences prefs) {
    _selectedSoundPath =
        prefs.getString("selectedSoundPath") ?? musicList[0].musicPath;
    _selectedMission = prefs.getString("selectedMission") ?? "Default";
    _selectedMath = prefs.getString("selectedMath") ?? "easy";
  }

  static AlarmSettings buildAlarmSettings(DateTime date) {
    const id = 1000;
    return AlarmSettings(
      id: id,
      dateTime: date,
      loopAudio: true,
      vibrate: true,
      volume: 1,
      assetAudioPath: _selectedSoundPath,
      notificationTitle: 'Alarm',
      notificationBody: 'Optimal time to WAKE UP',
    );
  }

  static Future<void> saveAlarm({
    required String userId,
    required String bedtime,
    required String optimalWakeTime,
    required String name,
    bool usertype = false,
    required String sensorId,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    alarmsData = AlarmData(
      userId: userId,
      beneficiaryId: userId,
      bedtime: bedtime,
      optimalWakeTime: optimalWakeTime,
      name: name,
      isForBeneficiary: usertype,
      sensorId: sensorId,
    );

    await prefs.setString("alarms", jsonEncode(alarmsData.toJson()));
    DateTime now = DateTime.now();
    DateTime bedtimeDate = DateFormat("HH:mm a").parse(bedtime);
    bedtimeDate = DateTime(
        now.year, now.month, now.day, bedtimeDate.hour, bedtimeDate.minute);

    DateTime optimalWakeUpDate = DateFormat("hh:mm a").parse(optimalWakeTime);
    optimalWakeUpDate = DateTime(now.year, now.month, now.day,
        optimalWakeUpDate.hour, optimalWakeUpDate.minute);

// // إذا كان وقت الاستيقاظ قبل الوقت الحالي، اضبطه ليكون في اليوم التالي
//     if (optimalWakeUpDate.isBefore(now)) {
//       optimalWakeUpDate = optimalWakeUpDate.add(const Duration(days: 1));
//     }

// // إذا كان وقت الاستيقاظ في اليوم التالي بالنسبة لوقت النوم
//     if (optimalWakeUpDate.isBefore(bedtimeDate)) {
//       optimalWakeUpDate = optimalWakeUpDate.add(const Duration(days: 1));
//     }

    final alarmSettings = buildAlarmSettings(optimalWakeUpDate);
    await Alarm.set(alarmSettings: alarmSettings);
    log("Setting alarm for userId: $userId at optimalWakeUpDate: $optimalWakeUpDate");
    log("Setting alarm for userId: $userId at optimalWakeUpDate: $optimalWakeUpDate");

    await getAlarms();
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

  static Future<void> checkAndroidNotificationPermission() async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
      log("Notification permission requested.");
    } else {
      log("Notification permission already granted.");
    }
  }

  static Future<void> checkAndroidScheduleExactAlarmPermission() async {
    if (await Permission.scheduleExactAlarm.isDenied) {
      await Permission.scheduleExactAlarm.request();
      log("Schedule exact alarm permission requested.");
    } else {
      log("Schedule exact alarm permission already granted.");
    }
  }

  static Future<void> loadAndUpdateAlarm({
    required String userId,
    String? newBedtime,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    if (alarmsData.userId == userId && newBedtime != null) {
      alarmsData.bedtime = newBedtime;

      await prefs.setString("alarms", jsonEncode(alarmsData.toJson()));

      String optimalWakeTime = alarmsData.optimalWakeTime;
      String name = alarmsData.name;
      bool usertype = alarmsData.isForBeneficiary;
      String sensorId = alarmsData.sensorId;
      await saveAlarm(
        userId: userId,
        bedtime: newBedtime,
        optimalWakeTime: optimalWakeTime,
        name: name,
        usertype: usertype,
        sensorId: sensorId,
      );
    } else {
      log("No alarm data found for userId $userId.");
    }
  }

  static Future<void> getAlarmss() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonData = prefs.getString("alarms");

    if (jsonData != null) {
      List<dynamic> alarmList = jsonDecode(jsonData);
      List<AlarmData> alarmsData =
          alarmList.map((alarmJson) => AlarmData.fromJson(alarmJson)).toList();

      for (var alarm in alarmsData) {
        log("Alarm User ID: ${alarm.userId}, Bedtime: ${alarm.bedtime}, Wake Time: ${alarm.optimalWakeTime}");
      }
    } else {
      log("No alarms data found in SharedPreferences.");
    }
  }

  static Future<void> getAlarms() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonData = prefs.getString("alarms");

    if (jsonData != null) {
      try {
        var decodedData = jsonDecode(jsonData);

        // Check if it's already a list or a single map
        List<dynamic> alarmList =
            decodedData is List ? decodedData : [decodedData];
        List<AlarmData> alarmsData = alarmList
            .map((alarmJson) =>
                AlarmData.fromJson(alarmJson as Map<String, dynamic>))
            .toList();

        for (var alarm in alarmsData) {
          log("Alarm User ID: ${alarm.userId}, Bedtime: ${alarm.bedtime}, Wake Time: ${alarm.optimalWakeTime}");
        }
      } catch (e) {
        log("Error decoding alarm data: $e");
      }
    } else {
      log("No alarms data found in SharedPreferences.");
    }
  }

  static Future<void> clearExistingAlarm() async {
    var alarms = await Alarm.getAlarms();

    for (var alarm in alarms) {
      await Alarm.stop(alarm.id);
      log("Stopped alarm with ID: ${alarm.id}");
    }
  }

  static Future<void> printAllAlarms() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonData = prefs.getString("alarms");

    alarmsData = AlarmData.fromJson(jsonDecode(jsonData!));
    log("=====================printAllAlarms===========================");

    log(alarmsData.toJson().toString());
  }
}

// class AppAlarm {
//   static StreamSubscription<AlarmSettings>? subscription;
//   static String _selectedSoundPath = musicList[0].musicPath;
//   static String _selectedMission = 'Default';
//   static String _selectedMath = 'easy';
//   static List<AlarmData> alarmsData = [];

//   static Future<void> initAlarms() async {
//     if (Alarm.android) {
//       await checkAndroidNotificationPermission();
//       await checkAndroidScheduleExactAlarmPermission();
//     }

//     final prefs = await SharedPreferences.getInstance();
//     _loadSettings(prefs);

//     String? jsonData = prefs.getString("alarms");
//     if (jsonData != null) {
//       dynamic rawData = jsonDecode(jsonData);

//       // Handle both single alarm map and list of alarms
//       if (rawData is Map<String, dynamic>) {
//         alarmsData = [
//           AlarmData.fromJson(rawData)
//         ]; // Wrap single alarm data in a list
//       } else if (rawData is List<dynamic>) {
//         alarmsData = rawData
//             .map((data) => AlarmData.fromJson(data as Map<String, dynamic>))
//             .toList();
//       } else {
//         log("Unexpected data format in stored alarms.");
//       }
//     }

//     subscription ??= Alarm.ringStream.stream.listen((alarmSettings) {
//       log("Alarm triggered for: ${alarmSettings.id}");
//       if (_selectedMission == "Default") {
//         Get.to(() => AlarmRingScreen(
//               alarmSettings: alarmSettings,
//               alarmsData: alarmsData[0],
//             ));
//       } else {
//         Get.to(() => AlarmRingWithEquationScreen(
//               alarmSettings: alarmSettings,
//               showEasyEquation: _selectedMath == "easy",
//               alarmsData: alarmsData[0],
//             ));
//       }
//     });
//   }

//   static void _loadSettings(SharedPreferences prefs) {
//     _selectedSoundPath =
//         prefs.getString("selectedSoundPath") ?? musicList[0].musicPath;
//     _selectedMission = prefs.getString("selectedMission") ?? "Default";
//     _selectedMath = prefs.getString("selectedMath") ?? "easy";
//   }

//   static Future<int> generateNewAlarmId() async {
//     final prefs = await SharedPreferences.getInstance();
//     int alarmId =
//         prefs.getInt("alarmId") ?? 1000; // Start at 1000 if no ID is stored
//     prefs.setInt("alarmId", alarmId + 1); // Increment ID for each new alarm
//     return alarmId;
//   }

//   static Future<AlarmSettings> buildAlarmSettings(DateTime date, int id) async {
//     return AlarmSettings(
//       id: id,
//       dateTime: date,
//       loopAudio: true,
//       vibrate: true,
//       volume: 1,
//       assetAudioPath: _selectedSoundPath,
//       notificationTitle: 'Alarm',
//       notificationBody: 'Optimal time to WAKE UP',
//     );
//   }

//   static Future<void> saveAlarm({
//     required String userId,
//     required String bedtime,
//     required String optimalWakeTime,
//     required String name,
//     bool usertype = false,
//     required String sensorId,
//   }) async {
//     final prefs = await SharedPreferences.getInstance();

//     // Load current alarm list
//     List<dynamic> alarmList = [];
//     String? existingAlarms = prefs.getString("alarms");
//     if (existingAlarms != null) {
//       alarmList = jsonDecode(existingAlarms);
//     }

//     // Set up new alarm data
//     AlarmData newAlarmData = AlarmData(
//       userId: userId,
//       beneficiaryId: userId,
//       bedtime: bedtime,
//       optimalWakeTime: optimalWakeTime,
//       name: name,
//       isForBeneficiary: usertype,
//       sensorId: sensorId,
//     );

//     // Add new alarm to list and save
//     alarmList.add(newAlarmData.toJson());
//     await prefs.setString("alarms", jsonEncode(alarmList));

//     DateTime now = DateTime.now();
//     DateTime bedtimeDate = DateFormat("HH:mm a").parse(bedtime);
//     bedtimeDate = DateTime(
//         now.year, now.month, now.day, bedtimeDate.hour, bedtimeDate.minute);

//     DateTime optimalWakeUpDate = DateFormat("hh:mm a").parse(optimalWakeTime);
//     optimalWakeUpDate = DateTime(now.year, now.month, now.day,
//         optimalWakeUpDate.hour, optimalWakeUpDate.minute);

//     int id = await generateNewAlarmId();
//     final alarmSettings = await buildAlarmSettings(optimalWakeUpDate, id);
//     await Alarm.set(alarmSettings: alarmSettings);

//     log("Setting alarm for userId: $userId at optimalWakeUpDate: $optimalWakeUpDate with alarmId: ${alarmSettings.id}");
//     await getAlarms();
//   }

//   static updateStoredWakeUpAlarmSound() {
//     AlarmSettings? alarmSettings = Alarm.getAlarm(1000);
//     if (alarmSettings != null) {
//       alarmSettings =
//           alarmSettings.copyWith(assetAudioPath: _selectedSoundPath);
//       Alarm.set(alarmSettings: alarmSettings);
//       log("Alarm sound updated for Alarm ID: ${alarmSettings.id}");
//     }
//   }

//   static Future<void> checkAndroidNotificationPermission() async {
//     if (await Permission.notification.isDenied) {
//       await Permission.notification.request();
//       log("Notification permission requested.");
//     } else {
//       log("Notification permission already granted.");
//     }
//   }

//   static Future<void> checkAndroidScheduleExactAlarmPermission() async {
//     if (await Permission.scheduleExactAlarm.isDenied) {
//       await Permission.scheduleExactAlarm.request();
//       log("Schedule exact alarm permission requested.");
//     } else {
//       log("Schedule exact alarm permission already granted.");
//     }
//   }

//   static Future<void> loadAndUpdateAlarm({
//     required String userId,
//     String? newBedtime,
//   }) async {
//     final prefs = await SharedPreferences.getInstance();

//     if (alarmsData.isNotEmpty &&
//         alarmsData[0].userId == userId &&
//         newBedtime != null) {
//       alarmsData[0].bedtime = newBedtime;
//       await prefs.setString(
//           "alarms", jsonEncode(alarmsData.map((e) => e.toJson()).toList()));

//       String optimalWakeTime = alarmsData[0].optimalWakeTime;
//       String name = alarmsData[0].name;
//       bool usertype = alarmsData[0].isForBeneficiary;
//       String sensorId = alarmsData[0].sensorId;
//       await saveAlarm(
//         userId: userId,
//         bedtime: newBedtime,
//         optimalWakeTime: optimalWakeTime,
//         name: name,
//         usertype: usertype,
//         sensorId: sensorId,
//       );
//     } else {
//       log("No alarm data found for userId $userId.");
//     }
//   }

//   static Future<void> getAlarms() async {
//     final prefs = await SharedPreferences.getInstance();
//     String? jsonData = prefs.getString("alarms");

//     if (jsonData != null) {
//       try {
//         List<dynamic> alarmList = jsonDecode(jsonData);
//         alarmsData = alarmList
//             .map((alarmJson) =>
//                 AlarmData.fromJson(alarmJson as Map<String, dynamic>))
//             .toList();

//         for (var alarm in alarmsData) {
//           log("Alarm User ID: ${alarm.userId}, Bedtime: ${alarm.bedtime}, Wake Time: ${alarm.optimalWakeTime}");
//         }
//       } catch (e) {
//         log("Error decoding alarm data: $e");
//       }
//     } else {
//       log("No alarms data found in SharedPreferences.");
//     }
//   }

//   static Future<void> clearExistingAlarm() async {
//     var alarms = await Alarm.getAlarms();

//     for (var alarm in alarms) {
//       await Alarm.stop(alarm.id);
//       log("Stopped alarm with ID: ${alarm.id}");
//     }
//   }

//   static Future<void> printAllAlarms() async {
//     final prefs = await SharedPreferences.getInstance();
//     String? jsonData = prefs.getString("alarms");

//     if (jsonData != null) {
//       alarmsData = (jsonDecode(jsonData) as List)
//           .map((data) => AlarmData.fromJson(data as Map<String, dynamic>))
//           .toList();

//       log("=====================printAllAlarms===========================");
//       for (var alarm in alarmsData) {
//         log(alarm.toJson().toString());
//       }
//     } else {
//       log("No alarms data found.");
//     }
//   }
// }
