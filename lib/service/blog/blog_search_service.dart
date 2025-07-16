import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:inkbloom/api/api.dart';
import 'package:inkbloom/models/blog/blogmodel.dart';
import 'package:inkbloom/service/helper/authhelper.dart';

class BlogSearchService {
  final client = http.Client();
  Future<List<BlogModel>?> searchBlogs(String query, {int page = 1}) async {
    final token = await AuthHelper.getToken();
    try {
      final request = await client.get(
          Uri.parse(
              "${Apis().baseurl}${Apis().blogurl}search?query=$query&page=$page"),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          });

      if (request.statusCode == 200) {
        final List<dynamic> responsebody = jsonDecode(request.body);

        final List<BlogModel> blogs =
            responsebody.map((json) => BlogModel.fromJson(json)).toList();
        return blogs;
      } else {
        debugPrint('error occured and statuscode failed:${request.statusCode}');
      }
    } catch (e) {
      debugPrint('$e');
    }
    return null;
  }
}
