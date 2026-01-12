// Classe Question, è la classe della domanda con tutti i suoi attributi e il metodo factory che la istanzia a partire da un json
class Question {

  final String type;
  final String difficulty;
  final String category;
  final String question;
  final String correctAnswer;
  final List<String> incorrectAnswers;

  const Question({required this.type, required this.difficulty, required this.category, required this.question, required this.correctAnswer, required this.incorrectAnswers});

  factory Question.fromJson(Map<String, dynamic> json) {
    /*return switch (json) {
      {
        'type': String type,
        'difficulty': String difficulty,
        'category': String category,
        'question': String question,
        'correct_answer': String correctAnswer,
        'incorrect_answers': List<String> incorrectAnswers
      } => Question(
        type: type,
        difficulty: difficulty,
        category: category,
        question: question,
        correctAnswer: correctAnswer,
        incorrectAnswers: incorrectAnswers
      ),
      _ => throw const FormatException('Failed to load question')
    };*/

    // È necessario prelevare i dati dal json in questo modo per far si che la lista delle risposte sbagliate venga interpretata correttamente
    return Question(
      type: json['type'] as String,
      difficulty: json['difficulty'] as String,
      category: json['category'] as String,
      question: json['question'] as String,
      correctAnswer: json['correct_answer'] as String,
      incorrectAnswers: List<String>.from(json['incorrect_answers']),
    );
  }
}
