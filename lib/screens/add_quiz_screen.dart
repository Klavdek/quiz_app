import 'package:flutter/material.dart';
import 'package:quiz_app/database/database_helper.dart';
import 'package:quiz_app/models/quiz_model.dart';

class AddQuizScreen extends StatefulWidget {
  const AddQuizScreen({super.key});
  @override
  State<AddQuizScreen> createState() => _AddQuizScreenState();
}

class _AddQuizScreenState extends State<AddQuizScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController numController = TextEditingController();
  bool withTime = false;
  QuizType? type = QuizType.oneAnswer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Dodaj quiz'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration:
                      const InputDecoration(label: Text('Wpisz tytuł quizu')),
                ),
                TextField(
                  controller: numController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(label: Text('Wpisz czas')),
                ),
              ],
            ),
          ),
          const Text('Wybierz typ quizu:'),
          ListTile(
            title: const Text('Typ jednej odpowiedzi'),
            trailing: Radio(
              value: QuizType.oneAnswer,
              groupValue: type,
              onChanged: (QuizType? value) => setState(() {
                type = value;
              }),
            ),
          ),
          ListTile(
            title: const Text('Typ kilku odpowiedzi'),
            trailing: Radio(
              value: QuizType.multiAnswers,
              groupValue: type,
              onChanged: (QuizType? value) => setState(() {
                type = value;
              }),
            ),
          ),
          ListTile(
            title: const Text('Czy quiz ma być na czas?'),
            trailing: Switch(
              value: withTime,
              onChanged: (value) => setState(() {
                withTime = value;
              }),
            ),
          ),
          OutlinedButton(onPressed: saveQuiz, child: const Text('Dodaj quiz')),
        ],
      ),
    );
  }

  saveQuiz() {
    QuizModel quiz = QuizModel(
        name: titleController.text,
        questionNum: 0,
        type: type!,
        withTime: withTime,
        time: int.tryParse(numController.text) ?? 0);
    DbHelper().insertQuiz(quiz);
    Navigator.pop(context);
  }
}
