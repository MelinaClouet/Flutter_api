import 'package:flutter_api/screen.register.dart';
import 'package:flutter_api/screen.home.dart';

import 'package:flutter/material.dart';

class ScreenLogin extends StatefulWidget {
  const ScreenLogin({Key? key}) : super(key: key);

  @override
  State<ScreenLogin> createState() => _ScreenLoginState();
}

class _ScreenLoginState extends State<ScreenLogin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Connexion',
          style: TextStyle(
            fontSize: 30,
            color: Color(0xFF9F5540),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Pseudo',
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Mot de passe',
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ScreenRegister()),
                        );
                      },
                      child: const Text('Inscription', style: TextStyle(color: Color(0xFF9F5540))),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => ScreenHome()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:Color(0xFF80586B), // Couleur de fond du bouton
                        minimumSize: Size(double.infinity, 50), // Largeur étendue sur toute la largeur de l'écran, hauteur 50
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // Bordures arrondies
                        ),
                      ),
                      child: const Text('Se connecter',style: TextStyle(color: Colors.white),),
                    ),
                  ],
                ),

              ],
            ),
        ),
      ),
    );
  }
}
