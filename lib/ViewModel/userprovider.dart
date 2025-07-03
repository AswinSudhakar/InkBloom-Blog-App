import 'package:flutter/material.dart';
import 'package:inkbloom/models/user/usermodel.dart';
import 'package:inkbloom/service/userprofile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  UserProfileModel? user;
  String? _name;
  String? _email;
  String? _profileImage;
  List<String>? _selectedCategories;
  List<String>? _favourites;

  String? get name => _name;
  String? get email => _email;
  String? get profileimage =>
      _profileImage?.isNotEmpty == true ? _profileImage : null;

  List<String>? get favourites => _favourites;
  List<String>? get selectedCategories => _selectedCategories;

  Future<void> loadData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    _name = pref.getString('name') ?? 'Guest';
    _email = pref.getString('email') ?? 'No Email';
    _profileImage = pref.getString('avatar') ?? 'No Image';
    _profileImage = pref.getString('avatar');
    if (_profileImage == null || _profileImage!.isEmpty) {
      _profileImage = null;
    }

    _selectedCategories = pref.getStringList('favourites');
    _favourites = pref.getStringList('selected_categories');

    notifyListeners();
  }

  String? get safeProfileImage {
    if (profileimage == null || profileimage!.endsWith('.heic')) {
      return null;
    }
    return profileimage;
  }

  Future<void> fetchandUpdate() async {
    try {
      UserProfileModel? userdata = await ProfileService().getUserProfile();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (userdata != null) {
        _name = userdata.name;
        _email = userdata.email;
        _profileImage = userdata.profileImage;
        _profileImage = userdata.profileImage;
        if (_profileImage == null || _profileImage!.isEmpty) {
          prefs.remove('avatar');
        } else {
          prefs.setString('avatar', _profileImage!);
        }

        _favourites = userdata.favourites;
        _selectedCategories = userdata.selectedCategories;

        await prefs.setString('name', _name!);
        await prefs.setString('email', _email!);
        await prefs.setString('avatar', _profileImage ?? '');

        await prefs.setStringList('favourites', _favourites!);
        await prefs.setStringList('selected_categories', _selectedCategories!);

        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }

  bool isUpdating = false;

  Future<bool?> updateProfile(String name, dynamic image) async {
    isUpdating = true;
    notifyListeners();

    final success = await ProfileService().editUserProfile(name, image);
    fetchandUpdate();

    isUpdating = false;
    notifyListeners();
    return success;
  }

  void clearProfileImage() async {
    _profileImage = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('avatar');

    notifyListeners();
  }
}
