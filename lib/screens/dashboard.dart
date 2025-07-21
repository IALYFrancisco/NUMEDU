import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final TextEditingController _searchController = TextEditingController();

  final List<String> _formations = [
    "Utiliser un smartphone",
    "Créer une adresse email",
    "Naviguer sur Internet",
    "Remplir un formulaire en ligne",
    "Consulter un site gouvernemental",
    "Installer une application",
  ];

  final List<String> _descriptions = [
    "Apprenez à maîtriser les fonctionnalités de base de votre smartphone pour mieux communiquer, utiliser les applications et gérer vos contacts au quotidien.",
    "Découvrez comment créer, configurer et gérer efficacement une adresse email, envoyer des messages, gérer votre boîte de réception et rester connecté.",
    "Explorez les bonnes pratiques pour naviguer en toute sécurité sur Internet, rechercher des informations fiables, et utiliser les moteurs de recherche efficacement.",
    "Un guide complet pour remplir correctement les formulaires en ligne, éviter les erreurs courantes et soumettre vos demandes aux services publics sans souci.",
    "Apprenez à consulter et utiliser les sites gouvernementaux officiels pour accéder aux services en ligne, télécharger des documents et effectuer des démarches administratives.",
    "Comprenez comment installer, mettre à jour et gérer les applications mobiles essentielles sur votre smartphone pour améliorer votre expérience numérique.",
  ];


  // Liste des progressions correspondantes en valeur entre 0 et 1
  final List<double> _progressions = [
    0.8,  // 80%
    0.35, // 35%
    0.5,  // 50%
    0.95, // 95%
    0.12, // 12%
    1.0,  // 100%
  ];

  List<String> _filtered = [];
  List<String> _filteredDescriptions = [];
  List<double> _filteredProgress = [];

  @override
  void initState() {
    super.initState();
    _filtered = List.from(_formations);
    _filteredDescriptions = List.from(_descriptions);
    _filteredProgress = List.from(_progressions);
    _searchController.addListener(_filterList);
  }

  void _filterList() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filtered = [];
      _filteredDescriptions = [];
      _filteredProgress = [];

      for (int i = 0; i < _formations.length; i++) {
        if (_formations[i].toLowerCase().contains(query)) {
          _filtered.add(_formations[i]);
          _filteredDescriptions.add(_descriptions[i]);
          _filteredProgress.add(_progressions[i]);
        }
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/images/logo-de-numedu.png',
                  width: 24,
                  height: 24,
                ),
                SizedBox(width: 8),
                Text(
                  "Formations",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ],
            ),
            Row(
              children: [
                Icon(Icons.notifications_none, color: Colors.black),
                SizedBox(width: 10),
                CircleAvatar(
                  backgroundColor: Colors.grey[300],
                  child: Icon(Icons.person, color: Colors.black),
                  radius: 16,
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 18.0),
                hintText: "Rechercher une formation...",
                prefixIcon: Icon(Icons.search, size: 20),
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50.0),
                  borderSide: BorderSide(
                    color: Colors.grey.withOpacity(0.4),
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50.0),
                  borderSide: BorderSide(
                    color: Color(0xFF23468E),
                    width: 1,
                  ),
                ),
              ),
              style: TextStyle(fontSize: 14),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filtered.length,
              itemBuilder: (context, index) {
                final progress = _filteredProgress[index];
                final percent = (progress * 100).toInt();

                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  padding: EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      CircularPercentIndicator(
                        radius: 30.0,
                        lineWidth: 3.0,
                        percent: progress,
                        center: Text(
                          "$percent%",
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        progressColor: Color(0xFF23468E),
                        backgroundColor: Colors.grey[300]!,
                        circularStrokeCap: CircularStrokeCap.round,
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _filtered[index],
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                            ),
                            SizedBox(height: 4),
                            Text(
                              _filteredDescriptions[index],
                              style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}