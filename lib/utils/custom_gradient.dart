import 'package:flutter/material.dart';

LinnearGradientDarkBlue() {
  return LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF6574FF),
      Color(0xFF4355F5),
    ],
  );
}

LinnearGradientDarkGreen() {
  return LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color.fromARGB(255, 123, 226, 127),
      Color.fromARGB(255, 101, 223, 105),
    ],
  );
}
