import 'package:flutter/material.dart';
import '../models/flashcard_model.dart';

class ManageCardsScreen extends StatefulWidget {
  final List<QuizCategory> categories;
  const ManageCardsScreen({super.key, required this.categories});

  @override
  State<ManageCardsScreen> createState() => _ManageCardsScreenState();
}

class _ManageCardsScreenState extends State<ManageCardsScreen> {
  late QuizCategory _selectedCategory;
  final _questionController = TextEditingController();
  final _answerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.categories.first;
  }

  void _openCardModal({Flashcard? card, int? index}) {
    if (card != null) {
      _questionController.text = card.question;
      _answerController.text = card.answer;
    } else {
      _questionController.clear();
      _answerController.clear();
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF15102A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 24,
          right: 24,
          top: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              card == null ? "Add Flashcard" : "Edit Flashcard",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _questionController,
              style: const TextStyle(color: Colors.white),
              decoration: _inputDecoration("Enter Question"),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _answerController,
              style: const TextStyle(color: Colors.white),
              decoration: _inputDecoration("Enter Answer"),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF38BDF8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  if (_questionController.text.isEmpty ||
                      _answerController.text.isEmpty)
                    return;

                  setState(() {
                    if (card == null) {
                      _selectedCategory.cards.add(
                        Flashcard(
                          id: DateTime.now().toString(),
                          question: _questionController.text.trim(),
                          answer: _answerController.text.trim(),
                        ),
                      );
                    } else {
                      _selectedCategory.cards[index!] = Flashcard(
                        id: card.id,
                        question: _questionController.text.trim(),
                        answer: _answerController.text.trim(),
                      );
                    }
                  });
                  Navigator.pop(context);
                },
                child: Text(
                  card == null ? "Save Card" : "Update Card",
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  void _deleteCard(int index) {
    setState(() {
      _selectedCategory.cards.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Card deleted successfully!"),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white38),
      filled: true,
      fillColor: const Color(0xFF0F0C20),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.05)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF38BDF8)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0C20),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Manage Custom Cards",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: const Color(0xFF15102A),
                borderRadius: BorderRadius.circular(14),
              ),
              child: DropdownButton<QuizCategory>(
                value: _selectedCategory,
                isExpanded: true,
                dropdownColor: const Color(0xFF15102A),
                underline: const SizedBox(),
                style: const TextStyle(color: Colors.white, fontSize: 16),
                items: widget.categories.map((cat) {
                  return DropdownMenuItem(
                    value: cat,
                    child: Text("${cat.icon}  ${cat.name}"),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedCategory = val);
                },
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _selectedCategory.cards.isEmpty
                  ? Center(
                      child: Text(
                        "No cards found. Tap '+' to add!",
                        style: TextStyle(color: Colors.white.withOpacity(0.4)),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _selectedCategory.cards.length,
                      itemBuilder: (context, index) {
                        final card = _selectedCategory.cards[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF15102A),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ListTile(
                            title: Text(
                              card.question,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(
                              card.answer,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                                fontSize: 12,
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Color(0xFF38BDF8),
                                    size: 20,
                                  ),
                                  onPressed: () =>
                                      _openCardModal(card: card, index: index),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Color(0xFFF43F5E),
                                    size: 20,
                                  ),
                                  onPressed: () => _deleteCard(index),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFEC4899),
        onPressed: () => _openCardModal(),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }
}
