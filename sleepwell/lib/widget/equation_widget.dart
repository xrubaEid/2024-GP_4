import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:sleepwell/models/difficult_equation_model.dart';
import 'package:sleepwell/models/easy_equation_model.dart';
import 'package:sleepwell/models/equation_abstrat_model.dart';

class EquationWidget extends StatefulWidget {
  final bool showEasyEquation;
  final int alarmId;
  const EquationWidget({
    super.key,
    required this.alarmId,
    this.showEasyEquation = false,
  });

  @override
  State<EquationWidget> createState() => _EquationWidgetState();
}

class _EquationWidgetState extends State<EquationWidget> {
  @override
  Widget build(BuildContext context) {
    EquationModel equationModel = widget.showEasyEquation
        ? EasyEquationModel()
        : DifficultEquationModel();

    final width = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "To stop the alarm\nSolve the following mathematical equation:",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          // const SizedBox(height: 5),
          // const Text(
          //   "Note: If the answer is wrong, the equation will be changed.",
          //   textAlign: TextAlign.center,
          // ),
          const SizedBox(height: 20),

          // show the equation
          Container(
            width: double.infinity,
            alignment: AlignmentDirectional.center,
            height: 50,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 223, 224, 248),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey),
            ),
            child: Text(
              equationModel.equation,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          const SizedBox(height: 30),

          // options to solve the equation
          Container(
            alignment: AlignmentDirectional.center,
            height: 50,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final widthScreen = width - 30;
                final optionsCount = equationModel.options.length;
                // margin for all option from right and left
                const margin = 10 * 2;
                final allOptionsMargin = optionsCount * margin;

                return Container(
                  width: (widthScreen - allOptionsMargin) / optionsCount,
                  margin: const EdgeInsets.symmetric(horizontal: margin / 2),
                  child: FloatingActionButton(
                    heroTag: equationModel.options[index],
                    // shape: const CircleBorder(),
                    onPressed: () {
                      if (equationModel.options[index] ==
                          equationModel.result) {
                        print(":::::::::::::::::: Success choosen");
                        Alarm.stop(widget.alarmId).then((_) => Navigator.pop(context));
                      } else {
                        print(":::::::::::::::::: Wrong chossen");
                        setState(() {});
                      }
                    },
                    child: Text(equationModel.options[index].toString()),
                  ),
                );
              },
              itemCount: equationModel.options.length,
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
