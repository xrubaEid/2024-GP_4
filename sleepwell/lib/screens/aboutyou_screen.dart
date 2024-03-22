import 'package:flutter/material.dart';

class aboutyou_screen extends StatelessWidget {
  const aboutyou_screen({super.key});

  @override
  Widget build(BuildContext context) {
    Color myColor = const Color.fromARGB(255, 0, 74, 173);
    return Scaffold(
      backgroundColor: myColor,
      appBar: AppBar(
        backgroundColor: myColor,
        title: const Text('About You'),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: SafeArea(
        child: Container(
          //color: [Color(0xFF004AAD), Color(0xFF040E3B)],
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF004AAD), Color(0xFF040E3B)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'User Information',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 10),
              const Text(
                'Age: 30',
                style: TextStyle(color: Colors.white),
              ),
              const Text(
                'Gender: Male',
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),
              const Text(
                'Default Bedtime and Wake-up Time',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 10),
              DataTable(
                columns: const [
                  DataColumn(
                      label: Text(
                    'Day',
                    style: TextStyle(color: Colors.white),
                  )),
                  DataColumn(
                      label: Text(
                    'Bedtime',
                    style: TextStyle(color: Colors.white),
                  )),
                  DataColumn(
                      label: Text(
                    'Wake-up Time',
                    style: TextStyle(color: Colors.white),
                  )),
                ],
                rows: const [
                  DataRow(cells: [
                    DataCell(Text(
                      'Monday',
                      style: TextStyle(color: Colors.white),
                    )),
                    DataCell(Text(
                      '10:00',
                      style: TextStyle(color: Colors.white),
                    )),
                    DataCell(Text(
                      '06:00',
                      style: TextStyle(color: Colors.white),
                    )),
                  ]),
                  DataRow(cells: [
                    DataCell(Text(
                      'Tuesday',
                      style: TextStyle(color: Colors.white),
                    )),
                    DataCell(Text(
                      '10:00',
                      style: TextStyle(color: Colors.white),
                    )),
                    DataCell(Text(
                      '06:00',
                      style: TextStyle(color: Colors.white),
                    )),
                  ]),
                  DataRow(cells: [
                    DataCell(Text(
                      'Wednesday',
                      style: TextStyle(color: Colors.white),
                    )),
                    DataCell(Text(
                      '10:00',
                      style: TextStyle(color: Colors.white),
                    )),
                    DataCell(Text(
                      '06:00',
                      style: TextStyle(color: Colors.white),
                    )),
                  ]),
                  DataRow(cells: [
                    DataCell(Text(
                      'Thursday',
                      style: TextStyle(color: Colors.white),
                    )),
                    DataCell(Text(
                      '10:00',
                      style: TextStyle(color: Colors.white),
                    )),
                    DataCell(Text(
                      '06:00',
                      style: TextStyle(color: Colors.white),
                    )),
                  ]),
                  DataRow(cells: [
                    DataCell(Text(
                      'Friday',
                      style: TextStyle(color: Colors.white),
                    )),
                    DataCell(Text(
                      '10:00',
                      style: TextStyle(color: Colors.white),
                    )),
                    DataCell(Text(
                      '06:00',
                      style: TextStyle(color: Colors.white),
                    )),
                  ]),
                  DataRow(cells: [
                    DataCell(Text(
                      'Saturday',
                      style: TextStyle(color: Colors.white),
                    )),
                    DataCell(Text(
                      '10:00',
                      style: TextStyle(color: Colors.white),
                    )),
                    DataCell(Text(
                      '06:00',
                      style: TextStyle(color: Colors.white),
                    )),
                  ]),
                  DataRow(cells: [
                    DataCell(Text(
                      'Sunday',
                      style: TextStyle(color: Colors.white),
                    )),
                    DataCell(Text(
                      '10:00',
                      style: TextStyle(color: Colors.white),
                    )),
                    DataCell(Text(
                      '06:00',
                      style: TextStyle(color: Colors.white),
                    )),
                  ]),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
 /* @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About You'),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About You',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Fill in your personal information:',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Name',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Age',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Gender',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Save the information and navigate back
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
*/