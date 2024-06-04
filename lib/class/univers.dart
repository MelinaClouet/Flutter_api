import 'dart:convert';

import 'package:flutter/cupertino.dart';

import 'package:http/http.dart' as http;
class Univers{

  fetchUnivers(token) {
    debugPrint('token univers');
    debugPrint(token);
    var url = Uri.parse('https://mds.sprw.dev/universes');
    return http.get(url, headers: {'Authorization': 'Bearer $token'}).then((response) {


      if (response.statusCode == 201) {
        debugPrint(response.body);
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load data');
      }
    });
  }

  addUnivers(token,name){
    debugPrint('addUnivers');
    debugPrint(name);
    var url = Uri.parse('https://mds.sprw.dev/universes');
    var body={
      "name":name,
    };
    http.post(url,headers: {'Authorization': 'Bearer $token'}, body: jsonEncode(body)).then((response){
      debugPrint(response.statusCode.toString());

      if(response.statusCode==201){
        return true;
      }
      else{
        return false;
      }


    });
  }

  getUniversById(token,id){

    var url=Uri.parse('https://mds.sprw.dev/universes/$id');
    http.post(url,headers: {'Authorization': 'Bearer $token'}).then((response){
      debugPrint(response.statusCode.toString());

      if (response.statusCode == 201) {
        debugPrint(response.body);
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load data');
      }

    });

  }
}