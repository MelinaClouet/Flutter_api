import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_api/class/univers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'class/pictures.dart';

class ScreenUniverses extends StatefulWidget {
  const ScreenUniverses({Key? key});

  @override
  State<ScreenUniverses> createState() => _ScreenUniversesState();
}

class _ScreenUniversesState extends State<ScreenUniverses> {
  final Univers univers = Univers();
  final picture= Pictures();
  String? _token; // Declare a variable to hold the token
  String? _id;

  @override
  void initState() {
    super.initState();
    _getToken();
    _getId();
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
      _id = prefs.getString('id');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: Text(
                'Univers',
                textAlign: TextAlign.center, // Pour centrer le texte
                style: TextStyle(
                  fontSize: 30,
                  color: Color(0xFF9F5540),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            IconButton(
                onPressed: () => Navigator.pushNamed(context, '/addUnivers'),
                icon: Icon(
                  Icons.add,
                  color: Color(0xFF9F5540),
                ),
            ),
          ],
        ),
      ),
      body:  FutureBuilder(
        future: univers.fetchUnivers(_token),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
            return Center(child: Text('No data'));
          } else {
            final data = snapshot.data as List<dynamic>;
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Affichage de deux éléments par ligne
                crossAxisSpacing: 10, // Espacement horizontal entre les éléments
                mainAxisSpacing: 10, // Espacement vertical entre les éléments
              ),
              itemCount: data.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 145,
                        height: 145,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: FadeInImage(
                            placeholder: NetworkImage(
                              "https://via.placeholder.com/150",
                            ),
                            image: NetworkImage(
                              picture.fetchPictures(_token, data[index]['image'] as String) as String,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        data[index]['name'] as String,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      )

    );
  }
}
