import 'package:flutter/material.dart';

class FormationDetailsPage extends StatelessWidget {
  const FormationDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Le contenu passe sous l'AppBar
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
            padding: const EdgeInsets.all(12.0), // réduit la marge autour
            child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => Navigator.of(context).pop(),
            child: Container(
                decoration: BoxDecoration(
                color: const Color(0xFF23468E),
                borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(2), // réduit la surface intérieure
                child: const Icon(Icons.chevron_left, size: 25, color: Colors.white),
            ),
            ),
        ),
        ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: kToolbarHeight + 20), // Espace sous AppBar
            const Image(
              image: AssetImage('assets/images/bg.jpg'),
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20),
            const Text(
              "Paiement en ligne des factures JIRAMA",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              "Cette formation vous permet de découvrir les bases du numérique. "
              "Elle inclut des vidéos, des exercices et des quiz pour vous aider à progresser à votre rythme.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              "Contenu de la formation :",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "- Introduction\n"
              "- Leçon 1 : Présentation\n"
              "- Leçon 2 : Pratique\n"
              "- Quiz final",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            Align(
                alignment: Alignment.centerLeft,
                child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                    backgroundColor: const Color(0xFF23468E),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    ),
                    child: const Text("Suivre", style: TextStyle(fontSize: 16)),
                ),
            ),
          ],
        ),
      ),
    );
  }
}
