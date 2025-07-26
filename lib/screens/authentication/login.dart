import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart'; // Ajout
import '../dashboard.dart';
import 'register.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({ Key? key }) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Connexion réussie → rediriger vers Dashboard
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const DashboardPage()),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message;
      });
    } catch (e) {
      setState(() {
        _errorMessage = "Une erreur est survenue.";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Center(
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: [
              ClipRRect(
                child: Image.asset(
                  'assets/images/bg.jpg',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
              ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 2, sigmaY: 5),
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.black.withOpacity(0.8),
                  ),
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/logo-de-numedu.png', width: 80),
                    const SizedBox(height: 20),
                    const Text(
                      "Connexion",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                      )
                    ),
                    const SizedBox(height: 50),
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      width: 275,
                      child: Column(
                        children: [
                          // Email
                          const Row(children: [ 
                            Text(
                              "Votre email :",
                              style: TextStyle(color: Colors.white, fontSize: 15)
                            )
                          ]),
                          const SizedBox(height: 5),
                          TextField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              hintText: "ex: johndoe@example.com",
                              isDense: true,
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 18.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50.0),
                                borderSide: const BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50.0),
                                borderSide: const BorderSide(color: Color(0xFF23468E), width: 2),
                              ),
                            ),
                            style: const TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          const SizedBox(height: 25),

                          // Password
                          const Row(children: [ 
                            Text(
                              "Votre mot de passe :",
                              style: TextStyle(color: Colors.white, fontSize: 15)
                            )
                          ]),
                          const SizedBox(height: 5),
                          TextField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              hintText: ".......",
                              isDense: true,
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 18.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50.0),
                                borderSide: const BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50.0),
                                borderSide: const BorderSide(color: Color(0xFF23468E), width: 2),
                              ),
                            ),
                            obscureText: true,
                            style: const TextStyle(fontSize: 14, color: Colors.grey),
                          ),

                          const SizedBox(height: 25),

                          if (_errorMessage != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Text(
                                _errorMessage!,
                                style: const TextStyle(color: Colors.redAccent, fontSize: 14),
                                textAlign: TextAlign.center,
                              ),
                            ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed: _isLoading ? null : _login,
                                style: ElevatedButton.styleFrom(
                                  shape: const StadiumBorder(),
                                  backgroundColor: const Color(0xFF23468E),
                                  foregroundColor: Colors.white,
                                ),
                                child: _isLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text("Connexion", style: TextStyle(color: Colors.white)),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const RegisterPage())
                                  );
                                },
                                child: const Text(
                                  "Pas de compte ?",
                                  style: TextStyle(fontSize: 12, color: Colors.white),
                                )
                              ),
                            ]
                          )
                        ]
                      )
                    )
                  ]
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}