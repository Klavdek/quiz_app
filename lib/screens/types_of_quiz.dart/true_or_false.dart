import 'package:flutter/material.dart';
import 'package:quiz_app/models/question_model.dart';

class TrueOrFalse extends StatelessWidget {
  final QuestionModel quiz;
  final Function(bool) check;

  const TrueOrFalse({
    super.key,
    required this.quiz,
    required this.check,
  });

  @override
  Widget build(BuildContext context) {
    void _check(bool isCorrect) {
      if (isCorrect == quiz.answerBool) {
        check(true);
      } else {
        check(false);
      }
    }

    return Column(
      children: [
        Text(quiz.question),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: () => _check(true),
              child: const Text('Prawda'),
            ),
            ElevatedButton(
              onPressed: () => _check(false),
              child: const Text('Fałsz'),
            ),
          ],
        ),
      ],
    );
  }
}
