import 'package:flutter/material.dart';
import 'package:quiz_game/question.dart';

import 'boolean_choice_question.dart';
import 'multiple_choice_question.dart';

abstract class QuestionPage extends StatefulWidget {
  const QuestionPage({super.key, required this.title, required this.questionNumber, required this.question, required this.category, required this.difficulty, required this.correctAnswer, required this.incorrectAnswers, required this.questions});

  final String title;
  final int questionNumber;
  final String question;
  final String category;
  final String difficulty;
  final String correctAnswer;
  final List<String> incorrectAnswers;
  final List<Question> questions;
}

abstract class QuestionPageState<T extends QuestionPage> extends State<T> {
  late double scale;
  double p(double value) => value * scale;

  late TextStyle stileTitolo;
  late TextStyle stileTesto;

  BoxDecoration decorazioneContainer() {
    return BoxDecoration(
      border: Border.all(color: Colors.black, width: p(2)),
      borderRadius: BorderRadius.circular(p(12)),
    );
  }

  String sistema(String text){
    return text.replaceAll("&#039;", "'").replaceAll("&quot;", "\"").replaceAll("&amp;", "&");
  }

  void goToTheNextQuestion(){
    List<Question> questions = widget.questions;
    int questionNumber = widget.questionNumber + 1;

    if(questions[questionNumber].type == "multiple"){
      Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (context) => MultipleChoiceQuestion(
              key: UniqueKey(),
              title: 'Question ${questionNumber + 1}',
              questionNumber: questionNumber,
              question: questions[questionNumber].question,
              category: questions[questionNumber].category,
              difficulty: questions[questionNumber].difficulty,
              correctAnswer: questions[questionNumber].correctAnswer,
              incorrectAnswers: questions[questionNumber].incorrectAnswers,
              questions: questions
          ),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (context) => BooleanChoiceQuestion(
              key: UniqueKey(),
              title: 'Question ${questionNumber + 1}',
              questionNumber: questionNumber,
              question: questions[questionNumber].question,
              category: questions[questionNumber].category,
              difficulty: questions[questionNumber].difficulty,
              correctAnswer: questions[questionNumber].correctAnswer,
              incorrectAnswers: questions[questionNumber].incorrectAnswers,
              questions: questions
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}