// Light-green: Color(0xD1CEFFC3)
// Light-red: Color(0xD1FFC3C3)

import 'package:flutter/material.dart';

import 'package:quiz_game/question_page.dart';

class BooleanChoiceQuestion extends QuestionPage {
  const BooleanChoiceQuestion({super.key, required super.title, required super.questionNumber, required super.question, required super.category, required super.difficulty, required super.correctAnswer, required super.incorrectAnswers, required super.questions, required super.corrects, required super.questionPageKeys});

  @override
  State<BooleanChoiceQuestion> createState() => BooleanChoiceQuestionState();
}

class BooleanChoiceQuestionState extends QuestionPageState<BooleanChoiceQuestion> {
  String selectedAnswer = "";
  bool submitted = false;
  bool guessed = false;

  void selectAnswer(String i){
    setState(() {
      selectedAnswer = i;
    });
  }

  void submit(){
    if(selectedAnswer == widget.correctAnswer){
      guessed = true;
    }
    setState(() {
      submitted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    const double baseWidth = 412;
    const double baseHeight = 915;

    final size = MediaQuery.of(context).size;
    final scaleW = size.width / baseWidth;
    final scaleH = size.height / baseHeight;
    super.scale = scaleW < scaleH ? scaleW : scaleH;

    stileTitolo = TextStyle(fontSize: p(40));
    stileTesto = TextStyle(fontSize: p(18));

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
                RawMaterialButton(
                    onPressed: () => selectAnswer("True"),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: p(2)),
                        borderRadius: BorderRadius.circular(p(12)),
                        color: (selectedAnswer == "True" && !submitted) ? Colors.yellow : (selectedAnswer == "True" && submitted && guessed) ? Color(0xD1CEFFC3) : (selectedAnswer == "True" && submitted && !guessed) ? Color(0xD1FFC3C3) : (widget.correctAnswer == "True" && submitted && !guessed) ? Color(0xD1CEFFC3) : Colors.transparent
                      ),
                      child: Image.asset("images/symbols/true.png", width: p(100))
                    )
                ),
                RawMaterialButton(
                    onPressed: () => selectAnswer("False"),
                    child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: p(2)),
                          borderRadius: BorderRadius.circular(p(12)),
                          color: (selectedAnswer == "False" && !submitted) ? Colors.yellow : (selectedAnswer == "False" && submitted && guessed) ? Color(0xD1CEFFC3) : (selectedAnswer == "False" && submitted && !guessed) ? Color(0xD1FFC3C3) : (widget.correctAnswer == "False" && submitted && !guessed) ? Color(0xD1CEFFC3) : Colors.transparent
                        ),
                        child: Image.asset("images/symbols/false.png", width: p(100))
                    )
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: p(20),
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, size: p(30), color: Colors.transparent),
                      onPressed: () {},
                    ),
                    ElevatedButton(
                      onPressed: submit,
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
                      icon: Icon(Icons.arrow_forward, size: p(30), color: submitted ? Colors.black : Colors.transparent),
                      onPressed: submitted ? () => super.goToTheNextQuestion(guessed) : null
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