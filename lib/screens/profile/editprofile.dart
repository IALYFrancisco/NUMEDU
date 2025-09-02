import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileEdit extends StatefulWidget {
  final Map<String, dynamic> userData;
  const ProfileEdit({Key? key, required this.userData}) : super(key: key);

  @override
  State<ProfileEdit> createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userData['name']);
    _emailController = TextEditingController(text: widget.userData['email']);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  // Ré-authentification avec l'ancien email
  Future<bool> _reauthenticateUser(String oldEmail) async {
    String? password = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        TextEditingController passController = TextEditingController();
        return AlertDialog(
          title: const Text("Confirmez votre mot de passe"),
          content: TextField(
            controller: passController,
            obscureText: true,
            decoration:
                const InputDecoration(labelText: "Mot de passe actuel"),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context, null),
                child: const Text("Annuler")),
            TextButton(
                onPressed: () =>
                    Navigator.pop(context, passController.text.trim()),
                child: const Text("Confirmer")),
          ],
        );
      },
    );

    if (password == null || password.isEmpty) return false;

    try {
      User user = _auth.currentUser!;
      AuthCredential credential =
          EmailAuthProvider.credential(email: oldEmail, password: password);
      await user.reauthenticateWithCredential(credential);
      return true;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Ré-authentification échouée: $e")),
      );
      return false;
    }
  }

  Future<void> _updateProfile() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final newName = _nameController.text.trim();
    final newEmail = _emailController.text.trim();
    final oldEmail = widget.userData['email'];

    try {
      // Mise à jour du nom
      if (newName != widget.userData['name']) {
        await _firestore.collection('users').doc(user.uid).update({
          'name': newName,
        });
      }

      // Mise à jour de l'email
      if (newEmail != oldEmail) {
        // Ré-authentification avec l'ancien email
        bool reauthSuccess = await _reauthenticateUser(oldEmail);
        if (!reauthSuccess) return;

        // Mettre à jour l'email dans Firebase Auth
        await user.updateEmail(newEmail);

        // Envoyer un email de vérification pour le nouveau mail
        await user.sendEmailVerification();

        // Mettre à jour l'email dans Firestore
        await _firestore.collection('users').doc(user.uid).update({
          'email': newEmail,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Email mis à jour ! Un email de vérification a été envoyé à $newEmail.",
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profil mis à jour avec succès !")),
        );
      }

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors de la mise à jour : $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Modifier Profil"),
        backgroundColor: const Color(0xFF23468E),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Nom"),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _updateProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF23468E),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              ),
              child:
                  const Text("Enregistrer", style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}