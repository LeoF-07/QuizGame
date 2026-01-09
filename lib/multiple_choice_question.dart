import 'dart:math';

import 'package:flutter/material.dart';

import 'package:quiz_game/question_page.dart';

class MultipleChoiceQuestion extends QuestionPage {
  const MultipleChoiceQuestion({super.key, required super.title, required super.questionNumber, required super.question, required super.category, required super.difficulty, required super.correctAnswer, required super.incorrectAnswers, required super.questions});

  @override
  State<MultipleChoiceQuestion> createState() => MutipleChoiceQuestionState();
}

class MutipleChoiceQuestionState extends QuestionPageState<MultipleChoiceQuestion> {
  List<String> shuffledAnswers = [];
  int selectedAnswer = -1;

  bool initialized = false;

  void selectAnswer(int i){
    setState(() {
      selectedAnswer = i;
    });
  }

  BoxDecoration decorazioneContainerRisposta(int i){
    return BoxDecoration(
      border: Border.all(color: Colors.black, width: p(2)),
      borderRadius: BorderRadius.circular(p(12)),
      color: selectedAnswer == i ? Colors.yellow : Colors.transparent
    );
  }

  void initialize(){
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

    if(!initialized) {
      initialize();
    }

    List<GestureDetector> answers = [];

    for(int i = 0; i < 4; i++){
      answers.add(
          GestureDetector(
            onTap: () => selectAnswer(i),
            child: Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: p(30)),
                decoration: decorazioneContainerRisposta(i),
                child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.all(p(10)),
                      child: Text(shuffledAnswers[i], style: super.stileTesto),
                    )
                )
            ),
          )
      );
    }

    return Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              spacing: p(20),
              children: [
                SizedBox(height: 30),
                Text(widget.title, style: super.stileTitolo),
                SizedBox(height: 20),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: p(30)),
                    decoration: decorazioneContainer(),
                    child: Padding(
                      padding: EdgeInsets.all(p(10)),
                      child: Text(sistema(widget.question), style: super.stileTesto),
                    )
                  ),
                  SizedBox(height: 30),
                ...answers,
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: p(20),
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, size: p(30)),
                      onPressed: () => Navigator.pop(context),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: EdgeInsets.symmetric(vertical: p(14)),
                          minimumSize: Size(p(100), p(50))
                      ),
                      child: Text(
                        "Submit",
                        style: TextStyle(color: Colors.white, fontSize: p(15)),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.arrow_forward, size: p(30)),
                      onPressed: super.goToTheNextQuestion,
                    ),
                  ],
                )
              ],
            ),
          ),
        )
      );
    }
}