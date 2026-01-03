import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quiz_game/question.dart';


/*
  https://opentdb.com/api.php?amount=10

  {
    "response_code":0,
    "results":
      [
        {
          "type":"multiple",
          "difficulty":"hard",
          "category":"Entertainment: Video Games",
          "question":"What Pok&eacute;mon&#039;s Base Stat Total does not change when it evolves?",
          "correct_answer":"Scyther",
          "incorrect_answers":["Pikachu","Sneasel","Larvesta"]
        },
        {
          "type":"multiple",
          "difficulty":"medium",
          "category":"Science: Computers",
          "question":"What does AD stand for in relation to Windows Operating Systems? ",
          "correct_answer":"Active Directory",
          "incorrect_answers":["Alternative Drive","Automated Database","Active Department"]
        },
        {
          "type":"multiple",
          "difficulty":"hard",
          "category":"Entertainment: Board Games",
          "question":"How many rooms are there, not including the hallways and the set of stairs, in the board game &quot;Clue&quot;?","correct_answer":"9","incorrect_answers":["1","6","10"]},{"type":"multiple","difficulty":"easy","category":"General Knowledge","question":"The American company &quot;Campbell&#039;s&quot; is most well known for making what food product?",
          "correct_answer":"Canned soups",
          "incorrect_answers":["Chocolate","Soft drinks","Sausages"]
        },
        {
          "type":"multiple",
          "difficulty":"easy",
          "category":"Geography",
          "question":"Where would you find the &quot;Spanish Steps&quot;?",
          "correct_answer":"Rome, Italy",
          "incorrect_answers":["Barcelona, Spain","Berlin, Germany","London, England"]
        },
        {
          "type":"multiple",
          "difficulty":"medium",
          "category":"Entertainment: Comics",
          "question":"What is the name of the main character in the webcomic Gunnerkrigg Court by Tom Siddell?",
          "correct_answer":"Antimony",
          "incorrect_answers":["Bismuth","Mercury","Cobalt"]
        },
        {
          "type":"boolean",
          "difficulty":"easy",
          "category":"Entertainment: Musicals &amp; Theatres",
          "question":"IMAX stands for Image Maximum.",
          "correct_answer":"True",
          "incorrect_answers":["False"]
        },
        {
          "type":"multiple",
          "difficulty":"medium",
          "category":"Entertainment: Video Games",
          "question":"How many unique items does &quot;Borderlands 2&quot; claim to have?",
          "correct_answer":"87 Bazillion ",
          "incorrect_answers":["87 Million","87 Trillion","87 Gazillion "]},
        {
          "type":"multiple",
          "difficulty":"medium",
          "category":"Geography",
          "question":"How many countries are inside the United Kingdom?",
          "correct_answer":"Four",
          "incorrect_answers":["Two","Three","One"]
        },
        {
          "type":"multiple",
          "difficulty":"easy",
          "category":"Sports",
          "question":"What sport features the terms love, deuce, match and volley?",
          "correct_answer":"Tennis",
          "incorrect_answers":["Cricket","Basketball","Curling"]
        }
      ]
  }


  https://opentdb.com/api.php?amount=10&category=9&difficulty=easy&type=multiple
  https://opentdb.com/api.php?amount=10&type=boolean
*/


class QuizPage extends StatefulWidget {
  const QuizPage({super.key, required this.title, required this.category, required this.numberOfQuestions, required this.difficulty, required this.type});

  final String title;
  final String category;
  final int numberOfQuestions;
  final String difficulty;
  final String type;

  @override
  State<QuizPage> createState() => QuizPageState();
}

class QuizPageState extends State<QuizPage> {
  TextStyle stileTitolo = TextStyle(fontSize: 40);
  List<Question> questions = [];

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

  @override
  void initState() {
    super.initState();
    fetchQuestions().then((_) => startQuiz());
  }

  void startQuiz(){
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    List<Text> domande = [];
    for(int i = 0; i < questions.length; i++){
      domande.add(Text(questions[i].question));
    }

    return Scaffold(
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 500),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 30),
                  Text(widget.title, style: stileTitolo),
                  SizedBox(height: 30),
                  ...domande
                ],
              ),
            ),
          ),
        )
    );
  }
}