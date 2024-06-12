import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_api/screen/screen.characters.dart';
import 'package:flutter_api/screen/screen.home.dart';
import 'package:flutter_api/screen/screen.messages.dart';
import 'package:flutter_api/screen/screen.universes.dart';
import 'package:flutter_api/screen/screen.universes.description.dart';
import 'package:flutter_api/widgets/customeNavigationBarWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../class/conversations.dart';
import '../class/personnages.dart';
import '../class/pictures.dart';
import '../class/univers.dart';

class ScreenConversations extends StatefulWidget {
  const ScreenConversations({super.key});

  @override
  State<ScreenConversations> createState() => _ScreenConversationsState();
}

class _ScreenConversationsState extends State<ScreenConversations> {
  String? _token; // Declare a variable to hold the token
  String? _id;
  final conversations = Conversations();
  final univers= Univers();
  final picture=Pictures();
  final personnage=Personnages();
  var _selectedUniverse;
  var _selectedCharacter;
  bool isSelected=false;

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Conversations',
          textAlign: TextAlign.center, // Pour centrer le texte
          style: TextStyle(
            fontSize: 30,
            color: Color(0xFF9F5540),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          FutureBuilder(
            future: conversations.fetchConversations(_token),
            builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator()); // Centrer l'indicateur de chargement
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}')); // Afficher l'erreur s'il y en a une
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No conversations available')); // Gérer le cas où aucune conversation n'est disponible
              } else {
                final data = snapshot.data!;
                return SingleChildScrollView( // Utiliser SingleChildScrollView pour permettre le défilement horizontal
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    children: List.generate(
                      data.length,
                          (index) => Dismissible(

                            key: Key(data[index]['id'].toString()), // Clé unique pour chaque élément
                            direction: DismissDirection.endToStart, // Direction de glissement
                            onDismissed: (direction) {
                              var response=conversations.deleteConversation(_token, data[index]['id'].toString());
                              if(response==true){
                                setState(() {
                                  conversations.fetchConversations(_token);
                                });
                              }
                            },
                        background: Container(
                          color: Colors.red, // Couleur d'arrière-plan lors du glissement
                          alignment: Alignment.centerRight,
                          child: Icon(Icons.delete, color: Colors.white), // Icône de suppression
                        ),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.95,
                          margin: EdgeInsets.all(10),
                          child: GestureDetector(
                            onTap: () {

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ScreenMessages(
                                    conversationId: data[index]['id'].toString(),
                                    namePerso: data[index]['character_info']['name'] as String,
                                  ),
                                ),
                              );
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 60,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: FadeInImage(
                                      placeholder: NetworkImage(
                                        "https://via.placeholder.com/150",
                                      ),
                                      image: NetworkImage(
                                        picture.fetchPictures(_token, data[index]['character_info']['image'] as String),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Column(
                                  children: [
                                    Text(
                                      '${data[index]['character_info']['name']}' as String,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    // Ajoutez ici l'affichage du dernier message
                                  ],
                                ),
                              ],
                            ),
                          ),

                        ),
                      ),
                    ),

                  ),
                );
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Créer une nouvelle conversation'),
                content: Column(
                  children: [
                    FutureBuilder(
                      future: univers.fetchUnivers(_token),
                      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Center(child: Text('No universes available'));
                        } else {
                          final universes = snapshot.data!;

                          return Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Column(
                                children: [
                                  for (var universe in universes)

                                    FutureBuilder(
                                      future: personnage.getCharactersOfUnivers(_token!, universe['id'].toString()!),
                                      builder: (context, AsyncSnapshot<dynamic> snapshot) {
                                        if (snapshot.connectionState == ConnectionState.waiting) {
                                          return Center(child: CircularProgressIndicator());
                                        } else if (snapshot.hasError) {
                                          return Center(child: Text('Error: ${snapshot.error}'));
                                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                          return Center(child: Text(''));
                                        } else {
                                          final characters = snapshot.data!;
                                          return SingleChildScrollView(
                                            scrollDirection: Axis.vertical,
                                            child: Column(
                                              children: [
                                                for (var character in characters)
                                                  GestureDetector(
                                                    onTap: () {
                                                     setState(() {
                                                        _selectedCharacter = character['id'].toString();
                                                        isSelected = !isSelected;

                                                      });
                                                    },
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          width: 100,
                                                          height: 100,
                                                          child: ClipRRect(
                                                            borderRadius: BorderRadius.circular(15),
                                                            child: FadeInImage(
                                                              placeholder: NetworkImage(
                                                                "https://via.placeholder.com/150",
                                                              ),
                                                              image: NetworkImage(
                                                                picture.fetchPictures(_token, character['image'] as String),
                                                              ),
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(height: 10),
                                                        Text(
                                                          character['name'] as String,
                                                          style: TextStyle(
                                                            color: isSelected ? Colors.white : Colors.black, // Changez la couleur du texte en fonction de l'état de sélection
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          );

                                        }
                                      },
                                    ),
                                ],
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      conversations.addConversation(_token!, _selectedCharacter!, _id!);
                      setState(() {
                        Navigator.pop(context);
                        conversations.fetchConversations(_token!);
                      });
                    },
                    child: Text('Créer'),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),



      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 3, // Index de l'élément sélectionné
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
