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
  QuestionType? type = QuestionType.oneAnswer;
  bool answerBool = true;
  int number = 1;
  List<TextEditingController> listControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Dodaj pytanie'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Column(children: [
          TextField(
            decoration: const InputDecoration(label: Text('Wpisz pytanie')),
            controller: questionController,
          ),
          const Text('Wybierz typ quizu:'),
          ListTile(
            title: const Text('Jedna odpowiedź'),
            trailing: Radio(
              value: QuestionType.oneAnswer,
              groupValue: type,
              onChanged: (QuestionType? value) => setState(() {
                type = value;
              }),
            ),
          ),
          ListTile(
            title: const Text('Prawda - fałsz'),
            trailing: Radio(
              value: QuestionType.trueOrFalse,
              groupValue: type,
              onChanged: (QuestionType? value) => setState(() {
                type = value;
              }),
            ),
          ),
          ListTile(
            title: const Text('Kilka odpowiedzi (ABCD)'),
            trailing: Radio(
              value: QuestionType.multiAnswers,
              groupValue: type,
              onChanged: (QuestionType? value) => setState(() {
                type = value;
              }),
            ),
          ),
          type == QuestionType.oneAnswer
              ? TextField(
                  decoration: const InputDecoration(
                      label: Text('Wpisz poprawną odpowiedź')),
                  controller: answerController,
                )
              : type == QuestionType.trueOrFalse
                  ? Column(children: [
                      ListTile(
                        title: const Text('Prawda'),
                        trailing: Radio(
                          value: true,
                          groupValue: answerBool,
                          onChanged: (value) => setState(() {
                            answerBool = value!;
                          }),
                        ),
                      ),
                      ListTile(
                        title: const Text('Fałsz'),
                        trailing: Radio(
                          value: false,
                          groupValue: answerBool,
                          onChanged: (value) => setState(() {
                            answerBool = value!;
                          }),
                        ),
                      ),
                    ])
                  : Column(
                      children: [
                        TextField(
                          controller: listControllers[0],
                          decoration: const InputDecoration(
                            label: Text('Wpisz poprawną odpowiedź'),
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          itemBuilder: (context, index) => TextField(
                            controller: listControllers[index + 1],
                            decoration: const InputDecoration(
                              label: Text('Wpisz błędną odpowiedź'),
                            ),
                          ),
                          itemCount: number,
                        ),
                        Visibility(
                          visible: number < 3,
                          child: OutlinedButton(
                            onPressed: () => setState(() {
                              number += 1;
                            }),
                            child: const Icon(Icons.add),
                          ),
                        )
                      ],
                    ),
          FilledButton(
            onPressed: () async => saveQuestion(),
            child: const Text('Dodaj'),
          ),
        ]),
      ),
    );
  }

  void showAlert(String alertMessage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(alertMessage),
      ),
    );
  }

  saveQuestion() async {
    if (questionController.text.isEmpty) {
      showAlert('Wpisz pytanie');
    } else if (type == QuestionType.oneAnswer &&
        answerController.text.isEmpty) {
      showAlert('Uzupełnij odpowiedź');
    } else if (type == QuestionType.multiAnswers &&
        (listControllers[0].text.isEmpty || listControllers[1].text.isEmpty)) {
      showAlert('Uzupełnij przynajmniej 2 odpowedzi');
    } else {
      QuestionModel question = QuestionModel(
        idQuiz: widget.id,
        type: type!,
        question: questionController.text,
        answerBool: answerBool,
        correctAnswer: type == QuestionType.oneAnswer
            ? answerController.text
            : listControllers[0].text,
        answer2: listControllers[1].text,
        answer3: listControllers[2].text,
        answer4: listControllers[3].text,
      );
      await DbHelper()
          .insertQuestion(question)
          .then((value) => Navigator.pop(context));
    }
  }
}
