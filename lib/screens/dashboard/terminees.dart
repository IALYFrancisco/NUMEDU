import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'detailsformation.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TermineesPage extends StatelessWidget {
  final String searchQuery;

  const TermineesPage({Key? key, required this.searchQuery}) : super(key: key);

  Stream<QuerySnapshot> _getUserFormations() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return const Stream.empty();

    return FirebaseFirestore.instance
        .collection('userFormations') // même collection que encours.dart
        .where('userId', isEqualTo: uid)
        .where('progress', isEqualTo: 1.0) // formations terminées
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _getUserFormations(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

        final userDocs = snapshot.data!.docs;

        // Appliquer filtre de recherche
        final filteredDocs = userDocs.where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final formationID = data['formationID'] ?? '';
          return formationID.toLowerCase().contains(searchQuery.toLowerCase());
        }).toList();

        if (filteredDocs.isEmpty) {
          return const Center(child: Text("Aucune formation terminée trouvée."));
        }

        return ListView.builder(
          itemCount: filteredDocs.length,
          itemBuilder: (context, index) {
            final userData = filteredDocs[index].data() as Map<String, dynamic>;
            final formationID = userData['formationID'] as String;
            final progress = (userData['progress'] ?? 0.0).toDouble();
            final percent = (progress * 100).toInt();

            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('formations')
                  .doc(formationID)
                  .get(),
              builder: (context, formationSnapshot) {
                if (!formationSnapshot.hasData) return const SizedBox();

                final formationData = formationSnapshot.data!.data() as Map<String, dynamic>?;

                if (formationData == null) return const SizedBox();

                final title = formationData['title'] ?? '';
                final description = formationData['descriptions'] ?? '';

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            FormationDetailsPage(formationID: formationID),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
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
                        CircularPercentIndicator(
                          radius: 30,
                          lineWidth: 3,
                          percent: progress,
                          center: Text(
                            "$percent%",
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          progressColor: const Color(0xFF23468E),
                          backgroundColor: Colors.grey[300]!,
                          circularStrokeCap: CircularStrokeCap.round,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF23468E),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                description,
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
      },
    );
  }
}
