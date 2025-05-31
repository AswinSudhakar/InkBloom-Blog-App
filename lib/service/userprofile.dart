import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:inkbloom/api/api.dart';
import 'package:inkbloom/models/user/usermodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

final String pbaseurl = 'https://simple-blogging.onrender.com';

class ProfileService {
  final client = http.Client();
  String? _token;

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
          avatar = ""; // Default to empty if null
        }
        print("Profile Image URL: $avatar");
        // Update the userProfile instance with the corrected image URL

        await pref.setString('name', userprofile.name ?? 'Guest');
        await pref.setString('email', userprofile.email ?? 'No Email');

        await pref.setString('avatar', avatar);

        await pref.setStringList('favourites', userprofile.favourites ?? []);
        await pref.setStringList(
            'selected_categories', userprofile.selectedCategories ?? []);

        print(userprofile);
        return userprofile;
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

// Future<bool?> editUserProfile(String username, File? avatar) async {
//   SharedPreferences pref = await SharedPreferences.getInstance();
//   final token = pref.getString('token');
//   final uri = Uri.parse("${Apis().baseurl}${Apis().profile}");

//   try {
//     final request = http.MultipartRequest("PUT", uri);
//     request.headers['Authorization'] = 'Bearer $token';

//     request.fields['name'] = username;

//     if (avatar != null) {
//       request.files.add(
//         await http.MultipartFile.fromPath('profile_image', avatar.path),
//       );
//     }

//     final response = await request.send();

//     if (response.statusCode == 200 || response.statusCode == 201) {
//       print('User Data Updated successfully.');
//       final responseBody = await response.stream.bytesToString();
//       final data = json.decode(responseBody);
//       print(data);
//       return true;
//     } else {
//       print('Profile update failed: ${response.statusCode}');
//       final errorBody = await response.stream.bytesToString();
//       print('Response: $errorBody');
//       return false;
//     }
//   } catch (e) {
//     print('Error during profile update: $e');
//     return false;
//   }
// }

  Future<bool?> editUserProfile(String username, dynamic image) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    _token = pref.getString('token');

    try {
      final uri = Uri.parse("${Apis().baseurl}${Apis().profile}");
      var request = http.MultipartRequest('PUT', uri);
      request.headers['Authorization'] = 'Bearer $_token';

      request.fields['name'] = username;

      if (image != null) {
        if (image is File) {
          request.files.add(
              await http.MultipartFile.fromPath('profile_image', image.path));
        } else if (image is String && image.isNotEmpty) {
          // If the image is a URL, just add it as a field (optional based on your backend handling)
          request.fields['profile_image_url'] = image;
        }
      }

      final response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Profile updated successfully");
        return true;
      } else {
        final responseBody = await response.stream.bytesToString();
        print('Update failed: ${response.statusCode} - $responseBody');
      }
    } catch (e) {
      print("Error during profile update: $e");
    }

    return false;
  }

  // //edit the user category
  // Future<void> editUserCAtegory(List<String> categories) async {
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   _token = pref.getString('token');
  //   final Map<String, dynamic> body = {
  //     "selected_categories": categories,
  //   };

  //   try {
  //     final response =
  //         await client.put(Uri.parse("${Apis().baseurl}${Apis().category}"),
  //             headers: {
  //               'Content-Type': 'application/json',
  //               'Authorization': 'Bearer $_token',
  //             },
  //             body: jsonEncode(body));

  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       print('User Data Updated successfully.');
  //       final data = json.decode(response.body);

  //       final message = data['message'];
  //       // print(message);
  //       return message;
  //     } else {
  //       print('profile Update failed with status code: ${response.statusCode}');
  //       print('Response: ${response.body}');
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  //   return;
  // }
}
