import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _formations = [
    "Utiliser un smartphone",
    "Créer une adresse email",
    "Naviguer sur Internet",
    "Remplir un formulaire en ligne",
    "Consulter un site gouvernemental",
    "Installer une application",
  ];
  List<String> _filtered = [];

  @override
  void initState() {
    super.initState();
    _filtered = _formations;
    _searchController.addListener(_filterList);
  }

  void _filterList() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filtered = _formations
          .where((item) => item.toLowerCase().contains(query))
          .toList();
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
            Text("Formations", style: TextStyle(fontSize: 16, color: Colors.black)),
            Row(
              children: [
                Icon(Icons.notifications_none, color: Colors.black),
                SizedBox(width: 10),
                CircleAvatar(
                  backgroundColor: Colors.grey[300],
                  child: Icon(Icons.person, color: Colors.black),
                  radius: 16,
                )
              ],
            )
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
                hintText: "Rechercher une formation...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filtered.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(_filtered[index]),
                leading: Icon(Icons.school),
              ),
            ),
          ),
        ],
      ),
    );
  }
}