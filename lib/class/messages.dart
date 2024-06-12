import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'personnages.dart';

class Messages{


  Future<List<dynamic>> fetchMessages(token, conversationId) async {

    var url = Uri.parse('https://mds.sprw.dev/conversations/$conversationId/messages');
    try {
      final response = await http.get(url, headers: {'Authorization': 'Bearer $token'});

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as List<dynamic>;
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

  Future<String?> addMessage(token, conversationId, message) async {
    var url = Uri.parse('https://mds.sprw.dev/conversations/$conversationId/messages');
    var body = {
      "content": message,
    };
    var response = await http.post(url, headers: {'Authorization': 'Bearer $token'}, body: jsonEncode(body));

    if (response.statusCode == 201) {
      return response.body;
    } else {
      return null;
    }
  }

  deleteMessage(token, conversationId, id) {
    var url = Uri.parse('https://mds.sprw.dev/conversations/$conversationId/messages/$id');
    http.delete(url, headers: {'Authorization': 'Bearer $token'}).then((response) {

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    });
  }
  regenerateLastMessage(token, conversationId){
    var url = Uri.parse('https://mds.sprw.dev/conversations/$conversationId');
    http.put(url, headers: {'Authorization': 'Bearer $token'}).then((response) {

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    });
  }

}