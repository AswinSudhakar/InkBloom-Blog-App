import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:inkbloom/api/api.dart';
import 'package:inkbloom/service/helper/authhelper.dart';

class Categoryservice {
  final client = http.Client();

  //get all categories
  Future<List<String>?> getallCAtegory() async {
    final token = await AuthHelper.getToken();
    try {
      final request = await client
          .get(Uri.parse("${Apis().baseurl}${Apis().categoryall}"), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });
      debugPrint(
          'getting categories from ${Apis().baseurl}${Apis().categoryall}');
      if (request.statusCode == 200) {
        final List<String> categories = jsonDecode(request.body);
        debugPrint('category length is ${categories.length}');
        return categories.isNotEmpty ? categories : null;
      } else {
        debugPrint('error occured and statuscode failed:${request.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('$e');
      return null;
    }
  }

//Update CAtegory
  Future<String?> updateCategories(List<String> categories) async {
    final token = await AuthHelper.getToken();
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

      debugPrint(' category add url is ${Apis().baseurl}${Apis().category}');

      if (request.statusCode == 200) {
        final data = jsonDecode(request.body);
        final message = data['message'];

        return message;
      } else {
        debugPrint('error occured and statuscode failed:${request.statusCode}');
      }
    } catch (e) {
      debugPrint('$e');
    }
    return null;
  }

  //get User categories
  Future<List<String>?> getuserCAtegory() async {
    final token = await AuthHelper.getToken();
    try {
      final request = await client
          .get(Uri.parse("${Apis().baseurl}${Apis().category}"), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });
      debugPrint('getting categories from ${Apis().baseurl}${Apis().category}');
      if (request.statusCode == 200) {
        final dynamic decoded = jsonDecode(request.body);
        debugPrint('Decoded user categories: $decoded');

        if (decoded is List) {
          final List<String> usercategories = List<String>.from(decoded);
          debugPrint('Usercategory length is ${usercategories.length}');
          return usercategories.isNotEmpty ? usercategories : null;
        } else {
          debugPrint('Unexpected response format: $decoded');
          return null;
        }
      }
    } catch (e) {
      debugPrint('$e');
      return null;
    }
    return null;
  }
}
