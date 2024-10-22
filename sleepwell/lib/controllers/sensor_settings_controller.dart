import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
 
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sleepwell/models/sensor_model.dart';
 
import '../models/user_sensor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import '../widget/show_sensor_widget.dart';

class SensorSettingsController extends GetxController {
  final DatabaseReference sensorsDatabase =
      FirebaseDatabase.instance.ref().child('sensors');
  final DatabaseReference usersSensorsDatabase =
      FirebaseDatabase.instance.ref().child('usersSensors');

  var loading = true.obs;
  var sensorsCurrentUser = <String>[].obs;
  var selectedSensor = ''.obs;
  List<UserSensor> userSensors = [];
  String? userId = FirebaseAuth.instance.currentUser?.uid;
  var sensorsIds = <String>[].obs;
  RxBool isSleeping = false.obs;
  var isCheckingReadings = false.obs;
  String sleepStartTime = '';
  @override
  void onInit() {
    super.onInit();
    loadCachedSensors();
    loadSensors();
    listenToSensorChanges(selectedSensor.value);
  }

  Future<void> loadSensors() async {
    loading.value = true;
    userSensors = await getUserSensors(userId);
    sensorsCurrentUser.value = userSensors.map((e) => e.sensorId).toList();

    // تحديث البيانات المخزنة محلياً
    await cacheUserSensors();

    loading.value = false;
  }

  Future<void> checkUserSensors(BuildContext context) async {
    if (userId == null) {
      print("Error: User ID is null");
      return;
    }

    print("Fetching user sensors for user ID: $userId");
    userSensors = await getUserSensors(userId);

    if (userSensors.isEmpty) {
      print("No sensors found. Prompting user to add a sensor.");
      showAddSensorDialog(context);
    } else if (userSensors.length == 1) {
      selectedSensor = userSensors[0].sensorId.obs;
      print('Executing operation with the only device: $selectedSensor');
    } else {
      showSensorSelectionDialog(
        context: context,
        userSensors: sensorsCurrentUser
            .map((sensorId) => UserSensor(
                  sensorId: sensorId,
                  userId: userId ?? '', // userId
                  enable: true, // assuming default enabled
                ))
            .toList(),
        selectedSensorId: selectedSensor.value,
        onSensorSelected: (sensorId) {
          selectSensor(sensorId);
        },
        onDeleteSensor: (sensorId) {
          deleteSensor(sensorId);
        },
      );

      // مسح الحساسات السابقة لضمان عدم تكرار المعرفات
      sensorsCurrentUser.clear();

      // إضافة جميع معرفات الحساسات المرتبطة بالمستخدم الحالي إلى القائمة
      sensorsCurrentUser
          .addAll(userSensors.map((sensor) => sensor.sensorId).toList());

      print('Sensors for current user: $sensorsCurrentUser');
    }
    loading = false.obs;

    //   setState(()  {
    //  loading = false.obs;
    //   });
  }

  Future<void> loadCachedSensors() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cachedSensors = prefs.getString('userSensors');

    if (cachedSensors != null) {
      try {
        List<dynamic> sensorsList = jsonDecode(cachedSensors);
        userSensors = sensorsList
            .where((element) => element != null && element is Map)
            .map((e) => UserSensor.fromMap(e as Map<dynamic, dynamic>))
            .toList();
        sensorsCurrentUser.value = userSensors.map((e) => e.sensorId).toList();
      } catch (e) {
        print("Error decoding cached sensors: $e");
      }
    } else {
      print("No cached sensors found.");
    }
  }

  Future<void> cacheUserSensors() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List sensorData = userSensors.map((sensor) => sensor.toMap()).toList();
    await prefs.setString('userSensors', jsonEncode(sensorData));
    print("User sensors cached successfully.");
  }

  Future<List<Sensor>> getAllSensors() async {
    DataSnapshot snapshot =
        await sensorsDatabase.get(); // جلب جميع البيانات من قاعدة البيانات
    List<Sensor> sensorsList = []; // قائمة لتخزين السنسورات
    if (snapshot.exists) {
      Map<dynamic, dynamic> sensorData =
          snapshot.value as Map<dynamic, dynamic>;
      print("--------------- Sensors Data --------------");

      // الدوران على كل سنسر في قاعدة البيانات
      sensorData.forEach((key, value) {
        Sensor sensor = Sensor.fromMap(value as Map<dynamic, dynamic>);
        sensorsList.add(sensor); // إضافة السنسر إلى قائمة السنسورات
        sensorsIds
            .add(sensor.sensorId); // إضافة معرّف السنسر إلى قائمة المعرّفات

        // طباعة بيانات السنسر
        print("Sensor ID: ${sensor.sensorId}");
        print("Heart Rate: ${sensor.heartRate}");
        print("SpO2: ${sensor.spO2}");
        print("Temperature: ${sensor.temperature}");
        print("----------- End ---- Sensors Data --------------");
      });

      // طباعة جميع معرّفات السنسورات بعد الانتهاء
      for (String sensorId in sensorsIds) {
        print("Collected Sensor ID: $sensorId");
      }
    } else {
      print("No sensors found in the database.");
    }

    print("------------- End getAllSensors ----------------");
    return sensorsList; // إرجاع قائمة السنسورات
  }

  Future<Sensor?> getSensorById(String sensorId) async {
    // جلب جميع البيانات من قاعدة البيانات
    DataSnapshot snapshot = await sensorsDatabase.get();

    if (snapshot.exists) {
      Map<dynamic, dynamic> sensorData =
          snapshot.value as Map<dynamic, dynamic>;

      // البحث عن السنسور بناءً على معرفه
      for (var value in sensorData.values) {
        Sensor sensor = Sensor.fromMap(value as Map<dynamic, dynamic>);
        if (sensor.sensorId == sensorId) {
          print(
              '---------------------Selected User Sensor Data--------------------------');
          print(sensor.sensorId);
          print(sensor.temperature);
          print(sensor.heartRate);
          print(sensor.spO2);
          print(
              '----------------Selected User Sensor Data-------------------------------');

          return sensor; // إرجاع السنسور إذا تم العثور عليه
        }
      }
    }

    return null; // إرجاع null إذا لم يتم العثور على السنسور
  }

  void listenToSensorChanges(String sensorId) {
    // isCheckingReadings.value = true; // بدء التحقق
    sensorsDatabase.onValue.listen((DatabaseEvent event) {
      try {
        final data = event.snapshot.value;
        if (data != null && data is Map<dynamic, dynamic>) {
          List<Sensor> sensorReadings = [];
          for (var value in data.values) {
            sensorReadings.add(Sensor.fromMap(value as Map<dynamic, dynamic>));
          }

          if (sensorReadings.isNotEmpty) {
            calculateSleepStartTimeFromReadings(sensorReadings, sensorId);
          }
        }
      } catch (error) {
        print("Error processing data: $error");
      } finally {
        isCheckingReadings.value = false; // انتهى التحقق
      }
    }, onError: (error) {
      print("Error reading data: $error");
      isCheckingReadings.value = false; // في حالة حدوث خطأ
    });
  }

  void calculateSleepStartTimeFromReadings(
      List<Sensor> sensorReadings, String targetSensorId) {
    Sensor previousReading = sensorReadings.firstWhere(
        (sensor) => sensor.sensorId == targetSensorId,
        orElse: () => null!);

    if (previousReading == null) {
      print("No readings found for the specified sensor ID: $targetSensorId");
      return;
    }

    // المرور على جميع القراءات بعد القراءة الأولى لنفس المستشعر المحدد
    for (var reading in sensorReadings.skip(1)) {
      if (reading.sensorId == targetSensorId) {
        // حساب نسبة التغير في معدل نبضات القلب ودرجة الحرارة
        double heartRateChange =
            ((previousReading.heartRate - reading.heartRate).abs() /
                    previousReading.heartRate) *
                100;
        double temperatureChange =
            ((previousReading.temperature - reading.temperature).abs() /
                    previousReading.temperature) *
                100;

        // التحقق من انخفاض معدل ضربات القلب بنسبة 20%
        if (previousReading.heartRate != 0 &&
            reading.heartRate < previousReading.heartRate * 0.80) {
          sleepStartTime = DateTime.now().toString(); // تسجيل وقت التنبيه
          print("::::::::::::::::::::::::::::::::::::::::::::::::;");
          print("Heart rate dropped: ${reading.heartRate} at $sleepStartTime");
          print("::::::::::::::::::::::::::::::::::::::::::::::::;");
        }

        // التحقق من انخفاض درجة الحرارة بأكثر من 0.5 درجة
        if (previousReading.temperature != 0 &&
            reading.temperature < previousReading.temperature - 0.5) {
          sleepStartTime = DateTime.now().toString(); // تسجيل وقت التنبيه
          print("::::::::::::::::::::::::::::::::::::::::::::::::;");
          print(
              "Temperature dropped: ${reading.temperature} at $sleepStartTime");
          print("::::::::::::::::::::::::::::::::::::::::::::::::;");
        }

        // تعيين القراءة الحالية كقراءة سابقة للجولة القادمة
        previousReading = reading;
      }
    }

    // طباعة النتائج فقط إذا تم تحديث sleepStartTime
    if (sleepStartTime != null) {
      print(':::::::::::::::::::::::::::::::::::::::::::::::::::::::::::');
      print("Sensor ID: ${previousReading.sensorId}");
      print("Heart Rate: ${previousReading.heartRate}");
      print("Temperature: ${previousReading.temperature}");
      print("SpO2: ${previousReading.spO2}");
      print("Heart rate dropped at $sleepStartTime");
      print("::::::::::::::::::::::::::::::::::::::::::::::::;");
    }

    print(':::::::::::::::::::::::::::::::::::::::::::::::::::::::::::');
    print('Finished checking sensor readings for sensor ID: $targetSensorId');
  }

  void calculateSleepStartTimeFromReadings111(
      List<Sensor> sensorReadings, String targetSensorId) {
    Sensor previousReading = sensorReadings.firstWhere(
        (sensor) => sensor.sensorId == targetSensorId,
        orElse: () => null!);

    if (previousReading == null) {
      print("No readings found for the specified sensor ID: $targetSensorId");
      return;
    }

    // المرور على جميع القراءات بعد القراءة الأولى لنفس المستشعر المحدد
    for (var reading in sensorReadings.skip(1)) {
      if (reading.sensorId == targetSensorId) {
        // حساب نسبة التغير في معدل نبضات القلب ودرجة الحرارة
        double heartRateChange =
            ((previousReading.heartRate - reading.heartRate).abs() /
                    previousReading.heartRate) *
                100;
        double temperatureChange =
            ((previousReading.temperature - reading.temperature).abs() /
                    previousReading.temperature) *
                100;

        // التحقق من انخفاض معدل ضربات القلب بنسبة 20% على الأقل
        if (previousReading.heartRate != 0 &&
            reading.heartRate < previousReading.heartRate * 0.80) {
          sleepStartTime = DateTime.now().toString(); // تسجيل وقت التنبيه
          print("::::::::::::::::::::::::::::::::::::::::::::::::;");
          print("Heart rate dropped: ${reading.heartRate} at $sleepStartTime");
          print("::::::::::::::::::::::::::::::::::::::::::::::::;");
        }

        // التحقق من انخفاض درجة الحرارة بأكثر من 0.5 درجة
        if (previousReading.temperature != 0 &&
            reading.temperature < previousReading.temperature - 0.5) {
          sleepStartTime = DateTime.now().toString(); // تسجيل وقت التنبيه
          print("::::::::::::::::::::::::::::::::::::::::::::::::;");
          print(
              "Temperature dropped: ${reading.temperature} at $sleepStartTime");
          print("::::::::::::::::::::::::::::::::::::::::::::::::;");
        }

        // تعيين القراءة الحالية كقراءة سابقة للجولة القادمة
        previousReading = reading;
      }
    }

    print(':::::::::::::::::::::::::::::::::::::::::::::::::::::::::::');
    print("Sensor ID: ${previousReading.sensorId}");
    print("Heart Rate: ${previousReading.heartRate}");
    print("Temperature: ${previousReading.temperature}");
    print("SpO2: ${previousReading.spO2}");
    print("Heart rate dropped: at $sleepStartTime");
    print("::::::::::::::::::::::::::::::::::::::::::::::::;");

    print(':::::::::::::::::::::::::::::::::::::::::::::::::::::::::::');
    print('Finished checking sensor readings for sensor ID: $targetSensorId');
  }

  Future<List<UserSensor>> getUserSensors(String? userId) async {
    if (userId == null) {
      print("Error: Current user ID is null.");
      return [];
    }

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

      if (userSensors.isNotEmpty) {
        this.userSensors = userSensors;
        await cacheUserSensors();
      } else {
        print("No sensors found for current user: $userId.");
      }
    } else {
      print("No sensor data found in the database.");
    }

    return userSensors;
  }

  Future<void> addUserSensor(
      String userId, String sensorId, BuildContext context) async {
    // try {
    //   // تحقق من وجود المستشعر في جدول sensors
    //   DataSnapshot sensorSnapshot = await sensorsDatabase.get();
    //   if (!sensorSnapshot.exists) {
    //     _showErrorDialog(context, 'Failed to add sensor.');
    //     throw Exception('Sensor does not exist.');
    //   }

    //   // تحقق من عدم وجود المستشعر مسبقاً لهذا المستخدم
    //   List<UserSensor> currentUserSensors = await getUserSensors(userId);
    //   bool sensorAlreadyAdded =
    //       currentUserSensors.any((sensor) => sensor.sensorId == sensorId);

    //   if (sensorAlreadyAdded) {
    //     _showErrorDialog(context, 'Sensor is already added..');
    //     throw Exception('Sensor is already added.');
    //   } else {
    Map<String, dynamic> sensorData = {
      'sensorId': sensorId,
      'userId': userId,
      'enable': true,
    };

    await usersSensorsDatabase.push().set(sensorData);
    print("User sensor added successfully.");
    _showSuccessDialog(context, 'Sensor added successfully.');
    // }
    // إضافة المستشعر

    // تحديث القائمة بعد الإضافة
    await loadSensors();
    // } catch (e) {
    //   print("Error adding user sensor: $e");
    // }
  }

  Future<void> deleteSensor(String sensorId) async {
    try {
      DataSnapshot snapshot = await usersSensorsDatabase.get();
      if (snapshot.exists) {
        Map<dynamic, dynamic> sensorsMap =
            snapshot.value as Map<dynamic, dynamic>;
        sensorsMap.forEach((key, value) async {
          if (value['sensorId'] == sensorId && value['userId'] == userId) {
            await usersSensorsDatabase.child(key).remove();
            userSensors.removeWhere((sensor) => sensor.sensorId == sensorId);

            // تحديث التخزين المحلي بعد الحذف
            await cacheUserSensors();

            // تحديث واجهة المستخدم
            sensorsCurrentUser.value =
                userSensors.map((e) => e.sensorId).toList();
            print("Sensor with sensorId $sensorId deleted successfully.");
          }
        });
      }
    } catch (e) {
      print("Error deleting sensor: $e");
    }
  }

  void showAddSensorDialog(BuildContext context) {
    TextEditingController sensorIdController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Sensor'),
          content: TextField(
            controller: sensorIdController,
            decoration: const InputDecoration(hintText: 'Enter Sensor ID'),
          ),
          actions: [
            ElevatedButton(
              child: const Text('Add'),
              onPressed: () async {
                String sensorId = sensorIdController.text.trim();
                print('sensorsIdsaaaaaaaaaaaaa');
                print(sensorsIds);
                print('sensorsIdsaaaaaaaaaaaaa');

                if (sensorId.isNotEmpty) {
                  if (sensorsIds.contains(sensorId)) {
                    // التحقق من أن الحساس غير مرتبط مسبقًا بالمستخدم
                    List<UserSensor> userSensors = await getUserSensors(userId);
                    bool sensorExistsForUser = userSensors.any(
                      (userSensor) => userSensor.sensorId == sensorId,
                    );

                    if (sensorExistsForUser) {
                      _showErrorDialog(
                        context,
                        'This sensor is already linked to your account.',
                      );
                    } else {
                      await addUserSensor(userId!, sensorId, context);
                      Navigator.pop(context); // إغلاق الـDialog بعد الإضافة
                      // setState(() {});
                      _showSuccessDialog(context, 'Sensor added successfully.');
                      loadSensors();
                    }
                  } else {
                    _showErrorDialog(
                      context,
                      'Sensor with ID $sensorId not found.',
                    );
                  }

                  // await addUserSensor(userId!, sensorId, context);
                  // Navigator.pop(context); // Close after adding
                }
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context); // Close dialog
              },
            ),
          ],
        );
      },
    );
  }

  void _showConfirmationDialog(BuildContext context, String sensorId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Sensor'),
          content: const Text('Are you sure you want to delete this sensor?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context); // إغلاق النافذة بدون حذف
              },
            ),
            ElevatedButton(
              child: const Text('Delete'),
              onPressed: () async {
                Navigator.pop(context); // إغلاق النافذة بعد الحذف
                try {
                  _showConfirmationDialog(context, sensorId);

                  await deleteSensor(sensorId);
                  _showSuccessDialog(context, 'Sensor deleted successfully.');
                } catch (e) {
                  _showErrorDialog(
                      context, 'Failed to delete sensor. Please try again.');
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            ElevatedButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.pop(context); // Close dialog
              },
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Success'),
          content: Text(message),
          actions: [
            ElevatedButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.pop(context); // Close dialog
              },
            ),
          ],
        );
      },
    );
  }

  void selectSensor(String sensorId) {
    selectedSensor.value = sensorId;
  }
}
