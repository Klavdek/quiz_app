import 'package:flutter/material.dart';
import 'package:quiz_app/models/question_model.dart';
import 'package:quiz_app/models/quiz_model.dart';
import 'package:quiz_app/widgets/types_of_quiz.dart/multi_answers.dart';
import 'package:quiz_app/widgets/types_of_quiz.dart/one_answer.dart';
import 'package:quiz_app/widgets/types_of_quiz.dart/true_or_false.dart';

class Quiz extends StatefulWidget {
  final List<QuestionModel> questionList;
  final QuizModel quiz;
  const Quiz({
    super.key,
    required this.questionList,
    required this.quiz,
  });

  @override
  State<Quiz> createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  bool finish = false;
  late List<QuestionModel> questionList;
  int number = 0;
  int score = 0;
  List<Map> result = [];

  @override
  void initState() {
    questionList = widget.questionList;
    super.initState();
  }

  void check(bool isCorrect) {
    if (isCorrect == true) {
      setState(() {
        result.add({'title': questionList[number].question, 'isCorrect': true});
        score += 1;
        number += 1;
      });
    } else if (isCorrect == false) {
      setState(() {
        result
            .add({'title': questionList[number].question, 'isCorrect': false});
        number += 1;
      });
    }
    if (number == widget.quiz.questionNum) {
      setState(() {
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
                  const Text('Wyniki:'),
                  Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        itemBuilder: (context, index) => Card(
                          color: result[index]['isCorrect']
                              ? Colors.lightGreen
                              : Colors.redAccent,
                          child: ListTile(
                            title: Text(result[index]['title']),
                          ),
                        ),
                        itemCount: result.length,
                      ),
                    ],
                  ),
                ],
              )
            : Column(
                children: [
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
