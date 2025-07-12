import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:inkbloom/api/api.dart';
import 'package:inkbloom/models/user/usermodel.dart';
import 'package:inkbloom/service/cloudinaryService/cloudinaryService.dart';
import 'package:inkbloom/service/helper/authhelper.dart';
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
        debugPrint("Profile Image URL: $avatar");

        await pref.setString('name', userprofile.name ?? 'Guest');
        await pref.setString('email', userprofile.email ?? 'No Email');

        await pref.setString('avatar', avatar);

        await pref.setStringList('favourites', userprofile.favourites ?? []);
        await pref.setStringList(
            'selected_categories', userprofile.selectedCategories ?? []);

        debugPrint('$userprofile');
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
        // 👇 Send it as a field even though it's a URL
        request.fields['profile_image'] = imageUrl;
      }

      final response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint("✅ Profile updated successfully");
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

  // Future<bool?> editUserProfile(String username, dynamic image) async {
  //   final token = await AuthHelper.getToken();

  //   String? imageUrl;

  //   // Upload to Cloudinary if image is a local file
  //   if (image != null && image is File) {
  //     imageUrl = await CloudinaryService.uploadImageToCloudinary(
  //       image,
  //       isProfileImage: true,
  //     );
  //     debugPrint("Cloudinary URL: $imageUrl");
  //   } else if (image is String && image.isNotEmpty) {
  //     imageUrl = image;
  //   }

  //   final Map<String, dynamic> body = {
  //     "name": username,
  //     if (imageUrl != null && imageUrl.isNotEmpty) "profile_image": imageUrl,
  //   };

  //   try {
  //     final response = await http.put(
  //       Uri.parse("${Apis().baseurl}${Apis().profile}"),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $token',
  //       },
  //       body: jsonEncode(body),
  //     );

  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       debugPrint("✅ Profile updated successfully");
  //       return true;
  //     } else {
  //       debugPrint(
  //           "❌ Update failed: ${response.statusCode} - ${response.body}");
  //     }
  //   } catch (e) {
  //     debugPrint("❌ Error during profile update: $e");
  //   }

  //   return false;
  // }

  //Edit UserProfile
  // Future<bool?> editUserProfile(String username, dynamic image) async {
  //   final token = await AuthHelper.getToken();

  //   try {
  //     final uri = Uri.parse("${Apis().baseurl}${Apis().profile}");
  //     var request = http.MultipartRequest('PUT', uri);
  //     request.headers['Authorization'] = 'Bearer $token';

  //     request.fields['name'] = username;

  //     if (image != null) {
  //       if (image is File) {
  //         request.files.add(
  //             await http.MultipartFile.fromPath('profile_image', image.path));
  //       } else if (image is String && image.isNotEmpty) {
  //         request.fields['profile_image_url'] = image;
  //       }
  //     }

  //     final response = await request.send();

  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       debugPrint("Profile updated successfully");
  //       return true;
  //     } else {
  //       final responseBody = await response.stream.bytesToString();
  //       debugPrint('Update failed: ${response.statusCode} - $responseBody');
  //     }
  //   } catch (e) {
  //     debugPrint("Error during profile update: $e");
  //   }

  //   return false;
  // }
}
