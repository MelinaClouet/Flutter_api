import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_api/screen/screen.user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../class/user.dart';

class ScreenUsers extends StatefulWidget {
  const ScreenUsers({super.key});

  @override
  State<ScreenUsers> createState() => _ScreenUsersState();
}

class _ScreenUsersState extends State<ScreenUsers> {
  final user=User();
  String? _token;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Users',
          style: TextStyle(
            fontSize: 30,
            color: Color(0xFF9F5540),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body:FutureBuilder(
        future: user.fetchUsers(_token!),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xFFC49D83).withOpacity(0.7)

                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(

                          child: Column(
                            children: [
                              Text(
                                snapshot.data[index]['username'],
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.start,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    snapshot.data[index]['lastname'],
                                    style: const TextStyle(
                                      fontSize: 10,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                  const Text(' '),
                                  Text(
                                    snapshot.data[index]['firstname'],
                                    style: const TextStyle(
                                      fontSize: 10,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ScreenUser(
                                  userId: snapshot.data[index]['id'].toString(),
                                ),
                              ),
                            );
                          },
                            icon: Icon(Icons.update)),
                      ],
                    ),
                  );
                },
              );
            } else {
              return const Center(
                child: Text('No data'),
              );
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      )
    );
  }
}
