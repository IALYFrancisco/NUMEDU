import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'detailsformation.dart';

class AutresPage extends StatelessWidget {
  final String searchQuery;

  const AutresPage({Key? key, required this.searchQuery}) : super(key: key);

  Stream<QuerySnapshot> _getFirestoreFormations() {
    return FirebaseFirestore.instance.collection('formations').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    return StreamBuilder<QuerySnapshot>(
      stream: _getFirestoreFormations(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("Aucune formation trouvée"));
        }

        final docs = snapshot.data!.docs;

        // 🔎 Filtrage par titre avec searchQuery
        final filteredDocs = docs.where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final title = (data['title'] ?? '').toString().toLowerCase();
          return title.contains(searchQuery.toLowerCase());
        }).toList();

        if (filteredDocs.isEmpty) {
          return const Center(child: Text("Aucune formation correspondante"));
        }

        return ListView.builder(
          itemCount: filteredDocs.length,
          itemBuilder: (context, index) {
            final data = filteredDocs[index].data() as Map<String, dynamic>;
            final formationId = filteredDocs[index].id;
            final title = data['title'] ?? 'Sans titre';
            final description = data['descriptions'] ?? '';

            return StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("userFormations")
                  .doc("${userId}_$formationId")
                  .snapshots(),
              builder: (context, suiviSnapshot) {
                final isSuivie =
                    suiviSnapshot.hasData && suiviSnapshot.data!.exists;

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => FormationDetailsPage(formationID: docs[index].id)),
                    );
                  },
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                    child: Stack(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: const BoxDecoration(
                                color: Color(0xFF23468E),
                                shape: BoxShape.circle,
                              ),
                              child:
                                  const Icon(Icons.book, color: Colors.white),
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
                                        color: Colors.grey[600]),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              minimumSize: const Size(0, 0),
                              tapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              backgroundColor: isSuivie
                                  ? Colors.green
                                  : const Color(0xFF23468E),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            onPressed: () async {
                              if (userId == null) return;

                              final docRef = FirebaseFirestore.instance
                                  .collection("userFormations")
                                  .doc("${userId}_$formationId");

                              if (isSuivie) {
                                await docRef.delete();
                              } else {
                                await docRef.set({
                                  "userId": userId,
                                  "formationId": formationId,
                                  "status": "suivie",
                                  "date": FieldValue.serverTimestamp(),
                                });
                              }
                            },
                            child: Text(
                              isSuivie ? "suivie" : "suivre",
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.white),
                            ),
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