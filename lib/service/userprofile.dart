import 'dart:convert';

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

  //edit user profile
  Future<UserProfileModel?> editUserProfile(
    String username,
    String avatar,
  ) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    _token = pref.getString('token');
    final Map<String, dynamic> body = {
      "name": username,
      "profile_image": avatar,
    };

    try {
      final response =
          await client.put(Uri.parse("${Apis().baseurl}${Apis().profile}"),
              headers: {
                'Content-Type': 'multipart/form-data',
                'Authorization': 'Bearer $_token',
              },
              body: jsonEncode(body));

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('User Data Updated successfully.');
        final data = json.decode(response.body);

        final message = data['message'];
        // print(message);
        return message;
      } else {
        print('profile Update failed with status code: ${response.statusCode}');
        print('Response: ${response.body}');
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  //edit the user category
  Future<void> editUserCAtegory(List<String> categories) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    _token = pref.getString('token');
    final Map<String, dynamic> body = {
      "selected_categories": categories,
    };

    try {
      final response =
          await client.put(Uri.parse("${Apis().baseurl}${Apis().category}"),
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $_token',
              },
              body: jsonEncode(body));

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('User Data Updated successfully.');
        final data = json.decode(response.body);

        final message = data['message'];
        // print(message);
        return message;
      } else {
        print('profile Update failed with status code: ${response.statusCode}');
        print('Response: ${response.body}');
      }
    } catch (e) {
      print(e);
    }
    return;
  }
}
