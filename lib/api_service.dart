import 'dart:convert';

import 'package:http/http.dart' as http;

import 'constants.dart';

Map<String, dynamic> data = {};

class ApiService {
  Uri getUrl(bool category) {
    if (category == true) {
      return Uri.parse(ApiConstants.baseUrl + ApiConstants.usersEndpoint1);
    }
    return Uri.parse(ApiConstants.baseUrl + ApiConstants.usersEndpoint2);
  }

  Future<Map> getIngredients(name,category) async {
    var url = getUrl(category);
    try {
      var response = await http
          .post(url, body: {'product_name': name.toLowerCase()});
      if (200 == response.statusCode) {
        data = json.decode(response.body);
        return data;
      } else {
        return {"error": -1};
      }
    } catch (e) {
      return {"error": -1};
    }
  }
  Future<Map> getIngredientsforBarcode(name,category) async {
    var url = getUrl(category);
    try {
      var response = await http
          .post(url, body: {'product_name': name.toLowerCase()});
      if (200 == response.statusCode) {
        data = json.decode(response.body);
        return data;
      } else {
        return {"error": -1};
      }
    } catch (e) {
      return {"error": -1};
    }
  }

  Future<Map> getRating(name, ingredients, subcategory,category) async {
    var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.fetchendpoint);
    try {
      var response = await http.post(url, body: {
        'product_name': name,
        'ingredients': ingredients,
        'sub_category': subcategory,
        'category': category,
      });
      if (200 == response.statusCode) {
        data = json.decode(response.body);
        return data;
      } else{
        return {"error": -1};
      }
    } catch (e) {
      return {"error": -1};
    }
  }
}
