import 'dart:convert';

import 'package:flutter/cupertino.dart';

import 'package:http/http.dart' as http;
class Univers{

  fetchUnivers(token) {
    var url = Uri.parse('https://mds.sprw.dev/universes');
    return http.get(url, headers: {'Authorization': 'Bearer $token'}).then((response) {

      if (response.statusCode == 200) {
        //debugPrint(response.body);
        return jsonDecode(response.body) as List<dynamic>;
      } else {
        throw Exception('Failed to load data');
      }
    });
  }

  addUnivers(token,name){
    var url = Uri.parse('https://mds.sprw.dev/universes');
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

  Future<dynamic> getUniversById(String token, String id) async {
    var url = Uri.parse('https://mds.sprw.dev/universes/$id');
    var response = await http.get(url, headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      //debugPrint(response.body);
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<dynamic> updateUnivers(String token, String id, String name) async {
    var url = Uri.parse('https://mds.sprw.dev/universes/$id');
    var body = {
      "name": name,
    };
    var response = await http.put(url, headers: {'Authorization': 'Bearer $token'}, body: jsonEncode(body));

    if (response.statusCode == 200) {
      debugPrint(response.statusCode.toString());
      return response.statusCode.toString();
    } else {
      throw Exception('Failed to load data');
    }
  }
}