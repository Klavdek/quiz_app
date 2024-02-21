import 'package:flutter/material.dart';
import 'package:quiz_app/database/database_helper.dart';
import 'package:quiz_app/screens/add_quiz_screen.dart';
import 'package:quiz_app/widgets/quiz_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = true;
  late List quizList;

  Future getQuizes() async {
    quizList = await DbHelper().queryQuizList();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getQuizes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Twoje quizy'),
        actions: <Widget>[
          IconButton(
              onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddQuizScreen()))
                  .then((value) async => getQuizes()),
              icon: const Icon(Icons.add)),
        ],
      ),
      body: isLoading
          ? const CircularProgressIndicator()
          : ListView.builder(
              itemCount: quizList.length,
              itemBuilder: (context, index) => QuizWidget(
                quiz: quizList[index],
                getQuizes: getQuizes,
              ),
            ),
    );
  }
}
