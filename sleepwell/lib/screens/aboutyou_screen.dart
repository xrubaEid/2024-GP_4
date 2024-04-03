import 'package:flutter/material.dart';

class aboutyou_screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Color myColor = const Color.fromARGB(255, 0, 74, 173);
    return Scaffold(
      backgroundColor: myColor,
      appBar: AppBar(
        backgroundColor: myColor,
        title:const Text('About You'),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: SafeArea(
        child: Container(
           height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF004AAD), Color(0xFF040E3B)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          padding: const EdgeInsets.all(15.0),
          child: Column(
           
            children: [
              Text(
                'User Information',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ]   
          ),
        ),
      ),
    );
  }
}
 