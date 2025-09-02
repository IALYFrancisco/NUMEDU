import 'dart:convert';
import 'dart:io' show File; // uniquement dispo sur mobile
import 'dart:typed_data';
import 'package:flutter/foundation.dart'; // pour kIsWeb
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class ProfileEdit extends StatefulWidget {
  final Map<String, dynamic> userData;
  const ProfileEdit({Key? key, required this.userData}) : super(key: key);

  @override
  State<ProfileEdit> createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  File? _selectedImageFile;
  Uint8List? _selectedImageBytes; // pour web
  String? _imageUrl;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userData['name']);
    _emailController = TextEditingController(text: widget.userData['email']);
    _imageUrl = widget.userData['profile']; // clé Firestore = "profile"
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (kIsWeb) {
        // Web → on garde les bytes
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _selectedImageBytes = bytes;
          _selectedImageFile = null;
        });
      } else {
        // Mobile → on garde le fichier
        setState(() {
          _selectedImageFile = File(pickedFile.path);
          _selectedImageBytes = null;
        });
      }
    }
  }

  // Upload image vers ton API
  Future<String?> _uploadImageToAPI() async {
    try {
      var request = http.MultipartRequest(
        "POST",
        Uri.parse("https://numedu.onrender.com/api/images/"),
      );

      if (kIsWeb && _selectedImageBytes != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            "image",
            _selectedImageBytes!,
            filename: "upload.png",
          ),
        );
      } else if (_selectedImageFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath("image", _selectedImageFile!.path),
        );
      } else {
        return null; // pas d’image sélectionnée
      }

      var response = await request.send();

      if (response.statusCode == 201 || response.statusCode == 200) {
        final respStr = await response.stream.bytesToString();
        final data = json.decode(respStr);
        return data["image"]; // ex: http://numedu.onrender.com/media/uploads/xxx.jpg
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Échec de l’upload (${response.statusCode})")),
        );
        return null;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors de l’upload : $e")),
      );
      return null;
    }
  }

  Future<void> _updateProfile() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final newName = _nameController.text.trim();
    final newEmail = _emailController.text.trim();
    final oldEmail = widget.userData['email'];

    try {
      // Upload image si modifiée
      if (_selectedImageFile != null || _selectedImageBytes != null) {
        String? url = await _uploadImageToAPI();
        if (url != null) {
          _imageUrl = url;
          await _firestore.collection('users').doc(user.uid).update({
            'profile': url,
          });
        }
      }

      // Mise à jour du nom
      if (newName != widget.userData['name']) {
        await _firestore.collection('users').doc(user.uid).update({
          'name': newName,
        });
      }

      // Mise à jour de l'email
      if (newEmail != oldEmail) {
        bool reauthSuccess = await _reauthenticateUser(oldEmail);
        if (!reauthSuccess) return;

        await user.updateEmail(newEmail);
        await user.sendEmailVerification();

        await _firestore.collection('users').doc(user.uid).update({
          'email': newEmail,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Email mis à jour ! Vérifiez $newEmail.")),
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
            decoration: const InputDecoration(labelText: "Mot de passe actuel"),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, null), child: const Text("Annuler")),
            TextButton(onPressed: () => Navigator.pop(context, passController.text.trim()), child: const Text("Confirmer")),
          ],
        );
      },
    );

    if (password == null || password.isEmpty) return false;

    try {
      User user = _auth.currentUser!;
      AuthCredential credential = EmailAuthProvider.credential(email: oldEmail, password: password);
      await user.reauthenticateWithCredential(credential);
      return true;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Ré-authentification échouée: $e")));
      return false;
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
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _selectedImageFile != null
                    ? FileImage(_selectedImageFile!)
                    : _selectedImageBytes != null
                        ? MemoryImage(_selectedImageBytes!)
                        : (_imageUrl != null
                            ? NetworkImage(_imageUrl!)
                            : const AssetImage("assets/images/default-avatar.jpg")) as ImageProvider,
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 16,
                    child: const Icon(Icons.edit, size: 18, color: Colors.black),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
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
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              ),
              child: const Text("Enregistrer", style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
