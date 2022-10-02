import 'dart:math';
import 'package:ansicolor/ansicolor.dart';
import 'package:flutter/material.dart';
import 'package:gym_project/viewmodels/login-view-model.dart';
import 'package:provider/provider.dart';

void debuggerLine(int number, [int xterm = 006]) {
  AnsiPen pen = AnsiPen()..xterm(xterm, bg: true)..xterm(255);
  print(pen('this line runs #$number'));
}

void ansiPrint(String message, [int xterm = 005]) {
  AnsiPen pen = AnsiPen()..xterm(xterm, bg: true)..xterm(255);
  print(pen(message));
}

// capitalize first letter in the string
String capitalize(String str) {
  if (str == null) return null;
  return str[0].toUpperCase() + str.substring(1);
}

String getToken(BuildContext context) {
  String token = Provider.of<LoginViewModel>(context, listen: false).token;
  return token;
}

void setTextFormFieldsInitialValues(
  List<TextEditingController> controllers,
  List<String> initialValues,
) {
  assert(
    initialValues.length == controllers.length,
    'When setting initial values of text form fields in a creation form, number of controllers should equal the number of passed initial values',
  );
  controllers.asMap().entries.forEach((controllerEntry) {
    int index = controllerEntry.key;
    TextEditingController controller = controllerEntry.value;
    controller.text = initialValues[index];
  });
}

Exception get responseFailedException {
  return Exception('Response failed');
}

void disposeOfControllers(List<TextEditingController> controllers) {
  controllers.forEach((controller) => controller.dispose());
}

Duration parseDuration(String stringDuration) {
  assert(
    checkDuration(stringDuration),
    'parsed duration ($stringDuration) should be in the form xx:xx, where units are in range (0-9) and tens are in range (0-5)',
  );
  String strMinutes = stringDuration.substring(0, 2);
  String strSeconds = stringDuration.substring(3);
  int minutes = int.parse(strMinutes);
  int seconds = int.parse(strSeconds);
  return Duration(minutes: minutes, seconds: seconds);
}

bool checkDuration(String stringDuration) {
  if (stringDuration.length != 5) return false;
  if (stringDuration[2] != ':') return false;
  for (int i = 0; i < stringDuration.length; i++) {
    if (i != 2) {
      double digit = double.tryParse(stringDuration[i]);
      if (digit == null) return false;
      bool isTens = (i == 0 || i == 3);
      if (isTens && digit > 5) return false;
    }
  }
  return true;
}
