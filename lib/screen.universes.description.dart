import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _getToken();
    _getId();
    _fetchUniverseDetails(widget.universeId);
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

  Future<void> _fetchUniverseDetails(String universeId) async {
    var univers=Univers();
    var universById=await univers.getUniversById(_token,universeId);
    debugPrint(universById.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Universe Description'),
      ),
      body: Center(
        child: _universeDetails == null
            ? const CircularProgressIndicator() // Show loading indicator while fetching
            : Text(_universeDetails!),
      ),
    );
  }
}

