import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MoreAboutYou extends StatefulWidget {
// Assuming you know the document ID to fetch
  static String RouteScreen = 'moreAboutYou';
  @override
  _MoreAboutYouState createState() => _MoreAboutYouState();
}

class _MoreAboutYouState extends State<MoreAboutYou> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<String> answers = List.filled(10, ''); // Assuming 10 questions
  bool _isLoading = true; // Track loading state
 late User userId; // Updated to use the Firebase User class

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

 Future<void> _getCurrentUser() async {
    setState(() {
        _isLoading = true; // Set it true here
    });

    try {
        FirebaseAuth auth = FirebaseAuth.instance;
        User? user = auth.currentUser;

        if (user != null) {
            userId = user;
            await fetchSavedAnswers(); // Consider awaiting fetch operation
        }
    } catch (e) {
        print('Error retrieving user: $e');
    } finally {
        setState(() {
            _isLoading = false; // Set it false once everything is done
        });
    }
}
  List<String> questions = [
    'Q1: How consistent is your sleep schedule?',
    'Q2: Do you have a regular bedtime routine?',
    'Q3:How often do you wake up tired in the morning?',
    'Q4:How much sleep do you usually get at night?',
    'Q5:How long does it take to fall asleep after you get into bed?',
    'Q6: Do you use your smartphone within 30 minutes before bedtime?',
    'Q7:Do you consume caffeine close to bedtime?',
    'Q8:When do you typically stop consuming coffee, tea, smoking, and other substances before bedtime?',
    'Q9:What activities do you typically engage in during the two hours leading up to your bedtime?',
    'Q10:Do you frequently consume food or snacks during the night?',
  ];

  List<List<String>> options = [
    ['Very consistent', 'Somewhat consistent', 'Inconsistent'],
    ['Yes', 'Occasionally', 'No'],
    ['Always', 'Usually', 'Sometimes', 'Rarely'], //q3
    ['6 hours or less', '6-8 hours', '8-10hours', '10 hours or more'], //q4
    [
      'everal minutes',
      '10-15 minutes',
      '20-40 minutes',
      'Hard to fall asleep'
    ], //q5
    ['Yes', 'Occasionally', 'No'],
    ['Yes', 'Occasionally', 'No'],
    [
      'I stop consuming at least 1-2 hours before bedtime',
      'I stop consuming at least 3-4 hours before bedtime',
      'I do not consume these substances at all',
      'I use these substances right before bedtime'
    ],
    [
      'Engage in relaxation techniques',
      'Engage in physical activity or exercise',
      ' Engage in activities that may increase stress ',
      'Other'
    ],
    ['Yes', 'Occasionally', 'No'],
  ];


 fetchSavedAnswers() async {
    setState(() {
        _isLoading = true;
    });

    try {
        DocumentSnapshot snapshot = await _firestore.collection('User behavior').doc(userId.uid).get();
        if (snapshot.exists) {
            Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
            setState(() {
                // Populate answers based on individual fields
                answers = [
                    data['answerQ1'] ?? '',
                    data['answerQ2'] ?? '',
                    data['answerQ3'] ?? '',
                    data['answerQ4'] ?? '',
                    data['answerQ5'] ?? '',
                    data['answerQ6'] ?? '',
                    data['answerQ7'] ?? '',
                    data['answerQ8'] ?? '',
                    data['answerQ9'] ?? '',
                    data['answerQ10'] ?? '',
                ];
                _isLoading = false; // Set loading to false after fetching data
            });
        }
    } catch (e) {
        print("Error fetching data: $e");
        setState(() {
            _isLoading = false;
        });
    }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF004AAD),
        title: const Text('More About You',
         style: TextStyle(  color: Colors.white,  ),),
      ),
      body: Container(
         decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF004AAD), Color(0xFF040E3B)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: _isLoading
              ? const Center(child: CircularProgressIndicator()) // Show loading indicator while fetching data
              : ListView.builder(
                  itemCount: questions.length,
                  itemBuilder: (context, index) {
                    return Card(
  shape: RoundedRectangleBorder(
    side: const BorderSide(color: Colors.black),
    borderRadius: BorderRadius.circular(8.0),
  ),
  child: Container(
    color: const Color(0xFF004AAD), // Set the desired background color
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            questions[index],
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          DropdownButton<String>(
            value: answers[index].isEmpty ? null : answers[index],
            isExpanded: true,
            hint: const Text(
              'Select an answer',
              style: TextStyle(color: Colors.white),
            ),
            items: options[index].map<DropdownMenuItem<String>>(
              (String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              },
            ).toList(),
            onChanged: (String? newValue) {
              setState(() {
                answers[index] = newValue!;
              });
            },
          ),
        ],
      ),
    ),
  ),
);
                  },
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: saveAnswers,
        child: const Icon(Icons.save),
        tooltip: 'Save Answers',
      ),
    );
  }
  void saveAnswers() async {
  try {
    await _firestore.collection('User behavior').doc(userId.uid).update({
      'answerQ1': answers[0],
      'answerQ2': answers[1],
      'answerQ3': answers[2],
      'answerQ4': answers[3],
      'answerQ5': answers[4],
      'answerQ6': answers[5],
      'answerQ7': answers[6],
      'answerQ8': answers[7],
      'answerQ9': answers[8],
      'answerQ10': answers[9],
      'timestamp': FieldValue.serverTimestamp(),
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Answers saved!'),
    ));
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Error saving answers: $e'),
    ));
  }
}
}