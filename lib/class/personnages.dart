import 'dart:convert';

import 'package:flutter/cupertino.dart';

import 'package:http/http.dart' as http;
class Personnages{
  fetchCharacter(token, id){
    var url = Uri.parse('https://mds.sprw.dev/characters/$id');
    return http.get(url, headers: {'Authorization': 'Bearer $token'}).then((response) {

      debugPrint(response.body);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load data');
      }
    });
  }
}