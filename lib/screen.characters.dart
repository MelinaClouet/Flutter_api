import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_api/class/personnages.dart';
import 'package:flutter_api/screen.conversations.dart';
import 'package:flutter_api/screen.home.dart';
import 'package:flutter_api/screen.universes.dart';
import 'package:flutter_api/widgets/customeNavigationBarWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'class/pictures.dart';
import 'class/univers.dart';

class ScreenCharacters extends StatefulWidget {
  const ScreenCharacters({super.key});

  @override
  State<ScreenCharacters> createState() => _ScreenCharactersState();
}

class _ScreenCharactersState extends State<ScreenCharacters> {
  final  univers = Univers();
  final personnage=Personnages();

  final picture= Pictures();
  String? _token; // Declare a variable to hold the token
  String? _id;
  String? _selectedUniverse;
  TextEditingController nameController = TextEditingController();

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
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            if (_token != null)
              FutureBuilder<List<dynamic>>(
                future: univers.fetchUnivers(_token!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('No Universes');
                  } else {
                    final data = snapshot.data!;
                    return DropdownButton<String>(
                      value: _selectedUniverse,
                      hint: const Text(
                        'Select Universe',
                        style: TextStyle(color: Colors.black),
                      ),
                      dropdownColor: Colors.white,
                      iconEnabledColor: Color(0xFF80586B),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedUniverse = newValue;
                        });
                      },
                      items: data.map<DropdownMenuItem<String>>((universe) {
                        return DropdownMenuItem<String>(
                          value: universe['id'].toString(),
                          child: Text(universe['name'], style: const TextStyle(color: Color(0xFF80586B))),
                        );
                      }).toList(),
                    );
                  }
                },
              ),
          ],
        ),
      ),
      body: FutureBuilder(
        future: _selectedUniverse != null ? personnage.getCharactersOfUnivers(_token!, _selectedUniverse!) : Future.value(null),
        builder: (context, snapshot) {
          if (_selectedUniverse == null) {
            return Center(
              child: Text(
                'Sélectionnez un univers',
                style: TextStyle(fontSize: 18),
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final data = snapshot.data as List<dynamic>;
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Affichage de deux éléments par ligne
                crossAxisSpacing: 10, // Espacement horizontal entre les éléments
                mainAxisSpacing: 10, // Espacement vertical entre les éléments
              ),
              itemCount: data.length + 1, // +1 pour le conteneur d'ajout
              itemBuilder: (context, index) {
                if (index == data.length) {
                  // Afficher le conteneur d'ajout à la fin
                  return GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Ajouter un personnage'),
                            content: TextField(
                              controller: nameController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Nom',
                              ),
                            ),
                            actions: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      var response = personnage.addCharacter(_token, nameController.text, _selectedUniverse!);
                                      if (response == true) {
                                        Navigator.pop(context);
                                        setState(() {
                                          personnage.getCharactersOfUnivers(_token!, _selectedUniverse!);
                                        });
                                      }
                                    },
                                    child: const Text('Ajouter'),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.grey[200], // Couleur de fond du conteneur d'ajout
                      ),
                      child: Icon(
                        Icons.add,
                        size: 50,
                        color: Colors.grey[600], // Couleur de l'icône d'ajout
                      ),
                    ),
                  );
                } else {
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
                                showDialog(context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(data[index]['name'] as String , style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
                                            IconButton(onPressed: (){
                                              var response=personnage.updateDescription(_token!,_selectedUniverse, data[index]['id']);

                                              if(response!=null){
                                                Navigator.pop(context);
                                                setState(() {
                                                  personnage.getCharactersOfUnivers(_token!, _selectedUniverse!);
                                                });
                                              }
                                            },
                                                icon: Icon(Icons.update), color: Color(0xFF9F5540)
                                            )
                                          ],
                                        ),
                                        content: FutureBuilder(
                                          future:personnage.getACharacters(_token!,_selectedUniverse, data[index]['id']),
                                          builder:(context,snapshot){
                                            if(snapshot.connectionState==ConnectionState.waiting){
                                              return CircularProgressIndicator();
                                            }
                                            else if(snapshot.hasError){
                                              return Text('Error: ${snapshot.error}');
                                            }
                                            else if(!snapshot.hasData){
                                              return Text('No data found');
                                            }
                                            else{
                                              var data=snapshot.data;
                                              return Column(
                                                children: [
                                                  Container(
                                                    margin: const EdgeInsets.all(10),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(15),
                                                    ),
                                                    child:  ClipRRect(
                                                      borderRadius: BorderRadius.circular(15),
                                                      child: InteractiveViewer(
                                                        panEnabled: true, // Enable panning
                                                        scaleEnabled: true, // Enable scaling
                                                        minScale: 1.0, // Minimum scale
                                                        maxScale: 4.0, // Maximum scale
                                                        child: FadeInImage(
                                                          placeholder: NetworkImage(
                                                            "https://via.placeholder.com/150",
                                                          ),
                                                          image: NetworkImage(
                                                            picture.fetchPictures(_token, data['image'] as String),
                                                          ),
                                                          fit: BoxFit.fitWidth,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(child: Container(
                                                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                                                    child: SingleChildScrollView(
                                                      child: Column(
                                                        children: [

                                                          const SizedBox(height: 20),
                                                          Text(
                                                            data['description'] as String,
                                                            style: const TextStyle(fontSize: 18, color: Color(0xFF9F5540)), textAlign: TextAlign.justify,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  ),
                                                ],
                                              );
                                            }
                                          }
                                        ),
                                      );
                                    }
                                  );
                              },
                              child: FadeInImage(
                                placeholder: NetworkImage(
                                  "https://via.placeholder.com/150",
                                ),
                                image: NetworkImage(
                                  picture.fetchPictures(_token, data[index]['image'] as String) as String,
                                ),
                                fit: BoxFit.cover,
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
                }
              },
            );
          }
        },
      ),



      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 2, // Index de l'élément sélectionné
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
