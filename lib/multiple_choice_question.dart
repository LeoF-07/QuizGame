import 'dart:math';

import 'package:flutter/material.dart';
import 'package:quiz_game/paths_database.dart';

import 'package:quiz_game/question_page.dart';

// Pagina che pone una domanda a risposta multipla, estende la classe astratta Question
class MultipleChoiceQuestion extends QuestionPage {
  const MultipleChoiceQuestion({super.key, required super.title, required super.questionNumber, required super.question, required super.category, required super.difficulty, required super.correctAnswer, required super.incorrectAnswers, required super.questions, required super.corrects, required super.questionPageKeys});

  @override
  State<MultipleChoiceQuestion> createState() => MutipleChoiceQuestionState();
}

class MutipleChoiceQuestionState extends QuestionPageState<MultipleChoiceQuestion> {
  List<String> shuffledAnswers = [];
  int selectedAnswer = -1;

  bool initialized = false;
  bool submitted = false;

  bool guessed = false;

  void selectAnswer(int i){
    setState(() {
      selectedAnswer = i;
    });
  }

  BoxDecoration decorazioneContainerRisposta(int i){
    return BoxDecoration(
      border: Border.all(color: Colors.black, width: p(2)),
      borderRadius: BorderRadius.circular(p(12)),
      color: (selectedAnswer == i && !submitted) ? Colors.yellow : (selectedAnswer == i && submitted && guessed) ? Colors.green : (selectedAnswer == i && submitted && !guessed) ? Colors.red : (widget.correctAnswer == shuffledAnswers[i] && submitted && !guessed) ? Colors.green : Colors.transparent
    );
  }

  void submit(){
    if(selectedAnswer == -1){
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Select an answer"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("OK"),
              ),
            ],
          );
        },
      );

      return;
    }

    if(shuffledAnswers[selectedAnswer] == widget.correctAnswer){
      guessed = true;
    }
    setState(() {
      submitted = true;
    });
  }

  @override
  void initState() {
    super.initState();

    List<int> indexes = [0, 1, 2, 3];
    List<String> allAnswers = [widget.correctAnswer, ...widget.incorrectAnswers];
    shuffledAnswers = [];
    for(int i = 0; i < 4; i++){
      int index = Random().nextInt(indexes.length);
      shuffledAnswers.add(allAnswers[indexes[index]]);
      indexes.removeAt(index);
    }
    initialized = true;
  }

  @override
  Widget build(BuildContext context) {
    const double baseWidth = 412;
    const double baseHeight = 915;

    final size = MediaQuery.of(context).size;
    final scaleW = size.width / baseWidth;
    final scaleH = size.height / baseHeight;
    super.scale = scaleW < scaleH ? scaleW : scaleH;

    super.stileTitolo = TextStyle(fontSize: p(40));
    super.stileTesto = TextStyle(fontSize: p(18));

    String category = format(widget.questions[widget.questionNumber].category);

    List<GestureDetector> answers = [];
    for(int i = 0; i < 4; i++){
      answers.add(
          GestureDetector(
            onTap: submitted ? null : () => selectAnswer(i),
            child: Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: p(30)),
                decoration: decorazioneContainerRisposta(i),
                child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.all(p(10)),
                      child: Text(format(shuffledAnswers[i]), style: super.stileTesto),
                    )
                )
            ),
          )
      );
    }

    return Scaffold(
          body: SafeArea(
              child: Column(
                spacing: p(20),
                children: [
                  SizedBox(height: 20),
                  SizedBox(
                      width: double.infinity,
                      height: p(100),
                      // Stack che contiene al centro il titolo della domanda mentre a sinistra e a destra con posizioni assolute l'immagine della categoria e della difficoltà
                      child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Positioned(
                              left: p(10),
                              width: p(80),
                              child: Image.asset(PathDatabases.categoriesPaths[PathDatabases.categoriesCorrispondences[category]!]),
                            ),
                            Text(widget.title, style: super.stileTitolo),
                            Positioned(
                              right: p(40),
                              width: p(40),
                              child: Image.asset(PathDatabases.difficultiesPaths[PathDatabases.difficultiesCorrispondences[widget.questions[widget.questionNumber].difficulty]!]),
                            ),
                          ]
                      )
                  ),
                  SizedBox(height: 20),

                  // Contenitore della domanda
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: p(30)),
                      decoration: decorazioneContainer(),
                      child: Padding(
                        padding: EdgeInsets.all(p(10)),
                        child: Text(format(widget.question), style: super.stileTesto),
                      )
                  ),
                  SizedBox(height: 10),

                  // ConstrainedBox per imporre una larghezza minima e un'altezza massima ai GestureDetectors delle risposte
                  // in modo da gestire eventuali overflow con lo scroll
                  ConstrainedBox(
                    constraints: BoxConstraints(minWidth: double.infinity, maxHeight: p(300)),
                    child: SingleChildScrollView(
                        child: Column(
                          spacing: p(20),
                          children: answers,
                        )
                    ),
                  ),
                  SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,

                    // Stack con il pulsante submit al centro e a sinistra e a destra con posizioni assolute il pulsante per tornare alla Home e la freccia alla domanda successiva
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          left: p(30),
                          child: ElevatedButton(
                            onPressed: askConfirm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding: EdgeInsets.symmetric(vertical: p(14)),
                              minimumSize: Size(p(70), p(50)),
                            ),
                            child: Text(
                              "Quit",
                              style: TextStyle(color: Colors.black, fontSize: p(15)),
                            ),
                          ),
                        ),

                        ElevatedButton(
                          onPressed: submitted ? null : submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            padding: EdgeInsets.symmetric(vertical: p(14)),
                            minimumSize: Size(p(100), p(50)),
                          ),
                          child: Text(
                            "Submit",
                            style: TextStyle(color: Colors.white, fontSize: p(15)),
                          ),
                        ),

                        Positioned(
                          left: p(285),
                          child: IconButton(
                            icon: Icon(Icons.arrow_forward, size: p(30), color: submitted ? Colors.black : Colors.transparent,),
                            onPressed: submitted ? () => super.goToTheNextQuestion(guessed) : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
          )
      );
    }
}