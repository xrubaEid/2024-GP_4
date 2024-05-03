import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sleepwell/screens/signin_screen.dart';

class QuestionScreen extends StatefulWidget {
  static String RouteScreen = 'question';
 const QuestionScreen({Key? key}) : super(key: key);

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
 
 // @override
  //_QuestionScreenState createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  late String userId;
  late String email;

 @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      setState(() {
        showSpinner = true; // Show spinner while fetching user
      });

      final user = await _auth.currentUser;
      if (user != null) {
        setState(() {
          userId = user.uid;
          email = user.email!;
        });
      }

      setState(() {
        showSpinner = false; // Hide spinner after fetching user
      });
    } catch (e) {
      print(e);
      setState(() {
        showSpinner = false; // Hide spinner in case of an error
      });
    }
  }

  int currentQuestionIndex = 0;
  List<String> questions = [
    'Q1:How consistent is your sleep schedule?',
    'Q2:Do you have a regular bedtime routine? ',
    'Q3: Do you use your smartphone within 30 minutes before bedtime?',
    'Q3:Do you have a regular bedtime routine? ',
    'Q4:Do you consume caffeine close to bedtime?',
    'Q5:When do you typically stop consuming coffee, tea, smoking, and other substances before bedtime?',
    'Q6:What activities do you typically engage in during the two hours leading up to your bedtime?',
    'Q7:Do you frequently consume food or snacks during the night?',
    //'Question 8',
  ];

  List<List<String>> options = [
    ['Very consistent', 'Somewhat consistent', 'Inconsistent'],
    ['Yes', 'Occasionally', 'No'],
    ['Yes', 'Occasionally', 'No'],
    ['Yes', 'Occasionally', 'No'],
    ['I usually stop consuming coffee, tea, and smoking at least three hours before bedtime.', 'About 2 hours before bedtime, I avoid coffee, tea, and smoking to ensure better sleep.', 'I try to cut off coffee, tea, and smoking at least 4 hours before my bedtime.', 'Other'],
    ['Engage in relaxation techniques', 'Engage in physical activity or exercise', ' Engage in activities that may increase stress ', 'Other'],
    ['Yes', 'Occasionally', 'No'],
   // ['Option 1', 'Option 2', 'Option 3', 'Other'],
  ];

  List<String> answers = List.filled(7, ''); // Initialize with empty strings
  bool showError = false;

  void _saveAnswer(String answer) {
    setState(() {
      if (answer == 'Other') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            TextEditingController otherAnswerController = TextEditingController();

            return AlertDialog(
              title: const Text('Enter Your Answer'),
              content: TextField(
                controller: otherAnswerController,
              ),
              actions: [
                ElevatedButton(
                  child:const  Text('Save'),
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
                    child: const Text('Cancel'),
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
        _submitAnswers();
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
 void _submitAnswers() async {
  try {
    setState(() {
      showSpinner = true;
    });

    await _firestore.collection('Users').doc(userId).update({
      'answerQ1': answers[0],
      'answerQ2': answers[1],
      'answerQ3': answers[2],
      'answerQ4': answers[3],
      'answerQ5': answers[4],
      'answerQ6': answers[5],
      'answerQ7': answers[6],
    });

    // Show a dialog to inform the user that their answer is saved
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:const  Text('you are sign up successfully'),
          content:const  Text('Thank you for joining us , we know more about you can sign in to your account now '),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pushNamed(context, SignInScreen.RouteScreen);
              },
            ),
          ],
        );
      },
    );

    setState(() {
      showSpinner = false;
    });
  } catch (e) {
    print('Error while submitting answers: $e');
    setState(() {
      showSpinner = false;
    });
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.grey[300],
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
            const SizedBox(height: 70),
           const Text(
               'More About You ',
                style: TextStyle(fontSize: 20,
                fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 25),
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: Text(
                  questions[currentQuestionIndex],
                  style:const TextStyle(fontSize: 18),
                ),
             ),
             const  SizedBox(height: 20),
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
               const  Text(
                  'Please select an answer.',
                  style: TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    child: const Text('Back'),
                    onPressed: _previousQuestion,
                  ),
                  ElevatedButton(
                    child: const Text('Next'),
                    onPressed: answers[currentQuestionIndex].isEmpty
                        ? null
                        : _nextQuestion,
                  ),
                  if (showError && options[currentQuestionIndex].contains('Other'))
                    ElevatedButton(
                      child:const Text('Cancel'),
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