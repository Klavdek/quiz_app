import 'package:flutter/material.dart';
import 'package:quiz_app/models/question_model.dart';

class MultiAnswers extends StatefulWidget {
  const MultiAnswers({
    super.key,
    required this.quiz,
    required this.check,
  });
  final QuestionModel quiz;
  final Function(bool) check;

  @override
  State<MultiAnswers> createState() => _MultiAnswersState();
}

class _MultiAnswersState extends State<MultiAnswers> {
  late QuestionModel quiz;
  late List<String> list;
  bool isLoading = true;
  late String? answer;
  @override
  void initState() {
    getitems();
    super.initState();
  }

  void getitems() {
    quiz = widget.quiz;
    list = [
      quiz.correctAnswer!,
      quiz.answer2!,
      quiz.answer3!,
      quiz.answer4!,
    ];
    list.shuffle();
    isLoading = false;
  }

  void _check(String val) {
    if (val == quiz.correctAnswer) {
      setState(() {
        widget.check(true);
      });
    } else {
      setState(() {
        widget.check(false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    getitems();
    return isLoading
        ? const CircularProgressIndicator()
        : Column(
            children: [
              Text(quiz.question),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Card(
                    child: ListTile(
                      title: Text(list[0]),
                      onTap: () => _check(list[0]),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: Text(list[1]),
                      onTap: () => _check(list[1]),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: Text(list[2]),
                      onTap: () => _check(list[2]),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: Text(list[3]),
                      onTap: () => _check(list[3]),
                    ),
                  ),
                ],
              ),
            ],
          );
  }
}
