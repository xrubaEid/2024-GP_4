//import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sleepwell/screens/profile_screen.dart';

class FeedbackPage extends StatefulWidget {
  static String RouteScreen = 'feedback';

  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  int _currentQuestionIndex = 0;
  bool _canProceed = false;

  List<String> questions = [
    'How would you rate the overall quality of your sleep last night?', //q1
    'Did you experience high levels of stress or anxiety before bedtime?', //q2
     'Did you use nicotine products close to bedtime?'//q3
    'Did you use electronic devices before bedtime?', //q4
    'Is your bedroom?', //q5
    'Is the temperature in your bedroom?', //q6
    'Did you consume any caffeinated beverages within 2 hours before bedtime?'//q7
    'Did you consume food within 2 hours before bedtime?'//q8
  ];

  List<List<String>> options = [
    ['Excellent', 'Good', 'Average', 'Poor'], //  Q1
    [ 'Yes', 'No', ], //Q2
    ['Yes', 'No', ], //Q3
    ['Yes', 'Occasionally', 'No', ], //Q4
    ['quiet', 'moderately noisy', 'noisy'], //Q5
    ['cool', 'moderately warm', 'warm'], //Q6
    ['Yes', 'No', ], //Q7
    ['Yes', 'No', ], //Q8
   
  ];

  List<String> answers = List.filled(8, ''); // Initialize with empty strings
  bool showError = false;

  void _saveAnswer(String answer) {
    setState(() {
      if (answer == 'Other') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            TextEditingController otherAnswerController =
                TextEditingController();

            return AlertDialog(
              title: Text('Enter Your Answer'),
              content: TextField(
                controller: otherAnswerController,
              ),
              actions: [
                ElevatedButton(
                  child: Text('Save'),
                  onPressed: () {
                    String otherAnswer = otherAnswerController.text;
                    answers[_currentQuestionIndex] = otherAnswer;
                    otherAnswerController.clear();
                    Navigator.pop(context);
                    showError = false; // Reset error state
                  },
                ),
                if (options[_currentQuestionIndex].contains('Other'))
                  ElevatedButton(
                    child: Text('Cancel'),
                    onPressed: () {
                      setState(() {
                        answers[_currentQuestionIndex] = '';
                        showError = false; // Reset error state
                      });
                      Navigator.pop(context);
                    },
                  ),
              ],
            );
          },
        );
      } else {
        answers[_currentQuestionIndex] = answer;
        showError = false; // Reset error state
      }
    });
  }

  void _nextQuestion() {
    setState(() {
      if (answers[_currentQuestionIndex].isEmpty) {
        showError = true; // Show error message if no answer is selected
      } else if (_currentQuestionIndex < questions.length - 1) {
        _currentQuestionIndex++;
      } else {
        _canProceed = true;
      }
    });
  }

  void _previousQuestion() {
    setState(() {
      if (_currentQuestionIndex > 0) {
        _currentQuestionIndex--;
      }
    });
  }

  void _submitFeedback() {
    _firestore.collection('feedback').add({
      'answers': answers,
    });
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Feedback Submitted'),
          content: Text('Thank you for your feedback!'),
          actions: [
            ElevatedButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.pop(
                    context,
                    MaterialPageRoute(builder: (context) => ProfileScreen()),
                  );
                }),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Color myColor = const Color.fromARGB(255, 0, 74, 173);
    return Scaffold(
      /*appBar: AppBar(
        backgroundColor: myColor,
        title: const Text('Sleep Feedback'),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),*/
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF004AAD), Color(0xFF040E3B)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        //color: Colors.grey[300],
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 70),
              const Text(
                'Sleep Feedback',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              Text(
                questions[_currentQuestionIndex],
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Column(
                children: options[_currentQuestionIndex].map((option) {
                  return RadioListTile<String>(
                    title: DefaultTextStyle(
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      child: Text(option),
                    ),
                    value: option,
                    groupValue: answers[_currentQuestionIndex] == option
                        ? option
                        : null,
                    onChanged: (dynamic value) {
                      _saveAnswer(value as String);
                    },
                  );
                }).toList(),
              ),
              if (showError)
                Text(
                  'Please select an answer.',
                  style: TextStyle(color: Colors.red),
                ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    child: Text('Back'),
                    onPressed: _previousQuestion,
                  ),
                  ElevatedButton(
                    child: Text('Next'),
                    onPressed: answers[_currentQuestionIndex].isEmpty
                        ? null
                        : _nextQuestion,
                  ),
                  if (showError &&
                      options[_currentQuestionIndex].contains('Other'))
                    ElevatedButton(
                      child: Text('Cancel'),
                      onPressed: () {
                        setState(() {
                          answers[_currentQuestionIndex] = '';
                          showError = false; // Reset error state
                        });
                      },
                    ),
                  if (_canProceed)
                    ElevatedButton(
                      child: Text('Submit Feedback'),
                      onPressed: _submitFeedback,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
