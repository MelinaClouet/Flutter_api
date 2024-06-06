import 'dart:convert';

import 'package:flutter/cupertino.dart';

import 'package:http/http.dart' as http;
class Pictures {
  String fetchPictures(token, String? urlImage) {
    if (urlImage == null || urlImage.isEmpty) {
      return 'https://via.placeholder.com/150';
    } else {
      var url = Uri.parse('https://mds.sprw.dev/image_data/$urlImage');
      //debugPrint(url.toString());
      // Retourne l'URL directement pour une utilisation immédiate
      return url.toString();
    }
  }
}