import 'package:flutter/material.dart';

class FAQScreen extends StatelessWidget {
  const FAQScreen({super.key});

  final List<Map<String, String>> faqList = const [
    {
      "question": "What is CalcBot?",
      "answer": "CalcBot is an AI-powered app to help students understand math concepts using natural language."
    },
    {
      "question": "How does the AI work?",
      "answer": "We use OpenAI to generate step-by-step math explanations tailored to your question."
    },
    {
      "question": "Who can use CalcBot?",
      "answer": "High school to college students who need help with math."
    },
    {
      "question": "How can I reset my password?",
      "answer": "On the login page, click 'Forgot Password' to receive a reset link by email."
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("FAQ")),
      body: ListView.builder(
        itemCount: faqList.length,
        itemBuilder: (context, index) {
          return ExpansionTile(
            title: Text(faqList[index]["question"]!),
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(faqList[index]["answer"]!),
              )
            ],
          );
        },
      ),
    );
  }
}
