import 'package:flutter/material.dart';
import 'package:quiz_app/database/database_helper.dart';
import 'package:quiz_app/models/question_model.dart';

class AddQuestion extends StatefulWidget {
  final int id;

  const AddQuestion({super.key, required this.id});

  @override
  State<AddQuestion> createState() => _AddQuestionState();
}

class _AddQuestionState extends State<AddQuestion> {
  TextEditingController questionController = TextEditingController();
  TextEditingController answerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dodaj pytanie'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(children: [
        TextField(
          decoration: const InputDecoration(label: Text('Wpisz pytanie')),
          controller: questionController,
        ),
        TextField(
          decoration:
              const InputDecoration(label: Text('Wpisz poprawną odpowiedź')),
          controller: answerController,
        ),
        OutlinedButton(
            onPressed: () async => saveQuestion(), child: const Text('Dodaj'))
      ]),
    );
  }

  saveQuestion() async {
    QuestionModel question = QuestionModel(
      idQuiz: widget.id,
      question: questionController.text,
      answer: answerController.text,
    );
    await DbHelper()
        .insertQuestion(question)
        .then((value) => Navigator.pop(context));
  }
}
