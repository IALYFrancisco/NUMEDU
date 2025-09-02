import 'package:flutter/material.dart';
import 'editprofile.dart'; // Import pour la page d'édition

class ProfileView extends StatelessWidget {
  final String name;
  final String email;
  final String? profileImageUrl;

  const ProfileView({
    Key? key,
    required this.name,
    required this.email,
    this.profileImageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double fixedHeight = 275.0;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                // Image de couverture / photo de profil
                Container(
                  height: fixedHeight,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: profileImageUrl != null
                          ? NetworkImage(profileImageUrl!)
                          : const AssetImage('assets/images/default-avatar.jpg')
                              as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // Barre supérieure avec bouton retour et edit
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: kToolbarHeight + MediaQuery.of(context).padding.top,
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top,
                      left: 14,
                      right: 14,
                    ),
                    color: Colors.transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Bouton retour
                        Container(
                          decoration: const BoxDecoration(
                            color: Color(0xFF23468E),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            padding: const EdgeInsets.all(4), // marge interne réduite
                            icon: const Icon(Icons.chevron_left,
                                size: 28, color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),

                        // Bouton edit
                        Container(
                          decoration: const BoxDecoration(
                            color: Color(0xFF23468E),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            padding: const EdgeInsets.all(4),
                            icon: const Icon(Icons.edit, size: 18, color: Colors.white),
                            onPressed: () {
                              // Préparer les données à envoyer à l'édition
                              final userData = {
                                'name': name,
                                'email': email,
                                'profileImageUrl': profileImageUrl,
                              };

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProfileEdit(userData: userData),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Affichage du nom et email en bas de l'image
                Positioned(
                  left: 16,
                  bottom: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                                blurRadius: 4,
                                color: Colors.black54,
                                offset: Offset(1, 1))
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        email,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          shadows: [
                            Shadow(
                                blurRadius: 4,
                                color: Colors.black45,
                                offset: Offset(1, 1))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
