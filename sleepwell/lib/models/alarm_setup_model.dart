class SleepModel {
  DateTime bedtime;
  DateTime wakeUpTime;
  int numberOfCycles;
  String optimalWakeUpTime;
  
  SleepModel({
    required this.bedtime,
    required this.wakeUpTime,
    required this.numberOfCycles,
    required this.optimalWakeUpTime,
  });

  // دالة لحساب مدة النوم
  Duration getSleepDuration() {
    return wakeUpTime.difference(bedtime);
  }

  // دالة لحساب وقت الاستيقاظ المثالي
  String calculateOptimalWakeUpTime() {
    int sleepCycleMinutes = 90;
    int bedtimeMinutes = bedtime.hour * 60 + bedtime.minute;
    int wakeUpTimeMinutes = wakeUpTime.hour * 60 + wakeUpTime.minute;
    
    if (wakeUpTimeMinutes < bedtimeMinutes) {
      wakeUpTimeMinutes += 24 * 60;
    }
    
    int totalSleepTimeMinutes = wakeUpTimeMinutes - bedtimeMinutes;
    int numberOfCycles = (totalSleepTimeMinutes / sleepCycleMinutes).floor();
    
    int optimalWakeUpMinutes = bedtimeMinutes + (numberOfCycles * sleepCycleMinutes);
    optimalWakeUpTime = "${(optimalWakeUpMinutes ~/ 60) % 24}:${optimalWakeUpMinutes % 60}";

    return optimalWakeUpTime;
  }
}
