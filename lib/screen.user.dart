import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'class/user.dart';

class ScreenUser extends StatefulWidget {
  const ScreenUser({super.key, required this.userId});
final String userId;
  @override
  State<ScreenUser> createState() => _ScreenUserState();
}

class _ScreenUserState extends State<ScreenUser> {
  String? _token;
  String? _id;
  final user = User();
  late TextEditingController _usernameController= TextEditingController();
  late TextEditingController _emailController= TextEditingController();
  late TextEditingController _firstNameController= TextEditingController();
  late TextEditingController _lastNameController= TextEditingController();

  @override
  void initState() {
    super.initState();
    _getToken();
    _getId();
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  Future<void> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _token = prefs.getString('token');
    });
  }

  Future<void> _getId() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _id = prefs.getString('id').toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'MON PROFIL',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 30,
            color: Color(0xFF9F5540),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder(
        future: user.getUser(_token!, widget.userId),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            _usernameController.text = snapshot.data['username'];
            _emailController.text = snapshot.data['email'];
            _firstNameController.text = snapshot.data['firstname'];
            _lastNameController.text = snapshot.data['lastname'];

            return Container(
              height: MediaQuery.of(context).size.height * 0.5,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Pseudo',
                    ),
                    controller: _usernameController,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                    ),
                    controller: _emailController,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Prénom',
                    ),
                    controller: _firstNameController,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Nom',
                    ),
                    controller: _lastNameController,
                  ),
                  TextButton(
                    onPressed: () async {
                      var userResponse = await user.updateUser(
                        _token!,
                        widget.userId,
                        _usernameController.text,
                        _emailController.text,
                        _firstNameController.text,
                        _lastNameController.text,
                      );
                      if(userResponse != null && userResponse == "200"){
                        setState(() {
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.green,
                            content: Text('Profil mis à jour'),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.red,
                            content: Text('Erreur lors de la mise à jour du profil'),
                          ),
                        );
                      }
                    },

                    child: Text('Enregistrer'),
                  ),
                ],
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
