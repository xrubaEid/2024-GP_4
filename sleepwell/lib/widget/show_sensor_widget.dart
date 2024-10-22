import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sleepwell/models/user_sensor.dart';

class ReusableSensorDialog extends StatefulWidget {
  final List<UserSensor> userSensors;
  final String? selectedSensorId;
  final Function(String) onSensorSelected;
  final Function(String) onDeleteSensor;

  const ReusableSensorDialog({
    Key? key,
    required this.userSensors,
    required this.selectedSensorId,
    required this.onSensorSelected,
    required this.onDeleteSensor,
  }) : super(key: key);

  @override
  _ReusableSensorDialogState createState() => _ReusableSensorDialogState();
}

class _ReusableSensorDialogState extends State<ReusableSensorDialog> {
  String? _selectedSensorId;
  bool selectedForYou = true;

// دالة لتخزين الحساس في SharedPreferences
  Future<void> _storeSelectedSensorId(String sensorId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedSensorId', sensorId);
  }

// دالة لاسترجاع الحساس المختار من SharedPreferences
  Future<void> _getSelectedSensorId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedSensorId = prefs.getString('selectedSensorId');
    });
  }

// دالة لتحديد الحساس المختار
  void _sensorSelected(String sensorId) {
    setState(() {
      _selectedSensorId = sensorId;
    });
    widget.onSensorSelected(sensorId);
    print('Selected Sensor: $sensorId');

    // تخزين الحساس في SharedPreferences
    _storeSelectedSensorId(sensorId);
  }

  @override
  void initState() {
    super.initState();
    _selectedSensorId = widget.selectedSensorId;
    _getSelectedSensorId(); // استرجاع الحساس المخزن عند بدء الـ dialog
  }

  // دالة لحذف الحساس من قاعدة البيانات
  void _deleteSensorFromDatabase(String sensorId) {
    print('Sensor deleted: $sensorId');
    setState(() {
      widget.onDeleteSensor(
          sensorId); // استدعاء الدالة التي تم تمريرها لحذف الحساس
    });
  }

  // دالة لتحديد الحساس المختار

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      maxChildSize: 0.7,
      initialChildSize: 0.5,
      minChildSize: 0.3,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    selectedForYou
                        ? ' Available Devices Select Device\n For  YourSelf'
                        : 'Choose Available Devices For\n beneficiaryName ',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: widget.userSensors.length,
                  itemBuilder: (context, index) {
                    final userSensor = widget.userSensors[index];
                    return ListTile(
                      title: Text("Sensor ${userSensor.sensorId}"),
                      leading: _selectedSensorId == userSensor.sensorId
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : const Icon(Icons.radio_button_unchecked),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _deleteSensorFromDatabase(userSensor.sensorId!);
                        },
                      ),
                      onTap: () {
                        _sensorSelected(userSensor.sensorId!);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// دالة لإظهار الـ Dialog
void showSensorSelectionDialog({
  required BuildContext context,
  required List<UserSensor> userSensors,
  required String? selectedSensorId,
  required Function(String) onSensorSelected,
  required Function(String) onDeleteSensor,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return ReusableSensorDialog(
        userSensors: userSensors,
        selectedSensorId: selectedSensorId,
        onSensorSelected: onSensorSelected,
        onDeleteSensor: onDeleteSensor,
      );
    },
  );
}
