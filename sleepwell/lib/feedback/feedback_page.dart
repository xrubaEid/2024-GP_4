import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sleepwell/screens/profile_screen.dart';
import 'questions.dart';

class FeedbackPage extends StatefulWidget {
  static String RouteScreen = 'feedback';

  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  int _currentQuestionIndex = 0;
  bool _canProceed = false;

  @override
  void initState() {
    super.initState();
    Questions.groupValues = List.filled(Questions.questions.length, '');
    Questions.answersOptions = _createAnswersOptions(updateGroupValue);
  }

  void updateGroupValue(int index, String value) {
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
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => ProfileScreen()),
                  );
                }),
          ],
        );
      },
    );
  }

  void _nextQuestion() {
    setState(() {
      if (_currentQuestionIndex < Questions.questions.length - 1) {
        _currentQuestionIndex++;
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

  List<List<RadioListTile<String>>> _createAnswersOptions(
      Function(int, String) updateGroupValueCallback) {
    List<List<RadioListTile<String>>> answersOptions = [
      [
        // Question 1 answer options
        RadioListTile<String>(
          title: Text('Excellent'),
          value: 'Excellent',
          groupValue: Questions.groupValues[0],
          onChanged: (value) {
            updateGroupValueCallback(_currentQuestionIndex, value!);
          },
        ),
        RadioListTile<String>(
          title: Text('Good'),
          value: 'Good',
          groupValue: Questions.groupValues[0],
          onChanged: (value) {
            updateGroupValueCallback(_currentQuestionIndex, value!);
          },
        ),
        RadioListTile<String>(
          title: Text('Average'),
          value: 'Average',
          groupValue: Questions.groupValues[0],
          onChanged: (value) {
            updateGroupValueCallback(_currentQuestionIndex, value!);
          },
        ),
        RadioListTile<String>(
          title: Text('Poor'),
          value: 'Poor',
          groupValue: Questions.groupValues[0],
          onChanged: (value) {
            updateGroupValueCallback(_currentQuestionIndex, value!);
          },
        ),
      ],
      [
        // Question 2 answer options
        RadioListTile<String>(
          title: Text('Sleep tracking and analysis'),
          value: 'Sleep tracking and analysis',
          groupValue: '',
          onChanged: (value) {
            updateGroupValueCallback(_currentQuestionIndex, value!);
          },
        ),
        RadioListTile<String>(
          title: Text('Relaxation exercises'),
          value: 'Relaxation exercises',
          groupValue: '',
          onChanged: (value) {
            updateGroupValueCallback(_currentQuestionIndex, value!);
          },
        ),
        RadioListTile<String>(
          title: Text('White noise or soothing sounds'),
          value: 'White noise or soothing sounds',
          groupValue: '',
          onChanged: (value) {
            updateGroupValueCallback(_currentQuestionIndex, value!);
          },
        ),
        RadioListTile<String>(
          title: Text('Sleep environment recommendations'),
          value: 'Sleep environment recommendations',
          groupValue: '',
          onChanged: (value) {
            updateGroupValueCallback(_currentQuestionIndex, value!);
          },
        ),
      ],
      [
        // Question 3 answer options
        RadioListTile<String>(
          title: Text('Daily'),
          value: 'Daily',
          groupValue: '',
          onChanged: (value) {
            updateGroupValueCallback(_currentQuestionIndex, value!);
          },
        ),
        RadioListTile<String>(
          title: Text('Several times a week'),
          value: 'Several times a week',
          groupValue: '',
          onChanged: (value) {
            updateGroupValueCallback(_currentQuestionIndex, value!);
          },
        ),
        RadioListTile<String>(
          title: Text('Occasionally'),
          value: 'Occasionally',
          groupValue: '',
          onChanged: (value) {
            updateGroupValueCallback(_currentQuestionIndex, value!);
          },
        ),
        RadioListTile<String>(
          title: Text('Rarely or never'),
          value: 'Rarely or never',
          groupValue: '',
          onChanged: (value) {
            updateGroupValueCallback(_currentQuestionIndex, value!);
          },
        ),
      ],
      [
        // Question 4 answer options
        RadioListTile<String>(
          title: Text('Yes, definitely'),
          value: 'Yes, definitely',
          groupValue: '',
          onChanged: (value) {
            updateGroupValueCallback(_currentQuestionIndex, value!);
          },
        ),
        RadioListTile<String>(
          title: Text('Yes, to some extent'),
          value: 'Yes, to some extent',
          groupValue: '',
          onChanged: (value) {
            updateGroupValueCallback(_currentQuestionIndex, value!);
          },
        ),
        RadioListTile<String>(
          title: Text('Not sure'),
          value: 'Not sure',
          groupValue: '',
          onChanged: (value) {
            updateGroupValueCallback(_currentQuestionIndex, value!);
          },
        ),
        RadioListTile<String>(
          title: Text('No, not at all'),
          value: 'No, not at all',
          groupValue: '',
          onChanged: (value) {
            updateGroupValueCallback(_currentQuestionIndex, value!);
          },
        ),
      ],
      [
        // Question 5 answer options
        RadioListTile<String>(
          title: Text('Yes, significantly'),
          value: 'Yes, significantly',
          groupValue: '',
          onChanged: (value) {
            updateGroupValueCallback(_currentQuestionIndex, value!);
          },
        ),
        RadioListTile<String>(
          title: Text('Yes, to some extent'),
          value: 'Yes, to some extent',
          groupValue: '',
          onChanged: (value) {
            updateGroupValueCallback(_currentQuestionIndex, value!);
          },
        ),
        RadioListTile<String>(
          title: Text('Not sure'),
          value: 'Not sure',
          groupValue: '',
          onChanged: (value) {
            updateGroupValueCallback(_currentQuestionIndex, value!);
          },
        ),
        RadioListTile<String>(
          title: Text('No, not at all'),
          value: 'No, not at all',
          groupValue: '',
          onChanged: (value) {
            updateGroupValueCallback(_currentQuestionIndex, value!);
          },
        ),
      ],
      [
        // Question 6 answer options
        RadioListTile<String>(
          title: Text('Very user-friendly'),
          value: 'Very user-friendly',
          groupValue: '',
          onChanged: (value) {
            updateGroupValueCallback(_currentQuestionIndex, value!);
          },
        ),
        RadioListTile<String>(
          title: Text('Somewhat user-friendly'),
          value: 'Somewhat user-friendly',
          groupValue: '',
          onChanged: (value) {
            updateGroupValueCallback(_currentQuestionIndex, value!);
          },
        ),
        RadioListTile<String>(
          title: Text('Neutral'),
          value: 'Neutral',
          groupValue: '',
          onChanged: (value) {
            updateGroupValueCallback(_currentQuestionIndex, value!);
          },
        ),
        RadioListTile<String>(
          title: Text('Not user-friendly at all'),
          value: 'Not user-friendly at all',
          groupValue: '',
          onChanged: (value) {
            updateGroupValueCallback(_currentQuestionIndex, value!);
          },
        ),
      ],
      [
        // Question 7 answer options
        RadioListTile<String>(
          title: Text('Yes, definitely'),
          value: 'Yes, definitely',
          groupValue: '',
          onChanged: (value) {
            updateGroupValueCallback(_currentQuestionIndex, value!);
          },
        ),
        RadioListTile<String>(
          title: Text('Yes, if they have sleep issues'),
          value: 'Yes, if they have sleep issues',
          groupValue: '',
          onChanged: (value) {
            updateGroupValueCallback(_currentQuestionIndex, value!);
          },
        ),
        RadioListTile<String>(
          title: Text('Not sure'),
          value: 'Not sure',
          groupValue: '',
          onChanged: (value) {
            updateGroupValueCallback(_currentQuestionIndex, value!);
          },
        ),
        RadioListTile<String>(
          title: Text('No, I wouldn\'t'),
          value: 'No, I wouldn\'t',
          groupValue: '',
          onChanged: (value) {
            updateGroupValueCallback(_currentQuestionIndex, value!);
          },
        ),
      ],
      [
        // Question 8 answer options
        RadioListTile<String>(
          title: Text('Very satisfied'),
          value: 'Very satisfied',
          groupValue: '',
          onChanged: (value) {
            updateGroupValueCallback(_currentQuestionIndex, value!);
          },
        ),
        RadioListTile<String>(
          title: Text('Somewhat satisfied'),
          value: 'Somewhat satisfied',
          groupValue: '',
          onChanged: (value) {
            updateGroupValueCallback(_currentQuestionIndex, value!);
          },
        ),
        RadioListTile<String>(
          title: Text('Neutral'),
          value: 'Neutral',
          groupValue: '',
          onChanged: (value) {
            updateGroupValueCallback(_currentQuestionIndex, value!);
          },
        ),
        RadioListTile<String>(
          title: Text('Not satisfied at all'),
          value: 'Not satisfied at all',
          groupValue: '',
          onChanged: (value) {
            updateGroupValueCallback(_currentQuestionIndex, value!);
          },
        ),
      ],
      [
        // Question 9 answer options
        RadioListTile<String>(
          title: Text('No issues at all'),
          value: 'No issues at all',
          groupValue: '',
          onChanged: (value) {
            updateGroupValueCallback(_currentQuestionIndex, value!);
          },
        ),
        RadioListTile<String>(
          title: Text('Minor issues that didn\'t affect functionality'),
          value: 'Minor issues that didn\'t affect functionality',
          groupValue: '',
          onChanged: (value) {
            updateGroupValueCallback(_currentQuestionIndex, value!);
          },
        ),
        RadioListTile<String>(
          title: Text('Significant issues that affected functionality'),
          value: 'Significant issues that affected functionality',
          groupValue: '',
          onChanged: (value) {
            updateGroupValueCallback(_currentQuestionIndex, value!);
          },
        ),
        RadioListTile<String>(
          title:
              Text('Couldn\'t use the application due to technical problems'),
          value: 'Couldn\'t use the application due to technical problems',
          groupValue: '',
          onChanged: (value) {
            updateGroupValueCallback(_currentQuestionIndex, value!);
          },
        ),
      ],
      [
        // Question 10 answer options
        RadioListTile<String>(
          title: Text('Very likely'),
          value: 'Very likely',
          groupValue: '',
          onChanged: (value) {
            updateGroupValueCallback(_currentQuestionIndex, value!);
          },
        ),
        RadioListTile<String>(
          title: Text('Somewhat likely'),
          value: 'Somewhat likely',
          groupValue: '',
          onChanged: (value) {
            updateGroupValueCallback(_currentQuestionIndex, value!);
          },
        ),
        RadioListTile<String>(
          title: Text('Not sure'),
          value: 'Not sure',
          groupValue: '',
          onChanged: (value) {
            updateGroupValueCallback(_currentQuestionIndex, value!);
          },
        ),
        RadioListTile<String>(
          title: Text('Not likely at all'),
          value: 'Not likely at all',
          groupValue: '',
          onChanged: (value) {
            updateGroupValueCallback(_currentQuestionIndex, value!);
          },
        ),
      ],
      //... other questions...
    ];

    return answersOptions;
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
