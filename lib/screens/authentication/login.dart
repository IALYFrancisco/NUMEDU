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
                    child: SingleChildScrollView(
                        padding: EdgeInsets.all(24),
                        child: Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            elevation: 10,
                            child: Padding(
                                padding: EdgeInsets.all(20),
                                child: Form(
                                    child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                            Text(
                                                "hello!",
                                                style: TextStyle(
                                                    fontSize: 26,
                                                    fontWeight: FontWeight.bold
                                                )
                                            ),
                                            SizedBox(height: 20),
                                            TextFormField(
                                                decoration: InputDecoration(
                                                    labelText: "Username"
                                                )
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                                children: [
                                                    Checkbox(value: true, onChanged: (v){}),
                                                    Expanded(child: Text("I agree to the termes and conditions.")) 
                                                ]
                                            ),
                                            SizedBox(height: 10),
                                            ElevatedButton(
                                                onPressed: () {},
                                                style: ElevatedButton.styleFrom(
                                                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                                                    shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(30) ),
                                                    backgroundColor: Colors.blueAccent
                                                ),
                                                child: Text("Sign up"),
                                            ),
                                            SizedBox(height: 20),
                                            Text("Log in with your social media account."),
                                            SizedBox(height: 10),
                                            Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                    IconButton( onPressed: (){}, icon: Icon(Icons.facebook), color: Colors.blue ),
                                                    IconButton( onPressed: (){}, icon: Icon(Icons.g_mobiledata), color: Colors.blue ),
                                                    IconButton( onPressed: (){}, icon: Icon(Icons.apple), color: Colors.black )
                                                ]
                                            )
                                        ]
                                    )
                                )
                            )
                        )
                    )
                )
            )
        );
    }
}