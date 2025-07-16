import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:inkbloom/api/api.dart';
import 'package:inkbloom/models/blog/blogmodel.dart';
import 'package:inkbloom/service/cloudinaryService/cloudinaryService.dart';
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

  Future<String?> addBlog(BlogModel blogmodel) async {
    final token = await AuthHelper.getToken();

    if (blogmodel.imageUrl != null &&
        blogmodel.imageUrl!.isNotEmpty &&
        !blogmodel.imageUrl!.startsWith("http")) {
      final file = File(blogmodel.imageUrl!);
      final uploadedUrl = await CloudinaryService.uploadImageToCloudinary(file,
          isProfileImage: false);
      blogmodel.imageUrl = uploadedUrl;
    }

    final uri = Uri.parse("${Apis().baseurl}${Apis().blogurl}");
    final request = http.MultipartRequest('POST', uri);

    request.headers.addAll({
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });

    request.fields['title'] = blogmodel.title ?? '';
    request.fields['category'] = blogmodel.category ?? '';
    request.fields['topic'] = blogmodel.topic ?? '';
    request.fields['readTime'] = blogmodel.readTime ?? '';
    request.fields['content'] = blogmodel.content ?? '';
    request.fields['image_url'] = blogmodel.imageUrl ?? '';

    try {
      final responseStream = await request.send();
      final response = await http.Response.fromStream(responseStream);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final message = data['message'];
        getAllBlogs();
        return message;
      } else {
        debugPrint("Error Body: ${response.body}");
      }
    } catch (e) {
      debugPrint("Exception: $e");
    }

    return null;
  }

  Future<String?> editBlog(BlogModel blogmodel) async {
    final token = await AuthHelper.getToken();

    // Upload image if it's a local file path
    if (blogmodel.imageUrl != null &&
        blogmodel.imageUrl!.isNotEmpty &&
        !blogmodel.imageUrl!.startsWith("http")) {
      final file = File(blogmodel.imageUrl!);
      final uploadedUrl = await CloudinaryService.uploadImageToCloudinary(
        file,
        isProfileImage: false,
      );
      blogmodel.imageUrl = uploadedUrl;
    }

    final uri = Uri.parse("${Apis().baseurl}${Apis().blogurl}${blogmodel.id}");

    final request = http.MultipartRequest('PATCH', uri);

    request.headers.addAll({
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });

    // Add fields to match FastAPI backend
    request.fields['title'] = blogmodel.title ?? '';
    request.fields['category'] = blogmodel.category ?? '';
    request.fields['topic'] = blogmodel.topic ?? '';
    request.fields['readTime'] = blogmodel.readTime ?? '';
    request.fields['content'] = blogmodel.content ?? '';
    request.fields['image_url'] = blogmodel.imageUrl ?? '';

    try {
      final responseStream = await request.send();
      final response = await http.Response.fromStream(responseStream);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final message = data['message'];
        getAllBlogs();
        return message;
      } else {
        print('Error Body: ${response.body}');
      }
    } catch (e) {
      print("Exception during blog edit: $e");
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

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        debugPrint('Delete message: ${data['message']}');
        getAllBlogs();
        return true;
      } else {
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

      if (request.statusCode == 200) {
        final List<dynamic> responsebody = jsonDecode(request.body);

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
