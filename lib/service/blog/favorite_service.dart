import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wordsview/api/api.dart';
import 'package:wordsview/models/blog/blogmodel.dart';
import 'package:wordsview/service/helper/authhelper.dart';

class FavoriteService {
  final client = http.Client();

//add to favorites
  Future<String?> addToFavorite(String id) async {
    final token = await AuthHelper.getToken();
    try {
      final request = await client.post(
          Uri.parse("${Apis().baseurl}${Apis().favorites}/$id"),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          });

      if (request.statusCode == 200) {
        final requestbody = await jsonDecode(request.body);

        final message = requestbody['message'];

        return message;
      }
    } catch (e) {
      debugPrint('$e');
    }
    return null;
  }

  //get all favorite blogs
  Future<List<BlogModel>?> getFavoriteBlogs() async {
    final token = await AuthHelper.getToken();
    try {
      final request = await client
          .get(Uri.parse("${Apis().baseurl}${Apis().favorites}"), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });

      if (request.statusCode == 200) {
        List<dynamic> requestbody = jsonDecode(request.body);
        final List<BlogModel> blogs =
            requestbody.map((json) => BlogModel.fromJson(json)).toList();
        return blogs;
      }
    } catch (e) {
      debugPrint("$e");
    }
    return null;
  }

  //delete blog from Favorite
  Future<bool?> deletefromFavorite(String id) async {
    final token = await AuthHelper.getToken();
    try {
      final request = await client.delete(
          Uri.parse("${Apis().baseurl}${Apis().favorites}/$id"),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          });

      if (request.statusCode == 200) {
        final reqbody = jsonDecode(request.body);
        final message = reqbody['message'];
        debugPrint("$message");
        return true;
      } else {
        debugPrint("deleteing request failed");
        return false;
      }
    } catch (e) {
      debugPrint("$e");
    }
    return null;
  }
}
