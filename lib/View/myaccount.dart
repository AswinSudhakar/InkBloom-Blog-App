import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inkbloom/ViewModel/userprovider.dart';
import 'package:inkbloom/View/blogscreens/home2.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<void> fetchAndLoadUserData() async {
    // await ProfileService().getUserProfile(); // Ensure profile is fetched
    Provider.of<UserProvider>(context, listen: false).loadData();
    Provider.of<UserProvider>(context, listen: false).fetchandUpdate();
    // await _loadUserData();
  }

  // Future<void> _loadUserData() async {
  @override
  void initState() {
    super.initState();

    fetchAndLoadUserData();
  }

  XFile? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = pickedFile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      backgroundColor: Colors.grey[200],
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
                    color: Colors.blue.shade700,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(90),
                      bottomRight: Radius.circular(90),
                    ),
                  ),
                ),
                Positioned(
                    top: 210, left: 250, child: Icon(Icons.edit_rounded)),
                Positioned(
                  left: 20,
                  top: 50,
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeScreen2(),
                          ));
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
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
                        child: ClipOval(
                          child: userProvider.profileimage != null &&
                                  userProvider.profileimage!.isNotEmpty
                              ? Image.network(
                                  userProvider.profileimage!,
                                  fit: BoxFit.fill,
                                )
                              : Container(
                                  color: Colors.grey[300],
                                  child: Icon(Icons.person, size: 40),
                                ),
                        ),
                      ),

                      SizedBox(height: 20),
                      // Text(
                      //   'Anna Avetisyan',
                      //   style: TextStyle(
                      //     fontSize: 20,
                      //     fontWeight: FontWeight.bold,
                      //     color: Colors.white,
                      //   ),
                      // ),
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
                  ProfileField(
                      icon: Icons.person, text: '${userProvider.name}'),
                  ProfileField(
                      icon: Icons.email, text: '${userProvider.email}'),

                  // InkWell(
                  //     onTap: () {
                  //       Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //             builder: (context) => CategoryScreen(),
                  //           ));
                  //     },
                  //     child: ProfileField(
                  //         icon: Icons.category, text: 'Categories')),
                  // // ProfileField(icon: Icons.camera_alt, text: 'Instagram account'),

                  // ProfileField(
                  //     icon: Icons.visibility, text: 'Password', isPassword: true),

                  SizedBox(height: 20),

                  // Edit Profile Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        editProfile(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade700,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: Text(
                        "Edit Profile",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom Widget for Profile Fields
class ProfileField extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isPassword;

  const ProfileField({
    super.key,
    required this.icon,
    required this.text,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(text, style: TextStyle(fontSize: 16)),
        trailing: isPassword ? Icon(Icons.sync, color: Colors.grey) : null,
      ),
    );
  }
}

// Future<void> _categoriesSelect(BuildContext context) async {
//   return showDialog(
//     context: context,
//     builder: (context) => AlertDialog(
//       actions: [
//         SizedBox(
//           height: 18,
//         ),
//         Container(
//           width: 400,
//           height: 400,
//           color: Colors.black.withOpacity(.3),
//         )
//       ],
//     ),
//   );
// }

Future<void> editProfile(BuildContext context) async {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(
        'Edit Profile',
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      content: SizedBox(
        height: 350,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {},
                  child: CircleAvatar(
                    radius: 50,
                  ),
                ),
                TextFormField(
                  decoration: InputDecoration(hintText: 'Name'),
                ),
                TextFormField(
                  decoration: InputDecoration(hintText: 'Email'),
                ),
                // TextFormField(
                //     decoration: InputDecoration(hintText: 'Category')),
                SizedBox(
                  height: 70,
                ),
                // ElevatedButton(onPressed: () {}, child: Text('Update'))
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          child: Text("Cancel"),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: Text("Update"),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    ),
  );
}
