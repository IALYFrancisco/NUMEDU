import "package:flutter/material.dart";
import "register.dart";
import 'dart:ui';
import '../dashboard.dart';

class LoginPage extends StatelessWidget {
    const LoginPage({ Key? key }) : super(key:key);

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
                            Image.asset(
                                'assets/images/logo-de-numedu.png',
                                width: 80
                            ),
                            SizedBox(height: 20),
                            Text(
                                "Connexion",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold
                                )
                            ),
                            SizedBox(height: 50),
                            Column(
                                children: [
                                    Container(
                                        padding: EdgeInsets.all(16.0),
                                        width: 275,
                                        child: Column(
                                            children: [
                                                Row(
                                                    children: [ 
                                                        Text(
                                                            "Votre email :",
                                                            style: TextStyle(
                                                                color: Colors.white,
                                                                fontSize: 15
                                                            )
                                                        ),
                                                    ]
                                                ),
                                                SizedBox(height: 5),
                                                TextField(
                                                    decoration: InputDecoration(
                                                        hintText: "ex: johndoe@example.com",
                                                        isDense: true,
                                                        filled: true,
                                                        fillColor: Colors.white,
                                                        contentPadding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 18.0),
                                                        border: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(50.0),
                                                            ),
                                                            enabledBorder: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(50.0),
                                                            borderSide: BorderSide(color: Colors.grey),
                                                            ),
                                                            focusedBorder: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(50.0),
                                                            borderSide: BorderSide(color: const Color(0xFF23468E), width: 2),
                                                            ),
                                                    ),
                                                    style: TextStyle(fontSize: 14, color: Colors.grey),
                                                ),
                                                SizedBox(height: 25),
                                                Row(
                                                    children: [ 
                                                        Text(
                                                            "Votre mot de passe :",
                                                            style: TextStyle(
                                                                color: Colors.white,
                                                                fontSize: 15
                                                            )
                                                        ),
                                                    ]
                                                ),
                                                TextField(
                                                    decoration: InputDecoration(
                                                        hintText: ".......",
                                                        isDense: true,
                                                        filled: true,
                                                        fillColor: Colors.white,
                                                        contentPadding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 18.0),
                                                        border: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(50.0),
                                                            ),
                                                            enabledBorder: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(50.0),
                                                            borderSide: BorderSide(color: Colors.grey),
                                                            ),
                                                            focusedBorder: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(50.0),
                                                            borderSide: BorderSide(color: const Color(0xFF23468E), width: 2),
                                                            ),
                                                    ),
                                                    style: TextStyle(fontSize: 14, color: Colors.grey),
                                                ),
                                                SizedBox(height: 25),
                                                Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                        ElevatedButton(
                                                            onPressed: () {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(builder: (context) => const DashboardPage())
                                                                );
                                                            },
                                                            style: ElevatedButton.styleFrom(
                                                            shape: const StadiumBorder(),
                                                            backgroundColor: const Color(0xFF23468E),
                                                            foregroundColor: Colors.white,
                                                            ),
                                                            child: const Text(
                                                            "Connexion",
                                                            style: TextStyle(color: Colors.white),
                                                            ),
                                                        ),
                                                        GestureDetector(
                                                            onTap: (){
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute( builder: (context) => const RegisterPage() )
                                                                );
                                                            },
                                                            child: Text(
                                                                    "Pas de compte ?",
                                                                    style: TextStyle(
                                                                        fontSize: 12,
                                                                        color: Colors.white
                                                                    )
                                                                )
                                                        ),
                                                    ]
                                                )
                                            ]
                                        )
                                    )
                                ]
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