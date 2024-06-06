import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_api/class/univers.dart';
import 'package:flutter_api/screen.characters.dart';
import 'package:flutter_api/screen.conversations.dart';
import 'package:flutter_api/screen.home.dart';
import 'package:flutter_api/screen.universes.description.dart';
import 'package:flutter_api/widgets/customeNavigationBarWidget.dart';
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

  TextEditingController nameController = TextEditingController();


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
                onPressed: () =>showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    // Build the content of your modal here
                    return AlertDialog(
                      backgroundColor: Colors.white ,
                      title: Text('Ajouter un univers', style: TextStyle(color: Color(0xFF80586B), fontWeight: FontWeight.bold,)),
                      content:TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Nom de l\'univers',
                        ),
                      ),
                      actions: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children:[
                            TextButton(
                              onPressed: () => Navigator.pop(context), // Close the modal
                              child: Text('Close', style: TextStyle(color: Color(0xFF80586B))),
                            ),
                            TextButton(
                              onPressed: () =>
                                  univers.addUnivers(_token, nameController.text),
                              // Close the modal
                              child: Text('Ajouter', style: TextStyle(color: Color(0xFF9F5540))),
                            ),

                          ]
                        )

                      ],
                    );
                  },
                ),
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
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ScreenUniversesDescription(universeId: data[index]["id"].toString(),)),
                              );
                              print(data[index]["id"]); // For testing purposes
                            },
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
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 1, // Index de l'élément sélectionné
        onTap: (index) {

        // Gestion de la navigation
          switch (index) {
            case 0:
              Navigator.push(context, MaterialPageRoute(builder: (context) => ScreenHome()));
              break;
            case 1:
              Navigator.push(context, MaterialPageRoute(builder: (context) => ScreenUniverses()));
              break;
            case 2:
              Navigator.push(context, MaterialPageRoute(builder: (context) => ScreenCharacters()));
              break;
            case 3:
              Navigator.push(context, MaterialPageRoute(builder: (context) => ScreenConversations()));
              break;

          }

        },
      ),

    );
  }
}
