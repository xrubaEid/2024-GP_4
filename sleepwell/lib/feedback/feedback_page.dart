import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'questions.dart';

class FeedbackPage extends StatefulWidget {
  static String RouteScreen = 'feedback';

  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  int _currentQuestionIndex = 0;
  Function(int, String)? updateGroupValueCallback;
  bool _canProceed = false;

  @override
  void initState() {
    super.initState();
    updateGroupValueCallback = _updateGroupValue;
    Questions.groupValues = List.filled(Questions.questions.length, '');
  }

  void _updateGroupValue(int index, String value) {
    setState(() {
      Questions.answers[index] = value;
      Questions.groupValues[index] = value;
      _canProceed = value != '';
    });
  }

  void _submitFeedback() {
    _firestore.collection('feedback').add({
      'answers': Questions.answersMap,
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
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _nextQuestion() {
    setState(() {
      if (_currentQuestionIndex < Questions.questions.length - 1) {
        _currentQuestionIndex++;
        updateGroupValueCallback?.call(
            _currentQuestionIndex, Questions.answers[_currentQuestionIndex]);
      }
    });
  }

  void _previousQuestion() {
    setState(() {
      if (_currentQuestionIndex > 0) {
        _currentQuestionIndex--;
        updateGroupValueCallback?.call(
            _currentQuestionIndex, Questions.answers[_currentQuestionIndex]);
      }
    });
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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              Questions.questions[_currentQuestionIndex],
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 8.0),
            // Display the answer options for each question
            ...Questions.answersOptions[_currentQuestionIndex],
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  child: Text('Previous'),
                  onPressed: _previousQuestion,
                ),
                ElevatedButton(
                  child: Text('Next'),
                  onPressed: _canProceed ? _nextQuestion : null,
                ),
              ],
            ),
            ElevatedButton(
              child: Text('Submit Feedback'),
              onPressed: _currentQuestionIndex == Questions.questions.length - 1
                  ? _submitFeedback
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
