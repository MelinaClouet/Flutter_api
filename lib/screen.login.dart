import 'dart:convert';

import 'package:flutter_api/screen.register.dart';
import 'package:flutter_api/screen.home.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class ScreenLogin extends StatefulWidget {
  const ScreenLogin({Key? key}) : super(key: key);

  @override
  State<ScreenLogin> createState() => _ScreenLoginState();
}

class _ScreenLoginState extends State<ScreenLogin> {
  TextEditingController pseudoController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    passwordController.dispose();
    pseudoController.dispose();
    super.dispose();
  }

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
                     Padding(
                      padding:  EdgeInsets.all(8.0),
                      child:  TextField(
                        controller: pseudoController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Pseudo',
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextField(

                        obscureText: true,
                        controller: passwordController,
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
                        debugPrint('Pseudo: ${pseudoController.text}');
                        var url = Uri.parse('https://mds.sprw.dev/auth');
                        var body={
                          "username":pseudoController.text,
                          "password":passwordController.text
                        };
                        http.post(url, body: jsonEncode(body)).then((response) async {

                          if (response.statusCode == 201) {
                            debugPrint("Response status: ${response.statusCode}");
                            final Map<String, dynamic> data = jsonDecode(response.body);
                            String token = data['token']; // Assuming 'token' is the key in the response

                            debugPrint(token);
                            final prefs = await SharedPreferences.getInstance();
                            debugPrint(prefs.toString());

                            await prefs.setString('token', token); // Store token with key 'token'
                            debugPrint(prefs.getString('token').toString());
                            var parts = token.split('.');
                            if (parts.length != 3) {
                              throw Exception('Invalid token');
                            }
                            var payload = parts[1];
                            var normalized = base64Url.normalize(payload);
                            var decoded = utf8.decode(base64Url.decode(normalized));
                            Map<String, dynamic> payloadMap = jsonDecode(decoded);

                            debugPrint(payloadMap.toString());

                            // Extract the ID safely
                            var dataToken = payloadMap['data'];
                            var dataTokenPayload = jsonDecode(dataToken);
                            debugPrint('ici');
                            debugPrint(dataTokenPayload.toString());
                            var id = dataTokenPayload['id'];
                            debugPrint(id.toString());



                            await prefs.setString('id', id.toString());

                            //Navigate to ScreenHome and pass the token
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ScreenHome(),
                              ),
                            );
                          }
                          else {
                            debugPrint(response.body);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: Colors.red,
                                content: Text('Identifiant ou mot de passe incorrect',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          }
                        });
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
