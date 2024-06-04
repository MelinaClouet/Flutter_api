import 'dart:convert';

import 'package:flutter/cupertino.dart';

import 'package:http/http.dart' as http;
class Univers{

  fetchUnivers(token) {
    debugPrint('token univers');
    debugPrint(token);
    var url = Uri.parse('https://mds.sprw.dev/universes');
    return http.get(url, headers: {'Authorization': 'Bearer $token'}).then((response) {


      if (response.statusCode == 200) {
        debugPrint(response.body);
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load data');
      }
    });
  }
}