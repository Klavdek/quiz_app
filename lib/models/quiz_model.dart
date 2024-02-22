class QuizModel {
  int? id;
  String name;
  int questionNum;
  int time;
  bool withTime;

  QuizModel(
      {required this.name,
      required this.questionNum,
      required this.withTime,
      required this.time, this.id});
}

