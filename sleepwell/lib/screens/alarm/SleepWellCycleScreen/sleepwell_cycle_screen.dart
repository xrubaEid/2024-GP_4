import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

import '../../../controllers/beneficiary_controller.dart';
import '../../../controllers/sensor_settings_controller.dart';
import '../../../controllers/alarm_setup_controller.dart';
import '../../../widget/clockview.dart';

class SleepWellCycleScreen extends StatelessWidget {
  final SleepCycleController _controller = Get.put(SleepCycleController());
  final SensorSettingsController deviceController =
      Get.put(SensorSettingsController());
  final BeneficiaryController beneficiaryController =
      Get.put(BeneficiaryController());
  String? userId = FirebaseAuth.instance.currentUser?.uid;
  @override
  Widget build(BuildContext context) {
    deviceController
        .listenToSensorChanges(deviceController.selectedSensor.value);

    print(
        '----------------${deviceController.sleepStartTime.toString()}-------------------------------');

    return Scaffold(
      appBar: _buildAppBar(),
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.only(left: 30, bottom: 30, right: 30),
        decoration: _buildGradientBackground(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildHeader(),
            const Divider(color: Color.fromRGBO(255, 7, 247, 1)),
            SizedBox(height: MediaQuery.of(context).padding.top),
            _buildDateTimeRow(),
            const SizedBox(height: 40),
            _buildTimeSelectors(context),
            const SizedBox(height: 10),
            _buildSaveButton(context),
            const SizedBox(height: 20),
            _buildSelectDeviceButton(context),
            Obx(
              () => deviceController.isCheckingReadings.value
                  ? const CircularProgressIndicator() // عرض مؤشر تحميل أثناء التحقق من القراءات
                  : Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text(
                        'Finished checking sensor\n readings:${deviceController.sleepStartTime.toString()}',
                        style:
                            const TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text(
        'SleepWell Cycle',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.w700,
        ),
      ),
      iconTheme: const IconThemeData(color: Colors.white),
      backgroundColor: const Color(0xFF004AAD),
    );
  }

  BoxDecoration _buildGradientBackground() {
    return const BoxDecoration(
      gradient: LinearGradient(
        colors: [Color(0xFF004AAD), Color(0xFF040E3B)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    );
  }

  Widget _buildHeader() {
    return Obx(() {
      if (beneficiaryController.isLoading.value) {
        return const CircularProgressIndicator();
      }

      if (beneficiaryController.beneficiaries.isEmpty) {
        return const Text("No beneficiaries found.");
      }

      // قائمة العناصر مع إضافة "Yourself" كأول عنصر
      List<DropdownMenuItem<String>> dropdownItems = [
        const DropdownMenuItem<String>(
          value: 'yourself', // قيمة مخصصة للخيار الأول
          child: Text('Yourself'),
        ),
        ...beneficiaryController.beneficiaries.map((beneficiary) {
          return DropdownMenuItem<String>(
            value: beneficiary.id,
            child: Text(
              beneficiary.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          );
        }).toList(),
      ];

      return Row(
        mainAxisAlignment:
            MainAxisAlignment.center, // محاذاة المحتويات في المنتصف
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start, // محاذاة النص لليسار
            children: [
              Text(
                'Select Alarm For',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(width: 10), // إضافة مسافة بين النص والقائمة
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButton<String>(
                value:
                    beneficiaryController.selectedBeneficiaryId.value.isNotEmpty
                        ? beneficiaryController.selectedBeneficiaryId.value
                        : null,
                hint: const Text(
                  'Select a beneficiary',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(6, 248, 26, 1),
                  ),
                ),
                items: dropdownItems,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    beneficiaryController.setBeneficiaryId(newValue);
                  }
                },
              ),
            ],
          ),
        ],
      );
    });
  }

  Widget _buildDateTimeRow() {
    var formattedDate = DateFormat('EEE, d MMM').format(DateTime.now());
    var formattedTime = DateFormat('hh:mm').format(DateTime.now());

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                formattedTime,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                ),
              ),
              Text(
                formattedDate,
                style: const TextStyle(
                  color: Colors.white,
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
    );
  }

  Widget _buildTimeSelectors(BuildContext context) {
    return Column(
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
          onTap: () => _showTimePicker(context, true),
          child: Obx(() => Text(
                // 'Select BedTime:${DateFormat('hh:mm a').format(_controller.bedtime.value)}',
                DateFormat('hh:mm a').format(_controller.bedtime.value),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              )),
        ),
        const Divider(color: Color.fromRGBO(7, 255, 181, 1)),
        const SizedBox(height: 20),
        const Text(
          "WAKE UP TIME",
          style: TextStyle(
            color: Color(0xffff0863),
            fontSize: 15,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.3,
          ),
        ),
        GestureDetector(
          onTap: () => _showTimePicker(context, false),
          child: Obx(() => Text(
                // 'Select Wake Up Time:${DateFormat('hh:mm a').format(_controller.wakeUpTime.value)}',
                DateFormat('hh:mm a').format(_controller.wakeUpTime.value),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              )),
        ),
        const Divider(color: Color.fromRGBO(7, 255, 181, 1)),
      ],
    );
  }

  void _showTimePicker(BuildContext context, bool isBedtime) {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(
          isBedtime ? _controller.bedtime.value : _controller.wakeUpTime.value),
    ).then((selectedTime) {
      if (selectedTime != null) {
        final now = DateTime.now();
        final selectedDateTime = DateTime(now.year, now.month, now.day,
            selectedTime.hour, selectedTime.minute);
        if (isBedtime) {
          _controller.setBedtime(selectedDateTime);
        } else {
          _controller.setWakeUpTime(selectedDateTime);
        }
      }
    });
  }

  int timeDifferenceInMinutes(DateTime start, DateTime end) {
    final startTime = start.hour * 60 + start.minute;
    final endTime = end.hour * 60 + end.minute;
    return (endTime - startTime).abs();
  }

  void _checkAndSaveTimes(BuildContext context) {
    if (timeDifferenceInMinutes(
            _controller.bedtime.value, _controller.wakeUpTime.value) <
        120) {
      // Show warning dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              "Warning",
              style: TextStyle(color: Colors.red),
            ),
            content: const Text(
                "please select the wake up time with at least 2 hours deffrence"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  // Navigator.of(context).pop(); // Close the dialog
                  Get.back();
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    } else {
      // print('-----------------------------------------------');
      // deviceController.getSensorById(deviceController.selectedSensor.value);
      // print(deviceController.selectedSensor.value);
      // print('-----------------------------------------------');

      List<Map<String, int>> myHourList = [];

      _controller.saveTimes(myHourList, userId!);
      //  _controller          .saveTimes();
    }
  }

  Widget _buildSaveButton(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: TextButton(
        onPressed: () => _checkAndSaveTimes(context),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.pink),
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        ),
        child: const Text('Save'),
      ),
    );
  }

  Widget _buildSelectDeviceButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => {
        deviceController.checkUserSensors(context),
        deviceController.getSensorById(deviceController.selectedSensor.value),
        print(deviceController.selectedSensor.value),
        print('-----------------------------------------------'),
      },
      child: const Text('Select Device'),
    );
  }
}
