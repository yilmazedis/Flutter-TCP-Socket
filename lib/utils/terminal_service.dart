import 'package:ansicolor/ansicolor.dart';
import 'package:flutter/foundation.dart';

void printRed(String message) {
  AnsiPen pen = AnsiPen()..red();
  if (kDebugMode) {
    print(pen(message));
  }
}

void printGreen(String message) {
  AnsiPen pen = AnsiPen()..green();
  if (kDebugMode) {
    print(pen(message));
  }
}

void printBlue(String message) {
  AnsiPen pen = AnsiPen()..blue();
  if (kDebugMode) {
    print(pen(message));
  }
}

enum PromptColor {
  red,
  yellow,
  cyan,
  blue,
  green,
}

void printColored(PromptColor color, String message) {
  AnsiPen pen;

  switch (color) {
    case PromptColor.red:
      pen = AnsiPen()..red();
      break;
    case PromptColor.yellow:
      pen = AnsiPen()..yellow();
      break;
    case PromptColor.cyan:
      pen = AnsiPen()..cyan();
      break;
    case PromptColor.blue:
      pen = AnsiPen()..blue();
      break;
    case PromptColor.green:
      pen = AnsiPen()..green();
      break;
  }

  if (kDebugMode) {
    print(pen(message));
  }
}