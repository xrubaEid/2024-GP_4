import 'package:flutter/material.dart';
import 'package:sleepwell/screens/signin_screen.dart';

class QuestionScreen extends StatefulWidget {
  static String RouteScreen = 'question';

  @override
  verbal createState() => verbal();
}

class verbal extends State<QuestionScreen> {

  //// How to make sure it's tha same user in signup screen 
   String Fname = '';
  String email = '';
  String password = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Retrieve the user's information from the RouteSettings
    final arguments = ModalRoute.of(context)?.settings.arguments as Map<String, String>?;
    Fname = arguments?['Fname'] ?? '';
    email = arguments?['email'] ?? '';
    password = arguments?['password'] ?? '';
  }


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
  String? answerQ1;
  String? answerQ2;
  String? answerQ3;
  String? answerQ4;
  String? answerQ5;
  String? answerQ6;

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
                  if (currentQuestionIndex == 0) {
                    answerQ1 = otherAnswer;
                  } else if (currentQuestionIndex == 1) {
                    answerQ2 = otherAnswer;
                  } else if (currentQuestionIndex == 2) {
                    answerQ3 = otherAnswer;
                  } else if (currentQuestionIndex == 3) {
                    answerQ4 = otherAnswer;
                  } else if (currentQuestionIndex == 4) {
                    answerQ5 = otherAnswer;
                  } else if (currentQuestionIndex == 5) {
                    answerQ6 = otherAnswer;
                  }
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
                      if (currentQuestionIndex == 0) {
                        answerQ1 = null;
                      } else if (currentQuestionIndex == 1) {
                        answerQ2 = null;
                      } else if (currentQuestionIndex == 2) {
                        answerQ3 = null;
                      } else if (currentQuestionIndex == 3) {
                        answerQ4 = null;
                      } else if (currentQuestionIndex == 4) {
                        answerQ5 = null;
                      } else if (currentQuestionIndex == 5) {
                        answerQ6 = null;
                      }
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
      if (currentQuestionIndex == 0) {
        answerQ1 = answer;
      } else if (currentQuestionIndex == 1) {
        answerQ2 = answer;
      } else if (currentQuestionIndex == 2) {
        answerQ3 = answer;
      } else if (currentQuestionIndex == 3) {
        answerQ4 = answer;
      } else if (currentQuestionIndex == 4) {
        answerQ5 = answer;
      } else if (currentQuestionIndex == 5) {
        answerQ6 = answer;
      }
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
        
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title:Text('Thank you $Fname'),
                                titleTextStyle: TextStyle(
                                  color:Colors.green,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                                content: Text(
                                    'Your Answer will help us serve you better.'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                       Navigator.pushNamed(
                                        context, SignInScreen.RouteScreen, );
                                    },
                                    child: Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
      }
    });
  }
 // method back to the previous Question 
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
