import 'package:flutter/material.dart';
import 'package:quiz_game/quiz_page.dart';

class SetupPage extends StatefulWidget {
  const SetupPage({super.key, required this.title, required this.category});

  final String title;
  final String category;

  @override
  State<SetupPage> createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  TextStyle stileTitolo = TextStyle(fontSize: 40);
  TextStyle stileTesto = TextStyle(fontSize: 18);

  int numeroDomande = 10;
  String difficulty = "";
  String type = "";

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

  void goToQuizPage() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizPage(
            key: UniqueKey(),
            title: 'Quiz',
            category: widget.category,
            numberOfQuestions: numeroDomande,
            difficulty: difficulty,
            type: type
        ),
      ),
    );
  }

  BoxDecoration decorazioneSelettori() {
    return BoxDecoration(
      border: Border.all(color: Colors.black, width: 2),
      borderRadius: BorderRadius.circular(12),
    );
  }

  Container selettoreNumeroDomande() {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(horizontal: 30),
      decoration: decorazioneSelettori(),
      child: Column(
        children: [
          Text("Number of Questions (5 - 20)", style: stileTesto),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: decrementNumberOfQuestions,
                child: const Icon(Icons.arrow_drop_down, size: 40),
              ),
              Text("$numeroDomande", style: stileTesto),
              GestureDetector(
                onTap: incrementNumberOfQuestions,
                child: const Icon(Icons.arrow_drop_up, size: 40),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container selettoreDifficolta() {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(horizontal: 30),
      decoration: decorazioneSelettori(),
      child: Column(
        children: [
          Text("Difficulty", style: stileTesto),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              pulsanteDifficolta("easy", "images/difficulties/easy.png"),
              SizedBox(width: 10),
              pulsanteDifficolta("medium", "images/difficulties/medium.png"),
              SizedBox(width: 10),
              pulsanteDifficolta("hard", "images/difficulties/hard.png"),
            ],
          ),
        ],
      ),
    );
  }

  GestureDetector pulsanteDifficolta(String valore, String path) {
    return GestureDetector(
      onTap: () => setState(() => difficulty = valore),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: difficulty == valore ? Colors.green : Colors.transparent,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Image.asset(path, width: 40),
      ),
    );
  }

  Container selettoreTipo() {
    return Container(
      padding: EdgeInsets.all(16),
      width: 500,
      margin: EdgeInsets.symmetric(horizontal: 30),
      decoration: decorazioneSelettori(),
      child: Column(
        children: [
          Text("Type", style: stileTesto),
          SizedBox(height: 10),
          pulsanteTipo("all", "All type"),
          SizedBox(height: 10),
          pulsanteTipo("multiple", "Multiple choice"),
          SizedBox(height: 10),
          pulsanteTipo("boolean", "True or False"),
        ],
      ),
    );
  }

  GestureDetector pulsanteTipo(String valore, String testo) {
    return GestureDetector(
      onTap: () => setState(() => type = valore),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 2),
          borderRadius: BorderRadius.circular(12),
          color: type == valore ? Colors.green : Colors.transparent,
        ),
        child: Text(testo),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              left: 7,
              top: 35,
              child: IconButton(
                icon: Icon(Icons.arrow_back, size: 30),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 500),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 30),
                    Text(widget.title, style: stileTitolo),
                    SizedBox(height: 30),

                    selettoreNumeroDomande(),
                    SizedBox(height: 20),
                    selettoreDifficolta(),
                    SizedBox(height: 20),
                    selettoreTipo(),
                    SizedBox(height: 40),

                    SizedBox(
                      width: 220,
                      child: ElevatedButton(
                        onPressed: goToQuizPage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text(
                          "Start Quiz",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        )
      ),
    );
  }
}
