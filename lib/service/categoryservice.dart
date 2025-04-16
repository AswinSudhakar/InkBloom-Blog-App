import 'dart:convert';

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
        return categories;
      } else {
        print('error occured and statuscode failed:${request.statusCode}');
      }
    } catch (e) {
      print(e);
    }
  }

  //update usercategories

  Future<void> updateCategories() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    final token = _pref.getString('token');

    try {
      final request = await client
          .put(Uri.parse("${Apis().baseurl}${Apis().category}"), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });
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
        return usercategories;
      } else {
        print('error occured and statuscode failed:${request.statusCode}');
      }
    } catch (e) {
      print(e);
    }
  }
}
