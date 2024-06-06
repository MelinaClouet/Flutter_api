import 'dart:convert';

import 'package:flutter/cupertino.dart';

import 'package:http/http.dart' as http;
class Personnages{
  fetchCharacter(token, id){
    var url = Uri.parse('https://mds.sprw.dev/characters/$id');
    return http.get(url, headers: {'Authorization': 'Bearer $token'}).then((response) {

      //debugPrint(response.body);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load data');
      }
    });
  }

  Future<dynamic> getACharacters(String token, id, idCharacter) async {
    var url = Uri.parse('https://mds.sprw.dev/universes/$id/characters/$idCharacter');

    var response = await http.get(url, headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<dynamic> updateDescription(String token, id, idCharacter) async {
    var url = Uri.parse('https://mds.sprw.dev/universes/$id/characters/$idCharacter');
    var response = await http.put(url, headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<dynamic> getCharactersOfUnivers(String token, String id) async {
    var url = Uri.parse('https://mds.sprw.dev/universes/$id/characters');
    debugPrint('ici');
    var response = await http.get(url, headers: {'Authorization': 'Bearer $token'});
    debugPrint(response.body);
   if (response.statusCode == 200) {
      //debugPrint(response.body);
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  addCharacter(token,name, id){
    var url = Uri.parse('https://mds.sprw.dev/universes/$id/characters');

    var body={
      "name":name,
    };

    http.post(url,headers: {'Authorization': 'Bearer $token'}, body: jsonEncode(body)).then((response){
      if(response.statusCode==201){
        return true;
      }
      else{
        return false;
      }


    });
  }


}