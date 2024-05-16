
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_api/screen.home.dart';
import 'package:flutter_api/screen.login.dart';

import 'package:http/http.dart' as http;


class ScreenRegister extends StatefulWidget {
  const ScreenRegister({Key? key});

  @override
  State<ScreenRegister> createState() => _ScreenRegisterState();
}

class _ScreenRegisterState extends State<ScreenRegister> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController nomController = TextEditingController();
  TextEditingController prenomController = TextEditingController();
  TextEditingController pseudoController = TextEditingController();
  TextEditingController mailController = TextEditingController();


  bool passwordsMatch = true;

  @override
  void initState() {
    super.initState();
    confirmPasswordController.addListener(updatePasswordMatch);
  }

  @override
  void dispose() {
    passwordController.dispose();
    nomController.dispose();
    prenomController.dispose();
    pseudoController.dispose();
    mailController.dispose();
    confirmPasswordController.removeListener(updatePasswordMatch);
    confirmPasswordController.dispose();
    super.dispose();
  }

  void updatePasswordMatch() {
    setState(() {
      passwordsMatch = passwordController.text == confirmPasswordController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Inscription',
          style: TextStyle(
            fontSize: 30,
            color: Color(0xFF9F5540),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                     Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextField(
                        controller: nomController, // Ajout du contrôleur ici
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Nom',
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextField(
                        controller: prenomController, // Ajout du contrôleur ici
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Prénom',
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextField(
                        controller: pseudoController, // Ajout du contrôleur ici
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Pseudo',
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextField(
                        controller: mailController, // Ajout du contrôleur ici
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Mail',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        obscureText: true,
                        controller: passwordController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Mot de passe',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        obscureText: true,
                        controller: confirmPasswordController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Confirmation du mot de passe',
                          errorText: passwordsMatch ? null : "Les mots de passe ne correspondent pas",
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 90,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (passwordsMatch) {

                      // Effectuer la requête HTTP
                      var url = Uri.parse('https://mds.sprw.dev/users');
                      http.post(url, body: jsonEncode({
                        'username': pseudoController.text,
                        'password': passwordController.text,
                        'email': mailController.text,
                        'firstname': prenomController.text,
                        'lastname': nomController.text,

                      })).then((response) {
                        debugPrint(response.statusCode.toString());
                        if(response.statusCode == 201){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ScreenHome(),
                              settings: RouteSettings(
                                arguments: response.body,
                              ),
                              // Pass the arguments as part of the RouteSettings.

                            ),
                          );
                        }
                        if(response.statusCode==400){
                          debugPrint("Response body: ${response.body}");
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: Colors.red,
                              content: Text('Identifiant ou mot de passe incorrect',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        }
                        else{
                         debugPrint('else');
                        }
                      });
                    } else {
                      // Afficher un message si les mots de passe ne correspondent pas
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Erreur'),
                            content: Text('Les mots de passe ne correspondent pas.'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF80586B),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'S\'inscrire',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
