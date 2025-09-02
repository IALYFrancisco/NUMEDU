import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'authentication/login.dart';
import 'profile.dart';
import 'dashboard/autres.dart';
import 'dashboard/engagees.dart';
import 'dashboard/encours.dart';
import 'dashboard/terminees.dart';

class CustomPopupMenuItem extends PopupMenuEntry<int> {
  final Widget child;
  final int value;

  const CustomPopupMenuItem({required this.child, required this.value});

  @override
  double get height => kMinInteractiveDimension - 15;

  @override
  bool represents(int? value) => this.value == value;

  @override
  State createState() => _CustomPopupMenuItemState();
}

class _CustomPopupMenuItemState extends State<CustomPopupMenuItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pop(context, widget.value),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: widget.child,
      ),
    );
  }
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;
  String? userName;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => setState(() {}));
    _tabController = TabController(length: 4, vsync: this);
    _loadUserNameFromFirestore();
  }

  Future<void> _loadUserNameFromFirestore() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      try {
        final doc =
            await FirebaseFirestore.instance.collection('users').doc(uid).get();
        if (doc.exists) {
          setState(() {
            userName = doc.data()?['name'] ?? 'Utilisateur';
          });
        } else {
          setState(() {
            userName = 'Utilisateur';
          });
        }
      } catch (e) {
        setState(() {
          userName = 'Utilisateur';
        });
        print('Erreur récupération nom utilisateur Firestore : $e');
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF23468E),
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
                const SizedBox(width: 8),
                const Text(
                  "Formations",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.notifications_none, color: Colors.white),
                const SizedBox(width: 10),
                GestureDetector(
                  onTapDown: (details) async {
                    final selected = await showMenu<int>(
                      context: context,
                      position: RelativeRect.fromLTRB(
                        details.globalPosition.dx,
                        details.globalPosition.dy,
                        details.globalPosition.dx,
                        details.globalPosition.dy,
                      ),
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      items: [
                        PopupMenuItem(
                          enabled: false,
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ProfilePage()),
                              );
                            },
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundImage: user?.photoURL != null
                                      ? NetworkImage(user!.photoURL!)
                                      : const AssetImage(
                                              'assets/images/default-avatar.jpg')
                                          as ImageProvider,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        userName ?? 'Utilisateur',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        user?.email ?? '',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600]),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const PopupMenuDivider(),
                        CustomPopupMenuItem(
                          value: 1,
                          child: Row(
                            children: const [
                              Icon(Icons.logout, color: Colors.red, size: 16),
                              SizedBox(width: 6),
                              Text('Déconnexion',
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 13)),
                            ],
                          ),
                        ),
                      ],
                    );

                    if (selected == 1) {
                      await FirebaseAuth.instance.signOut();
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                      );
                    }
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.grey[300],
                    radius: 16,
                    backgroundImage: user?.photoURL != null
                        ? NetworkImage(user!.photoURL!)
                        : const AssetImage(
                                'assets/images/default-avatar.jpg')
                            as ImageProvider,
                  ),
                ),
              ],
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle:
              const TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontSize: 12.0),
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Toutes'),
            Tab(text: 'Engagées'),
            Tab(text: 'En cours'),
            Tab(text: 'Terminées'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Barre de recherche
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 18.0),
                hintText: "Rechercher une formation...",
                prefixIcon: const Icon(Icons.search, size: 20),
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
                  borderSide: const BorderSide(
                    color: Color(0xFF23468E),
                    width: 1,
                  ),
                ),
              ),
              style: const TextStyle(fontSize: 14),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // 1. Toutes les formations
                AutresPage(searchQuery: _searchController.text),

                // 2. Formations engagées
                EngageesPage(searchQuery: _searchController.text),

                // 3. Formations en cours (0.1 <= progress <= 0.9)
                EncoursPage(searchQuery: _searchController.text),

                // 4. Formations terminées (progress == 1.0)
                TermineesPage(searchQuery: _searchController.text),
              ],
            ),
          ),
        ],
      ),
    );
  }
}