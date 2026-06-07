import 'dart:math';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';

// --- Local Storage Mock Data ---
final Map<String, Map<String, String>> localUserDatabase = {
  "admin@gmail.com": {
    "name": "Admin User",
    "password": "admin123"
  }, // Default account
};

// Global variable for user name
String loggedInUserName = "User";

// --- Model ---
class Quote {
  final String text;
  final String author;
  final String category;

  Quote({required this.text, required this.author, required this.category});
}

// --- Data ---
final List<Quote> allQuotes = [
  // Inspire
  Quote(
      text: "Believe you can and you're halfway there.",
      author: "Theodore Roosevelt",
      category: "Inspire"),
  Quote(
      text: "Your time is limited, so don't waste it.",
      author: "Steve Jobs",
      category: "Inspire"),
  Quote(
      text: "Dream big and dare to fail.",
      author: "Norman Vaughan",
      category: "Inspire"),
  Quote(
      text: "The best way to predict the future is to create it.",
      author: "Peter Drucker",
      category: "Inspire"),
  Quote(
      text: "Everything you've ever wanted is on the other side of fear.",
      author: "George Addair",
      category: "Inspire"),
  // Love
  Quote(
      text: "Where there is love there is life.",
      author: "Mahatma Gandhi",
      category: "Love"),
  Quote(
      text: "Love is composed of a single soul.",
      author: "Aristotle",
      category: "Love"),
  Quote(
      text: "To love and be loved is to feel the sun from both sides.",
      author: "David Viscott",
      category: "Love"),
  Quote(
      text: "Love all, trust a few, do wrong to none.",
      author: "William Shakespeare",
      category: "Love"),
  Quote(
      text: "The heart has its reasons which reason knows not.",
      author: "Blaise Pascal",
      category: "Love"),
  // Life
  Quote(
      text: "Life is what happens when you're busy making other plans.",
      author: "John Lennon",
      category: "Life"),
  Quote(
      text: "Get busy living or get busy dying.",
      author: "Stephen King",
      category: "Life"),
  Quote(
      text: "Life is really simple, but we insist on making it complicated.",
      author: "Confucius",
      category: "Life"),
  Quote(
      text: "The purpose of our lives is to be happy.",
      author: "Dalai Lama",
      category: "Life"),
  Quote(
      text: "You only live once, but if you do it right, once is enough.",
      author: "Mae West",
      category: "Life"),
  // Wisdom
  Quote(
      text: "Knowing yourself is the beginning of all wisdom.",
      author: "Aristotle",
      category: "Wisdom"),
  Quote(
      text: "The only true wisdom is in knowing you know nothing.",
      author: "Socrates",
      category: "Wisdom"),
  Quote(
      text: "Wisdom begins in wonder.", author: "Socrates", category: "Wisdom"),
  Quote(
      text: "It is better to be wise than to be rich.",
      author: "Proverb",
      category: "Wisdom"),
  Quote(
      text: "The roots of education are bitter, but the fruit is sweet.",
      author: "Aristotle",
      category: "Wisdom"),
  // Success
  Quote(
      text: "Success is not final, failure is not fatal.",
      author: "Winston Churchill",
      category: "Success"),
  Quote(
      text: "It always seems impossible until it's done.",
      author: "Nelson Mandela",
      category: "Success"),
  Quote(
      text:
          "Success usually comes to those who are too busy to be looking for it.",
      author: "Henry David Thoreau",
      category: "Success"),
  Quote(
      text: "Don't watch the clock; do what it does. Keep going.",
      author: "Sam Levenson",
      category: "Success"),
  // Faith
  Quote(
      text: "Keep faith and don't lose hope.",
      author: "MLK Jr.",
      category: "Faith"),
  Quote(
      text: "Faith is the bird that feels the light.",
      author: "Rabindranath Tagore",
      category: "Faith"),
  Quote(
      text:
          "Faith is the strength by which a shattered world shall emerge into the light.",
      author: "Helen Keller",
      category: "Faith"),
  Quote(
      text:
          "Faith consists in believing when it is beyond the power of reason to believe.",
      author: "Voltaire",
      category: "Faith"),
  Quote(
      text: "Have faith in your dreams and they will come true.",
      author: "Unknown",
      category: "Faith"),
  // Work
  Quote(
      text: "The only way to do great work is to love what you do.",
      author: "Steve Jobs",
      category: "Work"),
  Quote(text: "Work hard in silence.", author: "Frank Ocean", category: "Work"),
  Quote(
      text: "Hard work beats talent when talent doesn't work hard.",
      author: "Tim Notke",
      category: "Work"),
  Quote(
      text:
          "Genius is one percent inspiration and ninety-nine percent perspiration.",
      author: "Thomas Edison",
      category: "Work"),
  Quote(
      text: "Opportunities are usually disguised as hard work.",
      author: "Ann Landers",
      category: "Work"),
];

// --- Background Images URLs (Cached Globals) ---
const String splashBgUrl =
    "https://images.unsplash.com/photo-1519681393784-d120267933ba?q=80&w=1200"; // Nature Mountain/Cloud Image
const String loginBgUrl =
    "https://images.unsplash.com/photo-1475924156734-496f6cac6ec1?q=80&w=1200";
const String signupBgUrl =
    "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?q=80&w=1200";

void main() {
  runApp(const QuoteGeneratorApp());
}

class QuoteGeneratorApp extends StatelessWidget {
  const QuoteGeneratorApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      home: const SplashScreen(),
    );
  }
}

// ==================== NEW SPLASH SCREEN (WITH BG IMAGE & NEW UI) ====================
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: const Duration(seconds: 2), vsync: this)
          ..repeat();

    // Jab tak splash timer chalta hai, piche images load hokar memory mein chali jati hain
    Future.delayed(Duration.zero, () {
      if (mounted) {
        precacheImage(const NetworkImage(splashBgUrl),
            context); // Pre-cache Splash itself
        precacheImage(const NetworkImage(loginBgUrl), context);
        precacheImage(const NetworkImage(signupBgUrl), context);
      }
    });

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Gradient hata kar use simple black/color de diya hai. Stack se image lagai hai.
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Splash Background Image
          Positioned.fill(
            child: Image.network(
              splashBgUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF8A2387), Color(0xFFE94057)],
                  ),
                ),
              ),
            ),
          ),
          // 2. Dark Tint Layer for better visibility
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.55),
            ),
          ),
          // 3. New Splash UI Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon Logo
                RotationTransition(
                  turns: _controller,
                  child: const Icon(Icons.format_quote_rounded,
                      size: 100, color: Colors.white),
                ),
                const SizedBox(height: 25),
                // App Name
                const Text(
                  "DAILY QUOTES",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 10),
                // App Slogan/ Motto
                const Text(
                  "Your Daily Dose of Wisdom",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 60),
                // Loading Indicator
                const SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== LOGIN SCREEN ====================
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  void _login() {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();

      if (localUserDatabase.containsKey(email) &&
          localUserDatabase[email]!["password"] == password) {
        loggedInUserName = localUserDatabase[email]!["name"] ?? "User";
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Welcome back, $loggedInUserName! 🎉")),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const QuoteScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid Email or Password! ❌")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              loginBgUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  Container(color: const Color(0xFF1F1C2C)),
            ),
          ),
          Positioned.fill(
              child: Container(color: Colors.black.withOpacity(0.6))),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: SizedBox(
                  width: 320,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.lock_outline_rounded,
                          size: 70, color: Colors.white),
                      const SizedBox(height: 10),
                      const Text(
                        "Welcome Back",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 25),
                      TextFormField(
                        controller: _emailController,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 15),
                        decoration: InputDecoration(
                          labelText: "Email",
                          labelStyle: const TextStyle(
                              color: Colors.white70, fontSize: 14),
                          prefixIcon: const Icon(Icons.email,
                              color: Colors.white70, size: 20),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.15),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 15),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        validator: (val) =>
                            (val == null || val.isEmpty || !val.contains("@"))
                                ? "Enter a valid email"
                                : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 15),
                        decoration: InputDecoration(
                          labelText: "Password",
                          labelStyle: const TextStyle(
                              color: Colors.white70, fontSize: 14),
                          prefixIcon: const Icon(Icons.lock,
                              color: Colors.white70, size: 20),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.white70,
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.15),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 15),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        validator: (val) =>
                            (val == null || val.isEmpty || val.length < 6)
                                ? "Password must be 6+ chars"
                                : null,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 45),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child:
                            const Text("Login", style: TextStyle(fontSize: 16)),
                      ),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignupScreen()),
                          );
                        },
                        child: const Text("Don't have an account? Sign Up",
                            style:
                                TextStyle(color: Colors.white70, fontSize: 13)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== SIGNUP SCREEN ====================
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  void _signup() {
    if (_formKey.currentState!.validate()) {
      String name = _nameController.text.trim();
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();

      localUserDatabase[email] = {
        "name": name,
        "password": password,
      };

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Account Created! Please Login. 🎉")),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              signupBgUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  Container(color: const Color(0xFF1F1C2C)),
            ),
          ),
          Positioned.fill(
              child: Container(color: Colors.black.withOpacity(0.6))),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: SizedBox(
                  width: 320,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.person_add_alt_1_rounded,
                          size: 70, color: Colors.white),
                      const SizedBox(height: 10),
                      const Text(
                        "Create Account",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 25),
                      TextFormField(
                        controller: _nameController,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 15),
                        decoration: InputDecoration(
                          labelText: "Full Name",
                          labelStyle: const TextStyle(
                              color: Colors.white70, fontSize: 14),
                          prefixIcon: const Icon(Icons.person,
                              color: Colors.white70, size: 20),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.15),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 15),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        validator: (val) => (val == null || val.isEmpty)
                            ? "Please enter your full name"
                            : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _emailController,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 15),
                        decoration: InputDecoration(
                          labelText: "Email",
                          labelStyle: const TextStyle(
                              color: Colors.white70, fontSize: 14),
                          prefixIcon: const Icon(Icons.email,
                              color: Colors.white70, size: 20),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.15),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 15),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        validator: (val) =>
                            (val == null || val.isEmpty || !val.contains("@"))
                                ? "Enter a valid email"
                                : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 15),
                        decoration: InputDecoration(
                          labelText: "Password",
                          labelStyle: const TextStyle(
                              color: Colors.white70, fontSize: 14),
                          prefixIcon: const Icon(Icons.lock,
                              color: Colors.white70, size: 20),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.white70,
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.15),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 15),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        validator: (val) =>
                            (val == null || val.isEmpty || val.length < 6)
                                ? "Password must be 6+ chars"
                                : null,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _signup,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 45),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text("Sign Up",
                            style: TextStyle(fontSize: 16)),
                      ),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Already have an account? Login",
                            style:
                                TextStyle(color: Colors.white70, fontSize: 13)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== QUOTE SCREEN (HOME SCREEN) ====================
class QuoteScreen extends StatefulWidget {
  const QuoteScreen({super.key});
  @override
  State<QuoteScreen> createState() => _QuoteScreenState();
}

class _QuoteScreenState extends State<QuoteScreen> {
  String selectedCategory = "Inspire";
  String searchQuery = "";
  int _currentQuoteIndex = 0;
  final Set<String> _favorites = {};

  final List<String> bgs = [
    'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?q=80&w=1200',
    'https://images.unsplash.com/photo-1447752875215-b2761acb3c5d?q=80&w=1200',
    'https://images.unsplash.com/photo-1470071459604-3b5ec3a7fe05?q=80&w=1200',
  ];
  String _currentBg =
      'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?q=80&w=1200';

  final List<String> categories = [
    "All",
    "Inspire",
    "Love",
    "Life",
    "Wisdom",
    "Success",
    "Faith",
    "Work"
  ];

  List<Quote> get filteredQuotes {
    List<Quote> list = allQuotes;
    if (selectedCategory != "All") {
      list = list.where((q) => q.category == selectedCategory).toList();
    }
    if (searchQuery.isNotEmpty) {
      list = list
          .where(
              (q) => q.text.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }
    return list;
  }

  void _getNext() {
    setState(() {
      _currentBg = bgs[Random().nextInt(bgs.length)];
      if (filteredQuotes.isNotEmpty) {
        _currentQuoteIndex = Random().nextInt(filteredQuotes.length);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentQ = filteredQuotes.isNotEmpty
        ? filteredQuotes[_currentQuoteIndex % filteredQuotes.length]
        : Quote(text: "No quotes found", author: "-", category: "None");
    final bool isFav = _favorites.contains(currentQ.text);

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(seconds: 1),
        child: Container(
          key: ValueKey(_currentBg),
          decoration: const BoxDecoration(color: Colors.black),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.network(
                  _currentBg,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF1F1C2C), Color(0xFF928DAB)],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Positioned.fill(child: Container(color: Colors.black54)),
              Positioned.fill(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints:
                              BoxConstraints(minHeight: constraints.maxHeight),
                          child: IntrinsicHeight(
                            child: Column(
                              children: [
                                const SizedBox(height: 45),

                                // Welcome Message with User Full Name
                                Text(
                                  "Welcome, $loggedInUserName! 👋",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 15),

                                TextField(
                                  onChanged: (val) => setState(() {
                                    searchQuery = val;
                                  }),
                                  style: const TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    hintText: "Search...",
                                    hintStyle:
                                        const TextStyle(color: Colors.white54),
                                    filled: true,
                                    fillColor: Colors.white.withOpacity(0.2),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: selectedCategory,
                                      dropdownColor: Colors.black87,
                                      isExpanded: true,
                                      style:
                                          const TextStyle(color: Colors.white),
                                      items: categories
                                          .map((cat) => DropdownMenuItem(
                                              value: cat, child: Text(cat)))
                                          .toList(),
                                      onChanged: (val) => setState(
                                          () => selectedCategory = val!),
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                const SizedBox(height: 20),
                                Container(
                                  padding: const EdgeInsets.all(25),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: Colors.white24),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        currentQ.text,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                      const SizedBox(height: 15),
                                      Text(
                                        "- ${currentQ.author}",
                                        style: const TextStyle(
                                          color: Colors.cyanAccent,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.share,
                                                color: Colors.white),
                                            onPressed: () =>
                                                Share.share(currentQ.text),
                                          ),
                                          const SizedBox(width: 20),
                                          IconButton(
                                            icon: Icon(
                                              isFav
                                                  ? Icons.favorite
                                                  : Icons.favorite_border,
                                              color: isFav
                                                  ? Colors.red
                                                  : Colors.white,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                if (isFav) {
                                                  _favorites
                                                      .remove(currentQ.text);
                                                } else {
                                                  _favorites.add(currentQ.text);
                                                }
                                              });
                                            },
                                          ),
                                          const SizedBox(width: 20),
                                          IconButton(
                                            icon: const Icon(Icons.copy,
                                                color: Colors.white),
                                            onPressed: () {
                                              Clipboard.setData(ClipboardData(
                                                  text: currentQ.text));
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                    content:
                                                        Text("Quote copied!")),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                const SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: _getNext,
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 40, vertical: 15),
                                  ),
                                  child: const Text("Next Quote"),
                                ),
                                const SizedBox(height: 30),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
