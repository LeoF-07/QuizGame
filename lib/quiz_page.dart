import 'package:flutter/material.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key, required this.title, required this.category, required this.numberOfQuestions, required this.difficulty, required this.type});

  final String title;
  final String category;
  final int numberOfQuestions;
  final String difficulty;
  final String type;

  @override
  State<QuizPage> createState() => QuizPageState();
}

class QuizPageState extends State<QuizPage> {
  TextStyle stileTitolo = TextStyle(fontSize: 40);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 500),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 30),
                  Text(widget.title, style: stileTitolo),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        )
    );
  }
}