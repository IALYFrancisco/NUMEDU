import 'package:flutter/material.dart';

class FormationDetailsPage extends StatelessWidget {
  const FormationDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
        appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: SafeArea(
            child: Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 20.0),
            child: Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                    width: 34,
                    height: 34,
                    decoration: const BoxDecoration(
                    color: Color(0xFF23468E),
                    shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.chevron_left, size: 25, color: Colors.white),
                ),
                ),
            ),
            ),
        ),
    ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: kToolbarHeight + 20),
            Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 3,
                        offset: Offset(0, 3),
                    ),
                    ],
                ),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: const Image(
                    image: AssetImage('assets/images/jirama.jpeg'),
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    ),
                ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Paiement en ligne des factures JIRAMA",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF23468E),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "Cette formation vous permet de découvrir les bases du numérique. "
              "Elle inclut des vidéos, des exercices et des quiz pour vous aider à progresser à votre rythme.",
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF707070),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Contenu de la formation :",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF23468E),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "- Introduction\n"
              "- Leçon 1 : Présentation\n"
              "- Leçon 2 : Pratique\n"
              "- Quiz final",
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF707070),
              ),
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
                child: const Text("Suivre", style: TextStyle(fontSize: 14)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
