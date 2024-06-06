import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'class/messages.dart';
import 'class/user.dart';

class ScreenMessages extends StatefulWidget {
  const ScreenMessages({super.key, required this.conversationId});

  final String conversationId;

  @override
  State<ScreenMessages> createState() => _ScreenMessagesState();
}

class _ScreenMessagesState extends State<ScreenMessages> {
  String? _token; // Declare a variable to hold the token
  String? _id;
  final message=Messages();
  TextEditingController messageController = TextEditingController();

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
        title: Text('Messages',
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
          Expanded(
            child: FutureBuilder(
              future: message.fetchMessages(_token, widget.conversationId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Erreur de chargement des messages'),
                    );
                  } else {
                    final data = snapshot.data as List<dynamic>;
                    return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children:[

                            FutureBuilder(
                              future: getFirstNameUser(),
                              builder: (context, AsyncSnapshot<dynamic> snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  // Afficher la valeur retournée par la fonction
                                  return Text(data[index]['is_sent_by_human'] ? snapshot.data.toString() : "ChatGpt" , textAlign: data[index]['is_sent_by_human'] ? TextAlign.start : TextAlign.end,);
                                }
                              },
                            ),

                            Container(
                              width: MediaQuery.of(context).size.width*0.8 ,
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.only(top: 10,bottom: 10, left:data[index]['is_sent_by_human']? 50 : 0, right:data[index]['is_sent_by_human']? 0 : 50 ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: data[index]['is_sent_by_human'] ? Color(0xFF80586D) : Color(0xFFC49D83),
                                ),
                                child:
                                Text(data[index]['content'],
                                  style: TextStyle(fontSize: 20, color: data[index]['is_sent_by_human'] ? Colors.white : Colors.black),
                                  textAlign: data[index]['is_sent_by_human'] ? TextAlign.right : TextAlign.left,
                                )
                            ),
                            Text(data[index]['created_at'],
                              style: TextStyle(fontSize: 15, color: Colors.grey),
                            ),

                          ]
                        );
                      },
                    );
                  }
                }
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: 'Entrez votre message',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    var response=message.addMessage(_token, widget.conversationId, messageController.text);
                    if(response){
                      messageController.clear();
                      setState(() {
                        message.fetchMessages(_token, widget.conversationId);
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
        ],
      ),

    );
  }

  getFirstNameUser() async {
    final user=User();
   var userId=await user.getUser(_token!, _id!);
   return userId['firstname'];

  }
}
