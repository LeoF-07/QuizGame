import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quiz_game/paths_database.dart';
import 'package:quiz_game/question.dart';
import 'package:quiz_game/question_page.dart';

import 'boolean_choice_question_page.dart';
import 'multiple_choice_question_page.dart';

// Pagina di setup in cui si impostano le preferenze del quiz e lo si avvia
class SetupPage extends StatefulWidget {
  const SetupPage({super.key, required this.title, required this.category});

  final String title;
  final int category;

  @override
  State<SetupPage> createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  late double scale;
  double p(double value) => value * scale;

  late TextStyle stileTitolo;
  late TextStyle stileTesto;

  int questionsNumber = 10;
  bool randomNumber = false;
  String difficulty = "";
  String type = "";

  List<Question> questions = [];
  int questionNumber = 0;

  String startButtonText = "Start Quiz";

  void decrementNumberOfQuestions() {
    if (questionsNumber > 5) {
      setState(() => questionsNumber--);
    }
  }

  void incrementNumberOfQuestions() {
    if (questionsNumber < 20) {
      setState(() => questionsNumber++);
    }
  }

  Future<void> fetchQuestions(int questionsNumber) async {
    final response = await http.get(
      Uri.parse('https://opentdb.com/api.php?amount=$questionsNumber${widget.category == 0 ? '' : '&category=${widget.category}'}${difficulty == "" ? '' : '&difficulty=$difficulty'}${type == "all" ? '' : '&type=$type'}'),
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
    if(type == ""){
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Select a Type"),
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

    setState(() {
      startButtonText = "Loading...";
    });

    int questionsNumber = this.questionsNumber;
    if(randomNumber){
      questionsNumber = 5 + Random().nextInt(16);
    }

    await fetchQuestions(questionsNumber);

    List<GlobalKey<QuestionPageState>> questionPageKeys = [];
    List<bool> corrects = [];

    for(int i = 0; i < questions.length; i++){
      questionPageKeys.add(GlobalKey<QuestionPageState>());
      corrects.add(false);
    }

    if(questions[questionNumber].type == "multiple"){
      Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (context) => MultipleChoiceQuestionPage(
            key: questionPageKeys[questionNumber],
            title: 'Question ${questionNumber + 1}',
            questionNumber: questionNumber,
            question: questions[questionNumber].question,
            category: widget.category,
            difficulty: questions[questionNumber].difficulty,
            correctAnswer: questions[questionNumber].correctAnswer,
            incorrectAnswers: questions[questionNumber].incorrectAnswers,
            questions: questions,
            corrects: corrects,
            questionPageKeys: questionPageKeys,
          ),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (context) => BooleanChoiceQuestionPage(
            key: questionPageKeys[questionNumber],
            title: 'Question ${questionNumber + 1}',
            questionNumber: questionNumber,
            question: questions[questionNumber].question,
            category: widget.category,
            difficulty: questions[questionNumber].difficulty,
            correctAnswer: questions[questionNumber].correctAnswer,
            incorrectAnswers: questions[questionNumber].incorrectAnswers,
            questions: questions,
            corrects: corrects,
            questionPageKeys: questionPageKeys,
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
        child: Column(
          spacing: p(20),
          children: [
            SizedBox(height: 20),
            SizedBox(
                width: double.infinity,
                child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // IconButton per tornare alla pagina principale con posizione assoluta
                      Positioned(
                        left: p(20),
                        child: IconButton(
                          icon: Icon(Icons.arrow_back, size: p(30)),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      // Titolo
                      Text(widget.title, style: stileTitolo),
                    ]
                )
            ),
            SizedBox(height: p(10)),


            // Selettori
            selettoreNumeroDomande(),
            selettoreDifficolta(),
            selettoreTipo(),

            SizedBox(height: p(10)),

            // Pulsante di avvio del quiz
            ElevatedButton(
              onPressed: startQuiz,
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(vertical: p(14)),
                  minimumSize: Size(p(200), p(50))
              ),
              child: Text(
                startButtonText,
                style: TextStyle(color: Colors.white, fontSize: p(15)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container selettoreNumeroDomande() {
    return Container(
        padding: EdgeInsets.all(p(16)),
        margin: EdgeInsets.symmetric(horizontal: p(30)),
        decoration: decorazioneSelettori(),
        child: Stack(
          children: [
            // Colonna con il testo del selettore e la riga con le icone per la selezione del numero di domande
            // Le icone sono racchiuse in un GestureDetector e non in un IconButton solamente perché gli IconButton hanno un padding/margine strano
            Column(
              children: [
                Text("Number of Questions (5 - 20)", style: stileTesto),
                SizedBox(height: p(10)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: randomNumber ? null : decrementNumberOfQuestions,
                      child: Icon(Icons.arrow_drop_down, size: p(40)),
                    ),
                    Text("$questionsNumber", style: stileTesto),
                    GestureDetector(
                      onTap: randomNumber ? null : incrementNumberOfQuestions,
                      child: Icon(Icons.arrow_drop_up, size: p(40)),
                    ),
                  ],
                ),
              ],
            ),

            // Pulsante "Random" in posizione assoluta rispetto al selettore
            Positioned(
              bottom: p(0),
              right: p(0),
              child: GestureDetector(
                  onTap: () {setState(() {
                    randomNumber = !randomNumber;
                  });},
                  child: Container(
                      padding: EdgeInsets.symmetric(horizontal: p(16), vertical: p(8)),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: p(2)),
                          borderRadius: BorderRadius.circular(p(12)),
                          color: randomNumber ? Colors.green : Colors.transparent
                      ),
                      child: Text("Random")
                  )
              ),
            )
          ],
        )
    );
  }

  Container selettoreDifficolta() {
    return Container(
      padding: EdgeInsets.all(p(16)),
      margin: EdgeInsets.symmetric(horizontal: p(30)),
      decoration: decorazioneSelettori(),
      // Colonna con il testo del selettore e una riga con i 3 pulsanti delle difficoltà
      child: Column(
        children: [
          Text("Difficulty (optional)", style: stileTesto),
          SizedBox(height: p(10)),
          Row(
            spacing: p(10),
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              pulsanteDifficolta("easy", PathDatabases.difficultiesPaths[0]),
              pulsanteDifficolta("medium", PathDatabases.difficultiesPaths[1]),
              pulsanteDifficolta("hard", PathDatabases.difficultiesPaths[2]),
            ],
          ),
        ],
      ),
    );
  }

  GestureDetector pulsanteDifficolta(String valore, String path) {
    return GestureDetector(
      onTap: () => setState(() {
        if(difficulty == valore){
          difficulty = "";
        }
        else {
          difficulty = valore;
        }
      }),
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
      // Colonna con il testo del selettore e i 3 pulsanti del tipo
      child: Column(
        spacing: p(10),
        children: [
          Text("Type", style: stileTesto),
          pulsanteTipo("all", "Mix"),
          pulsanteTipo("multiple", "Multiple choice"),
          pulsanteTipo("boolean", "True or False"),
        ],
      ),
    );
  }

  GestureDetector pulsanteTipo(String valore, String testo) {
    return GestureDetector(
      onTap: () => setState(() {
        if(type == valore){
          type = "";
        }
        else {
          type = valore;
        }
      }),
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

}
