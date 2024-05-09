// import 'package:flutter/material.dart';
//
// class AlarmRunScreen extends StatelessWidget {
//   // final bool
//   //     isMathProblem; // Indicates if stopping the alarm requires a math problem
//   // final String alarmTitle; // Title of the alarm
//   // final String mathProblem; // The math problem to solve
//
//   // AlarmRunScreen(
//   //   bool bool, {
//   //   required this.isMathProblem,
//   //   required this.alarmTitle,
//   //   required this.mathProblem,
//   // });
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Alarm'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               // alarmTitle,
//               'alarmTitle',
//               style: TextStyle(fontSize: 24),
//             ),
//             const SizedBox(height: 20),
//             // if (isMathProblem)
//             Column(
//               children: [
//                 const Text(
//                   // 'Math Problem: $mathProblem',
//                   'Math Problem: mathProblem',
//                   style: TextStyle(fontSize: 20),
//                 ),
//                 TextFormField(
//                   keyboardType: TextInputType.number,
//                   decoration: const InputDecoration(
//                     labelText: 'Enter Answer',
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//               ],
//             ),
//             const SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Column(
//                   children: [
//                     FilledButton(
//                       onPressed: () {
//                         // Check if answer is correct for math problem or just stop the alarm
//                         // You can implement this logic according to your requirements
//                       },
//                       child: const Text('Stop Alarm'),
//                     ),
//                   ],
//                 ),
//                 Column(
//                   children: [
//                     FilledButton(
//                       onPressed: () {
//                         // Implement snooze functionality
//                       },
//                       child: const Text('Snooze'),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//
//             const SizedBox(height: 10),
//           ],
//         ),
//       ),
//     );
//   }
// }