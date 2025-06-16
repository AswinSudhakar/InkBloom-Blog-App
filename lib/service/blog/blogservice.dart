import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:inkbloom/api/api.dart';
import 'package:inkbloom/models/blog/blogmodel.dart';
import 'package:inkbloom/service/helper/authhelper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Blogservice {
  final client = http.Client();

  //Get all Blogs
  Future<List<BlogModel>?> getAllBlogs() async {
    // SharedPreferences pref = await SharedPreferences.getInstance();
    // final token = pref.getString('token');
    // print('the token is :$token');
    final token = await AuthHelper.getToken();

    try {
      final response = await client
          .get(Uri.parse("${Apis().baseurl}${Apis().blogurl}"), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });
      // print('Fetching blogs from: ${Apis().baseurl}${Apis().blogurl}');
      debugPrint("📡 API CALL: Getting all blogs ...");

      if (response.statusCode == 200) {
        final List<dynamic> responsebody = jsonDecode(response.body);

        final List<BlogModel> blogs =
            responsebody.map((json) => BlogModel.fromJson(json)).toList();

        // print('the blogs returned:${blogs.length}');

        return blogs;
      } else {
        debugPrint(
            'error occured and statuscode failed:${response.statusCode}');
      }

      // print('response url is :${Apis().baseurl}${Apis().blogurl}');
    } catch (e) {
      debugPrint('errorrrr occured :$e');
    }
    return null;
  }

  //add blog
  Future<String?> addBlog(BlogModel blogmodel) async {
    // SharedPreferences pref = await SharedPreferences.getInstance();
    // final token = pref.getString('token');
    final token = await AuthHelper.getToken();

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse("${Apis().baseurl}${Apis().blogurl}"),
      );
      debugPrint("📡 API CALL: Add blog...");

      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Content-Type'] = 'multipart/form-data';

      // Add fields (text data)
      request.fields['title'] = blogmodel.title!;
      request.fields['category'] = blogmodel.category!;
      request.fields['content'] = blogmodel.content!;
      request.fields['topic'] = blogmodel.topic!;
      request.fields['readTime'] = blogmodel.readTime!;
      request.fields['created_at'] = DateTime.now().toIso8601String();

      // Attach image file if available
      if (blogmodel.imageUrl!.isNotEmpty) {
        request.files.add(
          await http.MultipartFile.fromPath('image', blogmodel.imageUrl!),
        );
      }

      // Send request
      var response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final data = json.decode(responseBody);
        final message = data['message'];
        getAllBlogs();

        debugPrint(message);
        return message;
      } else {
        debugPrint(
            'Registration failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint("the message got back :=> $e");
    }
    return null;
  }

  //edit blog
  Future<String?> editBlog(BlogModel blogmodel) async {
    // SharedPreferences pref = await SharedPreferences.getInstance();
    // final token = pref.getString('token');
    final token = await AuthHelper.getToken();

    try {
      var request = http.MultipartRequest(
        'PATCH',
        Uri.parse("${Apis().baseurl}${Apis().blogurl}${blogmodel.id}"),
      );

      debugPrint("📡 API CALL: Edit Blog...");
      // debugPrint('The editing request url is $request');

      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Content-Type'] = 'multipart/form-data';

      // Add fields (text data)
      request.fields['title'] = blogmodel.title!;
      request.fields['category'] = blogmodel.category!;
      request.fields['content'] = blogmodel.content!;
      request.fields['topic'] = blogmodel.topic!;
      request.fields['readTime'] = blogmodel.readTime!;
      request.fields['updated_at'] = DateTime.now().toString();
      request.fields['created_at'] = blogmodel.createdAt!;

      // Attach image file if available
      if (blogmodel.imageUrl != null &&
          blogmodel.imageUrl!.isNotEmpty &&
          !blogmodel.imageUrl!.startsWith("http")) {
        // Only add if it's a local file path, not a URL
        request.files.add(
          await http.MultipartFile.fromPath('image', blogmodel.imageUrl!),
        );
      }

      // print('The editing request url is $request');

      // Send request
      var response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final data = json.decode(responseBody);
        final message = data['message'];
        getAllBlogs();

        debugPrint(message);
        return message;
      } else {
        debugPrint(
            'Registration failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint("the message got backkkkkk :=> $e");
    }
    return null;
  }

  //get the blogs by user category
  Future<List<BlogModel>?> getBlogsByuserCategory() async {
    // SharedPreferences pref = await SharedPreferences.getInstance();
    // final token = pref.getString('token');
    final token = await AuthHelper.getToken();

    try {
      final response = await client.get(
          Uri.parse(
              "https://simple-blogging.onrender.com/blogs/by-selected-categories"),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          });
      debugPrint("📡 API CALL: Getting blogs by selected category...");

      if (response.statusCode == 200) {
        final List<dynamic> responsebody = jsonDecode(response.body);
        // debugPrint("🧪 Raw response: ${response.body}");

        final List<BlogModel> blogs =
            responsebody.map((json) => BlogModel.fromJson(json)).toList();

        debugPrint(
            'the blogs returned by userselected category ------>:${blogs.length}');

        return blogs;
      } else {
        debugPrint(
            'error occured and statuscode failed:${response.statusCode}');
      }
    } catch (e) {
      debugPrint('$e');
    }
    return null;
  }

  //delete blog
  Future<bool?> deleteBlog(BlogModel blogModel) async {
    // final SharedPreferences pref = await SharedPreferences.getInstance();
    // final token = pref.getString('token');
    final token = await AuthHelper.getToken();

    final url = Uri.parse("${Apis().baseurl}${Apis().blogurl}${blogModel.id}");
    try {
      final response = await client.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      debugPrint("📡 API CALL: Delete Blog...");

      debugPrint('DELETE request sent to: $url');
      debugPrint('Status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        debugPrint('Delete message: ${data['message']}');
        getAllBlogs();
        return true;

        // Call to refresh the blog list
      } else {
        debugPrint('Failed to delete blog. Status: ${response.statusCode}');
        debugPrint('Response body: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error deleting blog: $e');
    }
    return null;
  }

  // //search blogs
  // Future<List<BlogModel>?> searchBlogs(String query) async {
  //   // SharedPreferences pref = await SharedPreferences.getInstance();
  //   // final token = pref.getString('token');
  //   final token = await AuthHelper.getToken();

  //   try {
  //     final request = await client.get(
  //         Uri.parse("${Apis().baseurl}${Apis().blogurl}search?query=$query"),
  //         headers: {
  //           'Content-Type': 'application/json',
  //           'Authorization': 'Bearer $token',
  //         });
  //     debugPrint("📡 API CALL: Edit Blog...");

  //     if (request.statusCode == 200) {
  //       final List<dynamic> responsebody = jsonDecode(request.body);
  //       debugPrint("🧪 Raw response: ${request.body}");

  //       final List<BlogModel> blogs =
  //           responsebody.map((json) => BlogModel.fromJson(json)).toList();
  //       return blogs;
  //     } else {
  //       debugPrint('error occured and statuscode failed:${request.statusCode}');
  //     }
  //   } catch (e) {
  //     debugPrint('$e');
  //   }
  //   return null;
  // }

  //filter blogs by selected category
  Future<List<BlogModel>?> filterBlog(String category) async {
    // SharedPreferences pref = await SharedPreferences.getInstance();
    // final token = pref.getString('token');
    final token = await AuthHelper.getToken();

    try {
      final request = await client.get(
          Uri.parse("${Apis().baseurl}${Apis().blogurl}?category=$category"),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          });
      debugPrint("📡 API CALL: filter Blog by $category...");

      if (request.statusCode == 200) {
        final List<dynamic> responsebody = jsonDecode(request.body);
        debugPrint("🧪 Raw response: ${request.body}");

        final List<BlogModel> blogs =
            responsebody.map((json) => BlogModel.fromJson(json)).toList();
        return blogs;
      } else {
        debugPrint('status code failed---');
      }
    } catch (e) {
      debugPrint('$e');
    }
    return null;
  }

  // //add blog to favorites
  // Future<String?> addToFavorite(String id) async {
  //   // SharedPreferences pref = await SharedPreferences.getInstance();
  //   // final token = pref.getString('token');
  //   final token = await AuthHelper.getToken();
  //   try {
  //     final request = await client.post(
  //         Uri.parse("${Apis().baseurl}${Apis().favorites}/$id"),
  //         headers: {
  //           'Content-Type': 'application/json',
  //           'Authorization': 'Bearer $token',
  //         });

  //     debugPrint("📡 API CALL: Add Blog To Favorite...");

  //     if (request.statusCode == 200) {
  //       final requestbody = await jsonDecode(request.body);
  //       debugPrint("The blog added to favorites $requestbody");
  //       final message = requestbody['message'];

  //       return message;
  //     }
  //   } catch (e) {
  //     debugPrint('$e');
  //   }
  //   return null;
  // }

  // //get all favorite blogs
  // Future<List<BlogModel>?> getFavoriteBlogs() async {
  //   // SharedPreferences pref = await SharedPreferences.getInstance();
  //   // final token = pref.getString('token');
  //   final token = await AuthHelper.getToken();
  //   try {
  //     final request = await client
  //         .get(Uri.parse("${Apis().baseurl}${Apis().favorites}"), headers: {
  //       'Content-Type': 'application/json',
  //       'Authorization': 'Bearer $token',
  //     });

  //     debugPrint("📡 API CALL: Get all Favorite Blogs...");
  //     if (request.statusCode == 200) {
  //       List<dynamic> requestbody = jsonDecode(request.body);
  //       final List<BlogModel> blogs =
  //           requestbody.map((json) => BlogModel.fromJson(json)).toList();
  //       return blogs;
  //     }
  //   } catch (e) {
  //     debugPrint("$e");
  //   }
  //   return null;
  // }

  // //delete blog from Favorite
  // Future<bool?> deletefromFavorite(String id) async {
  //   // SharedPreferences pref = await SharedPreferences.getInstance();
  //   // final token = pref.getString('token');
  //   final token = await AuthHelper.getToken();
  //   try {
  //     final request = await client.delete(
  //         Uri.parse("${Apis().baseurl}${Apis().favorites}/$id"),
  //         headers: {
  //           'Content-Type': 'application/json',
  //           'Authorization': 'Bearer $token',
  //         });
  //     debugPrint("📡 API CALL: Delete Blog From Favorites...");

  //     if (request.statusCode == 200) {
  //       final reqbody = jsonDecode(request.body);
  //       final message = reqbody['message'];
  //       debugPrint("$message");
  //       return true;
  //     } else {
  //       debugPrint("deleteing request failed");
  //       return false;
  //     }
  //   } catch (e) {
  //     debugPrint("$e");
  //   }
  //   return null;
  // }
}
