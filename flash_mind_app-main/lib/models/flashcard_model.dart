class Flashcard {
  String id;
  String question;
  String answer;

  Flashcard({required this.id, required this.question, required this.answer});

  // JSON se Flashcard banane ke liye
  factory Flashcard.fromJson(Map<String, dynamic> json) {
    return Flashcard(
      id: json['id'],
      question: json['question'],
      answer: json['answer'],
    );
  }

  // Flashcard ko JSON banane ke liye
  Map<String, dynamic> toJson() {
    return {'id': id, 'question': question, 'answer': answer};
  }
}

class QuizCategory {
  final String id;
  final String name;
  final String icon;
  final List<Flashcard> cards;

  QuizCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.cards,
  });

  factory QuizCategory.fromJson(Map<String, dynamic> json) {
    var list = json['cards'] as List;
    List<Flashcard> cardList = list.map((i) => Flashcard.fromJson(i)).toList();

    return QuizCategory(
      id: json['id'],
      name: json['name'],
      icon: json['icon'],
      cards: cardList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'cards': cards.map((c) => c.toJson()).toList(),
    };
  }
}
