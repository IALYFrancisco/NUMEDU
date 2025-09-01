import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../detailsformation.dart';

class EngageesPage extends StatelessWidget {
  const EngageesPage({Key? key, this.searchQuery}) : super(key: key);

  final String? searchQuery;

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final query = searchQuery?.toLowerCase() ?? '';

    if (userId == null) {
      return const Center(child: Text("Utilisateur non connecté"));
    }

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _getUserFormations(userId, query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("Aucune formation engagée"));
        }

        final formations = snapshot.data!;

        return ListView.builder(
          itemCount: formations.length,
          itemBuilder: (context, index) {
            final formation = formations[index];

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FormationDetailsPage()),
                );
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFEBFEFF),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Color(0xFF23468E),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.book, color: Colors.white),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            formation['title'] ?? 'Sans titre',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF23468E),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            formation['description'] ?? '',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[600],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<List<Map<String, dynamic>>> _getUserFormations(
      String userId, String query) async {
    final userFormationsSnapshot = await FirebaseFirestore.instance
        .collection("userFormations")
        .where("userId", isEqualTo: userId)
        .where("status", isEqualTo: "suivie")
        .get();

    List<Map<String, dynamic>> result = [];

    for (var doc in userFormationsSnapshot.docs) {
      final formationId = doc['formationId'];

      // Requête sur la collection "formations" avec where sur formationID
      final formationSnapshot = await FirebaseFirestore.instance
          .collection("formations")
          .where("formationID", isEqualTo: formationId)
          .get();

      if (formationSnapshot.docs.isNotEmpty) {
        final formationDoc = formationSnapshot.docs.first;
        final title = formationDoc['title'] ?? '';
        final description = formationDoc['descriptions'] ?? '';

        // Filtrer si besoin
        if (title.toLowerCase().contains(query)) {
          result.add({
            'title': title,
            'description': description,
          });
        }
      }
    }

    return result;
  }
}