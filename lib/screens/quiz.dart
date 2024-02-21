// ignore_for_file: unnecessary_new

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quiz_app/models/question_model.dart';
import 'package:quiz_app/models/quiz_model.dart';

class Quiz extends StatefulWidget {
  final List<QuestionModel> questionList;
  final QuizModel quiz;
  const Quiz({super.key, required this.questionList, required this.quiz});

  @override
  State<Quiz> createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  TextEditingController answerController = TextEditingController();
  int number = 0;
  int score = 0;
  bool finish = false;
  late int time;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    time = widget.quiz.time;
    Timer.periodic(
      oneSec,
      (Timer timer) {
        if (time == 0) {
          setState(() {
            timer.cancel();
            check();
          });
        } else {
          setState(() {
            time--;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<QuestionModel> questionList = widget.questionList;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [Text('${number + 1}')],
      ),
      body: Center(
        child: finish
            ? Column(
                children: [
                  const Text('Gratuluje'),
                  Text('Twoje punkty: $score'),
                ],
              )
            : Column(
                children: [
                  Text('Time: $time'),
                  Text('punkty: $score'),
                  Text(questionList[number].question),
                  TextField(
                    controller: answerController,
                  ),
                  ElevatedButton(
                      onPressed: () => check(), child: const Text('Sprawdź'))
                ],
              ),
      ),
    );
  }

  check() {
    if (answerController.text == widget.questionList[number].answer) {
      setState(() {
        number += 1;
        score += 1;
        startTimer();
      });
    } else {
      setState(() {
        number += 1;
        startTimer();
      });
    }
    if (number == widget.questionList.length) {
      setState(() {
        finish = true;
      });
    }
    answerController.text = '';
  }
}
