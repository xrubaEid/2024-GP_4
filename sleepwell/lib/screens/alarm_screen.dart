
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sleepwell/screens/clockview.dart';

class AlarmScreen extends StatefulWidget {
  static String RouteScreen = 'alarm_screen';

  const AlarmScreen({super.key});

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

  void _saveTimes() {
    final String bedtime = bedtimeController.text;
    final String wakeUpTime = wakeUpTimeController.text;

    // Perform your sleep cycle function using the saved values

    setState(() {
      printedBedtime = bedtime;
      printedWakeUpTime = wakeUpTime;
    });
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
      body: Container(
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
                    SizedBox(height: 20),
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
                    SizedBox(height: 20),
                    BottomAppBar(
                      color: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
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
                      ),
                    )
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
    );
  }
}