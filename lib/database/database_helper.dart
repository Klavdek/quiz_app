import 'package:quiz_app/models/question_model.dart';
import 'package:quiz_app/models/quiz_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbHelper {
  final String databaseName = 'quizDB.db';
  final String id = '_id';

  final String quizList = 'quizlist';
  final String name = 'name';
  final String questionNum = 'questionnum';
  final String withTime = 'withtime';
  final String time = 'time';

  final String questionList = 'questionlist';
  final String idQuiz = 'idquiz';
  final String type = 'type';
  final String question = 'question';
  final String answerBool = 'truefalse';
  final String correctAnswer = 'answer';
  final String answer2 = 'answer2';
  final String answer3 = 'answer3';
  final String answer4 = 'answer4';

  late Database _db;

  Future<void> init() async {
    final documentesDirectory = await getDatabasesPath();
    final databasePath = join(documentesDirectory, databaseName);
    _db = await openDatabase(databasePath, onCreate: onCreate, version: 1);
  }

  Future onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $quizList (
            $id INTEGER PRIMARY KEY,
            $name TEXT NOT NULL,
            $questionNum INTEGER NOT NULL,
            $withTime INTEGER NOT NULL,
            $time INTEGER NOT NULL
          )
          ''');
    await db.execute('''
          CREATE TABLE $questionList (
            $id INTEGER PRIMARY KEY,
            $idQuiz INTEGER NOT NULL,
            $type TEXT NOT NULL,
            $question TEXT NOT NULL,
            $answerBool INTEGER,
            $correctAnswer TEXT,
            $answer2 TEXT,
            $answer3 TEXT,
            $answer4 TEXT
          )
          ''');
  }

//QUIZ
  Future<int> insertQuiz(QuizModel quiz) async {
    Map<String, dynamic> row = {
      name: quiz.name,
      questionNum: quiz.questionNum,
      // type: quiz.type == QuizType.oneAnswer ? 'oneAnswer' : 'multiAnswers',
      withTime: quiz.withTime ? 1 : 0,
      time: quiz.time
    };
    await init();
    return await _db.insert(quizList, row);
  }

  Future<List<QuizModel>> queryQuizList() async {
    await init();
    List listRow = await _db.query(quizList);
    List<QuizModel> quizes = [];
    for (var element in listRow) {
      final quiz = QuizModel(
          id: element[id],
          name: element[name],
          questionNum: element[questionNum],
          withTime: element[withTime] == 1 ? true : false,
          time: element[time]);
      quizes.add(quiz);
    }
    return quizes;
  }

  Future<QuizModel> queryQuiz(int passId) async {
    await init();
    List listRow = await _db.query(
      quizList,
      where: '"_id" = ?',
      whereArgs: [passId],
    );
    QuizModel quiz = QuizModel(
        id: listRow[0][id],
        name: listRow[0][name],
        questionNum: listRow[0][questionNum],
        withTime: listRow[0][withTime] == 1 ? true : false,
        time: listRow[0][time]);
    return quiz;
  }

  Future<int> deleteQuiz(int passId) async {
    await init();
    await _db.delete(
      questionList,
      where: '$idQuiz = ?',
      whereArgs: [passId],
    );
    return await _db.delete(
      quizList,
      where: '$id = ?',
      whereArgs: [passId],
    );
  }

  //QUESTIONS
  Future<int> insertQuestion(QuestionModel quest) async {
    Map<String, dynamic> row = {
      idQuiz: quest.idQuiz,
      type: quest.type == QuestionType.oneAnswer
          ? 'oneAnswer'
          : quest.type == QuestionType.trueOrFalse
              ? 'trueOrFalse'
              : 'multiAnswers',
      question: quest.question,
      answerBool: quest.answerBool == true ? 1 : 0,
      correctAnswer: quest.correctAnswer,
    };
    await init();
    List num = await _db.query(
      quizList,
      columns: [questionNum],
      where: '"_id" = ?',
      whereArgs: [quest.idQuiz],
    );
    await _db.update(
      quizList,
      {questionNum: num[0][questionNum] + 1},
      where: '$id = ?',
      whereArgs: [quest.idQuiz],
    );
    return await _db.insert(questionList, row);
  }

  Future<List<QuestionModel>> queryQuestionList(int passId) async {
    await init();
    List listRow = await _db
        .query(questionList, where: '$idQuiz = ?', whereArgs: [passId]);
    List<QuestionModel> questions = []; //zamienić na .map
    for (var element in listRow) {
      final quiz = QuestionModel(
        id: element[id],
        idQuiz: element[idQuiz],
        type: element[type] == 'oneAnswer'
            ? QuestionType.oneAnswer
            : element[type] == 'trueOrFalse'
                ? QuestionType.trueOrFalse
                : QuestionType.multiAnswers,
        answerBool: element[answerBool] == 1 ? true : false,
        question: element[question],
        correctAnswer: element[correctAnswer],
      );
      questions.add(quiz);
    }
    return questions;
  }

  Future<int> deleteQuestion(int idQuestion) async {
    await init();
    List num = await _db.query(
      quizList,
      columns: [questionNum],
      where: '"_id" = ?',
      whereArgs: [idQuestion],
    );
    await _db.update(
      quizList,
      {questionNum: num[0][questionNum] - 1},
      where: '$id = ?',
      whereArgs: [idQuestion],
    );
    return await _db.delete(
      questionList,
      where: '$id = ?',
      whereArgs: [idQuestion],
    );
  }
}
