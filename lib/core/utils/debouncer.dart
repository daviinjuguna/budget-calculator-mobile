import 'dart:async';

import 'package:flutter/material.dart';

///run some function after some delay
class Debouncer implements BaseDebouncer {
  final int _milliseconds;
  final int _seconds;
  Timer? _timer;

  Debouncer({
    int milliseconds = 0,
    int seconds = 0,
  })  : _milliseconds = milliseconds,
        _seconds = seconds;

  @override
  void run({required VoidCallback action}) {
    if (_timer != null) _timer?.cancel();

    _timer =
        Timer(Duration(milliseconds: _milliseconds, seconds: _seconds), action);
  }

  @override
  void close() => _timer?.cancel();
}

abstract class BaseDebouncer {
  void run({required VoidCallback action});
  void close();
}
