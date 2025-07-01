import "package:flutter/material.dart";

class LoginPage extends StatelessWidget {
    const LoginPage({ Key? key }) : super(key:key);

    @override
    Widget build(BuildContext context){
        return Scaffold(
            body: Container(
                padding: const EdgeInsets.all(70),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/bg.jpg"),
                        fit: BoxFit.cover
                    )
                ),
                child: Center(
                    child: Text("Hello user, would you want to connect? Come back later.")
                )
            )
        );
    }
}