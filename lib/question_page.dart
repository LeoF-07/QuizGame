import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:quiz_game/question.dart';
import 'package:quiz_game/results_page.dart';

import 'boolean_choice_question_page.dart';
import 'main.dart';
import 'multiple_choice_question_page.dart';

// Classe astratta QuestionPage che viene estesa da MultipleChoiceQuestion e BooleanQuestion e implementa alcuni metodi comuni
abstract class QuestionPage extends StatefulWidget {
  const QuestionPage({super.key, required this.title, required this.questionNumber, required this.question, required this.category, required this.difficulty, required this.correctAnswer, required this.incorrectAnswers, required this.questions, required this.corrects, required this.questionPageKeys});

  final String title;
  final int questionNumber;
  final String question;
  final int category;
  final String difficulty;
  final String correctAnswer;
  final List<String> incorrectAnswers;
  final List<Question> questions;
  final List<bool> corrects;
  final List<GlobalKey<QuestionPageState>> questionPageKeys;
}

abstract class QuestionPageState<T extends QuestionPage> extends State<T> {
  late double scale;
  double p(double value) => value * scale;

  late TextStyle stileTitolo;
  late TextStyle stileTesto;

  bool quizEnded = false;

  BoxDecoration decorazioneContainer() {
    return BoxDecoration(
      border: Border.all(color: Colors.black, width: p(2)),
      borderRadius: BorderRadius.circular(p(12)),
    );
  }

  String format(String text){
    /*return text
        .replaceAll("&#039;", "'")
        .replaceAll("&quot;", "\"")
        .replaceAll("&amp;", "&")
        .replaceAll("&eacute;", "é")
        .replaceAll("&egrave", "è")*/

    return HtmlUnescape().convert(text);
  }

  void goToTheNextQuestion(bool guessed) async {
    List<Question> questions = widget.questions;
    int questionNumber = widget.questionNumber + 1;

    List<bool> newCorrects = widget.corrects;
    newCorrects[widget.questionNumber] = guessed;

    if(questionNumber == widget.questions.length){
      Navigator.pushReplacement(
        context,
        MaterialPageRoute<void>(
          builder: (context) => ResultsPage(
              key: UniqueKey(),
              title: 'Results Page',
              questions: questions,
              corrects: newCorrects,
            questionPageKeys: widget.questionPageKeys,
          ),
        ),
      );
    }
    else if(questions[questionNumber].type == "multiple"){
      Navigator.pushReplacement(
        context,
        MaterialPageRoute<void>(
          builder: (context) => MultipleChoiceQuestionPage(
              key: widget.questionPageKeys[questionNumber],
              title: 'Question ${questionNumber + 1}',
              questionNumber: questionNumber,
              question: questions[questionNumber].question,
              category: widget.category,
              difficulty: questions[questionNumber].difficulty,
              correctAnswer: questions[questionNumber].correctAnswer,
              incorrectAnswers: questions[questionNumber].incorrectAnswers,
              questions: questions,
              corrects: newCorrects,
              questionPageKeys: widget.questionPageKeys,
          ),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute<void>(
          builder: (context) => BooleanChoiceQuestionPage(
              key: widget.questionPageKeys[questionNumber],
              title: 'Question ${questionNumber + 1}',
              questionNumber: questionNumber,
              question: questions[questionNumber].question,
              category: widget.category,
              difficulty: questions[questionNumber].difficulty,
              correctAnswer: questions[questionNumber].correctAnswer,
              incorrectAnswers: questions[questionNumber].incorrectAnswers,
              questions: questions,
              corrects: newCorrects,
              questionPageKeys: widget.questionPageKeys,
          ),
        ),
      );
    }
  }

  void askConfirm(){
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Quit"),
          content: Text("Are you sure that you want to quit?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute<void>(
                    builder: (context) => MyHomePage(
                      key: UniqueKey(),
                      title: "Quiz Game",
                    ),
                  ),
                );
              },
              child: Text("YES"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("NO"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}