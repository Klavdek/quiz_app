import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quiz_app/models/question_model.dart';
import 'package:quiz_app/models/quiz_model.dart';
import 'package:quiz_app/screens/types_of_quiz.dart/one_answer.dart';
import 'package:quiz_app/screens/types_of_quiz.dart/true_or_false.dart';

class Quiz extends StatefulWidget {
  final List<QuestionModel> questionList;
  final QuizModel quiz;
  const Quiz({super.key, required this.questionList, required this.quiz});

  @override
  State<Quiz> createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  TextEditingController answerController = TextEditingController();
  bool finish = false;
  int number = 0;
  int score = 0;
  late int time;
  Timer? _timer;
  late List<QuestionModel> questionList;

  @override
  void initState() {
    startTimer();
    questionList = widget.questionList;
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    _timer?.cancel();
    const oneSec = Duration(seconds: 1);
    time = widget.quiz.time;
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (time == 0) {
          setState(() {
            timer.cancel();
            _timer?.cancel();
            check(false);
          });
        } else {
          setState(() {
            time--;
          });
        }
      },
    );
  }

  void check(bool isCorrect) {
    if (isCorrect == true) {
      setState(() {
        score += 1;
        number += 1;
        startTimer();
      });
    } else if (isCorrect == false) {
      setState(() {
        number += 1;
        startTimer();
      });
    }
    if (number == widget.quiz.questionNum) {
      setState(() {
        _timer?.cancel();
        finish = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  questionList[number].type == QuestionType.oneAnswer
                      ? OneAnswer(
                          quiz: questionList[number],
                          check: (val) => check(val),
                          answerController: answerController,
                        )
                      : questionList[number].type == QuestionType.trueOrFalse
                          ? TrueOrFalse(
                              quiz: questionList[number],
                              check: (val) => check(val))
                          : Text('nul')
                ],
              ),
      ),
    );
  }
}
