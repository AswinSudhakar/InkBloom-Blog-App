// // import 'dart:io';

// // import 'package:flutter/material.dart';
// // import 'package:image_picker/image_picker.dart';
// // import 'package:permission_handler/permission_handler.dart';

// // class AddBlog extends StatefulWidget {
// //   const AddBlog({super.key});

// //   @override
// //   State<AddBlog> createState() => _AddBlogState();
// // }

// // class _AddBlogState extends State<AddBlog> {
// //   XFile? _selectedImage;
// //   final ImagePicker _picker = ImagePicker();
// //   final TextEditingController _titleController = TextEditingController();
// //   final TextEditingController _topicController = TextEditingController();
// //   final TextEditingController _contentController = TextEditingController();

// //   Future<void> pickImage() async {
// //     final XFile? pickedFile =
// //         await _picker.pickImage(source: ImageSource.gallery);
// //     if (pickedFile != null) {
// //       setState(() {
// //         _selectedImage = pickedFile;
// //       });
// //     }
// //   }

// //   void _uploadBlog() {
// //     // Implement blog upload logic here
// //     final title = _titleController.text.trim();
// //     final topic = _topicController.text.trim();
// //     final content = _contentController.text.trim();

// //     if (title.isEmpty ||
// //         topic.isEmpty ||
// //         content.isEmpty ||
// //         _selectedImage == null) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text("All fields and image are required")),
// //       );
// //       return;
// //     }

// //     // Proceed with upload logic
// //     print(
// //         "Uploading Blog: $title, $topic, $content, Image: ${_selectedImage!.path}");
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('Add Blog'),
// //         centerTitle: true,
// //       ),
// //       body: SingleChildScrollView(
// //         padding: const EdgeInsets.all(20.0),
// //         child: Column(
// //           children: [
// //             GestureDetector(
// //               onTap: pickImage,
// //               child: Container(
// //                 height: 150,
// //                 width: double.infinity,
// //                 decoration: BoxDecoration(
// //                   color:
// //                       const Color.fromARGB(255, 171, 205, 233).withOpacity(.5),
// //                   borderRadius: BorderRadius.circular(20),
// //                   image: _selectedImage != null
// //                       ? DecorationImage(
// //                           image: FileImage(File(_selectedImage!.path)),
// //                           fit: BoxFit.cover,
// //                         )
// //                       : null,
// //                 ),
// //                 child: _selectedImage == null
// //                     ? const Center(
// //                         child: Icon(Icons.camera_alt,
// //                             size: 50, color: Colors.white),
// //                       )
// //                     : null,
// //               ),
// //             ),
// //             const SizedBox(height: 10),
// //             ElevatedButton.icon(
// //               onPressed: pickImage,
// //               icon: const Icon(Icons.image),
// //               label: const Text("Pick Image"),
// //             ),
// //             const SizedBox(height: 20),
// //             TextField(
// //               controller: _titleController,
// //               decoration: const InputDecoration(
// //                 hintText: 'Title',
// //                 border: OutlineInputBorder(),
// //               ),
// //             ),
// //             const SizedBox(height: 10),
// //             TextField(
// //               controller: _topicController,
// //               decoration: const InputDecoration(
// //                 hintText: 'Topic',
// //                 border: OutlineInputBorder(),
// //               ),
// //             ),
// //             const SizedBox(height: 10),
// //             TextField(
// //               controller: _contentController,
// //               maxLines: 5,
// //               decoration: const InputDecoration(
// //                 hintText: 'Content',
// //                 border: OutlineInputBorder(),
// //               ),
// //             ),
// //             const SizedBox(height: 20),
// //             ElevatedButton(
// //               onPressed: _uploadBlog,
// //               child: const Text('Upload Blog'),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:inkbloom/models/blog/blogmodel.dart';
// import 'package:inkbloom/ViewModel/blogprovider.dart';
// import 'package:inkbloom/View/blogscreens/home2.dart';
// import 'package:provider/provider.dart';

// class AddBlog extends StatefulWidget {
//   const AddBlog({super.key});

//   @override
//   State<AddBlog> createState() => _AddBlogState();
// }

// class _AddBlogState extends State<AddBlog> {
//   XFile? _selectedImage;
//   final ImagePicker _picker = ImagePicker();
//   final TextEditingController _titleController = TextEditingController();
//   final TextEditingController _topicController = TextEditingController();
//   final TextEditingController _contentController = TextEditingController();

//   final TextEditingController _readtimeController = TextEditingController();

//   BlogProvider blogProvider = BlogProvider();

//   Future<void> _pickImage() async {
//     final XFile? pickedFile =
//         await _picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         _selectedImage = pickedFile;
//       });
//     }
//   }

//   final List<String> _categories = [
//     'Technology',
//     'Business',
//     'Lifestyle',
//     'Health',
//     'Education',
//     'Culture',
//     'Sports',
//     'Society',
//     'Work',
//   ];

//   String? _selectedCategory;

//   void _uploadBlog() {
//     final title = _titleController.text.trim();
//     final topic = _topicController.text.trim();
//     final content = _contentController.text.trim();
//     final category = _selectedCategory;
//     final readTime = _readtimeController.text.trim();

//     if (title.isEmpty ||
//         topic.isEmpty ||
//         content.isEmpty ||
//         category == null ||
//         readTime.isEmpty ||
//         _selectedImage == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("All fields and image are required")),
//       );
//       return;
//     }

//     final newBlog = BlogModel(
//       category: category,
//       topic: topic,
//       title: title,
//       readTime: readTime,
//       content: content,
//       createdAt: DateTime.now().toString(),
//       imageUrl: _selectedImage!.path.toString(),
//     );

//     // ✅ Use Provider instead of creating a new instance
//     final blogProvider = Provider.of<BlogProvider>(context, listen: false);

//     blogProvider.addBlog(newBlog).then((_) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Blog uploaded successfully")),
//       );

//       // ✅ Refresh blog list
//       blogProvider.fetchBlogs(); // This ensures the home screen updates

//       // Clear fields

//       _contentController.clear();
//       _readtimeController.clear();
//       _titleController.clear();
//       _topicController.clear();
//       setState(() {
//         _selectedImage = null;
//       });

//       // Navigate back to home screen
//       Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => HomeScreen2(),
//           ));
//     }).catchError((error) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error: $error")),
//       );
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Add Blog',
//             style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600)),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               GestureDetector(
//                 onTap: _pickImage,
//                 child: Container(
//                   width: double.infinity,
//                   height: 150,
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.grey),
//                     borderRadius: BorderRadius.circular(10),
//                     color: Colors.grey[200],
//                   ),
//                   child: _selectedImage == null
//                       ? Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(Icons.upload_rounded,
//                                 size: 40, color: Colors.grey),
//                             SizedBox(height: 8),
//                             Text("Upload Image",
//                                 style: TextStyle(color: Colors.grey)),
//                           ],
//                         )
//                       : ClipRRect(
//                           borderRadius: BorderRadius.circular(10),
//                           child: Image.file(File(_selectedImage!.path),
//                               fit: BoxFit.cover, width: double.infinity),
//                         ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               TextField(
//                 controller: _titleController,
//                 decoration: const InputDecoration(
//                   hintText: 'Title',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               TextField(
//                 controller: _topicController,
//                 decoration: const InputDecoration(
//                   hintText: 'Topic',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               TextField(
//                 keyboardType: TextInputType.number,
//                 controller: _readtimeController,
//                 decoration: const InputDecoration(
//                   suffixText: 'Min',
//                   hintText: 'Read Time',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               DropdownButtonFormField<String>(
//                 value: _selectedCategory,
//                 decoration: const InputDecoration(
//                   hintText: 'Select Category',
//                   border: OutlineInputBorder(),
//                 ),
//                 items: _categories.map((category) {
//                   return DropdownMenuItem<String>(
//                     value: category,
//                     child: Text(category),
//                   );
//                 }).toList(),
//                 onChanged: (value) {
//                   setState(() {
//                     _selectedCategory = value;
//                   });
//                 },
//                 validator: (value) =>
//                     value == null ? 'Please select a category' : null,
//               ),
//               const SizedBox(height: 20),
//               TextField(
//                 controller: _contentController,
//                 maxLines: 5,
//                 decoration: const InputDecoration(
//                   hintText: 'Content',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _uploadBlog,
//                 child: const Text('Upload Blog'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inkbloom/View/blogscreens/mainhome.dart';
import 'package:inkbloom/models/blog/blogmodel.dart';
import 'package:inkbloom/ViewModel/blogprovider.dart';
import 'package:inkbloom/widgets/toastmessage.dart';

import 'package:provider/provider.dart';

class AddBlog extends StatefulWidget {
  const AddBlog({super.key});

  @override
  State<AddBlog> createState() => _AddBlogState();
}

class _AddBlogState extends State<AddBlog> {
  XFile? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _topicController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _readtimeController = TextEditingController();

  bool _hasUnsavedChanges() {
    return _titleController.text.isNotEmpty ||
        _topicController.text.isNotEmpty ||
        _contentController.text.isNotEmpty ||
        _readtimeController.text.isNotEmpty ||
        _selectedImage != null ||
        _selectedCategory != null;
  }

  Future<bool> _onBackPressed() async {
    if (_hasUnsavedChanges()) {
      bool? discard = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Discard changes?'),
          content: const Text(
              'You have unsaved changes. Are you sure you want to leave?'),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel')),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                  _titleController.clear();
                  _topicController.clear();
                  _contentController.clear();
                  _readtimeController.clear();
                  _selectedImage = null;
                  _selectedCategory = null;
                  setState(() {});
                },
                child: const Text('Discard')),
          ],
        ),
      );
      return discard ?? false;
    }
    return true;
  }

  final List<String> _categories = [
    'Technology',
    'Business',
    'Lifestyle',
    'Health',
    'Education',
    'Culture',
    'Sports',
    'Society',
    'Work',
  ];
  String? _selectedCategory;

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = pickedFile;
      });
    }
  }

  void _uploadBlog() {
    final title = _titleController.text.trim();
    final topic = _topicController.text.trim();
    final content = _contentController.text.trim();
    final category = _selectedCategory;
    final readTime = _readtimeController.text.trim();

    if (title.isEmpty ||
        topic.isEmpty ||
        content.isEmpty ||
        category == null ||
        readTime.isEmpty ||
        _selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("All fields and image are required",
                style: TextStyle(fontFamily: 'CrimsonText-Bold'))),
      );
      return;
    }

    final newBlog = BlogModel(
      category: category,
      topic: topic,
      title: title,
      readTime: readTime,
      content: content,
      createdAt: DateTime.now().toString(),
      imageUrl: _selectedImage!.path,
    );

    final blogProvider = Provider.of<BlogProvider>(context, listen: false);

    blogProvider.addBlog(newBlog).then((_) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(
      //       content: Text("Blog uploaded successfully",
      //           style: TextStyle(fontFamily: 'CrimsonText-Bold'))),
      // );
      CustomToastMessagee.show(
        message: 'Blog updated successfully',
      );

      blogProvider.fetchBlogs();

      _contentController.clear();
      _readtimeController.clear();
      _titleController.clear();
      _topicController.clear();
      setState(() {
        _selectedImage = null;
        _selectedCategory = null;
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Mainhome()),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Error: $error",
                style: TextStyle(fontFamily: 'CrimsonText-Bold'))),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return WillPopScope(
        onWillPop: () => _onBackPressed(),
        // canPop: true,
        // onPopInvoked: (didPop) async {
        //   if (didPop) return;
        //   bool shouldPop = await _onBackPressed();
        //   if (shouldPop) Navigator.of(context).pop();
        // },
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () async {
                bool shouldPop = await _onBackPressed();
                if (shouldPop) {
                  Navigator.of(context).pop();
                }
              },
            ),
            centerTitle: true,
            title: const Text(
              "Add Blog",
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'CrimsonText-Bold'),
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.onPrimary,
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 50,
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: double.infinity,
                    height: 180,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onBackground,
                      borderRadius: BorderRadius.circular(15),
                      image: _selectedImage != null
                          ? DecorationImage(
                              image: FileImage(File(_selectedImage!.path)),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: _selectedImage == null
                        ? const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.image, size: 50, color: Colors.grey),
                                SizedBox(height: 8),
                                Text("Tap to upload image",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontFamily: 'CrimsonText-Bold')),
                              ],
                            ),
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 20),
                _buildInputField(_titleController, "Title", Icons.title),
                const SizedBox(height: 10),
                _buildInputField(_topicController, "Topic", Icons.topic),
                const SizedBox(height: 10),
                _buildInputField(
                    _readtimeController, "Read Time (min)", Icons.timer,
                    isNumber: true),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.category),
                    hintText: 'Select Category',
                    hintStyle: TextStyle(
                      fontFamily: 'CrimsonText-Bold',
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                    border: const OutlineInputBorder(),
                  ),
                  style: TextStyle(
                    // 🔥 This styles the selected item text
                    fontFamily: 'CrimsonText-Bold',
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                  dropdownColor:
                      Theme.of(context).colorScheme.surface, // optional
                  items: _categories.map((category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(
                        category,
                        style: TextStyle(
                          // 🔥 This styles the dropdown items
                          fontFamily: 'CrimsonText-Bold',
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  },
                ),
                const SizedBox(height: 10),
                TextField(
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                  controller: _contentController,
                  maxLines: 6,
                  decoration: const InputDecoration(
                    hintText: 'Content',
                    hintStyle: TextStyle(fontFamily: 'CrimsonText-Bold'),
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _uploadBlog,
                        icon: const Icon(Icons.cloud_upload_rounded),
                        label: const Text("Upload Blog"),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor:
                              Theme.of(context).colorScheme.onSurface,
                          foregroundColor:
                              Theme.of(context).colorScheme.primary,
                          textStyle: const TextStyle(fontSize: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          bool shouldPop = await _onBackPressed();
                          if (shouldPop) {
                            Navigator.of(context).pop();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor:
                              Theme.of(context).colorScheme.onError,
                          foregroundColor: Colors.black,
                          textStyle: const TextStyle(fontSize: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Cancel'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildInputField(
    TextEditingController controller,
    String hintText,
    IconData icon, {
    bool isNumber = false,
  }) {
    return TextField(
      style: TextStyle(color: Theme.of(context).colorScheme.primary),
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(fontFamily: 'CrimsonText-Bold'),
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
    );
  }

  // Future<bool> _confirmDiscard() async {
  //   final hasunsaveddata = _titleController.text.isNotEmpty ||
  //       _topicController.text.isNotEmpty ||
  //       _readtimeController.text.isNotEmpty ||
  //       _contentController.text.isNotEmpty ||
  //       _selectedCategory != null ||
  //       _selectedImage != null;

  //   if (!hasunsaveddata) {
  //     return true;
  //   }

  //   final shouldDiscard = await showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: const Text('Discard Changes?'),
  //       content: const Text('You Have Unsaved Changes, Do You Wantn To Leave?'),
  //       actions: [
  //         TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop(false);
  //             },
  //             child: Text('Cancel')),
  //         TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop(true);
  //             },
  //             child: Text('Discard'))
  //       ],
  //     ),
  //   );
  //   return shouldDiscard ?? false;
  // }
}
