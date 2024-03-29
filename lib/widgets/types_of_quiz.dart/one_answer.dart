import 'package:flutter/material.dart';
import 'package:quiz_app/models/question_model.dart';

class OneAnswer extends StatelessWidget {
  const OneAnswer({
    super.key,
    required this.quiz,
    required this.check,
  });
  final QuestionModel quiz;
  final Function(bool) check;

  @override
  Widget build(BuildContext context) {
    TextEditingController answerController = TextEditingController();
    void _check() {
      if (answerController.text == quiz.correctAnswer) {
        check(true);
      } else {
        check(false);
      }
      answerController.text = '';
    }

    return Column(
      children: [
        Text(quiz.question),
        TextField(
          controller: answerController,
        ),
        ElevatedButton(
          onPressed: () => _check(),
          child: const Text('Sprawdź'),
        )
      ],
    );
  }
}
