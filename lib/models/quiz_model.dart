class QuizModel {
  int? id;
  String name;
  int questionNum;
  QuizType type;
  int time;
  bool withTime;

  QuizModel(
      {required this.name,
      required this.questionNum,
      required this.type,
      required this.withTime,
      required this.time, this.id});
}

enum QuizType { oneAnswer, multiAnswers }
