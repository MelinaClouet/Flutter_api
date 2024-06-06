import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'class/pictures.dart';
import 'class/univers.dart';
class ScreenUniversesDescription extends StatefulWidget {
  final String universeId; // Parameter to hold the universe ID

  const ScreenUniversesDescription({super.key, required this.universeId});

  @override
  State<ScreenUniversesDescription> createState() => _ScreenUniversesDescriptionState();
}

class _ScreenUniversesDescriptionState extends State<ScreenUniversesDescription> {
  String? _universeDetails; // Variable to store retrieved universe details
  final Univers univers = Univers();
  final picture= Pictures();
  String? _token; // Declare a variable to hold the token
  String? _id;
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
      appBar:AppBar(
        title: Row(
          children: [
            Expanded(
              child: Text(
                'Univers Details',
                textAlign: TextAlign.center, // Pour centrer le texte
                style: TextStyle(
                  fontSize: 30,
                  color: Color(0xFF9F5540),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.update),
              onPressed: () {
                //open modal
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Mettre à jour le nom de l\'univers'),
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
                                var response = await univers.updateUnivers(_token!, widget.universeId, nameController.text);
                                debugPrint('Response: $response');
                                if (response == '200') {
                                  // close showModal
                                  Navigator.pop(context);
                                  setState(() {
                                    _universeDetails = nameController.text;
                                  });
                                }
                              },

                              child: const Text('Update'),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                );

              },
            ),
          ],
        ),
      ),
      body: FutureBuilder(
        future: univers.getUniversById(_token!, widget.universeId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData) {
            return Center(
              child: Text('No data found'),
            );
          } else {
            var data = snapshot.data;
            _universeDetails = data.toString();
            return Center(
              child: Column(
                children:[
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
                          Text(
                            data['name'] as String,
                            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Color(0xFF9F5540)), textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            data['description'] as String,
                            style: const TextStyle(fontSize: 18), textAlign: TextAlign.justify,
                          ),
                        ],
                      ),
                    ),
                  )),

                ]
              ),
            );
          }
        },
      ),

    );
  }
}

