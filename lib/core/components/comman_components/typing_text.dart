import 'dart:async';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TypingText extends StatefulWidget {
  final String fullText;
  Function onFinished;
  final TextStyle? textStyle;
  final Duration durationPerChar;

  TypingText({
    super.key,
    required this.fullText,
    required this.onFinished,
    this.textStyle,
    this.durationPerChar = const Duration(milliseconds: 50),
  });

  @override
  TypingTextState createState() => TypingTextState();
}

class TypingTextState extends State<TypingText> {
  String _visibleText = '';
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTyping();
  }

  void _startTyping() {
    _timer = Timer.periodic(widget.durationPerChar, (timer) {
      if (_currentIndex < widget.fullText.length) {
        setState(() {
          _visibleText += widget.fullText[_currentIndex];
          _currentIndex++;
        });
      } else {
        _timer?.cancel();
        widget.onFinished();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _visibleText,
      style:
          widget.textStyle ??
          const TextStyle(color: Colors.white, fontSize: 14),
      textAlign: TextAlign.center,
    );
  }
}
