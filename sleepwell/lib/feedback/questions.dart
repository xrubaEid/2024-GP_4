import 'package:flutter/material.dart';
import 'feedback_page.dart';

class Questions {
  static int _currentQuestionIndex = 0;
  static List<String> groupValues = [];
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
  static Map<String, dynamic> get answersMap {
    Map<String, dynamic> answersMap = {};
    for (int i = 0; i < questions.length; i++) {
      answersMap[questions[i]] = answers[i];
    }
    return answersMap;
  }

  static List<List<RadioListTile<String>>> answersOptions = [
    [
      // Question 1 answer options
      RadioListTile<String>(
        title: Text('Excellent'),
        value: 'Excellent',
        groupValue: '',
        onChanged: (value) {
          Questions.answers[_currentQuestionIndex] = value!;
          //updateGroupValueCallback(_currentQuestionIndex, value);
        },
      ),

      RadioListTile<String>(
        title: Text('Good'),
        value: 'Good',
        groupValue: '',
        onChanged: (value) {
          Questions.answers[_currentQuestionIndex] = value!;
        },
      ),
      RadioListTile<String>(
        title: Text('Average'),
        value: 'Average',
        groupValue: '',
        onChanged: (value) {
          Questions.answers[_currentQuestionIndex] = value!;
        },
      ),
      RadioListTile<String>(
        title: Text('Poor'),
        value: 'Poor',
        groupValue: '',
        onChanged: (value) {
          Questions.answers[_currentQuestionIndex] = value!;
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
          Questions.answers[_currentQuestionIndex] = value!;
        },
      ),
      RadioListTile<String>(
        title: Text('Relaxation exercises'),
        value: 'Relaxation exercises',
        groupValue: '',
        onChanged: (value) {
          Questions.answers[_currentQuestionIndex] = value!;
        },
      ),
      RadioListTile<String>(
        title: Text('White noise or soothing sounds'),
        value: 'White noise or soothing sounds',
        groupValue: '',
        onChanged: (value) {
          Questions.answers[_currentQuestionIndex] = value!;
        },
      ),
      RadioListTile<String>(
        title: Text('Sleep environment recommendations'),
        value: 'Sleep environment recommendations',
        groupValue: '',
        onChanged: (value) {
          Questions.answers[_currentQuestionIndex] = value!;
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
          Questions.answers[_currentQuestionIndex] = value!;
        },
      ),
      RadioListTile<String>(
        title: Text('Several times a week'),
        value: 'Several times a week',
        groupValue: '',
        onChanged: (value) {
          Questions.answers[_currentQuestionIndex] = value!;
        },
      ),
      RadioListTile<String>(
        title: Text('Occasionally'),
        value: 'Occasionally',
        groupValue: '',
        onChanged: (value) {
          Questions.answers[_currentQuestionIndex] = value!;
        },
      ),
      RadioListTile<String>(
        title: Text('Rarely or never'),
        value: 'Rarely or never',
        groupValue: '',
        onChanged: (value) {
          Questions.answers[_currentQuestionIndex] = value!;
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
          Questions.answers[_currentQuestionIndex] = value!;
        },
      ),
      RadioListTile<String>(
        title: Text('Yes, to some extent'),
        value: 'Yes, to some extent',
        groupValue: '',
        onChanged: (value) {
          Questions.answers[_currentQuestionIndex] = value!;
        },
      ),
      RadioListTile<String>(
        title: Text('Not sure'),
        value: 'Not sure',
        groupValue: '',
        onChanged: (value) {
          Questions.answers[_currentQuestionIndex] = value!;
        },
      ),
      RadioListTile<String>(
        title: Text('No, not at all'),
        value: 'No, not at all',
        groupValue: '',
        onChanged: (value) {
          Questions.answers[_currentQuestionIndex] = value!;
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
          Questions.answers[_currentQuestionIndex] = value!;
        },
      ),
      RadioListTile<String>(
        title: Text('Yes, to some extent'),
        value: 'Yes, to some extent',
        groupValue: '',
        onChanged: (value) {
          Questions.answers[_currentQuestionIndex] = value!;
        },
      ),
      RadioListTile<String>(
        title: Text('Not sure'),
        value: 'Not sure',
        groupValue: '',
        onChanged: (value) {
          Questions.answers[_currentQuestionIndex] = value!;
        },
      ),
      RadioListTile<String>(
        title: Text('No, not at all'),
        value: 'No, not at all',
        groupValue: '',
        onChanged: (value) {
          Questions.answers[_currentQuestionIndex] = value!;
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
          Questions.answers[_currentQuestionIndex] = value!;
        },
      ),
      RadioListTile<String>(
        title: Text('Somewhat user-friendly'),
        value: 'Somewhat user-friendly',
        groupValue: '',
        onChanged: (value) {
          Questions.answers[_currentQuestionIndex] = value!;
        },
      ),
      RadioListTile<String>(
        title: Text('Neutral'),
        value: 'Neutral',
        groupValue: '',
        onChanged: (value) {
          Questions.answers[_currentQuestionIndex] = value!;
        },
      ),
      RadioListTile<String>(
        title: Text('Not user-friendly at all'),
        value: 'Not user-friendly at all',
        groupValue: '',
        onChanged: (value) {
          Questions.answers[_currentQuestionIndex] = value!;
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
          Questions.answers[_currentQuestionIndex] = value!;
        },
      ),
      RadioListTile<String>(
        title: Text('Yes, if they have sleep issues'),
        value: 'Yes, if they have sleep issues',
        groupValue: '',
        onChanged: (value) {
          Questions.answers[_currentQuestionIndex] = value!;
        },
      ),
      RadioListTile<String>(
        title: Text('Not sure'),
        value: 'Not sure',
        groupValue: '',
        onChanged: (value) {
          Questions.answers[_currentQuestionIndex] = value!;
        },
      ),
      RadioListTile<String>(
        title: Text('No, I wouldn\'t'),
        value: 'No, I wouldn\'t',
        groupValue: '',
        onChanged: (value) {
          Questions.answers[_currentQuestionIndex] = value!;
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
          Questions.answers[_currentQuestionIndex] = value!;
        },
      ),
      RadioListTile<String>(
        title: Text('Somewhat satisfied'),
        value: 'Somewhat satisfied',
        groupValue: '',
        onChanged: (value) {
          Questions.answers[_currentQuestionIndex] = value!;
        },
      ),
      RadioListTile<String>(
        title: Text('Neutral'),
        value: 'Neutral',
        groupValue: '',
        onChanged: (value) {
          Questions.answers[_currentQuestionIndex] = value!;
        },
      ),
      RadioListTile<String>(
        title: Text('Not satisfied at all'),
        value: 'Not satisfied at all',
        groupValue: '',
        onChanged: (value) {
          Questions.answers[_currentQuestionIndex] = value!;
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
          Questions.answers[_currentQuestionIndex] = value!;
        },
      ),
      RadioListTile<String>(
        title: Text('Minor issues that didn\'t affect functionality'),
        value: 'Minor issues that didn\'t affect functionality',
        groupValue: '',
        onChanged: (value) {
          Questions.answers[_currentQuestionIndex] = value!;
        },
      ),
      RadioListTile<String>(
        title: Text('Significant issues that affected functionality'),
        value: 'Significant issues that affected functionality',
        groupValue: '',
        onChanged: (value) {
          Questions.answers[_currentQuestionIndex] = value!;
        },
      ),
      RadioListTile<String>(
        title: Text('Couldn\'t use the application due to technical problems'),
        value: 'Couldn\'t use the application due to technical problems',
        groupValue: '',
        onChanged: (value) {
          Questions.answers[_currentQuestionIndex] = value!;
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
          Questions.answers[_currentQuestionIndex] = value!;
        },
      ),
      RadioListTile<String>(
        title: Text('Somewhat likely'),
        value: 'Somewhat likely',
        groupValue: '',
        onChanged: (value) {
          Questions.answers[_currentQuestionIndex] = value!;
        },
      ),
      RadioListTile<String>(
        title: Text('Not sure'),
        value: 'Not sure',
        groupValue: '',
        onChanged: (value) {
          Questions.answers[_currentQuestionIndex] = value!;
        },
      ),
      RadioListTile<String>(
        title: Text('Not likely at all'),
        value: 'Not likely at all',
        groupValue: '',
        onChanged: (value) {
          Questions.answers[_currentQuestionIndex] = value!;
        },
      ),
    ],
  ];

  /*static List<Widget> get _answersOptionsWidget {
    List<Widget> options = [];
    for (List<RadioListTile<String>> option in answersOptions) {
      options.add(
        Column(
          children: option,
        ),
      );
    }
    return options;
  }*/

  static List<String> answers = List.filled(Questions.questions.length, '');
  //static List<String> groupValues = List.filled(Questions.questions.length, '');
}
