import 'package:flutter/material.dart';
import 'package:quiz_app/models/question_model.dart';

class MultiAnswers extends StatelessWidget {
  const MultiAnswers({
    super.key,
    required this.quiz,
    required this.check,
  });
  final QuestionModel quiz;
  final Function(bool) check;

  @override
  Widget build(BuildContext context) {
    final List<String> list = [
      quiz.correctAnswer!,
      quiz.answer2!,
      quiz.answer3??'',
      quiz.answer4??'',
    ];
    print(list);
    list.shuffle();
    void _check(String val) {
      if (val == quiz.correctAnswer) {
        check(true);
      } else {
        check(false);
      }
    }

    return Column(
      children: [
        Text(quiz.question),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemBuilder: (context, index) => Visibility(
                visible: list[index].isNotEmpty,
                child: Card(
                  child: ListTile(
                    title: Text(list[index]),
                    onTap: () => _check(list[index]),
                  ),
                ),
              ),
              itemCount: list.length,
            ),
            // Card(
            //   child: ListTile(
            //     title: Text(list[0]),
            //     onTap: () => _check(list[0]),
            //   ),
            // ),
            // Card(
            //   child: ListTile(
            //     title: Text(list[1]),
            //     onTap: () => _check(list[1]),
            //   ),
            // ),
            // Card(
            //   child: ListTile(
            //     title: Text(list[2]),
            //     onTap: () => _check(list[2]),
            //   ),
            // ),
            // Card(
            //   child: ListTile(
            //     title: Text(list[3]),
            //     onTap: () => _check(list[3]),
            //   ),
            // ),
          ],
        ),
      ],
    );
  }
}
