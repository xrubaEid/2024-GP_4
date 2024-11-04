import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../controllers/alarm/cycles_calculation_testing_controller.dart';

class CyclesCalculationTesting extends StatelessWidget {
  final CyclesCalculationTestingController controller =
      Get.put(CyclesCalculationTestingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF004AAD),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Cycles Calculation Testing',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF004AAD), Color(0xFF040E3B)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTimeSelectors(context),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  alignment: Alignment.center,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 100, vertical: 10),
                  backgroundColor: const Color.fromRGBO(11, 157, 247, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: const BorderSide(color: Color(0xFF004AAD)),
                  ),
                ),
                onPressed: () {
                  controller.calculateSleepCycles();
                },
                child: const Text(
                  'Calculate',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const Divider(color: Color.fromRGBO(9, 238, 13, 1)),
              const SizedBox(height: 20),
              _buildCalculationResults(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeSelectors(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTimeSelector(
            context, "Bedtime", controller.bedtime, controller.setBedtime),
        const SizedBox(height: 20),
        _buildTimeSelector(context, "Actual Bedtime", controller.actualBedtime,
            controller.setActualBedtime),
        const SizedBox(height: 20),
        _buildTimeSelector(context, "Wake Up Time", controller.wakeUpTime,
            controller.setWakeUpTime),
      ],
    );
  }

  Widget _buildTimeSelector(BuildContext context, String label,
      Rx<DateTime> time, Function(DateTime) setTime) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
              color: Color(0xffff0863),
              fontSize: 15,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.3),
        ),
        GestureDetector(
          onTap: () => _showTimePicker(context, setTime),
          child: Obx(
            () => Text(
              DateFormat('hh:mm a').format(time.value),
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ],
    );
  }

  void _showTimePicker(BuildContext context, Function(DateTime) setTime) {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(DateTime.now()),
    ).then((selectedTime) {
      if (selectedTime != null) {
        final now = DateTime.now();
        final selectedDateTime = DateTime(now.year, now.month, now.day,
            selectedTime.hour, selectedTime.minute);
        setTime(selectedDateTime);
      }
    });
  }

  Widget _buildCalculationResults() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Calculation Results:',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 10),
        Obx(
          () => Text(
            "Number of Sleep Cycles: ${controller.numberOfCycles.value}     Remaining Minutes: ${controller.remainingminutesToCompleteCycle.value}",
            style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        const SizedBox(height: 10),
        Obx(
          () => Text(
            "Number of Sleep Hours: ${controller.sleepHourshours.value}     Sleep Minutes: ${controller.remainingminutesToCompleteHoure.value}",
            style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        const SizedBox(height: 10),
        Obx(
          () => Text(
            "Actual Wake Up Time: ${controller.actualWakeUpTime.value}",
            style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        const SizedBox(height: 10),
        Obx(
          () => Text(
            "The system added 15 min? ${controller.addedFifteenMinutes.value ? 'Yes' : 'No'}",
            style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ],
    );
  }

  int _timeDifferenceInMinutes(DateTime start, DateTime end) {
    return (end.difference(start).inMinutes).abs();
  }

  void _checkAndSaveTimes(BuildContext context) {
    if (_timeDifferenceInMinutes(
            controller.bedtime.value, controller.actualBedtime.value) <
        30) {
      _showWarningDialog(context,
          "Please select a wake-up time with at least 30 hours difference.");
    } else if (_timeDifferenceInMinutes(
            controller.actualBedtime.value, controller.wakeUpTime.value) <
        90) {
      _showWarningDialog(context,
          "Please select a wake-up time with at least 90 hours difference.");
    } else {
      controller.calculateSleepCycles();
    }
  }

  void _showWarningDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Warning", style: TextStyle(color: Colors.red)),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("OK"))
        ],
      ),
    );
  }
}
