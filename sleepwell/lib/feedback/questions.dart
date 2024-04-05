import 'package:flutter/material.dart';
import 'feedback_page.dart';

class Questions {
  static List<String> questions = [
    'How would you rate the overall effectiveness of the sleep enhancement features in the application?',
    'Which sleep enhancement feature did you find most helpful?',
    'How often did you use the sleep enhancement application?',
    'Did the sleep enhancement application help you fall asleep faster?',
    'Did the sleep enhancement application improve the quality of your sleep?',
    'How user-friendly did you find the interface of the sleep enhancement application?',
    'Would you recommend the sleep enhancement application to a friend or family member?',
    'How satisfied are you with the variety of sleep enhancement features offered by the application?',
    'Did you experience any technical issues or glitches while using the sleep enhancement application?',
    'How likely are you to continue using the sleep enhancement application in the future?',
  ];

  static List<String> groupValues = List.filled(questions.length, '');
  static List<List<RadioListTile<String>>> answersOptions =
      List.generate(questions.length, (index) => []);
  static List<String> answers = List.filled(questions.length, '');

  static Map<String, dynamic> get answersMap {
    Map<String, dynamic> answersMap = {};
    for (int i = 0; i < questions.length; i++) {
      answersMap[questions[i]] = answers[i];
    }
    return answersMap;
  }
}
