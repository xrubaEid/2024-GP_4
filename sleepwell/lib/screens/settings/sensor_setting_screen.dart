import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sleepwell/controllers/sensor_settings_controller.dart';
import 'package:sleepwell/models/user_sensor.dart';

import '../../widget/show_sensor_widget.dart';
 

class SensorSettingScreen extends StatelessWidget {
  final SensorSettingsController _controller =
      Get.put(SensorSettingsController());

  SensorSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    _controller.loadCachedSensors();
    _controller.loadSensors();
    _controller.getAllSensors();
    _controller.getSensorById(_controller.selectedSensor.value);
    print(_controller.selectedSensor.value);
    print('-----------------------------------------------');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sensor Setting'),
      ),
      body: Obx(() {
        if (_controller.loading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _controller.sensorsCurrentUser.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                        'Sensor ID: ${_controller.sensorsCurrentUser[index]}'),
                    onTap: () {
                      _controller
                          .selectSensor(_controller.sensorsCurrentUser[index]);
                    },
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                showSensorSelectionDialog(
                  context: context,
                  userSensors: _controller.sensorsCurrentUser
                      .map((sensorId) => UserSensor(
                            sensorId: sensorId,
                            userId: _controller.userId ?? '', // userId
                            enable: true, // assuming default enabled
                          ))
                      .toList(),
                  selectedSensorId: _controller.selectedSensor.value,
                  onSensorSelected: (sensorId) {
                    _controller.selectSensor(sensorId);
                  },
                  onDeleteSensor: (sensorId) {
                    _controller.deleteSensor(sensorId);
                  },
                );
              },
              child: const Text('Select Sensor'),
            ),
            ElevatedButton(
              onPressed: () {
                _controller
                    .showAddSensorDialog(context); // يتم استدعاء النافذة من هنا
              },
              child: const Text('Add Another Sensor'),
            ),
          ],
        );
      }),
    );
  }
}
