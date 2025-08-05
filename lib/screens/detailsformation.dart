import 'package:flutter/material.dart';

class FormationDetailsPage extends StatelessWidget {
  const FormationDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détail Formation'),
        backgroundColor: Color(0xFF23468E),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Image(
              image: AssetImage('assets/images/bg.jpg'),
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20),
            Text(
              "Titre de la formation",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text(
              "Cette formation vous permet de découvrir les bases du numérique. "
              "Elle inclut des vidéos, des exercices et des quiz pour vous aider à progresser à votre rythme.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              "Contenu de la formation :",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text("- Introduction\n- Leçon 1 : Présentation\n- Leçon 2 : Pratique\n- Quiz final\n"),
            SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: null, // ou une fonction plus tard
                child: Text("Commencer"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
