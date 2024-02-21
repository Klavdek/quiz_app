class QuestionModel {
  final int? id;
  final int idQuiz;
  final String question;
  final String answer;

  QuestionModel({
    this.id,
    required this.idQuiz,
    required this.question,
    required this.answer,
  });
}
