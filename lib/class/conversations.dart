import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'personnages.dart';

class Conversations {
  Future<List<dynamic>> fetchConversations(token) async {
    final character = Personnages();
    var url = Uri.parse('https://mds.sprw.dev/conversations');

    try {
      final response = await http.get(url, headers: {'Authorization': 'Bearer $token'});
      if (response.statusCode == 200) {
        List<dynamic> conversations = [];
        for (var i = 0; i < jsonDecode(response.body).length; i++) {
          var conversation = jsonDecode(response.body)[i];
          var characterInfo = await character.fetchCharacter(token, conversation['character_id']);
          conversation['character_info'] = characterInfo; // Ajouter les infos du personnage à la conversation
          conversations.add(conversation);

        }
        return conversations;
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

  addConversation(token, characterId,user_id) {
    var url = Uri.parse('https://mds.sprw.dev/conversations');
    var body = {
      "character_id": characterId,
      "user_id": user_id,
    };
    http.post(url, headers: {'Authorization': 'Bearer $token'}, body: jsonEncode(body)).then((response) {


      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    });
  }
  deleteConversation(token, id) {
    var url = Uri.parse('https://mds.sprw.dev/conversations/$id');
    http.delete(url, headers: {'Authorization': 'Bearer $token'}).then((response) {

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    });
  }
}
