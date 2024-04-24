//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
    'How would you rate the overall quality of your sleep?',
    'Which of the following factors most commonly disrupt your sleep?',
    'How frequently do you engage in physical exercise or activity during the day?',
    'Did you consume caffeine or other stimulants within a few hours before bedtime?',
    //'Did the sleep enhancement application improve the quality of your sleep?',
    //'How user-friendly did you find the interface of the sleep enhancement application?',
    //'Would you recommend the sleep enhancement application to a friend or family member?',
    //'How satisfied are you with the variety of sleep enhancement features offered by the application?',
    //'Did you experience any technical issues or glitches while using the sleep enhancement application?',
    //'How likely are you to continue using the sleep enhancement application in the future?',
  ];

  List<List<String>> options = [
    ['Excellent', 'Good', 'Average', 'Poor'], //  Q1
    [
      'Noise',
      'Temperature',
      'Stress or anxiety',
      'Physical discomfort',
      'None of the above'
    ], //Q2
    ['Daily', 'Several times a week', 'Occasionally', 'Rarely or never'], //Q3
    ['Yes', 'No'], //Q4
    //['I usually stop consuming coffee, tea, and smoking at least three hours before bedtime.', 'About 2 hours before bedtime, I avoid coffee, tea, and smoking to ensure better sleep.', 'I try to cut off coffee, tea, and smoking at least 4 hours before my bedtime.', 'Other'],
    // ['Reading a book or listening to calming music.', 'Meditation or deep breathing', ' stretching or yoga',' play a sport or engage in a physical activity ', 'Other'],
    //['Option 1', 'Option 2', 'Option 3', 'Other'],
    // ['Option 1', 'Option 2', 'Option 3', 'Other'],
  ];

  List<String> answers = List.filled(4, ''); // Initialize with empty strings
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
      appBar: AppBar(
        backgroundColor: myColor,
        title: const Text('Sleep Feedback'),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
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
              SizedBox(height: 20),
              Text(
                questions[_currentQuestionIndex],
                style: TextStyle(
                  fontSize: 25,
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
