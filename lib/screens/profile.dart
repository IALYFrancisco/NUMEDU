import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  File? _imageFile;
  String? _profileImageUrl;
  bool _isEditing = false;

  String? _originalEmail;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final uid = _auth.currentUser!.uid;
    final doc = await _firestore.collection('users').doc(uid).get();
    final data = doc.data();

    if (data != null) {
      _nameController.text = data['name'] ?? '';
      _emailController.text = data['email'] ?? '';
      _profileImageUrl = data['profileImageUrl'];
      _originalEmail = data['email'] ?? '';
      setState(() {});
    }
  }

  Future<void> _pickImage() async {
    if (!_isEditing) return;
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _imageFile = File(picked.path));
    }
  }

  Future<String?> _uploadImage(File imageFile) async {
    final uid = _auth.currentUser!.uid;
    final ref = FirebaseStorage.instance.ref().child('profile_images/$uid.jpg');
    await ref.putFile(imageFile);
    return await ref.getDownloadURL();
  }

  Future<String?> _askForPassword() async {
    final passwordController = TextEditingController();
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Confirmez votre mot de passe"),
        content: TextField(
          controller: passwordController,
          obscureText: true,
          decoration: const InputDecoration(labelText: "Mot de passe actuel"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(null),
            child: const Text("Annuler"),
          ),
          TextButton(
            onPressed: () {
              if (passwordController.text.isEmpty) return;
              Navigator.of(context).pop(passwordController.text);
            },
            child: const Text("Confirmer"),
          ),
        ],
      ),
    );
  }

  Future<void> _saveProfile() async {
    final user = _auth.currentUser!;
    String? newImageUrl = _profileImageUrl;

    if (_imageFile != null) {
      newImageUrl = await _uploadImage(_imageFile!);
    }

    try {
      if (_emailController.text.trim() != _originalEmail) {
        final password = await _askForPassword();
        if (password == null || password.isEmpty) return;

        final credential = EmailAuthProvider.credential(
          email: _originalEmail!,
          password: password,
        );

        await user.reauthenticateWithCredential(credential);
        await user.updateEmail(_emailController.text.trim());
        _originalEmail = _emailController.text.trim();
      }

      await _firestore.collection('users').doc(user.uid).update({
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'profileImageUrl': newImageUrl,
      });

      setState(() {
        _isEditing = false;
        _profileImageUrl = newImageUrl;
        _imageFile = null;
      });
    } catch (e) {}
  }

  Future<void> _changePassword() async {
    String? newPassword = await showDialog(
      context: context,
      builder: (context) {
        String tempPassword = '';
        return AlertDialog(
          title: const Text('Changer le mot de passe'),
          content: TextField(
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Nouveau mot de passe'),
            onChanged: (value) => tempPassword = value,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, tempPassword),
              child: const Text('Confirmer'),
            ),
          ],
        );
      },
    );

    if (newPassword != null && newPassword.length >= 6) {
      try {
        await _auth.currentUser!.updatePassword(newPassword);
      } catch (e) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    const double fixedHeight = 275.0;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: fixedHeight,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: _imageFile != null
                            ? FileImage(_imageFile!)
                            : (_profileImageUrl != null
                                ? NetworkImage(_profileImageUrl!)
                                : const AssetImage('assets/images/default-avatar.jpg'))
                            as ImageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 16,
                  bottom: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _isEditing
                              ? SizedBox(
                                  width: 200,
                                  child: TextField(
                                    controller: _nameController,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    decoration: const InputDecoration(
                                      isDense: true,
                                      contentPadding:
                                          EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                )
                              : Text(
                                  _nameController.text.isEmpty ? 'Nom utilisateur' : _nameController.text,
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
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.white, size: 20),
                            onPressed: () {
                              setState(() {
                                _isEditing = true;
                              });
                            },
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _isEditing
                              ? SizedBox(
                                  width: 250,
                                  child: TextField(
                                    controller: _emailController,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 16,
                                    ),
                                    decoration: const InputDecoration(
                                      isDense: true,
                                      contentPadding:
                                          EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                )
                              : Text(
                                  _emailController.text.isEmpty
                                      ? 'email@exemple.com'
                                      : _emailController.text,
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
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.white70, size: 18),
                            onPressed: () {
                              setState(() {
                                _isEditing = true;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: kToolbarHeight + MediaQuery.of(context).padding.top,
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top,
                      left: 8,
                      right: 8,
                    ),
                    color: Colors.transparent,
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chevron_left, size: 32, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.camera_alt, color: Colors.white),
                          tooltip: 'Changer la photo de profil',
                          onPressed: () {
                            setState(() {
                              _isEditing = true;
                            });
                            _pickImage();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Mot de passe", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextField(
                    obscureText: true,
                    enabled: false,
                    decoration: const InputDecoration(
                      labelText: "****************",
                      hintText: "********",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _changePassword,
                    child: const Text("Changer le mot de passe"),
                  ),
                  const SizedBox(height: 24),
                  if (_isEditing)
                    Row(
                      children: [
                        ElevatedButton.icon(
                          icon: const Icon(Icons.save),
                          label: const Text("Enregistrer"),
                          onPressed: _saveProfile,
                        ),
                        const SizedBox(width: 12),
                        OutlinedButton(
                          onPressed: () {
                            setState(() {
                              _isEditing = false;
                              _loadUserData();
                            });
                          },
                          child: const Text("Annuler"),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}