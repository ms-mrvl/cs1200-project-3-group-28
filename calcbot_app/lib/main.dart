import 'package:flutter/material.dart';

void main() {
  runApp(const CalcBotApp());
}

/// ROOT APP WITH PHONE FRAME + THEME
class CalcBotApp extends StatefulWidget {
  const CalcBotApp({super.key});

  @override
  State<CalcBotApp> createState() => _CalcBotAppState();
}

class _CalcBotAppState extends State<CalcBotApp> {
  bool darkMode = false;

  void toggleDarkMode() {
    setState(() => darkMode = !darkMode);
  }

  @override
  Widget build(BuildContext context) {
    final baseTheme = darkMode ? ThemeData.dark() : ThemeData.light();

    return MaterialApp(
      title: 'CalcBot',
      debugShowCheckedModeBanner: false,
      theme: baseTheme.copyWith(
        scaffoldBackgroundColor: Colors.transparent,
      ),
      home: PhoneShell(
        darkMode: darkMode,
        toggleDarkMode: toggleDarkMode,
      ),
    );
  }
}

/// OUTER PURPLE BACKGROUND + PHONE FRAME + NOTCH
class PhoneShell extends StatelessWidget {
  final bool darkMode;
  final VoidCallback toggleDarkMode;

  const PhoneShell({
    super.key,
    required this.darkMode,
    required this.toggleDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF7C5CFF), Color(0xFFB56CFF)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Center(
        child: Container(
          width: 430,
          margin: const EdgeInsets.symmetric(vertical: 24),
          decoration: BoxDecoration(
            color: darkMode ? const Color(0xFF101010) : Colors.white,
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 30,
                offset: const Offset(0, 20),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: Stack(
              children: [
                // Fake notch
                Positioned(
                  top: 10,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      height: 26,
                      width: 150,
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                  ),
                ),
                // Phone content
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: MainScreen(
                    darkMode: darkMode,
                    toggleDarkMode: toggleDarkMode,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// ===========================================
/// MAIN SCREEN WITH BOTTOM NAV INSIDE PHONE
/// ===========================================
class MainScreen extends StatefulWidget {
  final bool darkMode;
  final VoidCallback toggleDarkMode;

  const MainScreen({
    super.key,
    required this.darkMode,
    required this.toggleDarkMode,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int index = 0;

  void goToChat() => setState(() => index = 1);
  void goHome() => setState(() => index = 0);

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(startChat: goToChat),
      ChatScreen(goBack: goHome),
      SettingsScreen(
        darkMode: widget.darkMode,
        toggleDarkMode: widget.toggleDarkMode,
      ),
      const FAQScreen(),
    ];

    return Scaffold(
      backgroundColor:
          widget.darkMode ? const Color(0xFF181818) : const Color(0xFFF7F4FF),
      body: SafeArea(child: pages[index]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (i) => setState(() => index = i),
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline), label: "Chat"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
          BottomNavigationBarItem(icon: Icon(Icons.help_outline), label: "FAQ"),
        ],
      ),
    );
  }
}

/// =================== HOME ===================
class HomePage extends StatelessWidget {
  final VoidCallback startChat;
  const HomePage({super.key, required this.startChat});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 380,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "CalcBot",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text("Your AI Math Tutor"),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: startChat,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text("Start Chat", style: TextStyle(fontSize: 18)),
            )
          ],
        ),
      ),
    );
  }
}

/// ================= SETTINGS =================
class SettingsScreen extends StatefulWidget {
  final bool darkMode;
  final VoidCallback toggleDarkMode;

  const SettingsScreen({
    super.key,
    required this.darkMode,
    required this.toggleDarkMode,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notifications = true;

  void toast(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: const Text("Settings")),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text("Enable Notifications"),
            subtitle: const Text("Get study reminders"),
            value: notifications,
            onChanged: (v) {
              setState(() => notifications = v);
              toast(v ? "Notifications Enabled 🔔" : "Notifications Off ❌");
            },
          ),
          SwitchListTile(
            title: const Text("Dark Mode"),
            subtitle: const Text("Reduce eye strain"),
            value: widget.darkMode,
            onChanged: (v) {
              widget.toggleDarkMode();
              toast(v ? "Dark Mode Enabled 🌙" : "Light Mode ☀️");
            },
          ),
        ],
      ),
    );
  }
}

/// ================== FAQ =====================
class FAQScreen extends StatefulWidget {
  const FAQScreen({super.key});

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  final List<Map<String, String>> faq = [
    {
      "question": "What is CalcBot?",
      "answer":
          "CalcBot is your AI-powered math tutor for step-by-step explanations."
    },
    {"question": "Is it free?", "answer": "Yes, it's free for this project."},
    {
      "question": "Can it help with calculus?",
      "answer": "Yes, it can explain many topics in detail."
    },
  ];

  final TextEditingController controller = TextEditingController();

  void submit() {
    if (controller.text.trim().isEmpty) return;
    setState(() {
      faq.add({
        "question": controller.text.trim(),
        "answer": "Thanks! Your question has been submitted. 📩"
      });
    });
    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: const Text("FAQ")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ...faq.map(
            (q) => ExpansionTile(
              title: Text(q["question"]!),
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(q["answer"]!),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Submit Your Own Question",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: "Type your question...",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: submit,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
            child: const Text("Submit"),
          ),
        ],
      ),
    );
  }
}

/// =============== CHAT ===============

class Message {
  final String text;
  final bool isUser;
  Message({required this.text, required this.isUser});
}

class ChatScreen extends StatefulWidget {
  final VoidCallback goBack;
  const ChatScreen({super.key, required this.goBack});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Message> messages = [
    Message(
      text:
          "Hi! I'm CalcBot, your AI math tutor. Ask me anything from basic arithmetic to calculus, and I'll help you understand step by step! 📐✨",
      isUser: false,
    ),
  ];

  final TextEditingController controller = TextEditingController();
  bool sending = false;

  Future<void> send() async {
    if (controller.text.trim().isEmpty) return;

    final user = controller.text.trim();
    controller.clear();

    setState(() {
      messages.add(Message(text: user, isUser: true));
      sending = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      messages.add(
        Message(
          text:
              "Demo reply: In the final version, this will come from the AI API.\n\nYou asked: \"$user\"",
          isUser: false,
        ),
      );
      sending = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          // HEADER
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF8A4DFF), Color(0xFFC86CFF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
            ),
            padding:
                const EdgeInsets.only(top: 16, left: 20, right: 20, bottom: 18),
            child: Row(
              children: [
                IconButton(
                  onPressed: widget.goBack,
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                ),
                const SizedBox(width: 4),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "CalcBot",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      "• Online",
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
                const Spacer(),
                CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.smart_toy,
                      color: Colors.deepPurple.shade400),
                ),
              ],
            ),
          ),

          // BODY
          Expanded(
            child: Container(
              color: isDark ? const Color(0xFF101010) : Colors.white,
              child: Column(
                children: [
                  // messages
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      children: messages
                          .map(
                            (m) => Align(
                              alignment: m.isUser
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                margin:
                                    const EdgeInsets.symmetric(vertical: 5),
                                decoration: BoxDecoration(
                                  color: m.isUser
                                      ? Colors.deepPurple
                                      : const Color(0xFFF5F1FF),
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: Text(
                                  m.text,
                                  style: TextStyle(
                                    color: m.isUser
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),

                  // category chips
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    color: isDark
                        ? const Color(0xFF181818)
                        : const Color(0xFFF8F5FF),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: const [
                          _TopicChip(label: "Algebra", icon: Icons.menu_book),
                          _TopicChip(
                              label: "Geometry", icon: Icons.change_history),
                          _TopicChip(
                              label: "Equations", icon: Icons.calculate),
                          _TopicChip(
                              label: "Calculus",
                              icon: Icons.functions_outlined),
                        ],
                      ),
                    ),
                  ),

                  // input bar
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    color: isDark
                        ? const Color(0xFF181818)
                        : const Color(0xFFF8F5FF),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(
                                  color: Colors.deepPurple, width: 2),
                              color: isDark
                                  ? const Color(0xFF101010)
                                  : Colors.white,
                            ),
                            child: TextField(
                              controller: controller,
                              onSubmitted: (_) => send(),
                              decoration: const InputDecoration(
                                hintText: "Ask me a math question...",
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 10),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: sending ? null : send,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.deepPurple,
                            ),
                            child: Icon(
                              Icons.send,
                              color: sending ? Colors.white54 : Colors.white,
                              size: 22,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TopicChip extends StatelessWidget {
  final String label;
  final IconData icon;

  const _TopicChip({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.deepPurple),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 13),
          ),
        ],
      ),
    );
  }
}
