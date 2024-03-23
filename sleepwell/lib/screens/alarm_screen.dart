import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

  void _showBedtimePicker() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedBedtime,
    );

    if (pickedTime != null) {
      setState(() {
        selectedBedtime = pickedTime;
        bedtimeController.text = pickedTime.format(context);
      });
    }
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
  void _saveTimes() {
    List<Map<String, int>> myHourList =
        timeAndHeart(); // Retrieve the data internally

    int bedtimeIndex = 0;
    int bedtimeMinutes = 0;
    int sleepCycleMinutes = 90; // Duration of each sleep cycle in minutes

    for (int i = 0; i < myHourList.length; i++) {
      if (myHourList[i]['heartRate']! < 95) {
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

    setState(() {
      printedBedtime =
          "${myHourList[bedtimeIndex]['hour']}:${myHourList[bedtimeIndex]['minute']}";
      printedWakeUpTime = optimalWakeUpTime;
    });
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

  List<Map<String, int>> timeAndHeart() {
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
  }

  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    var formattedDate = DateFormat('EEE, d MMM').format(now);
    var formattedTime = DateFormat('hh:mm').format(now);

    var white = Colors.white;
    const color = Color.fromARGB(255, 255, 255, 255);

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 16, 95, 199),
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF004AAD), Color(0xFF040E3B)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(30),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        'SleepWell Cycle',
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 20,
                        ),
                      ),
                      SafeArea(
                        child: Row(
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
                      SafeArea(
                        child: BottomAppBar(
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
                      ),
                    ],
                  ),
                ),
                /* Expanded(
                  flex: 1,
                  child: ClockView(),
                ),*/
              ],
            ),
          ),
        ),
      ),
    );
  }
}