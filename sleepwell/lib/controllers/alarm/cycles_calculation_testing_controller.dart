import 'package:firebase_auth/firebase_auth.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../alarm.dart';
import '../../services/sensor_service.dart';

class CyclesCalculationTestingController extends GetxController {
  Rx<DateTime> bedtime = DateTime.now().obs;
  Rx<DateTime> actualBedtime = DateTime.now().obs;
  Rx<DateTime> wakeUpTime = DateTime.now().obs;

  RxInt numberOfCycles = 0.obs;
  // RxInt remainingMinutes = 0.obs;
  RxDouble sleepHours = 0.0.obs;
  RxDouble sleepHourshours = 0.0.obs;
  RxDouble remainingminutesToCompleteHoure = 0.0.obs;
  RxDouble remainingminutesToCompleteCycle = 0.0.obs;
  RxString actualWakeUpTime = ''.obs;
  RxBool addedFifteenMinutes = false.obs;
  String? userId = FirebaseAuth.instance.currentUser?.uid;
  final sensorService = Get.find<SensorService>();

  Future<void> calculateSleepCycles() async {
    final sleepDuration = wakeUpTime.value.difference(actualBedtime.value);

    sleepHours.value =
        sleepDuration.inHours + (sleepDuration.inMinutes % 60) / 60.0;
    numberOfCycles.value = (sleepDuration.inMinutes / 90).floor();
    remainingminutesToCompleteCycle.value = sleepDuration.inMinutes % 90;
    actualWakeUpTime.value = DateFormat('hh:mm a').format(wakeUpTime.value);
    addedFifteenMinutes.value = wakeUpTime.value.minute % 15 == 0;
    sleepHourshours.value = sleepDuration.inHours.toDouble();
    remainingminutesToCompleteHoure.value = sleepDuration.inMinutes % 60;
    print(
        'Sleep Duration (minutes): ${sleepDuration.inMinutes}'); // All Sleep Duration in Miniutes
    print(
        'sleepDuration.inHours  : ${sleepDuration.inHours}'); // All Sleep Duration in Hours only
    print(
        'sleepDuration.inMinutes Remaining Minutes: ${sleepDuration.inMinutes % 60}');
    print('------------------------------------');
    print('Number of Cycles: ${numberOfCycles.value}');
    print(
        'remainingminutesToCompleteCycle: ${remainingminutesToCompleteCycle.value}');
    print('------------------------------------');

    print('Sleep Hours: ${sleepHours.value}');
    print('Actual Wake Up Time: ${actualWakeUpTime.value}');
    print('Added Fifteen Minutes: ${addedFifteenMinutes.value}');

    await AppAlarm.saveAlarm(
      bedtime: DateFormat('hh:mm a').format(bedtime.value).toString(),
      optimalWakeTime: DateFormat('hh:mm a').format(wakeUpTime.value),
      userId: userId.toString(),
      usertype: true,
      name: 'Yourself',
      sensorId: sensorService.selectedSensor.value,
    );
    await AppAlarm.getAlarms();
  }

  void setBedtime(DateTime time) {
    bedtime.value = time;
  }

  void setActualBedtime(DateTime time) {
    actualBedtime.value = time;
  }

  void setWakeUpTime(DateTime time) {
    wakeUpTime.value = time;
  }
}
