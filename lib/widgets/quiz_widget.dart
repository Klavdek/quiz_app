import 'package:flutter/material.dart';
import 'package:quiz_app/models/quiz_model.dart';
import 'package:quiz_app/screens/quiz_screen.dart';

class QuizWidget extends StatelessWidget {
  final QuizModel quiz;
  final VoidCallback getQuizes;

  const QuizWidget({super.key, required this.quiz, required this.getQuizes});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(quiz.name),
        subtitle: Text('Liczba pytań: ${quiz.questionNum}'),
        trailing: quiz.withTime
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [const Icon(Icons.timelapse), Text('${quiz.time} s')],
              )
            : null,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuizScreen(
              id: quiz.id!,
            ),
          ),
        ).then((value) async => getQuizes()),
      ),
    );
  }
}
