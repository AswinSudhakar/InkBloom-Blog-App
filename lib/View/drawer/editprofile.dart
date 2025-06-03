import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inkbloom/View/blogscreens/mainhome.dart';
import 'package:inkbloom/View/drawer/myaccount.dart';
import 'package:inkbloom/ViewModel/userprovider.dart';
import 'package:provider/provider.dart';

class Editprofile extends StatefulWidget {
  const Editprofile({super.key});

  @override
  State<Editprofile> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<Editprofile> {
  Future<void> fetchAndLoadUserData() async {
    // await ProfileService().getUserProfile(); // Ensure profile is fetched
    Provider.of<UserProvider>(context, listen: false).loadData();
    Provider.of<UserProvider>(context, listen: false).fetchandUpdate();
    // await _loadUserData();
  }

  // Future<void> _loadUserData() async {
  final TextEditingController _nameController = TextEditingController();
  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    _nameController.text = userProvider.name!;

    fetchAndLoadUserData();
  }

  File? _pickedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> UploadDAta(String name, dynamic imageInput) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    final success = await userProvider.updateProfile(name, imageInput);
    if (!mounted) return;

    if (success == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Profile updated successfully!",
                style: TextStyle(fontFamily: 'CrimsonText-Bold'))),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Mainhome()),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
          "Failed to update Profile!",
          style: TextStyle(fontFamily: 'CrimsonText-Bold'),
        )),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      // backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Section with Name & Profile Pic
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
                          ));
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      // color: Colors.black,
                      size: 28,
                    ),
                  ),
                ),
                // Positioned(
                //   right: 116,
                //   top: 190,
                //   child: IconButton(
                //     onPressed: () {
                //       _pickImage();
                //     },
                //     icon: Icon(
                //       Icons.edit,
                //       color: Colors.black,
                //       size: 22,
                //     ),
                //   ),
                // ),
                Positioned(
                  top: 150,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: InkWell(
                            onTap: () {
                              _pickImage();
                            },
                            child: CircleAvatar(
                              backgroundColor: Colors.grey[300],
                              backgroundImage: _pickedImage != null
                                  ? FileImage(_pickedImage!)
                                  : (userProvider.profileimage != null &&
                                          userProvider.profileimage!.isNotEmpty
                                      ? NetworkImage(userProvider.profileimage!)
                                          as ImageProvider
                                      : null),
                              child: userProvider.profileimage == null ||
                                      userProvider.profileimage!.isEmpty
                                  ? (_pickedImage == null
                                      ? Icon(Icons.camera_alt,
                                          size: 40, color: Colors.grey[800])
                                      : null)
                                  : null,
                            )),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 70), // Adjusted to fit avatar

            // Profile Information Fields
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SizedBox(height: 20),

                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                          hintText: 'Full Name',
                          hintStyle: TextStyle(
                              fontFamily: 'CrimsonText-SemiBoldItalic')),
                    ),
                  ),

                  SizedBox(
                    height: 30,
                  ),

                  // Edit Profile Button
                  SizedBox(
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              final name = _nameController.text;
                              final imageInput =
                                  _pickedImage ?? userProvider.profileimage;
                              UploadDAta(name, imageInput);
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(100, 20),
                              // backgroundColor: Colors.grey.shade300,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 15),
                            ),
                            child: Text(
                              "Update",
                              style: TextStyle(
                                  fontSize: 18,
                                  // color: Colors.black,
                                  fontFamily: 'CrimsonText-Bold'),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(100, 20),
                              // backgroundColor: Colors.grey.shade300,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 15),
                            ),
                            child: Text(
                              "Cancel",
                              style: TextStyle(
                                  fontSize: 18,
                                  // color: Colors.black,
                                  fontFamily: 'CrimsonText-Bold'),
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
