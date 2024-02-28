import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quiz_app/models/question_model.dart';
import 'package:quiz_app/models/quiz_model.dart';
import 'package:quiz_app/widgets/types_of_quiz.dart/multi_answers.dart';
import 'package:quiz_app/widgets/types_of_quiz.dart/one_answer.dart';
import 'package:quiz_app/widgets/types_of_quiz.dart/true_or_false.dart';

class QuizWithTime extends StatefulWidget {
  final List<QuestionModel> questionList;
  final QuizModel quiz;
  const QuizWithTime({
    super.key,
    required this.questionList,
    required this.quiz,
  });

  @override
  State<QuizWithTime> createState() => _QuizWithTimeState();
}

class _QuizWithTimeState extends State<QuizWithTime> {
  bool finish = false;
  late List<QuestionModel> questionList;
  int number = 0;
  int score = 0;
  Timer? _timer;
  late ValueNotifier<int> _counter;

  @override
  void initState() {
    widget.quiz.withTime ? startTimer() : null;
    questionList = widget.questionList;
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    _counter = ValueNotifier<int>(widget.quiz.time);
    _timer?.cancel();
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_counter.value == 0) {
          check(false);
        } else {
          _counter.value--;
          print(_counter.value);
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
        finish = true;
        _timer?.cancel();
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
                  ValueListenableBuilder<int>(
                    builder: (BuildContext context, int value, Widget? child) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text('$value'),
                        ],
                      );
                    },
                    valueListenable: _counter,
                    child: null,
                  ),
                  Text('punkty: $score'),
                  questionList[number].type == QuestionType.oneAnswer
                      ? OneAnswer(
                          quiz: questionList[number],
                          check: (val) => check(val),
                        )
                      : questionList[number].type == QuestionType.trueOrFalse
                          ? TrueOrFalse(
                              quiz: questionList[number],
                              check: (val) => check(val))
                          : MultiAnswers(
                              quiz: questionList[number],
                              check: (val) => check(val),
                            )
                ],
              ),
      ),
    );
  }
}
