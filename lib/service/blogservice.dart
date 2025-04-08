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

  Future<String?> AddBlog(BlogModel blogmodel) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse("${Apis().baseurl}${Apis().blogurl}"),
      );

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

        print(message);
        return message;
      } else {
        print('Registration failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      print("the message got back :=> $e");
    }
    return null;
  }

  Future<String?> EditBlog(BlogModel blogmodel) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');

    try {
      var request = http.MultipartRequest(
        'PATCH',
        Uri.parse("${Apis().baseurl}${Apis().blogurl}${blogmodel.id}"),
      );
      print('The editing request url is $request');

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
      if (blogmodel.imageUrl != null && blogmodel.imageUrl!.isNotEmpty) {
        request.files.add(
          await http.MultipartFile.fromPath('image', blogmodel.imageUrl!),
        );
      }
      print('The editing request url is $request');

      // Send request
      var response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final data = json.decode(responseBody);
        final message = data['message'];
        getAllBlogs();

        print(message);
        return message;
      } else {
        print('Registration failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      print("the message got backkkkkk :=> $e");
    }
    return null;
  }
}
