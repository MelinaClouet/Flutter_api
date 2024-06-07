import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
class User{

  Future<dynamic> getUser(String token, String id) async { // Rendez la méthode asynchrone et retournez un Future
    var url = Uri.parse('https://mds.sprw.dev/users/$id');
    var response = await http.get(url, headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) { // Utilisez 200 pour vérifier la réussite de la requête
      return json.decode(response.body); // Utilisez json.decode pour convertir la réponse JSON en un objet Dart
    } else {
      return null; // Retournez null en cas d'échec de la requête
    }
  }

  Future<String?> updateUser(token ,id,String pseudo, String email, String firstname, String lastname) async {

    var body = {
      "username" : pseudo.toString(),
      "email" : email.toString(),
      "firstname" : firstname.toString(),
      "lastname" : lastname.toString(),
    };
    var url=Uri.parse('https://mds.sprw.dev/users/$id');
    var response = await http.put(url, headers: {'Authorization': 'Bearer $token'}, body: jsonEncode(body));
    if(response.statusCode==200){
      return response.statusCode.toString();
    }else{
      return null;
    }
  }

  fetchUsers(String token) async {
    var url = Uri.parse('https://mds.sprw.dev/users');
    var response = await http.get(url, headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return null;
    }
  }

}