import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:quiz_game/main.dart';
import 'package:quiz_game/paths_database.dart';
import 'package:quiz_game/question.dart';
import 'package:quiz_game/question_page.dart';

// Pagina dei risultati a cui si viene reindirizzati alla fine del quiz
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

  String format(String text){
    return HtmlUnescape().convert(text);
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
      String category = format(widget.questions[i].category);
      String difficulty = widget.questions[i].difficulty;

      // Lista di questions
      // Ogni question è una riga che contiene il numero della domanda, l'immagine della categoria,
      // l'immagine della diffcoltà e l'indicatore se è stata indovinata o no
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
          // Stack che contiene la colonna principale e il pulsante di ritorno alla HomePage in posizione assoluta rispetto alla pagina
          child: Stack(
            alignment: Alignment.center,
            children:[
              Column(
                spacing: p(20),
                children: [
                  // Titolo
                  Padding(
                    padding: EdgeInsets.all(p(20)),
                    child: Text(widget.title, style: stileTitolo),
                  ),
                  Column(
                    children: [
                      Text("You achieved a score of", style: stileTesto),
                      Text("$punteggio/${widget.questions.length}", style: stileTesto),
                    ],
                  ),

                  // ConstrainedBox che impone una altezza massima alla colonna dei risultati che viene poi gestita con lo scroll
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