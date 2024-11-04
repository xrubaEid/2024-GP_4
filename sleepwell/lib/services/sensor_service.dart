import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sleepwell/models/sensor_model.dart';
import 'package:sleepwell/services/alarm_service.dart';
import 'package:sleepwell/services/firebase_auth_service.dart';
import 'package:sleepwell/services/firebase_firestore_service.dart';
import '../alarm.dart';
import '../models/user_sensor.dart';
import '../push_notification_service.dart';

class SensorService extends GetxService {
  final DatabaseReference sensorsDatabase =
      FirebaseDatabase.instance.ref().child('sensors');
  final DatabaseReference usersSensorsDatabase =
      FirebaseDatabase.instance.ref().child('usersSensors');
  final FirebaseFirestoreService firestoreService = FirebaseFirestoreService();

  // var loading = true.obs;
  var sensorsCurrentUser = <String>[].obs;
  var selectedSensor = ''.obs;
  var selectedCurrentUser = ''.obs;
  List<UserSensor> userSensors = [];
  String? userId = FirebaseAuth.instance.currentUser?.uid;
  var sensorsIds = <String>[].obs;
  RxBool isSleeping = false.obs;

  var sleepStartTime = ''.obs;

  double? previousTemperature;
  int? previousHeartRate;
  final FirebaseAuthService authService = FirebaseAuthService();
  // /////////////////////////////////////////
  Sensor? previousSensorReading; // To store the previous sensor readings
  Timer? sensorCheckTimer; // Timer for periodic checks
  final int checkIntervalSeconds = 5; // Interval for checking in seconds
/////////////////////////////////////////
  // Async initializer for setting up SensorService
  Future<SensorService> init() async {
    // userId = authService.getUserId() ?? '';
    await loadSensors();
    log(userId.toString());
    log(userId.toString());
    log(userId.toString());
// ////////////////////////
    if (userId != null && selectedSensor.value.isNotEmpty) {
      await isSensorReading(selectedSensor.value.obs.toString());
      await getSelectedSensor();
      await startSensorReadingChecker();
// ////////////////////////
      listenToSensorChanges(selectedSensor.value.obs.toString());
      AlarmService().init();
    }
    // Check if the selected sensor is reading and get its details

    return this;
  }

// ////////////////////////
  Future<void> startSensorReadingChecker() async {
    stopSensorReadingChecker(); // Stop any existing timer to avoid duplicates

    // Start a periodic timer
    sensorCheckTimer =
        Timer.periodic(Duration(seconds: checkIntervalSeconds), (timer) async {
      bool isReading = await isSensorActivelyReading(selectedSensor.value);
      log("Sensor ${selectedSensor.value} actively reading: $isReading");

      if (!isReading) {
        log("Sensor ${selectedSensor.value} stopped reading.");
      }
    });
  }

  // Stop the periodic sensor reading checker
  void stopSensorReadingChecker() {
    sensorCheckTimer?.cancel();
  }

  // Function to check if the sensor is actively reading
  Future<bool> isSensorActivelyReading(String sensorId) async {
    Sensor? currentSensorReading = await getSensorById(sensorId);

    if (currentSensorReading == null) {
      log("Sensor data unavailable.");
      return false;
    }

    // Check if current reading is different from the previous one
    bool isActivelyReading = previousSensorReading == null ||
        currentSensorReading.temperatura !=
            previousSensorReading!.temperatura ||
        currentSensorReading.heartRate != previousSensorReading!.heartRate ||
        currentSensorReading.spO2 != previousSensorReading!.spO2;

    // Update previous reading with the current one for the next comparison
    previousSensorReading = currentSensorReading;

    return isActivelyReading;
  }

  // Function to get sensor data by ID from Firebase
  // Future<Sensor?> getSensorById(String sensorId) async {
  //   DataSnapshot snapshot = await sensorsDatabase.child(sensorId).get();

  //   if (snapshot.exists) {
  //     Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
  //     return Sensor.fromMap(data);
  //   }

  //   return null;
  // }

  @override
  void onClose() {
    stopSensorReadingChecker(); // Ensure the timer is stopped when the service is disposed
    super.onClose();
  }

  Future<bool> isSensorReading(String sensorId) async {
    Sensor? sensor = await getSensorById(sensorId);
    if (sensor != null) {
      // Check if any readings (e.g., temperature, heart rate) are non-zero
      bool isReading =
          sensor.temperatura > 0 || sensor.heartRate > 0 || sensor.spO2 > 0;
      log("Sensor ${sensor.sensorId} is reading: $isReading");
      await PushNotificationService.showNotification(
        title: 'Selected Sensor Avalible For Your Alarm',
        body: 'Selcted Sensor $sensorId Is Reading ',
        schedule: true,
        interval: 60,
        // actionButtons: [
        //   NotificationActionButton(
        //       key: 'DailyNotification', label: 'Go To Alarm Screen')
        // ],
      );
      return isReading;
    } else {
      log("Sensor not found or inactive.");
      await PushNotificationService.showNotification(
        title: 'Selected Sensor Avalible For Your Alarm',
        body: 'Sensor Is Not Reading Its Not Working Checked it',
        schedule: true,
        interval: 60,
        // actionButtons: [
        //   NotificationActionButton(
        //       key: 'DailyNotification', label: 'Go To Alarm Screen')
        // ],
      );
      return false;
    }
  }

  // Function to retrieve and log the selected sensor details
  Future<void> getSelectedSensor() async {
    if (selectedSensor.value.isEmpty) {
      log("::::::::::::::::::::::No sensor is currently selected.:::::::::::::::::::::::::::");
      return;
    }

    Sensor? sensor = await getSensorById(selectedSensor.value);
    if (sensor != null) {
      log("::::::::::::::::::Selected Sensor ID: ${sensor.sensorId}:::::::::::::::::::::::::::::::");
      log("Selected Sensor ID: ${sensor.sensorId}, Temperature: ${sensor.temperatura}, Heart Rate: ${sensor.heartRate}, SpO2: ${sensor.spO2}");
      log("::::::::::::::::END ::Selected Sensor ID: ${sensor.sensorId}:::::::::::::::::::::::::::::::");
    } else {
      log(":???????????????:::::::Selected sensor data is unavailable.:::::::::::::::::::::::::::::::::::::::::");
    }
  }

// ////////////////////////

  Future<void> loadSensors() async {
    // loading.value = true;
    userSensors = await getUserSensors(userId);
    sensorsCurrentUser.value = userSensors.map((e) => e.sensorId).toList();
    await getSelectedSensorId();
    log('sensorsCurrentUser');
    log('sensorsCurrentUser${selectedSensor.value.obs.toString()}');
    log(selectedSensor.toString());
    log('sensorsCurrentUser2');
    // loading.value = false;
  }

  Future<void> getSelectedSensorId() async {
    if (userId == null) {
      print("Error: User ID is null");
      return;
    }
    if (userSensors.length == 1) {
      selectedSensor = userSensors[0].sensorId.obs;
    }
    if (userSensors.length > 1) {
      selectedSensor = selectedSensor.value.obs;
      // selectedSensor = selectedSensor.toString().obs;
    }
  }

  Future<Sensor?> getSensorById(String sensorId) async {
    try {
      DataSnapshot snapshot = await sensorsDatabase.get();

      if (snapshot.exists) {
        Map<dynamic, dynamic> sensorData =
            snapshot.value as Map<dynamic, dynamic>;

        for (var value in sensorData.values) {
          Sensor sensor = Sensor.fromMap(value as Map<dynamic, dynamic>);
          if (sensor.sensorId == sensorId) {
            print("Selected User Sensor ID: ${sensor.sensorId}");
            return sensor;
          }
        }
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  void listenToSensorChanges(String sensorId) {
    sensorsDatabase.onValue.listen((DatabaseEvent event) async {
      final data = event.snapshot.value;

      // Convert data to a list of sensor objects
      List<Sensor> sensorReadings = convertObjectToLIst(data);
      // Filter by selected sensor ID
      Sensor currentSensor = sensorReadings.firstWhere(
        (sensor) => sensor.sensorId == selectedSensor.value,
        orElse: () =>
            Sensor(sensorId: '', temperatura: 0, spO2: 0, heartRate: 0),
      );
      print('currentSensor: ${currentSensor.toMap()}');
      if (currentSensor.sensorId.isNotEmpty) {
        double currentTemperature = currentSensor.temperatura.toDouble();
        int currentHeartRate = currentSensor.heartRate;

        bool hasDecreased = false;

        // Check if temperature has decreased
        if (previousTemperature != null &&
            previousTemperature! > currentTemperature) {
          hasDecreased = true;
          print(
              "Temperature decreased from $previousTemperature to $currentTemperature");
        }

        // Check if heart rate has decreased by 20% or more
        if (previousHeartRate != null &&
            currentHeartRate <= previousHeartRate! * 0.8) {
          hasDecreased = true;
          print(
              "Heart rate decreased by 20% or more from $previousHeartRate to $currentHeartRate");
        }

        // Print the datetime if any decrease was detected
        if (hasDecreased) {
          DateTime now = DateTime.now();

          print("Current DateTime: $now");
          await AppAlarm.loadAndUpdateAlarm(
            newBedtime: DateFormat('hh:mm a').format(now),
            userId: selectedCurrentUser.value.obs.toString(),
          );
          await AppAlarm.printAllAlarms();

          await firestoreService.updateBedtime(
            userId: userId.toString(),
            selectedCurrentUser: selectedCurrentUser.value.obs.toString(),
            newBedtime: DateFormat('hh:mm a').format(now),
          );

          await PushNotificationService.showNotification(
            title: 'Actual Sleep Time For Your Sleep Tracker',
            body: 'Actual Sleep Time is ${DateFormat('hh:mm a').format(now)}',
            schedule: true,
            interval: 60,
            // actionButtons: [
            //   NotificationActionButton(
            //       key: 'DailyNotification', label: 'Go To Alarm Screen')
            // ],
          );
        }

        // Update previous values for the next comparison
        previousTemperature = currentTemperature;
        previousHeartRate = currentHeartRate;
      }
    }, onError: (error) {
      print("Error reading data: $error");
    });
  }

  List<Sensor> convertObjectToLIst(Object? data) {
    List<Sensor> sensorReadings = [];
    if (data != null && data is Map<dynamic, dynamic>) {
      for (var value in data.values) {
        if (value is Map<dynamic, dynamic>) {
          sensorReadings.add(Sensor.fromMap(value));
        }
      }
    }
    return sensorReadings;
  }

  Future<List<UserSensor>> getUserSensors(String? userId) async {
    if (userId == null) {
      return [];
    }
    try {
      DataSnapshot snapshot = await usersSensorsDatabase.get();
      List<UserSensor> userSensors = [];

      if (snapshot.exists) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
        data.forEach((key, value) {
          Map<dynamic, dynamic> sensorData = value as Map<dynamic, dynamic>;
          if (sensorData['userId'] == userId &&
              sensorData.containsKey('sensorId')) {
            userSensors.add(UserSensor.fromMap(sensorData));
          }
        });
      }

      return userSensors;
    } catch (e) {
      print(e);

      return [];
    }
  }

  void selectSensor(String sensorId) {
    selectedSensor.value = sensorId;
    loadSensors();
  }

  // RxString getSelectedSensor(String sensorId) {
  //   return sensorId.obs;
  // }

  void selectUsers(String selectUsers) {
    selectedCurrentUser.value = selectUsers;
  }
}
