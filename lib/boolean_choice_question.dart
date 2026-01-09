import 'package:flutter/material.dart';

class BooleanChoiceQuestion extends StatefulWidget {
  const BooleanChoiceQuestion({super.key, required this.title, required this.questionNumber, required this.question, required this.category, required this.difficulty});

  final String title;
  final int questionNumber;
  final String question;
  final String category;
  final String difficulty;

  @override
  State<BooleanChoiceQuestion> createState() => BooleanChoiceQuestionState();
}

class BooleanChoiceQuestionState extends State<BooleanChoiceQuestion> {
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

    return Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              spacing: p(20),
              children: [
                Text(widget.title, style: stileTitolo),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: p(30)),
                    decoration: decorazioneContainer(),
                    child: Padding(
                      padding: EdgeInsets.all(p(10)),
                      child: Text(sistema(widget.question), style: stileTesto),
                    )
                )
              ],
            ),
          ),
        )
    );
  }
}