import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'authentication/login.dart';
import 'profile.dart';
import 'detailsformation.dart';

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

  final List<String> _formations = [
    "Utiliser un smartphone",
    "Créer une adresse email",
    "Naviguer sur Internet",
    "Remplir un formulaire en ligne",
    "Consulter un site gouvernemental",
    "Installer une application",
  ];

  final List<String> _descriptions = [
    "Apprenez à maîtriser les fonctionnalités de base de votre smartphone...",
    "Découvrez comment créer et gérer une adresse email...",
    "Explorez les bonnes pratiques pour naviguer en toute sécurité...",
    "Un guide complet pour remplir correctement les formulaires en ligne...",
    "Apprenez à consulter et utiliser les sites gouvernementaux officiels...",
    "Comprenez comment installer et gérer les applications mobiles...",
  ];

  final List<double> _progressions = [0.8, 0.35, 0.5, 0.95, 0.12, 1.0];

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

  List<int> _getFilteredIndices(int tabIndex) {
    final query = _searchController.text.toLowerCase();
    return List.generate(_formations.length, (i) {
      final matchesSearch = _formations[i].toLowerCase().contains(query);
      final progress = _progressions[i];

      switch (tabIndex) {
        case 0:
          return matchesSearch && progress > 0 && progress < 1 ? i : -1;
        case 1:
          return matchesSearch && progress == 1.0 ? i : -1;
        case 2:
          return matchesSearch ? i : -1;
        default:
          return -1;
      }
    }).where((i) => i != -1).toList();
  }

  Stream<QuerySnapshot> _getFirestoreFormations() {
    return FirebaseFirestore.instance.collection('formations').snapshots();
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
                    color: Colors.white, // titre en blanc
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
            Tab(text: 'En cours'),
            Tab(text: 'Terminées'),
            Tab(text: 'Engagées'),
            Tab(text: 'Autres'),
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
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 18.0),
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
                    color: Colors.white,
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
                _buildLocalList(0),
                _buildLocalList(1),
                _buildLocalList(2),
                _buildOtherList(), // <-- section Autres
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocalList(int tabIndex) {
    final filteredIndices = _getFilteredIndices(tabIndex);

    return ListView.builder(
      itemCount: filteredIndices.length,
      itemBuilder: (context, listIndex) {
        final index = filteredIndices[listIndex];
        final progress = _progressions[index];
        final percent = (progress * 100).toInt();

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
                  radius: 30.0,
                  lineWidth: 3.0,
                  percent: progress,
                  center: Text(
                    "$percent%",
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  progressColor: const Color(0xFF23468E),
                  backgroundColor: Colors.grey,
                  circularStrokeCap: CircularStrokeCap.round,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _formations[index],
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF23468E),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _descriptions[index],
                        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
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
  }

  Widget _buildOtherList() {
    final query = _searchController.text.toLowerCase();

    return StreamBuilder<QuerySnapshot>(
      stream: _getFirestoreFormations(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("Aucune formation trouvée"));
        }

        final docs = snapshot.data!.docs.where((doc) {
          final title = (doc['title'] ?? '').toString().toLowerCase();
          return title.contains(query);
        }).toList();

        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final data = docs[index].data() as Map<String, dynamic>;
            final title = data['title'] ?? 'Sans titre';
            final description = data['descriptions'] ?? '';

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const FormationDetailsPage()),
                );
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFEBFEFF), // fond bleu très clair
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
                          decoration: BoxDecoration(
                            color: const Color(0xFF23468E),
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
                                    fontSize: 11, color: Colors.grey[600]),
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
                          backgroundColor: const Color(0xFF23468E),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {},
                        child: const Text(
                          "Suivre",
                          style: TextStyle(fontSize: 12, color: Colors.white),
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
  }
}