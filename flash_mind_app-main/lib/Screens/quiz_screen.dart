import 'package:flutter/material.dart';
import '../models/flashcard_model.dart';

class QuizScreen extends StatefulWidget {
  final QuizCategory category;
  const QuizScreen({super.key, required this.category});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentIndex = 0;
  bool _showAnswer = false;

  void _nextCard() {
    if (_currentIndex < widget.category.cards.length - 1) {
      setState(() {
        _currentIndex++;
        _showAnswer = false;
      });
    }
  }

  void _previousCard() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _showAnswer = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentCard = widget.category.cards[_currentIndex];
    final totalCards = widget.category.cards.length;

    return Scaffold(
      backgroundColor: const Color(0xFF0F0C20),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.category.name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
        child: Column(
          children: [
            // Progress tracker
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Card ${_currentIndex + 1} of $totalCards",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF38BDF8).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "${((_currentIndex + 1) / totalCards * 100).toInt()}% Done",
                    style: const TextStyle(
                      color: Color(0xFF38BDF8),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Premium Frosted Glass Interactive Card Container
            Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: double.infinity,
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(
                    color: _showAnswer
                        ? const Color(0xFFEC4899).withOpacity(0.3)
                        : const Color(0xFF38BDF8).withOpacity(0.3),
                    width: 1.5,
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF1A1535),
                      const Color(0xFF15102A).withOpacity(0.8),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _showAnswer
                          ? const Color(0xFFEC4899).withOpacity(0.1)
                          : const Color(0xFF38BDF8).withOpacity(0.1),
                      blurRadius: 25,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _showAnswer ? Icons.wb_incandescent : Icons.help_outline,
                      size: 45,
                      color: _showAnswer
                          ? const Color(0xFFEC4899)
                          : const Color(0xFF38BDF8),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      _showAnswer ? "ANSWER" : "QUESTION",
                      style: TextStyle(
                        color: _showAnswer
                            ? const Color(0xFFEC4899)
                            : const Color(0xFF38BDF8),
                        letterSpacing: 2.0,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 25),
                    SingleChildScrollView(
                      child: Text(
                        _showAnswer ? currentCard.answer : currentCard.question,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Show Answer Trigger Button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _showAnswer
                      ? const Color(0xFFEC4899)
                      : const Color(0xFF8B5CF6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 5,
                ),
                onPressed: () {
                  setState(() {
                    _showAnswer = !_showAnswer;
                  });
                },
                icon: Icon(
                  _showAnswer ? Icons.flip_to_front : Icons.remove_red_eye,
                  color: Colors.white,
                ),
                label: Text(
                  _showAnswer ? "Hide Answer" : "Reveal Answer",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25),

            // Navigation Controls (Previous and Next Buttons)
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.white.withOpacity(0.15)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: _currentIndex > 0 ? _previousCard : null,
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        size: 16,
                        color: Colors.white,
                      ),
                      label: const Text(
                        "Previous",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.white.withOpacity(0.15)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: _currentIndex < totalCards - 1
                          ? _nextCard
                          : null,
                      icon: const Text(
                        "Next",
                        style: TextStyle(color: Colors.white),
                      ),
                      label: const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
