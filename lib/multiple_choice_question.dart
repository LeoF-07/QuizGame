import 'dart:math';

import 'package:flutter/material.dart';

class MutipleChoiceQuestion extends StatefulWidget {
  const MutipleChoiceQuestion({super.key, required this.title, required this.questionNumber, required this.question, required this.category, required this.difficulty, required this.correctAnswer, required this.incorrectAnswers});

  final String title;
  final int questionNumber;
  final String question;
  final String category;
  final String difficulty;
  final String correctAnswer;
  final List<String> incorrectAnswers;

  @override
  State<MutipleChoiceQuestion> createState() => MutipleChoiceQuestionState();
}

class MutipleChoiceQuestionState extends State<MutipleChoiceQuestion> {
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
    return text.replaceAll("&#039;", "'").replaceAll("&quot;", "\"");
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
    stileTesto = TextStyle(fontSize: p(18));

    List<Container> answers = [];
    List<int> indexes = [0, 1, 2, 3];
    widget.incorrectAnswers.add(widget.correctAnswer);
    for(int i = 0; i < 4; i++){
      int index = Random().nextInt(indexes.length);
      answers.add(
        Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: p(30)),
          decoration: decorazioneContainer(),
          child: Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.all(p(10)),
              child: Text(widget.incorrectAnswers[indexes[index]], style: stileTesto),
            )
          )
        )
      );
      indexes.remove(index);
    }

    return Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              spacing: p(20),
              children: [
                SizedBox(height: 30),
                Text(widget.title, style: stileTitolo),
                SizedBox(height: 20),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: p(30)),
                    decoration: decorazioneContainer(),
                    child: Padding(
                      padding: EdgeInsets.all(p(10)),
                      child: Text(sistema(widget.question), style: stileTesto),
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
                    /*ElevatedButton(
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
                    ),*/
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
                    /*ElevatedButton(
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
                    ),*/
                    IconButton(
                      icon: Icon(Icons.arrow_back, size: p(30)),
                      onPressed: () => Navigator.pop(context),
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