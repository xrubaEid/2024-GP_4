import 'dart:math';

import 'package:math_expressions/math_expressions.dart';
import 'package:sleepwell/models/equation_abstrat_model.dart';

class DifficultEquationModel extends EquationModel {
  late int _operand1;
  late int _operand2;
  late int _operand3;
  late String _operator1;
  late String _operator2;

  DifficultEquationModel() {
    Random random = Random();

    // توليد ثلاثة أعداد عشوائية
    _operand1 = random.nextInt(10); // توليد رقم عشوائي بين 0 و 10
    _operand2 = random.nextInt(10);
    _operand3 = random.nextInt(10);

    // توليد عمليات رياضية عشوائية
    int operatorIndex1 = random.nextInt(3);
    int operatorIndex2 = random.nextInt(3);

    _operator1 = _getOperatorSymbol(operatorIndex1);
    _operator2 = _getOperatorSymbol(operatorIndex2);

    equation = '$_operand1 $_operator1 $_operand2 $_operator2 $_operand3';

    // convert the string equation to math equation
    Expression expression = Parser().parse(equation);
    ContextModel contextModel = ContextModel();
    result = (expression.evaluate(EvaluationType.REAL, contextModel) as double)
        .toInt();

    // get solution options
    options = _generateOptions(result);

    print(":::::::::::: the equation is: $equation");
    print(":::::::::::: the result is: $result");
    print(":::::::::::: the options are: $options");
  }

  String _getOperatorSymbol(int operatorIndex) {
    switch (operatorIndex) {
      case 0:
        return '+';
      case 1:
        return '-';
      case 2:
        return '*';
    }
    return '';
  }

  List<int> _generateOptions(int correctResult) {
    const optionsNumber = 3;
    Random random = Random();
    List<int> options = [];

    // Add the correct solution to the options
    options.add(correctResult);

    // Generate other proposed options
    while (options.length < optionsNumber) {
      // Generate a random number close to the correct solution
      int deviation = random.nextInt(12) - 6;
      int option = correctResult + deviation;

      // Ensure the number is not already in the list
      if (!options.contains(option)) {
        options.add(option);
      }
    }

    // Shuffle the options randomly  تبديل ترتيب الخيارات بشكل عشوائي
    options.shuffle();
    return options;
  }
}
