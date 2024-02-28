import 'package:flutter/material.dart';
import 'package:quiz_app/database/database_helper.dart';
import 'package:quiz_app/models/question_model.dart';
import 'package:quiz_app/models/quiz_model.dart';
import 'package:quiz_app/screens/add_question_screen.dart';
import 'package:quiz_app/screens/quiz.dart';
import 'package:quiz_app/screens/quiz_with_time.dart';
import 'package:quiz_app/widgets/question_widget.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key, required this.id});

  final int id;

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  bool isLoading = true;
  late QuizModel quiz;
  late List<QuestionModel> questionList;
  late List<QuestionModel> shuffleQuestionList;

  Future getQuizNQuestions() async {
    isLoading = true;
    quiz = await DbHelper().queryQuiz(widget.id);
    questionList = await DbHelper().queryQuestionList(widget.id);
    shuffleQuestionList = List.of(questionList);
    shuffleQuestionList.shuffle();
    setState(() {
      isLoading = false;
    });
  }

  Future deleteQuiz() async {
    await DbHelper()
        .deleteQuiz(quiz.id!)
        .then((value) => Navigator.pop(context));
  }

  Future deleteQuestion(int questionId) async {
    print('@@@@@@@@@@@@@@ $questionId');
    await DbHelper().deleteQuestion(questionId, quiz.id!);
    await getQuizNQuestions();
  }

  @override
  void initState() {
    getQuizNQuestions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const CircularProgressIndicator()
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              title: Text(quiz.name),
              actions: [
                IconButton(
                    onPressed: () async => deleteQuiz(),
                    icon: const Icon(Icons.delete))
              ],
            ),
            body: Center(
              child: Column(
                children: [
                  Text('Liczba pytań: ${quiz.questionNum}'),
                  Text('Czas: ${quiz.time} s'),
                  OutlinedButton(
                      onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddQuestion(
                                  id: quiz.id!,
                                ),
                              )).then(
                            (value) => getQuizNQuestions(),
                          ),
                      child: const Text('Dodaj pytania')),
                  Visibility(
                    visible: questionList.isNotEmpty,
                    child: FilledButton(
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => quiz.withTime
                                  ? QuizWithTime(
                                      questionList: shuffleQuestionList,
                                      quiz: quiz,
                                    )
                                  : Quiz(
                                      questionList: shuffleQuestionList,
                                      quiz: quiz,
                                    ),
                            )),
                        child: const Text('Rozpocznij quiz')),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: questionList.length,
                      itemBuilder: (context, index) => QuestionWidget(
                        question: questionList[index],
                        delete: () {
                          deleteQuestion(questionList[index].id!);
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
  }
}
