import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inkbloom/View/blogscreens/mainhome.dart';
import 'package:inkbloom/View/drawer/myaccount.dart';
import 'package:inkbloom/ViewModel/userprovider.dart';
import 'package:inkbloom/widgets/toastmessage.dart';
import 'package:provider/provider.dart';

class Editprofile extends StatefulWidget {
  const Editprofile({super.key});

  @override
  State<Editprofile> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<Editprofile> {
  final TextEditingController _nameController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _pickedImage;
  bool _removeProfileImage = false;

  Future<void> fetchAndLoadUserData() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.loadData();
    await userProvider.fetchandUpdate();
    _nameController.text = userProvider.name ?? '';
  }

  @override
  void initState() {
    super.initState();
    fetchAndLoadUserData();
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
        _removeProfileImage = false;
      });
    }
  }

  Future<void> uploadData(String name) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    dynamic imageInput;

    if (_removeProfileImage) {
      imageInput = null;
    } else {
      imageInput = _pickedImage ?? userProvider.profileimage;
    }

    final success = await userProvider.updateProfile(name, imageInput);
    if (!mounted) return;

    if (success == true) {
      CustomToastMessagee.show(message: 'Profile updated successfully');
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Mainhome()),
        (route) => false,
      );
    } else {
      CustomToastMessagee.show(message: 'Failed to update Profile!');
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(.3),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(90),
                      bottomRight: Radius.circular(90),
                    ),
                  ),
                ),
                Positioned(
                  left: 20,
                  top: 50,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileScreen(),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: Theme.of(context).colorScheme.onSurface,
                      size: 28,
                    ),
                  ),
                ),
                Positioned(
                  top: 150,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: Stack(
                          children: [
                            GestureDetector(
                              onTap: _pickImage,
                              child: CircleAvatar(
                                radius: 80,
                                backgroundColor:
                                    Theme.of(context).colorScheme.background,
                                backgroundImage: _pickedImage != null
                                    ? FileImage(_pickedImage!)
                                    : (_removeProfileImage
                                        ? null
                                        : (userProvider.profileimage != null &&
                                                userProvider
                                                    .profileimage!.isNotEmpty
                                            ? NetworkImage(
                                                userProvider.profileimage!)
                                            : null)),
                                child: (_pickedImage == null &&
                                        (_removeProfileImage ||
                                            userProvider.profileimage == null ||
                                            userProvider.profileimage!.isEmpty))
                                    ? Icon(
                                        Icons.camera_alt,
                                        size: 40,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      )
                                    : null,
                              ),
                            ),
                            if (_pickedImage != null ||
                                (!_removeProfileImage &&
                                    userProvider.profileimage != null &&
                                    userProvider.profileimage!.isNotEmpty))
                              Positioned(
                                top: -4,
                                right: -4,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _pickedImage = null;
                                      _removeProfileImage = true;
                                    });
                                  },
                                  child: CircleAvatar(
                                    radius: 12,
                                    backgroundColor: Colors.red,
                                    child: Icon(
                                      Icons.close,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 70),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextField(
                      controller: _nameController,
                      cursorColor: Theme.of(context).colorScheme.onPrimary,
                      style: TextStyle(
                        fontFamily: 'CrimsonText-SemiBoldItalic',
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Full Name',
                        hintStyle: TextStyle(
                          fontFamily: 'CrimsonText-SemiBoldItalic',
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.6),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.onPrimary,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.onPrimary,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          final name = _nameController.text.trim();
                          uploadData(name);
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(100, 20),
                          backgroundColor:
                              Theme.of(context).colorScheme.background,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: Text(
                          "Update",
                          style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontFamily: 'CrimsonText-Bold',
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(100, 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontFamily: 'CrimsonText-Bold',
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
