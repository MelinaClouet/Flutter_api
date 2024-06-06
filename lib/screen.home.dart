import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_api/screen.characters.dart';
import 'package:flutter_api/screen.conversations.dart';
import 'package:flutter_api/screen.universes.dart';
import 'package:flutter_api/screen.universes.description.dart';
import 'package:flutter_api/widgets/customeNavigationBarWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'class/pictures.dart';
import 'class/univers.dart';
import 'class/conversations.dart';



class ScreenHome extends StatefulWidget {


  const ScreenHome({Key? key}) : super(key: key);

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {

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
      _id = prefs.getString('id').toString();
    });
  }


  final univers = Univers();
final conversations=Conversations();
  final picture=Pictures();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Accueil',
                style: TextStyle(
                  fontSize: 30,
                  color: Color(0xFF9F5540),
                  fontWeight: FontWeight.bold,
                ),
              ),
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.purple,
              ),
            ],
          ),
        ),
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Dernières conversations",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: FutureBuilder(
                    future: conversations.fetchConversations(_token),
                    builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        // Afficher un indicateur de chargement pendant le chargement des données
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        // Gérer les erreurs
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        // Gérer le cas où aucune conversation n'est retournée
                        return Text('No conversations available');
                      } else {
                        // Afficher la liste des conversations
                        final data = snapshot.data!;
                        debugPrint(data.toString());
                        return Row(
                          children: List.generate(
                            data.length,
                                (index) => Container(
                              margin: EdgeInsets.only(right: 20),
                              child: Column(
                                children: [
                                  Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.grey[300],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: FadeInImage(
                                        placeholder: AssetImage('assets/placeholder_image.png'), // Image de remplacement pendant le chargement
                                        image: NetworkImage(data[index]['character_info']["image"] as String), // URL de l'image de la conversation
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(data[index]['character_info']['name'] ?? "" as String),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  ),

                ),
              ],
            ),
          ),
          SizedBox(height: 100),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Univers",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: FutureBuilder(
                    future: univers.fetchUnivers(_token),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
                        return Text('No data');
                      } else {
                        final data = snapshot.data as List<dynamic>;
                        return Row(
                          children: List.generate(
                            10,
                                (index) => Container(
                              margin: EdgeInsets.only(right: 20),
                              child: Column(
                                children: [
                                  Container(
                                    width: 160,
                                    height: 160,
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
                                  Text(data[index]['name'] as String),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 0, // Index de l'élément sélectionné
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




  //img_data/.jpg
}
