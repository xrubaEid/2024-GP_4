import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sleepwell/alarm.dart';
import 'package:sleepwell/screens/clockview.dart';

class AlarmScreen extends StatefulWidget {
  static String RouteScreen = 'alarm_screen';

  const AlarmScreen({Key? key}) : super(key: key);

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  late TextEditingController bedtimeController;
  late TextEditingController wakeUpTimeController;
  late TimeOfDay selectedBedtime;
  late TimeOfDay selectedWakeUpTime;

  String printedBedtime = '';
  String printedWakeUpTime = '';
  String printednumOfCycles = '';

  @override
  void initState() {
    super.initState();
    bedtimeController = TextEditingController();
    wakeUpTimeController = TextEditingController();
    selectedBedtime = TimeOfDay.now();
    selectedWakeUpTime = TimeOfDay.now();
  }

  @override
  void dispose() {
    bedtimeController.dispose();
    wakeUpTimeController.dispose();
    super.dispose();
  }

  Future<TimeOfDay?> _showBedtimePicker() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        bedtimeController.text = pickedTime.format(context);
        selectedBedtime = pickedTime;
      });
    }

    return pickedTime;
  }

  void _showWakeUpTimePicker() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedWakeUpTime,
    );

    if (pickedTime != null) {
      setState(() {
        selectedWakeUpTime = pickedTime;
        wakeUpTimeController.text = pickedTime.format(context);
      });
    }
  }

  void _saveTimes() async {
    //await _showBedtimePicker();
    TimeOfDay? selectedTime = selectedBedtime;

    if (selectedTime != null) {
      List<Map<String, int>> myHourList = timeAndHeart(selectedTime);
      // ...

      int bedtimeIndex = 0;
      int bedtimeMinutes = 0;
      int sleepCycleMinutes = 90; // Duration of each sleep cycle in minutes

      for (int i = 0; i < myHourList.length; i++) {
        if (myHourList[i]['heartRate']! < 90) {
          bedtimeIndex = i;
          break;
        }
      }

      if (bedtimeIndex > 0) {
        bedtimeMinutes = myHourList[bedtimeIndex]['hour']! * 60 +
            myHourList[bedtimeIndex]['minute']!;
      } else {
        // Handle case where heart rate never drops below 95 bpm
        // Use the last hour in the list as bedtime
        bedtimeMinutes = myHourList[myHourList.length - 1]['hour']! * 60 +
            myHourList[myHourList.length - 1]['minute']!;
      }

      int numberOfCycles = ((selectedWakeUpTime.hour * 60 +
                  selectedWakeUpTime.minute -
                  bedtimeMinutes) /
              sleepCycleMinutes)
          .floor();

      int optimalWakeUpMinutes =
          bedtimeMinutes + (numberOfCycles * sleepCycleMinutes);
      String optimalWakeUpTime = calculateTimeFromMinutes(
          optimalWakeUpMinutes, wakeUpTimeController.text);

      String moreTime = calculateTimeFromMinutes(
          optimalWakeUpMinutes + 15, wakeUpTimeController.text);
      print(moreTime);
      print(selectedWakeUpTime);

      bool compare =
          compareTimeStringAndTimeOfDay(moreTime, selectedWakeUpTime);
      if (compare) {
        optimalWakeUpTime = moreTime;
      }

      setState(() {
        int? hour = myHourList[bedtimeIndex]['hour'];
        int? minute = myHourList[bedtimeIndex]['minute'];
        String period = (hour! < 12) ? 'AM' : 'PM';
        hour = (hour > 12) ? hour - 12 : hour;

        printedBedtime = '$hour:${minute.toString().padLeft(2, '0')} $period';
        printedWakeUpTime = optimalWakeUpTime;
        printednumOfCycles = numberOfCycles.toString();
      });

      // set alarm to optimal wake-up date
      await AppAlarm.saveAlarm(selectedBedtime, optimalWakeUpTime);
      AppAlarm.getAlarms();
    }
  }

  String calculateTimeFromMinutes(int minutes, String referenceTime) {
    int hours = minutes ~/ 60;
    int mins = minutes % 60;
    TimeOfDay timeOfDay = TimeOfDay(hour: hours, minute: mins);
    DateTime dateTime = DateFormat('hh:mm a').parse(referenceTime);
    dateTime = DateTime(dateTime.year, dateTime.month, dateTime.day,
        timeOfDay.hour, timeOfDay.minute);
    return DateFormat('hh:mm a').format(dateTime);
  }

  int calculateMinutesFromTime(String time) {
    TimeOfDay timeOfDay =
        TimeOfDay.fromDateTime(DateFormat('hh:mm a').parse(time));
    return (timeOfDay.hour * 60) + timeOfDay.minute;
  }

  bool compareTimeStringAndTimeOfDay(String timeString, TimeOfDay timeOfDay) {
    List<String> parts = timeString.split(' ');
    List<String> timeParts = parts[0].split(':');
    int hour = int.parse(timeParts[0]);
    int minute = int.parse(timeParts[1]);
    if (parts[1] == 'PM' && hour != 12) {
      hour += 12;
    }

    DateTime parsedDateTime = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      hour,
      minute,
    );

    DateTime targetDateTime = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      timeOfDay.hour,
      timeOfDay.minute,
    );

    return parsedDateTime.isBefore(targetDateTime) ||
        parsedDateTime.isAtSameMomentAs(targetDateTime);
  }

  List<Map<String, int>> timeAndHeart(TimeOfDay bedtime) {
    List<Map<String, int>> myHourList = [];

    DateTime now = DateTime.now();
    DateTime startTime = DateTime(
      now.year,
      now.month,
      now.day,
      bedtime.hour,
      bedtime.minute,
    );

    DateTime endTime = startTime.add(Duration(hours: 1));

    int initialHeartRate = 120;
    int finalHeartRate = 75;

    DateTime currentTime = startTime;
    Random random = Random();
    while (currentTime.isBefore(endTime)) {
      int heartRate;
      if (currentTime.isBefore(startTime.add(Duration(minutes: 30)))) {
        // Decrease heart rate gradually from initialHeartRate to 95 bpm
        double progress = currentTime.difference(startTime).inMinutes /
            (startTime.add(Duration(minutes: 30)).difference(startTime))
                .inMinutes;

        int decreaseAmount = (progress * (initialHeartRate - 95)).round();
        heartRate = initialHeartRate - decreaseAmount;
      } else {
        // Decrease heart rate gradually from 95 bpm to finalHeartRate
        double progress = currentTime
                .difference(startTime.add(Duration(minutes: 30)))
                .inMinutes /
            (endTime.difference(startTime.add(Duration(minutes: 30))))
                .inMinutes;

        int decreaseAmount = (progress * (95 - finalHeartRate)).round();
        heartRate = 95 - decreaseAmount;
      }

      myHourList.add({
        'hour': currentTime.hour,
        'minute': currentTime.minute,
        'heartRate': heartRate,
      });

      // Generate a random duration between 10 and 20 minutes
      int randomDuration = 10 + random.nextInt(11);
      currentTime = currentTime.add(Duration(minutes: randomDuration));
    }

    return myHourList;
  }

  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    var formattedDate = DateFormat('EEE, d MMM').format(now);
    var formattedTime = DateFormat('hh:mm').format(now);

    //var white = Colors.white;
    //const color = Color.fromARGB(255, 255, 255, 255);

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 16, 95, 199),
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(30),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF004AAD), Color(0xFF040E3B)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: MediaQuery.of(context).padding.top),
            const Text(
              'SleepWell Cycle',
              style: TextStyle(
                color: Color.fromARGB(255, 255, 255, 255),
                fontSize: 20,
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        formattedTime,
                        style: const TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 40,
                        ),
                      ),
                      Text(
                        formattedDate,
                        style: const TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: ClockView(),
                ),
              ],
            ),
            const SizedBox(height: 40),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "BEDTIME",
                      style: TextStyle(
                        color: Color(0xffff0863),
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.3,
                      ),
                    ),
                    GestureDetector(
                      onTap: _showBedtimePicker,
                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: bedtimeController,
                          decoration: InputDecoration(
                            hintText: "Select bedtime",
                            hintStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "WAKE UP TIME",
                      style: TextStyle(
                          color: Color(0xffff0863),
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.3),
                    ),
                    GestureDetector(
                      onTap: _showWakeUpTimePicker,
                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: wakeUpTimeController,
                          decoration: InputDecoration(
                            hintText: "Select wake-up time",
                            hintStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),
            Align(
                alignment: Alignment.center,
                child: Center(
                    child: TextButton(
                  onPressed: _saveTimes,
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.pink),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  child: Text('Save'),
                ))),
            SizedBox(height: 8),
            BottomAppBar(
              color: Colors.transparent,
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Actual sleep time is: $printedBedtime',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  //SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Optimal wake-up time is: $printedWakeUpTime',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: const Text(
                "Go to profile page to edit alarm settings",
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          DateTime now = DateTime.now();
          final nowTime = TimeOfDay.fromDateTime(now);
          await AppAlarm.saveAlarm(
              nowTime, "${nowTime.hour}:${nowTime.minute + 1} AM");
          AppAlarm.getAlarms();
        },
        child: Icon(Icons.alarm),
      ),
    );
  }
}

  /* List<Map<String, int>> timeAndHeart() {
    List<Map<String, int>> myHourList = [];

    DateTime startTime = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      11,
      0,
      0,
    );
    DateTime endTime = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      12,
      0,
      0,
    );

    int initialHeartRate = 120;
    int finalHeartRate = 75;

    DateTime currentTime = startTime;
    while (currentTime.isBefore(endTime)) {
      int heartRate;
      if (currentTime.isBefore(DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        11,
        30,
      ))) {
        // Decrease heart rate gradually from initialHeartRate to 95 bpm
        double progress = currentTime.difference(startTime).inMinutes /
            (DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
              11,
              30,
            ).difference(startTime))
                .inMinutes;

        int decreaseAmount = (progress * (initialHeartRate - 95)).round();
        heartRate = initialHeartRate - decreaseAmount;
      } else {
        // Decrease heart rate gradually from 95 bpm to finalHeartRate
        double progress = currentTime
                .difference(DateTime(
                  DateTime.now().year,
                  DateTime.now().month,
                  DateTime.now().day,
                  11,
                  30,
                ))
                .inMinutes /
            (endTime.difference(DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
              11,
              30,
            ))).inMinutes;

        int decreaseAmount = (progress * (95 - finalHeartRate)).round();
        heartRate = 95 - decreaseAmount;
      }

      myHourList.add({
        'hour': currentTime.hour,
        'minute': currentTime.minute,
        'heartRate': heartRate
      });
      currentTime = currentTime.add(Duration(minutes: 1));
    }

    return myHourList;
  }*/

/*
  void _saveTimes() {
    final String bedtime = bedtimeController.text;
    final String wakeUpTime = wakeUpTimeController.text;

    int bedtimeMinutes = calculateMinutesFromTime(bedtime);
    int wakeupMinutes = calculateMinutesFromTime(wakeUpTime);

    int sleepCycleMinutes = 90; // Duration of each sleep cycle in minutes
    int numberOfCycles =
        ((wakeupMinutes - bedtimeMinutes) / sleepCycleMinutes).floor();

    int optimalWakeUpMinutes =
        bedtimeMinutes + (numberOfCycles * sleepCycleMinutes);
    String optimalWakeUpTime =
        calculateTimeFromMinutes(optimalWakeUpMinutes, wakeUpTime);

    setState(() {
      printedBedtime = bedtime;
      printedWakeUpTime = optimalWakeUpTime;
    });
  }*/