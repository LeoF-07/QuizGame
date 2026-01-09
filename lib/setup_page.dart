import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quiz_game/question.dart';

import 'boolean_choice_question.dart';
import 'multiple_choice_question.dart';

class SetupPage extends StatefulWidget {
  const SetupPage({super.key, required this.title, required this.category});

  final String title;
  final String category;

  @override
  State<SetupPage> createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  late double scale;
  double p(double value) => value * scale;

  late TextStyle stileTitolo;
  late TextStyle stileTesto;

  int numeroDomande = 10;
  String difficulty = "";
  String type = "";

  List<Question> questions = [];
  int questionNumber = 0;

  void decrementNumberOfQuestions() {
    if (numeroDomande > 5) {
      setState(() => numeroDomande--);
    }
  }

  void incrementNumberOfQuestions() {
    if (numeroDomande < 20) {
      setState(() => numeroDomande++);
    }
  }

  Future<void> fetchQuestions() async {
    final response = await http.get(
      Uri.parse('https://opentdb.com/api.php?amount=2'),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final results = json['results'] as List<dynamic>;

      for (final singleQuestion in results) {
        final question = Question.fromJson(singleQuestion as Map<String, dynamic>);
        questions.add(question);
      }
    } else {
      throw Exception('Failed to load questions');
    }
  }

  void startQuiz() async {
    await fetchQuestions();

    if(questions[questionNumber].type == "multiple"){
      Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (context) => MutipleChoiceQuestion(
            key: UniqueKey(),
            title: 'Question $questionNumber',
            questionNumber: questionNumber,
            question: questions[questionNumber].question,
            category: questions[questionNumber].category,
            difficulty: questions[questionNumber].difficulty,
            correctAnswer: questions[questionNumber].correctAnswer,
            incorrectAnswers: questions[questionNumber].incorrectAnswers
          ),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (context) => BooleanChoiceQuestion(
            key: UniqueKey(),
            title: 'Question $questionNumber',
            questionNumber: questionNumber,
            question: questions[questionNumber].question,
            category: questions[questionNumber].category,
            difficulty: questions[questionNumber].difficulty,
          ),
        ),
      );
    }
  }

  BoxDecoration decorazioneSelettori() {
    return BoxDecoration(
      border: Border.all(color: Colors.black, width: p(2)),
      borderRadius: BorderRadius.circular(p(12)),
    );
  }

  Container selettoreNumeroDomande() {
    return Container(
      padding: EdgeInsets.all(p(16)),
      margin: EdgeInsets.symmetric(horizontal: p(30)),
      decoration: decorazioneSelettori(),
      child: Column(
        children: [
          Text("Number of Questions (5 - 20)", style: stileTesto),
          SizedBox(height: p(10)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: decrementNumberOfQuestions,
                child: Icon(Icons.arrow_drop_down, size: p(40)),
              ),
              Text("$numeroDomande", style: stileTesto),
              GestureDetector(
                onTap: incrementNumberOfQuestions,
                child: Icon(Icons.arrow_drop_up, size: p(40)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container selettoreDifficolta() {
    return Container(
      padding: EdgeInsets.all(p(16)),
      margin: EdgeInsets.symmetric(horizontal: p(30)),
      decoration: decorazioneSelettori(),
      child: Column(
        children: [
          Text("Difficulty", style: stileTesto),
          SizedBox(height: p(10)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              pulsanteDifficolta("easy", "images/difficulties/easy.png", p),
              SizedBox(width: p(10)),
              pulsanteDifficolta("medium", "images/difficulties/medium.png", p),
              SizedBox(width: p(10)),
              pulsanteDifficolta("hard", "images/difficulties/hard.png", p),
            ],
          ),
        ],
      ),
    );
  }

  GestureDetector pulsanteDifficolta(String valore, String path, double Function(double) p) {
    return GestureDetector(
      onTap: () => setState(() => difficulty = valore),
      child: Container(
        padding: EdgeInsets.all(p(16)),
        decoration: BoxDecoration(
          border: Border.all(
            color: difficulty == valore ? Colors.green : Colors.transparent,
            width: p(2),
          ),
          borderRadius: BorderRadius.circular(p(12)),
        ),
        child: Image.asset(path, width: p(40)),
      ),
    );
  }

  Container selettoreTipo() {
    return Container(
      padding: EdgeInsets.all(p(16)),
      width: p(350),
      margin: EdgeInsets.symmetric(horizontal: p(30)),
      decoration: decorazioneSelettori(),
      child: Column(
        children: [
          Text("Type", style: stileTesto),
          SizedBox(height: p(10)),
          pulsanteTipo("all", "All type"),
          SizedBox(height: p(10)),
          pulsanteTipo("multiple", "Multiple choice"),
          SizedBox(height: p(10)),
          pulsanteTipo("boolean", "True or False"),
        ],
      ),
    );
  }

  GestureDetector pulsanteTipo(String valore, String testo) {
    return GestureDetector(
      onTap: () => setState(() => type = valore),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: p(16), vertical: p(8)),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: p(2)),
          borderRadius: BorderRadius.circular(p(12)),
          color: type == valore ? Colors.green : Colors.transparent,
        ),
        child: Text(testo),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const double baseWidth = 412;
    const double baseHeight = 915;

    final size = MediaQuery.of(context).size;
    final scaleW = size.width / baseWidth;
    final scaleH = size.height / baseHeight;
    scale = scaleW < scaleH ? scaleW : scaleH;

    stileTitolo = TextStyle(fontSize: p(40));
    stileTesto = TextStyle(fontSize: p(22));

    return Scaffold(
      body: SafeArea(
          child: Stack(
            children: [
              Positioned(
                left: p(7),
                top: p(35),
                child: IconButton(
                  icon: Icon(Icons.arrow_back, size: p(30)),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              Center(
                child: Column(
                  spacing: p(20),
                  children: [
                    SizedBox(height: p(20)),
                    Text(widget.title, style: stileTitolo),
                    SizedBox(height: p(10)),

                    selettoreNumeroDomande(),
                    selettoreDifficolta(),
                    selettoreTipo(),

                    SizedBox(height: p(10)),

                    ElevatedButton(
                      onPressed: startQuiz,
                      style: ElevatedButton.styleFrom(
                         backgroundColor: Colors.black,
                         padding: EdgeInsets.symmetric(vertical: p(14)),
                         minimumSize: Size(p(200), p(50))
                      ),
                      child: Text(
                        "Start Quiz",
                        style: TextStyle(color: Colors.white, fontSize: p(15)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
      ),
    );
  }
}
