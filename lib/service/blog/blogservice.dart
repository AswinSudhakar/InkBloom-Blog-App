import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:inkbloom/api/api.dart';
import 'package:inkbloom/models/blog/blogmodel.dart';
import 'package:inkbloom/service/helper/authhelper.dart';

class Blogservice {
  final client = http.Client();

  //Get all Blogs
  Future<List<BlogModel>?> getAllBlogs({int page = 1}) async {
    final token = await AuthHelper.getToken();
    try {
      final response = await client.get(
          Uri.parse("${Apis().baseurl}${Apis().blogurl}?page=$page"),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          });
      debugPrint("📡 API CALL: Getting blogs for page $page");
      debugPrint("📡 API CALL: Getting all blogs ...");
      if (response.statusCode == 200) {
        final List<dynamic> responsebody = jsonDecode(response.body);
        final List<BlogModel> blogs =
            responsebody.map((json) => BlogModel.fromJson(json)).toList();
        return blogs;
      } else {
        debugPrint(
            'error occured and statuscode failed:${response.statusCode}');
      }
    } catch (e) {
      debugPrint('errorrrr occured :$e');
    }
    return null;
  }

//get myblogs
  Future<List<BlogModel>?> getMyBlogs({int page = 1}) async {
    final token = await AuthHelper.getToken();
    try {
      final request = await client.get(
          Uri.parse(
              'https://simple-blogging.onrender.com/blogs/my-blogs?page=$page'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          });
      debugPrint("📡 API CALL: Getting My blogs for page $page");

      if (request.statusCode == 200) {
        final List<dynamic> responsebody = jsonDecode(request.body);
        final List<BlogModel> blogs =
            responsebody.map((json) => BlogModel.fromJson(json)).toList();
        return blogs;
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  //add blog
  Future<String?> addBlog(BlogModel blogmodel) async {
    final token = await AuthHelper.getToken();
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse("${Apis().baseurl}${Apis().blogurl}"),
      );
      debugPrint("📡 API CALL: Add blog...");
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Content-Type'] = 'multipart/form-data';
      request.fields['title'] = blogmodel.title!;
      request.fields['category'] = blogmodel.category!;
      request.fields['content'] = blogmodel.content!;
      request.fields['topic'] = blogmodel.topic!;
      request.fields['readTime'] = blogmodel.readTime!;
      request.fields['created_at'] = DateTime.now().toIso8601String();

      if (blogmodel.imageUrl!.isNotEmpty) {
        request.files.add(
          await http.MultipartFile.fromPath('image', blogmodel.imageUrl!),
        );
      }
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
    final token = await AuthHelper.getToken();
    try {
      var request = http.MultipartRequest(
        'PATCH',
        Uri.parse("${Apis().baseurl}${Apis().blogurl}${blogmodel.id}"),
      );
      debugPrint("📡 API CALL: Edit Blog...");
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Content-Type'] = 'multipart/form-data';
      request.fields['title'] = blogmodel.title!;
      request.fields['category'] = blogmodel.category!;
      request.fields['content'] = blogmodel.content!;
      request.fields['topic'] = blogmodel.topic!;
      request.fields['readTime'] = blogmodel.readTime!;
      request.fields['updated_at'] = DateTime.now().toString();
      request.fields['created_at'] = blogmodel.createdAt!;

      if (blogmodel.imageUrl != null &&
          blogmodel.imageUrl!.isNotEmpty &&
          !blogmodel.imageUrl!.startsWith("http")) {
        request.files.add(
          await http.MultipartFile.fromPath('image', blogmodel.imageUrl!),
        );
      }
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

  //delete blog
  Future<bool?> deleteBlog(BlogModel blogModel) async {
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
      } else {
        debugPrint('Failed to delete blog. Status: ${response.statusCode}');
        debugPrint('Response body: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error deleting blog: $e');
    }
    return null;
  }

  //get the blogs by user category
  Future<List<BlogModel>?> getBlogsByuserCategory({int page = 1}) async {
    final token = await AuthHelper.getToken();
    try {
      final response = await client.get(
          Uri.parse(
              "https://simple-blogging.onrender.com/blogs/by-selected-categories?page=$page"),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          });
      debugPrint("📡 API CALL: Getting blogs by selected category...");
      if (response.statusCode == 200) {
        final List<dynamic> responsebody = jsonDecode(response.body);

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

  //filter blogs by selected category
  Future<List<BlogModel>?> filterBlog(String category) async {
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
}
