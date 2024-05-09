import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:get/get.dart';
import 'package:sleepwell/main.dart';

class CounterWidget extends StatelessWidget {
   const CounterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    double newValue = (prefs.getInt('snooze')?? 1).toDouble();
    return Padding(
      padding: const EdgeInsets.only(top: 30, bottom: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Snooze duration in minutes"),
          Container(
            alignment: AlignmentDirectional.center,
            margin: const EdgeInsets.all(10),
            child: SpinBox(
              min: 1,
              max: 15,
              value: newValue,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              onChanged: (value) {
                print("--- Value is $value");
                newValue = value;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Get.back(),
                    child: const Text("Cancel"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      prefs.setInt("snooze", newValue.toInt());
                      print("--- success save snooze value $newValue");
                      Get.back();
                    },
                    child: const Text("Save"),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}