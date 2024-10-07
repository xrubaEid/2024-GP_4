import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/statistic_controller.dart';
import '../../widget/info_card.dart';

class StatisticScreen extends StatefulWidget {
  const StatisticScreen({super.key});

  @override
  State<StatisticScreen> createState() => _StatisticScreenState();
}

class _StatisticScreenState extends State<StatisticScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF004AAD),
        title: const Text(
          "Statistics",
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: GetBuilder<StatisticController>(
        init: StatisticController(beneficiaryId: 'beneficiaryId'),
        builder: (controller) {
          print('Sleep Hours: ${controller.sleepHoursDurationLastDay.value}');
          // تأكد من توفر البيانات قبل بناء واجهة المستخدم
          bool hasData = controller.sleepHoursDurationLastDay.value.isNotEmpty;

          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF004AAD), Color(0xFF040E3B)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 5),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Statistics For Beneficiary Sleepwell Days',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                controller.sleepCycleDataLastDay.isNotEmpty
                    ? Column(children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                // إضافة الحدث عند الضغط على الزر
                                print("Set Alarm button pressed");
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                backgroundColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              icon: const Icon(
                                Icons.alarm,
                                size: 16,
                                color: Colors.white,
                              ),
                              label: const Text(
                                'Set new alarm for your follower',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: InfoCard(
                                title: 'Num of Sleep Hours:',
                                value:
                                    controller.sleepHoursDurationLastDay.value,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: InfoCard(
                                title: 'Actual Sleep Time:',
                                value: controller.sleepTimeActualLastDay.value,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Expanded(
                              child: InfoCard(
                                title: "Num Of Sleep Cycles:",
                                value: controller.sleepCyclesLastDay.value,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: InfoCard(
                                title: "Wake up Time:",
                                value: controller.wakeUpTimeLastDay.value,
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: LineChart(
                            LineChartData(
                              titlesData: FlTitlesData(
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 100,
                                    getTitlesWidget: (value, meta) {
                                      switch (value.toInt()) {
                                        case 0:
                                          return const Text(
                                            'Awake',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white,
                                            ),
                                          );
                                        case 1:
                                          return const Text(
                                            'Light Sleep',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white,
                                            ),
                                          );
                                        case 2:
                                          return const Text(
                                            'Deep Sleep',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white,
                                            ),
                                          );
                                        default:
                                          return const Text('');
                                      }
                                    },
                                    interval: 1,
                                  ),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 40,
                                    getTitlesWidget: (value, meta) {
                                      // عرض الساعات أسفل المحور الأفقي
                                      return Text(
                                        'h${value.toInt() + 1}',
                                        style: const TextStyle(
                                            fontSize: 14, color: Colors.white),
                                      );
                                    },
                                    interval: 1,
                                  ),
                                ),
                                rightTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                topTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                              ),
                              gridData: FlGridData(
                                show: true,
                                drawVerticalLine: true,
                                drawHorizontalLine: true,
                                horizontalInterval: 1,
                                verticalInterval: 1,
                                checkToShowHorizontalLine: (value) {
                                  return value == 0 || value == 1 || value == 2;
                                },
                                getDrawingHorizontalLine: (value) {
                                  return const FlLine(
                                    color: Colors.white,
                                    strokeWidth: 0.5,
                                  );
                                },
                                getDrawingVerticalLine: (value) {
                                  return const FlLine(
                                    color: Colors.white,
                                    strokeWidth: 0.5,
                                  );
                                },
                              ),
                              borderData: FlBorderData(
                                show: true,
                                border: Border.all(
                                  color: const Color.fromRGBO(13, 238, 219, 1),
                                  width: 1,
                                ),
                              ),
                              lineBarsData: [
                                LineChartBarData(
                                  isCurved: false,
                                  spots: [
                                    const FlSpot(0, 1),
                                    const FlSpot(1, 2),
                                    const FlSpot(2, 1),
                                    const FlSpot(3, 2),
                                    const FlSpot(4, 0),
                                  ],
                                  color: Colors.blue,
                                  barWidth: 3,
                                  belowBarData: BarAreaData(show: false),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ])
                    : Expanded(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment
                                .center, // Center the content vertically
                            crossAxisAlignment: CrossAxisAlignment
                                .center, // Center the content horizontally
                            children: [
                              const Text(
                                'Not Found Data OR No data available ',
                                style: TextStyle(color: Colors.white),
                              ),
                              const Divider(
                                color: Color.fromRGBO(5, 203, 22, 1),
                              ),
                              const Text(
                                'Set new alarm for your follower ',
                                style: TextStyle(color: Colors.white),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  // إضافة الحدث عند الضغط على الزر
                                  print("Set Alarm button pressed");
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  backgroundColor: const Color(0xFF21E9F3),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Icon(Icons.alarm),
                              ),
                            ],
                          ),
                        ),
                      ),
              ],
            ),
          );
        },
      ),
    );
  }
}
