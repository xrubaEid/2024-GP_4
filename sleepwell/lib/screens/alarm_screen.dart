//import 'dart:html';
import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:sleepwell/screens/clockview.dart';
import 'package:intl/intl.dart';

class AlarmScreen extends StatefulWidget {
  static String RouteScreen = 'alarm_screen';
  
  const AlarmScreen({super.key});
=======
import 'package:fl_chart/fl_chart.dart'; 
import '../../widget/round_button.dart';
import '../../widget/today_sleep_schedule_row.dart';

class AlarmScreen extends StatefulWidget {
  static String RouteScreen = 'alarm_screen';
  const AlarmScreen({Key? key}) : super(key: key);
>>>>>>> 14db60dfe48377b3d80628dc1b225398df4e8cd3

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
<<<<<<< HEAD
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
      backgroundColor: const Color.fromARGB(255, 16, 95, 199),
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
                          const Align(
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
                        const SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text(
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
                                  decoration: const InputDecoration(
                                    hintText: "Select bedtime",
                                    hintStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontSize: 30,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text(
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
                                  decoration: const InputDecoration(
                                    hintText: "Select wake-up time",
                                    hintStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  style: const TextStyle(
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
                    const SizedBox(height: 20),
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
                          child: const Text('Save'),
                        ))),
                    const SizedBox(height: 20),
                    BottomAppBar(
                      color: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Optimal wake-up time is: $printedWakeUpTime',
                              style: const TextStyle(
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
=======
  List todaySleepArr = [
    {
      "name": "Bedtime",
      "image": "assets/img/bed.png",
      "time": "01/06/2023 09:00 PM",
      "duration": "in 6hours 22minutes"
    },
    {
      "name": "Alarm",
      "image": "assets/img/alaarm.png",
      "time": "02/06/2023 05:10 AM",
      "duration": "in 14hours 30minutes"
    },
  ];

  List findEatArr = [
    {
      "name": "Breakfast",
      "image": "assets/img/m_3.png",
      "number": "120+ Foods"
    },
    {"name": "Lunch", "image": "assets/img/m_4.png", "number": "130+ Foods"},
  ];

  List<int> showingTooltipOnSpots = [4];

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    final tooltipsOnBar = lineBarsData1[0];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            margin: const EdgeInsets.all(8),
            height: 40,
            width: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10)),
            child: Image.asset(
              "assets/img/black_btn.png",
              width: 15,
              height: 15,
              fit: BoxFit.contain,
            ),
          ),
        ),
        title: Text(
          "Alarm",
          style: TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.w700),
        ),
        actions: [
          InkWell(
            onTap: () {},
            child: Container(
              margin: const EdgeInsets.all(8),
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)),
              child: Image.asset(
                "assets/img/more_btn.png",
                width: 15,
                height: 15,
                fit: BoxFit.contain,
              ),
            ),
          )
        ],
      ),
      backgroundColor:Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      padding: const EdgeInsets.only(left: 15),
                      height: media.width * 0.5,
                      width: double.maxFinite,
                      child: LineChart(
                        LineChartData(
                          showingTooltipIndicators:
                              showingTooltipOnSpots.map((index) {
                            return ShowingTooltipIndicators([
                              LineBarSpot(
                                tooltipsOnBar,
                                lineBarsData1.indexOf(tooltipsOnBar),
                                tooltipsOnBar.spots[index],
                              ),
                            ]);
                          }).toList(),
                          lineTouchData: LineTouchData(
                            enabled: true,
                            handleBuiltInTouches: false,
                            touchCallback: (FlTouchEvent event,
                                LineTouchResponse? response) {
                              if (response == null ||
                                  response.lineBarSpots == null) {
                                return;
                              }
                              if (event is FlTapUpEvent) {
                                final spotIndex =
                                    response.lineBarSpots!.first.spotIndex;
                                showingTooltipOnSpots.clear();
                                setState(() {
                                  showingTooltipOnSpots.add(spotIndex);
                                });
                              }
                            },
                            mouseCursorResolver: (FlTouchEvent event,
                                LineTouchResponse? response) {
                              if (response == null ||
                                  response.lineBarSpots == null) {
                                return SystemMouseCursors.basic;
                              }
                              return SystemMouseCursors.click;
                            },
                            getTouchedSpotIndicator: (LineChartBarData barData,
                                List<int> spotIndexes) {
                              return spotIndexes.map((index) {
                                return TouchedSpotIndicatorData(
                                  FlLine(
                                    color: Colors.transparent,
                                  ),
                                  FlDotData(
                                    show: true,
                                    getDotPainter:
                                        (spot, percent, barData, index) =>
                                            FlDotCirclePainter(
                                      radius: 3,
                                      color: Colors.white,
                                      strokeWidth: 1,
                                      strokeColor:Colors.white,
                                    ),
                                  ),
                                );
                              }).toList();
                            },
                            touchTooltipData: LineTouchTooltipData(
                              tooltipBgColor: Colors.white,
                              tooltipRoundedRadius: 5,
                              getTooltipItems:
                                  (List<LineBarSpot> lineBarsSpot) {
                                return lineBarsSpot.map((lineBarSpot) {
                                  return LineTooltipItem(
                                    "${lineBarSpot.y.toInt()} hours",
                                    const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                }).toList();
                              },
                            ),
                          ),
                          lineBarsData: lineBarsData1,
                          minY: -0.01,
                          maxY: 10.01,
                          titlesData: FlTitlesData(
                              show: true,
                              leftTitles: AxisTitles(),
                              topTitles: AxisTitles(),
                              bottomTitles: AxisTitles(
                                sideTitles: bottomTitles,
                              ),
                              rightTitles: AxisTitles(
                                sideTitles: rightTitles,
                              )),
                          gridData: FlGridData(
                            show: true,
                            drawHorizontalLine: true,
                            horizontalInterval: 2,
                            drawVerticalLine: false,
                            getDrawingHorizontalLine: (value) {
                              return FlLine(
                                color: Color.fromARGB(255, 0, 74, 173),
                                strokeWidth: 2,
                              );
                            },
                          ),
                          borderData: FlBorderData(
                            show: true,
                            border: Border.all(
                              color: Colors.transparent,
                            ),
                          ),
                        ),
                      )),
                  SizedBox(
                    height: media.width * 0.05,
                  ),
                  Container(
                    width: double.maxFinite,
                    height: media.width * 0.4,
                    decoration: BoxDecoration(
                       gradient: LinearGradient(
  colors: [
    Color.fromARGB(255, 200, 230, 255),
    Color.fromARGB(255, 180, 210, 255),
  ],
),
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Text(
                              "Last Night Sleep",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Text(
                              "8h 20m",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          const Spacer(),
                          Image.asset(
                            "assets/img/SleepGraph.png",
                            width: double.maxFinite,
                          )
                        ]),
                  ),
                  SizedBox(
                    height: media.width * 0.05,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 15),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Daily Sleep Schedule",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          width: 70,
                          height: 25,
                          child: RoundButton(
                            title: "Check",
                            type: RoundButtonType.bgGradient,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const AlarmScreen(),
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: media.width * 0.05,
                  ),
                  Text(
                    "Today Schedule",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: media.width * 0.03,
                  ),
                  ListView.builder(
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: todaySleepArr.length,
                      itemBuilder: (context, index) {
                        var sObj = todaySleepArr[index] as Map? ?? {};
                        return TodaySleepScheduleRow(
                          sObj: sObj,
                        );
                      }),
                ],
              ),
            ),
            SizedBox(
              height: media.width * 0.05,
            ),
          ],
        ),
      ),
    );
  }

  List<LineChartBarData> get lineBarsData1 => [
        lineChartBarData1_1,
      ];

  LineChartBarData get lineChartBarData1_1 => LineChartBarData(
        isCurved: true,
        gradient: LinearGradient(colors: [
                Color.fromARGB(255, 200, 230, 255),
    Color.fromARGB(255, 180, 210, 255),
        ]),
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(
          show: true,
          gradient: LinearGradient(colors: [
             Color.fromARGB(255, 200, 230, 255),
    Color.fromARGB(255, 180, 210, 255),
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        spots: const [
          FlSpot(1, 3),
          FlSpot(2, 5),
          FlSpot(3, 4),
          FlSpot(4, 7),
          FlSpot(5, 4),
          FlSpot(6, 8),
          FlSpot(7, 5),
        ],
      );

  SideTitles get rightTitles => SideTitles(
        getTitlesWidget: rightTitleWidgets,
        showTitles: true,
        interval: 2,
        reservedSize: 40,
      );

  Widget rightTitleWidgets(double value, TitleMeta meta) {
    String text;
    switch (value.toInt()) {
      case 0:
        text = '0h';
        break;
      case 2:
        text = '2h';
        break;
      case 4:
        text = '4h';
        break;
      case 6:
        text = '6h';
        break;
      case 8:
        text = '8h';
        break;
      case 10:
        text = '10h';
        break;
      default:
        return Container();
    }

    return Text(text,
        style: TextStyle(
          color: Colors.grey,
          fontSize: 12,
        ),
        textAlign: TextAlign.center);
  }

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 32,
        interval: 1,
        getTitlesWidget: bottomTitleWidgets,
      );

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    var style = TextStyle(
      color: Colors.grey,
      fontSize: 12,
    );
    Widget text;
    switch (value.toInt()) {
      case 1:
        text = Text('Sun', style: style);
        break;
      case 2:
        text = Text('Mon', style: style);
        break;
      case 3:
        text = Text('Tue', style: style);
        break;
      case 4:
        text = Text('Wed', style: style);
        break;
      case 5:
        text = Text('Thu', style: style);
        break;
      case 6:
        text = Text('Fri', style: style);
        break;
      case 7:
        text = Text('Sat', style: style);
        break;
      default:
        text = const Text('');
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: text,
>>>>>>> 14db60dfe48377b3d80628dc1b225398df4e8cd3
    );
  }
}
