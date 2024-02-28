import 'package:flutter/material.dart';
import 'package:quiz_app/models/question_model.dart';

class QuestionWidget extends StatelessWidget {
  final QuestionModel question;
  final VoidCallback delete;

  const QuestionWidget({
    super.key,
    required this.question,
    required this.delete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(question.question),
        trailing: PopupMenuButton(
          itemBuilder: (context) {
            return [
              const PopupMenuItem(
                value: 'edit',
                child: Text('Edytuj'),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Text('Usuń'),
              )
            ];
          },
          onSelected: (String value) {
            if (value == 'delete') {
              delete();
            } else if (value == 'edit') {}
          },
        ),
      ),
    );
  }
}
