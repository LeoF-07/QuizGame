import 'package:flutter/material.dart';
import 'package:quiz_game/boolean_choice_question.dart';
import 'package:quiz_game/main.dart';
import 'package:quiz_game/path_databases.dart';
import 'package:quiz_game/question.dart';
import 'package:quiz_game/question_page.dart';

import 'multiple_choice_question.dart';

class ResultsPage extends StatefulWidget {
  const ResultsPage({super.key, required this.title, required this.questions, required this.corrects, required this.questionPageKeys});

  final String title;
  final List<Question> questions;
  final List<bool> corrects;
  final List<GlobalKey<QuestionPageState>> questionPageKeys;

  @override
  State<ResultsPage> createState() => ResultsPageState();
}

class ResultsPageState extends State<ResultsPage> {
  late double scale;
  double p(double value) => value * scale;

  late TextStyle stileTitolo;
  late TextStyle stileTesto;
  late TextStyle stileVoce;

  int punteggio = 0;

  String sistema(String text){
    return text.replaceAll("&#039;", "'").replaceAll("&quot;", "\"").replaceAll("&amp;", "&");
  }

  @override
  void initState() {
    for(bool correct in widget.corrects){
      if(correct){
        punteggio++;
      }
    }
    super.initState();
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
    stileTesto = TextStyle(fontSize: p(25));
    stileVoce = TextStyle(fontSize: p(20));
    
    List<Row> questions = [];
    for(int i = 0; i < widget.questions.length; i++){
      String category = sistema(widget.questions[i].category);
      String difficulty = widget.questions[i].difficulty;

      questions.add(
        Row(
          spacing: p(20),
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("Question ${i + 1}", style: stileVoce),
            Image.asset(PathDatabases.categoriesPaths[PathDatabases.categoriesCorrispondences[category]!], width: p(40)),
            Image.asset(PathDatabases.difficultiesPaths[PathDatabases.difficultiesCorrispondences[difficulty]!], width: p(25)),
            Image.asset(widget.corrects[i] ? "images/symbols/true.png" : "images/symbols/false.png", width: p(30)),
          ],
        )
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children:[
              Column(
                spacing: p(20),
                children: [
                  Padding(
                    padding: EdgeInsets.all(p(20)),
                    child: Text(widget.title, style: stileTitolo),
                  ),
                  Column(
                    children: [
                      Text("Hai totalizzato un punteggio di", style: stileTesto),
                      Text("$punteggio/${widget.questions.length}", style: stileTesto),
                    ],
                  ),
                  ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: p(500)),
                      child: Container(
                        padding: EdgeInsets.all(p(30)),
                        margin: EdgeInsets.symmetric(horizontal: p(30)),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: p(2)),
                          borderRadius: BorderRadius.circular(p(12)),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            spacing: p(10),
                            children: questions,
                          ),
                        ),
                      )
                  ),
                ]
              ),
              Positioned(
                bottom: p(40),
                child: ElevatedButton(
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
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(vertical: p(14)),
                      minimumSize: Size(p(200), p(50))
                  ),
                  child: Text(
                    "Return to Home Page",
                    style: TextStyle(color: Colors.white, fontSize: p(15)),
                  ),
                ),
              )
            ]
          ),
        ),
      ),
    );
  }
}