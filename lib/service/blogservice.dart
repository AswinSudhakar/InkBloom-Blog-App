import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:inkbloom/api/api.dart';
import 'package:inkbloom/models/blog/blogmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Blogservice {
  final client = http.Client();

  Future<List<BlogModel>?> getAllBlogs() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');
    print('the token is :$token');

    try {
      final response = await client
          .get(Uri.parse("${Apis().baseurl}${Apis().blogurl}"), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });
      print('Fetching blogs from: ${Apis().baseurl}${Apis().blogurl}');

      if (response.statusCode == 200) {
        final List<dynamic> responsebody = jsonDecode(response.body);

        final List<BlogModel> blogs =
            responsebody.map((json) => BlogModel.fromJson(json)).toList();

        print('the blogs returned:${blogs.length}');
        return blogs;
      } else {
        print('error occured and statuscode failed:${response.statusCode}');
      }

      print('response url is :${Apis().baseurl}${Apis().blogurl}');
    } catch (e) {
      print('errorrrr occured :$e');
    }
    return null;
  }
}
