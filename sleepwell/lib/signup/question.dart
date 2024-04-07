import 'package:flutter/material.dart';

class QuestionScreen extends StatefulWidget {
  static String RouteScreen = 'question';

  @override
  _QuestionScreenState createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  int currentQuestionIndex = 0;
  List<String> questions = [
    'What would you like the default bedtime to be on working days?',
    'What time would you like the default wake-up time to be on working days?',
    'What time would you like the default bedtime to be on weekends?',
    'What time would you like the default wake-up time to be on weekends?',
    'When do you typically stop consuming coffee, tea, smoking, and other substances before bedtime?',
    'What activities do you typically engage in during the two hours leading up to your bedtime?',
    //'Question 7',
    //'Question 8',
  ];

  List<List<String>> options = [
    ['9:30 PM', '10:00 PM', '11:00 PM', 'Other'],
    ['6 AM', '7 AM', '8 AM', 'Other'],
    ['11:30 PM', '12:30 AM', '12:30 AM', 'Other'],
    ['8:30 AM', '9 AM', '10 AM', 'Other'],
    ['I usually stop consuming coffee, tea, and smoking at least three hours before bedtime.', 'About 2 hours before bedtime, I avoid coffee, tea, and smoking to ensure better sleep.', 'I try to cut off coffee, tea, and smoking at least 4 hours before my bedtime.', 'Other'],
    ['Reading a book or listening to calming music.', 'Meditation or deep breathing', ' stretching or yoga',' play a sport or engage in a physical activity ', 'Other'],
    //['Option 1', 'Option 2', 'Option 3', 'Other'],
   // ['Option 1', 'Option 2', 'Option 3', 'Other'],
  ];

  List<String> answers = List.filled(6, ''); // Initialize with empty strings
  bool showError = false;

  void _saveAnswer(String answer) {
    setState(() {
      if (answer == 'Other') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            TextEditingController otherAnswerController = TextEditingController();

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
                    answers[currentQuestionIndex] = otherAnswer;
                    otherAnswerController.clear();
                    Navigator.pop(context);
                    showError = false; // Reset error state
                  },
                ),
                if (options[currentQuestionIndex].contains('Other'))
                  ElevatedButton(
                    child: Text('Cancel'),
                    onPressed: () {
                      setState(() {
                        answers[currentQuestionIndex] = '';
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
        answers[currentQuestionIndex] = answer;
        showError = false; // Reset error state
      }
    });
  }

  void _nextQuestion() {
    setState(() {
      if (answers[currentQuestionIndex].isEmpty) {
        showError = true; // Show error message if no answer is selected
      } else if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++;
      } else {
        // All questions answered, do something
      }
    });
  }

  void _previousQuestion() {
    setState(() {
      if (currentQuestionIndex > 0) {
        currentQuestionIndex--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('More About You'),
        backgroundColor: Colors.grey,
      ),
      body: Container(
        color: Colors.grey[300],
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 20),
              Text(
                questions[currentQuestionIndex],
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              Column(
                children: options[currentQuestionIndex].map((option) {
                  return RadioListTile<String>(
                    title: Text(option),
                    value: option,
                    groupValue: answers[currentQuestionIndex] == option
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
                    onPressed: answers[currentQuestionIndex].isEmpty
                        ? null
                        : _nextQuestion,
                  ),
                  if (showError && options[currentQuestionIndex].contains('Other'))
                    ElevatedButton(
                      child: Text('Cancel'),
                      onPressed: () {
                        setState(() {
                          answers[currentQuestionIndex] = '';
                          showError = false; // Reset error state
                        });
                      },
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