import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wordsview/api/api.dart';
import 'package:wordsview/models/user/usermodel.dart';
import 'package:wordsview/service/cloudinaryService/cloudinaryService.dart';
import 'package:wordsview/service/helper/authhelper.dart';
import 'package:shared_preferences/shared_preferences.dart';

final String pbaseurl = 'https://simple-blogging.onrender.com';

class ProfileService {
  final client = http.Client();
  String? _token;

  //Get UserProfile
  Future<UserProfileModel?> getUserProfile() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    _token = pref.getString('token');

    try {
      final response = await client.get(
          Uri.parse('https://simple-blogging.onrender.com/users/profile'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $_token',
          });

      if (response.statusCode == 200) {
        final responsebody = jsonDecode(response.body);

        UserProfileModel userprofile = UserProfileModel.fromJson(responsebody);

        String? avatar = userprofile.profileImage;
        if (avatar != null && avatar.isNotEmpty) {
          if (!avatar.startsWith("http")) {
            avatar =
                "https://simple-blogging.onrender.com${avatar.startsWith("/") ? avatar : "/$avatar"}";
          }
        } else {
          avatar = "";
        }

        await pref.setString('name', userprofile.name ?? 'Guest');
        await pref.setString('email', userprofile.email ?? 'No Email');

        await pref.setString('avatar', avatar);

        await pref.setStringList('favourites', userprofile.favourites ?? []);
        await pref.setStringList(
            'selected_categories', userprofile.selectedCategories ?? []);

        return userprofile;
      }
    } catch (e) {
      debugPrint('$e');
    }
    return null;
  }

  Future<bool?> editUserProfile(String username, dynamic image) async {
    final token = await AuthHelper.getToken();

    String? imageUrl;

    if (image != null && image is File) {
      imageUrl = await CloudinaryService.uploadImageToCloudinary(
        image,
        isProfileImage: true,
      );
    } else if (image is String && image.isNotEmpty) {
      imageUrl = image;
    }

    try {
      final uri = Uri.parse("${Apis().baseurl}${Apis().profile}");
      var request = http.MultipartRequest('PUT', uri);
      request.headers['Authorization'] = 'Bearer $token';

      request.fields['name'] = username;
      if (imageUrl != null && imageUrl.isNotEmpty) {
        request.fields['profile_image'] = imageUrl;
      }

      final response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        final responseBody = await response.stream.bytesToString();
        debugPrint('❌ Update failed: ${response.statusCode} - $responseBody');
      }
    } catch (e) {
      debugPrint("❌ Error during profile update: $e");
    }

    return false;
  }
}
