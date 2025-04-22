import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:inkbloom/api/api.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Categoryservice {
  final client = http.Client();

  //get all categories

  Future<List<String>?> getallCAtegory() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');

    try {
      final request = await client
          .get(Uri.parse("${Apis().baseurl}${Apis().categoryall}"), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });
      print('getting categories from ${Apis().baseurl}${Apis().categoryall}');

      if (request.statusCode == 200) {
        final List<String> categories = jsonDecode(request.body);

        print('category length is ${categories.length}');
        return categories.isNotEmpty ? categories : null;
      } else {
        print('error occured and statuscode failed:${request.statusCode}');
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  //update usercategories

  Future<String?> updateCategories(List<String> categories) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');
    final Map<String, dynamic> body = {
      "selected_categories": categories,
    };
    debugPrint("the Category service is caled");

    try {
      final request =
          await client.put(Uri.parse("${Apis().baseurl}${Apis().category}"),
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $token',
              },
              body: jsonEncode(body));
      print(' category add url is ${Apis().baseurl}${Apis().category}');

      if (request.statusCode == 200) {
        final data = jsonDecode(request.body);
        final message = data['message'];

        return message;
      } else {
        print('error occured and statuscode failed:${request.statusCode}');
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  //get User categories

  Future<List<String>?> getuserCAtegory() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');

    try {
      final request = await client
          .get(Uri.parse("${Apis().baseurl}${Apis().category}"), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });
      print('getting categories from ${Apis().baseurl}${Apis().categoryall}');

      if (request.statusCode == 200) {
        final List<String> usercategories = jsonDecode(request.body);

        print('usercategory length is ${usercategories.length}');
        return usercategories.isNotEmpty ? usercategories : null;
      } else {
        print('error occured and statuscode failed:${request.statusCode}');
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }
}
