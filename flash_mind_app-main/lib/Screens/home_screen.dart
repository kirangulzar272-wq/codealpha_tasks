import 'dart:convert';
import 'dart:ui'; // Glass effect k liye zaroori hai
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/flashcard_model.dart';
import 'quiz_screen.dart';
import 'manage_cards_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<QuizCategory> categories = [];
  String userName = "Guest User";
  bool isLoading = true;

  final List<QuizCategory> _defaultCategories = [
    QuizCategory(
      id: '1',
      name: 'Flutter & Dart',
      icon: '📱',
      cards: [
        Flashcard(
          id: 'f1',
          question: 'What is Flutter?',
          answer:
              'An open-source UI software development kit created by Google.',
        ),
        Flashcard(
          id: 'f2',
          question: 'What is Dart?',
          answer:
              'A client-optimized programming language used to build apps in Flutter.',
        ),
        Flashcard(
          id: 'f3',
          question: 'Stateful vs Stateless Widget?',
          answer: 'Stateless is immutable, Stateful is mutable.',
        ),
        Flashcard(
          id: 'f4',
          question: 'What is pubspec.yaml?',
          answer: 'A file where assets and dependencies are defined.',
        ),
        Flashcard(
          id: 'f5',
          question: 'What is MainAxisAlignment?',
          answer: 'Aligns children along the main axis.',
        ),
      ],
    ),
    QuizCategory(
      id: '2',
      name: 'General Science',
      icon: '🔬',
      cards: [
        Flashcard(
          id: 's1',
          question: 'What is the powerhouse of the cell?',
          answer: 'Mitochondria.',
        ),
        Flashcard(
          id: 's2',
          question: 'What is the chemical formula of Water?',
          answer: 'H2O.',
        ),
        Flashcard(
          id: 's3',
          question: 'Which planet is known as the Red Planet?',
          answer: 'Mars.',
        ),
        Flashcard(
          id: 's4',
          question: 'What gas do humans breathe out?',
          answer: 'Carbon Dioxide (CO2).',
        ),
        Flashcard(
          id: 's5',
          question: 'What is the speed of light approx?',
          answer: '300,000 km/s.',
        ),
      ],
    ),
    QuizCategory(
      id: '3',
      name: 'World History',
      icon: '🌍',
      cards: [
        Flashcard(
          id: 'h1',
          question: 'Who discovered America?',
          answer: 'Christopher Columbus.',
        ),
        Flashcard(
          id: 'h2',
          question: 'In which year did World War I start?',
          answer: '1914.',
        ),
        Flashcard(
          id: 'h3',
          question: 'Who was the first president of the USA?',
          answer: 'George Washington.',
        ),
        Flashcard(
          id: 'h4',
          question: 'Which empire built the Colosseum?',
          answer: 'The Roman Empire.',
        ),
        Flashcard(
          id: 'h5',
          question: 'Who wrote the Declaration of Independence?',
          answer: 'Thomas Jefferson.',
        ),
      ],
    ),
    QuizCategory(
      id: '4',
      name: 'Computer Networks',
      icon: '🌐',
      cards: [
        Flashcard(
          id: 'n1',
          question: 'What does IP stand for?',
          answer: 'Internet Protocol.',
        ),
        Flashcard(
          id: 'n2',
          question: 'What is the function of a Router?',
          answer: 'To forward data packets between computer networks.',
        ),
        Flashcard(
          id: 'n3',
          question: 'What is DNS?',
          answer:
              'Domain Name System, which translates domain names to IP addresses.',
        ),
        Flashcard(
          id: 'n4',
          question: 'What does HTTP stand for?',
          answer: 'Hypertext Transfer Protocol.',
        ),
        Flashcard(
          id: 'n5',
          question: 'What is a Firewall?',
          answer:
              'A security system that monitors and controls network traffic.',
        ),
      ],
    ),
    QuizCategory(
      id: '5',
      name: 'Mathematics',
      icon: '🧮',
      cards: [
        Flashcard(
          id: 'm1',
          question: 'What is the value of Pi (approx)?',
          answer: '3.14159',
        ),
        Flashcard(
          id: 'm2',
          question: 'What is the square root of 144?',
          answer: '12',
        ),
        Flashcard(
          id: 'm3',
          question: 'Who is known as the Father of Geometry?',
          answer: 'Euclid.',
        ),
        Flashcard(
          id: 'm4',
          question: 'What is an acute angle?',
          answer: 'An angle that is less than 90 degrees.',
        ),
        Flashcard(
          id: 'm5',
          question: 'What is the formula for area of a circle?',
          answer: 'Area = πr²',
        ),
      ],
    ),
    QuizCategory(
      id: '6',
      name: 'Space Exploration',
      icon: '🚀',
      cards: [
        Flashcard(
          id: 'sp1',
          question: 'Which is the largest planet in our solar system?',
          answer: 'Jupiter.',
        ),
        Flashcard(
          id: 'sp2',
          question: 'Who was the first human in space?',
          answer: 'Yuri Gagarin.',
        ),
        Flashcard(
          id: 'sp3',
          question: 'What is the galaxy we live in called?',
          answer: 'The Milky Way.',
        ),
        Flashcard(
          id: 'sp4',
          question: 'Which planet has the most prominent rings?',
          answer: 'Saturn.',
        ),
        Flashcard(
          id: 'sp5',
          question: 'What year did man first land on the moon?',
          answer: '1969.',
        ),
      ],
    ),
    QuizCategory(
      id: '7',
      name: 'Geography',
      icon: '🗺️',
      cards: [
        Flashcard(
          id: 'g1',
          question: 'What is the capital of Japan?',
          answer: 'Tokyo.',
        ),
        Flashcard(
          id: 'g2',
          question: 'Which is the longest river on Earth?',
          answer: 'The Nile River.',
        ),
        Flashcard(
          id: 'g3',
          question: 'Which is the smallest country in the world?',
          answer: 'Vatican City.',
        ),
        Flashcard(
          id: 'g4',
          question: 'In which ocean is the Mariana Trench located?',
          answer: 'Pacific Ocean.',
        ),
        Flashcard(
          id: 'g5',
          question: 'What is the highest mountain peak in the world?',
          answer: 'Mount Everest.',
        ),
      ],
    ),
    QuizCategory(
      id: '8',
      name: 'English Literature',
      icon: '📚',
      cards: [
        Flashcard(
          id: 'l1',
          question: 'Who wrote "Romeo and Juliet"?',
          answer: 'William Shakespeare.',
        ),
        Flashcard(
          id: 'l2',
          question: 'Who is the author of "Harry Potter"?',
          answer: 'J.K. Rowling.',
        ), // Error Fixed Here (text changed to question)
        Flashcard(
          id: 'l3',
          question: 'What is a poem with 14 lines called?',
          answer: 'A Sonnet.',
        ),
        Flashcard(
          id: 'l4',
          question: 'Who wrote "Pride and Prejudice"?',
          answer: 'Jane Austen.',
        ),
        Flashcard(
          id: 'l5',
          question: 'What is the name of Sherlock Holmes\' sidekick?',
          answer: 'Dr. John Watson.',
        ),
      ],
    ),
    QuizCategory(
      id: '9',
      name: 'Sports Trivia',
      icon: '⚽',
      cards: [
        Flashcard(
          id: 'sr1',
          question: 'How many players are there in a cricket team?',
          answer: '11 players.',
        ),
        Flashcard(
          id: 'sr2',
          question: 'Which country won the first FIFA World Cup?',
          answer: 'Uruguay.',
        ),
        Flashcard(
          id: 'sr3',
          question: 'How long is a standard marathon race?',
          answer: '42.195 kilometers (26.2 miles).',
        ),
        Flashcard(
          id: 'sr4',
          question: 'Which sport uses the terms "Deuce" and "Volley"?',
          answer: 'Tennis.',
        ),
        Flashcard(
          id: 'sr5',
          question: 'Who is known as the Lightning Bolt of athletics?',
          answer: 'Usain Bolt.',
        ),
      ],
    ),
    QuizCategory(
      id: '10',
      name: 'General Mythology',
      icon: '⚡',
      cards: [
        Flashcard(
          id: 'my1',
          question: 'Who is the King of Gods in Greek Mythology?',
          answer: 'Zeus.',
        ),
        Flashcard(
          id: 'my2',
          question: 'What is the weapon of Norse god Thor?',
          answer: 'Mjolnir (Hammer).',
        ),
        Flashcard(
          id: 'my3',
          question: 'Who is the Egyptian God of the Underworld?',
          answer: 'Anubis / Osiris.',
        ),
        Flashcard(
          id: 'my4',
          question: 'What creature has the body of a lion and head of a human?',
          answer: 'The Sphinx.',
        ),
        Flashcard(
          id: 'my5',
          question: 'In Greek myths, who turned everything he touched to gold?',
          answer: 'King Midas.',
        ),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadDataFromStorage();
  }

  Future<void> _loadDataFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    String? storedName = prefs.getString('user_full_name');
    String? jsonString = prefs.getString('saved_quiz_categories');

    setState(() {
      if (storedName != null) userName = storedName;
      if (jsonString != null) {
        List<dynamic> jsonList = jsonDecode(jsonString);
        categories = jsonList
            .map((json) => QuizCategory.fromJson(json))
            .toList();
      } else {
        categories = _defaultCategories;
        _saveToStorage();
      }
      isLoading = false;
    });
  }

  Future<void> _saveToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    String jsonString = jsonEncode(categories.map((c) => c.toJson()).toList());
    await prefs.setString('saved_quiz_categories', jsonString);
  }

  Future<void> _showLogoutDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: AlertDialog(
            backgroundColor: const Color(0xFF15102A).withValues(alpha: 0.85),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
              side: BorderSide(
                color: Colors.white.withValues(alpha: 0.15),
                width: 1.5,
              ),
            ),
            title: const Row(
              children: [
                Icon(Icons.logout, color: Color(0xFFF43F5E)),
                SizedBox(width: 10),
                Text(
                  "Sign Out",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            content: const Text(
              "Are you sure you want to sign out?",
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            actionsPadding: const EdgeInsets.only(bottom: 16, right: 16),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "No",
                  style: TextStyle(
                    color: Color(0xFF38BDF8),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF43F5E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                onPressed: () async {
                  Navigator.pop(context);
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('is_logged_in', false);
                  if (mounted) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  }
                },
                child: const Text(
                  "Yes",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0816),
      body: Stack(
        children: [
          // Background Glowing Circles
          Positioned(
            top: -50,
            left: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: const BoxDecoration(
                color: Color(0xFF38BDF8),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            right: -80,
            child: Container(
              width: 250,
              height: 250,
              decoration: const BoxDecoration(
                color: Color(0xFFEC4899),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
              child: Container(color: Colors.transparent),
            ),
          ),

          // Main Content
          SafeArea(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFF38BDF8)),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment
                              .spaceBetween, // Error Fixed Here (changed from 'between' to 'spaceBetween')
                          children: [
                            ShaderMask(
                              shaderCallback: (bounds) => const LinearGradient(
                                colors: [Color(0xFF38BDF8), Color(0xFFEC4899)],
                              ).createShader(bounds),
                              child: const Text(
                                "FLASH MIND",
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 24,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit_note,
                                    color: Color(0xFF38BDF8),
                                    size: 28,
                                  ),
                                  onPressed: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ManageCardsScreen(
                                          categories: categories,
                                        ),
                                      ),
                                    );
                                    await _saveToStorage();
                                    setState(() {});
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.logout,
                                    color: Color(0xFFF43F5E),
                                  ),
                                  onPressed: _showLogoutDialog,
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "Hello, $userName 👋",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Pick a domain and start practicing with glassmorphic cards",
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.5),
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 25),

                        // Glass List View
                        Expanded(
                          child: ListView.builder(
                            itemCount: categories.length,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              final category = categories[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(24),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                      sigmaX: 15,
                                      sigmaY: 15,
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(
                                          alpha: 0.05,
                                        ),
                                        borderRadius: BorderRadius.circular(24),
                                        border: Border.all(
                                          color: Colors.white.withValues(
                                            alpha: 0.15,
                                          ),
                                          width: 1.5,
                                        ),
                                      ),
                                      child: ListTile(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 20,
                                              vertical: 14,
                                            ),
                                        leading: Container(
                                          width: 52,
                                          height: 52,
                                          decoration: BoxDecoration(
                                            color: Colors.white.withValues(
                                              alpha: 0.08,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                            border: Border.all(
                                              color: Colors.white.withValues(
                                                alpha: 0.1,
                                              ),
                                            ),
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            category.icon,
                                            style: const TextStyle(
                                              fontSize: 26,
                                            ),
                                          ),
                                        ),
                                        title: Text(
                                          category.name,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 18,
                                          ),
                                        ),
                                        subtitle: Padding(
                                          padding: const EdgeInsets.only(
                                            top: 6.0,
                                          ),
                                          child: Text(
                                            "${category.cards.length} Cards available",
                                            style: const TextStyle(
                                              color: Color(0xFF38BDF8),
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        trailing: const Icon(
                                          Icons.arrow_forward_ios,
                                          color: Colors.white60,
                                          size: 16,
                                        ),
                                        onTap: () {
                                          if (category.cards.isEmpty) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  "No cards available!",
                                                ),
                                              ),
                                            );
                                            return;
                                          }
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => QuizScreen(
                                                category: category,
                                              ),
                                            ),
                                          ).then((value) => setState(() {}));
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
