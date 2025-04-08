import 'package:flutter/material.dart';
import 'package:inkbloom/models/user/usermodel.dart';
import 'package:inkbloom/service/userprofile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  String? _name;
  String? _email;
  String? _profileImage;
  List<String>? _selectedCategories;
  List<String>? _favourites;

  String? get name => _name;
  String? get email => _email;
  String? get profileimage => _profileImage;
  List<String>? get favourites => _favourites;
  List<String>? get selectedCategories => _selectedCategories;

  Future<void> loadData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    _name = pref.getString('name') ?? 'Guest';
    _email = pref.getString('email') ?? 'No Email';
    _profileImage = pref.getString('avatar') ?? 'No Image';
    _selectedCategories = pref.getStringList('favourites');
    _favourites = pref.getStringList('selected_categories');

    notifyListeners();
  }

  Future<void> fetchandUpdate() async {
    try {
      UserProfileModel? userdata = await ProfileService().getUserProfile();
      if (userdata != null) {
        _name = userdata.name;
        _email = userdata.email;
        _profileImage = userdata.profileImage;

        _favourites = userdata.favourites;
        _selectedCategories = userdata.selectedCategories;

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('name', _name!);
        await prefs.setString('email', _email!);
        await prefs.setString('avatar', _profileImage!);
        await prefs.setStringList('favourites', _favourites!);
        await prefs.setStringList('selected_categories', _selectedCategories!);

        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }
}
