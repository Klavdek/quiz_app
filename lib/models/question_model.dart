class QuestionModel {
  final int? id;
  final int idQuiz;
  final QuestionType type;
  final String question;
  final bool? answerBool;
  final String? correctAnswer;
  final String? answer2;
  final String? answer3;
  final String? answer4;

  QuestionModel({
    this.id,
    required this.idQuiz,
    required this.type,
    required this.question,
    this.answerBool,
    this.correctAnswer,
    this.answer2,
    this.answer3,
    this.answer4,
  });
}

enum QuestionType { oneAnswer, trueOrFalse ,multiAnswers }
