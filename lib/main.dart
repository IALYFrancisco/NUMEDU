import 'package:flutter/material.dart';
import 'screens/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "TON_API_KEY",
        authDomain: "TON_AUTH_DOMAIN",
        projectId: "TON_PROJECT_ID",
        storageBucket: "TON_STORAGE_BUCKET",
        messagingSenderId: "TON_MESSAGING_SENDER_ID",
        appId: "TON_APP_ID",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Numedu",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Roboto",
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
