import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../class/messages.dart';
import '../class/user.dart';
import '../class/personnages.dart';
import '../widgets/CustomPainter.dart';

class ScreenMessages extends StatefulWidget {
  const ScreenMessages({super.key, required this.conversationId, required this.namePerso});

  final String namePerso;
  final String conversationId;

  @override
  State<ScreenMessages> createState() => _ScreenMessagesState();
}

class _ScreenMessagesState extends State<ScreenMessages> {
  String? _token;
  String? _id;
  final message = Messages();
  TextEditingController messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Future<List<dynamic>>? _messagesFuture;

  var personnage=Personnages();
  List<Map<String, dynamic>> _messages = [];

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    _id = prefs.getString('id');
    setState(() {
      _messagesFuture = _fetchMessages();
    });
  }



  Future<List<dynamic>> _fetchMessages() async {
    var response = await message.fetchMessages(_token, widget.conversationId);

    for(var i=0; i<response.length; i++){
      setState(() {
        _messages.add({
          'content': response[i]['content'],
          'is_sent_by_human': response[i]['is_sent_by_human'],
        });
      });
    }
    _scrollToBottom();

    return response;
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Messages',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 30,
            color: Color(0xFF9F5540),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body:  Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages != null ? _messages!.length : 0,
              itemBuilder: (context, index) {
                if(_messages[index]['is_sent_by_human'] == null){
                  // Circular progress indicator
                  return Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xFFC49D83),
                    ),
                    margin: EdgeInsets.only(
                      top: 10,
                      bottom: 10,
                      left: 10,
                      right: 50,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TypingIndicator(dotColor: Colors.black ),
                    ),

                  );
                }
                return Column(
                  children: [
                    FutureBuilder(
                      future: getFirstNameUser(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: FutureBuilder<String>(
                                future: getFirstNameUser(),
                                builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return CircularProgressIndicator();
                                  } else {
                                    if (snapshot.hasError)
                                      return Text('Error: ${snapshot.error}');
                                    else
                                      return Text(
                                        _messages[index]['is_sent_by_human']
                                            ? snapshot.data as String
                                            : widget.namePerso, // Here we display the data from the future
                                        textAlign: _messages[index]['is_sent_by_human']
                                            ? TextAlign.end
                                            : TextAlign.start,
                                      );
                                  }
                                },
                              )
                          );
                        }
                      },
                    ),
                    Container(

                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.only(
                            top: 10,
                            bottom: 10,
                            left: _messages[index]['is_sent_by_human'] ? 50 : 10,
                            right: _messages[index]['is_sent_by_human'] ? 10 : 50,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: _messages[index]['is_sent_by_human']
                                ? Color(0xFF80586D)
                                : Color(0xFFC49D83),
                          ),
                          child: Column(
                            children: [

                              Align(
                                alignment: _messages[index]['is_sent_by_human']
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: Text(
                                  _messages[index]['content'],
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: _messages[index]['is_sent_by_human']
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                              if(index==_messages.length-1)

                                Container(
                                  width: double.infinity,
                                  child: IconButton(onPressed: (){
                                    message.regenerateLastMessage(_token, widget.conversationId);
                                    setState(() {
                                      _messagesFuture = _fetchMessages();
                                    });

                                  },
                                    icon: Icon(Icons.refresh),
                                    color: Color(0xFF80586D),
                                    alignment: Alignment.centerRight,

                                  ),
                                )
                            ],
                          ),

                        ),
                  ],
                );
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
                  onPressed: () async {


                    setState(() {
                      _messages.add({
                        'content': messageController.text,
                        'is_sent_by_human': true,
                      });

                      _messages.add({
                        'content': 'ChatGpt',
                        'is_sent_by_human': null,
                      });
                    });

                    String? responseStr = await message.addMessage(_token, widget.conversationId, messageController.text);

                    if(responseStr == null){
                      return;
                    }
                    var response = jsonDecode(responseStr);

                    // Remove last message
                    _messages.removeLast();

                    Map<String, dynamic>  newMessage = {
                      'content': response['answer']['content'],
                      'is_sent_by_human': response['answer']['is_sent_by_human'],
                    };

                    // Update the list of messages
                    setState(() {
                      _messages.add(newMessage);
                      messageController.clear();
                    });

                    _scrollToBottom(); // Scroll to bottom after sending a message
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


  Future<String> getFirstNameUser() async {
    final user = User();
    var userId = await user.getUser(_token!, _id!);
    return userId['firstname'] as String;
  }

}
