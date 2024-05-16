import 'package:flutter/material.dart';

class ScreenRegister extends StatefulWidget {
  const ScreenRegister({Key? key});

  @override
  State<ScreenRegister> createState() => _ScreenRegisterState();
}

class _ScreenRegisterState extends State<ScreenRegister> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  bool passwordsMatch = true;

  @override
  void initState() {
    super.initState();
    confirmPasswordController.addListener(updatePasswordMatch);
  }

  @override
  void dispose() {
    passwordController.dispose();
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
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Nom',
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextField(

                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Prénom',
                        ),
                      ),
                    ),
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
                  onPressed: () {
                    if (passwordsMatch) {

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => ScreenRegister()),
                      );

                    } else {



                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF80586B), // Couleur de fond du bouton
                    minimumSize: const Size(double.infinity, 50), // Largeur étendue sur toute la largeur de l'écran, hauteur 50
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Bordures arrondies
                    ),
                  ),
                  child: const Text(
                    'Se connecter',
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
