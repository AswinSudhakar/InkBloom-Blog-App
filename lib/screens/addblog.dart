// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:permission_handler/permission_handler.dart';

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

//   Future<void> pickImage() async {
//     final XFile? pickedFile =
//         await _picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         _selectedImage = pickedFile;
//       });
//     }
//   }

//   void _uploadBlog() {
//     // Implement blog upload logic here
//     final title = _titleController.text.trim();
//     final topic = _topicController.text.trim();
//     final content = _contentController.text.trim();

//     if (title.isEmpty ||
//         topic.isEmpty ||
//         content.isEmpty ||
//         _selectedImage == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("All fields and image are required")),
//       );
//       return;
//     }

//     // Proceed with upload logic
//     print(
//         "Uploading Blog: $title, $topic, $content, Image: ${_selectedImage!.path}");
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Add Blog'),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           children: [
//             GestureDetector(
//               onTap: pickImage,
//               child: Container(
//                 height: 150,
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   color:
//                       const Color.fromARGB(255, 171, 205, 233).withOpacity(.5),
//                   borderRadius: BorderRadius.circular(20),
//                   image: _selectedImage != null
//                       ? DecorationImage(
//                           image: FileImage(File(_selectedImage!.path)),
//                           fit: BoxFit.cover,
//                         )
//                       : null,
//                 ),
//                 child: _selectedImage == null
//                     ? const Center(
//                         child: Icon(Icons.camera_alt,
//                             size: 50, color: Colors.white),
//                       )
//                     : null,
//               ),
//             ),
//             const SizedBox(height: 10),
//             ElevatedButton.icon(
//               onPressed: pickImage,
//               icon: const Icon(Icons.image),
//               label: const Text("Pick Image"),
//             ),
//             const SizedBox(height: 20),
//             TextField(
//               controller: _titleController,
//               decoration: const InputDecoration(
//                 hintText: 'Title',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 10),
//             TextField(
//               controller: _topicController,
//               decoration: const InputDecoration(
//                 hintText: 'Topic',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 10),
//             TextField(
//               controller: _contentController,
//               maxLines: 5,
//               decoration: const InputDecoration(
//                 hintText: 'Content',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _uploadBlog,
//               child: const Text('Upload Blog'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inkbloom/models/blog/blogmodel.dart';
import 'package:inkbloom/providers/blogprovider.dart';

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
  final TextEditingController _CategoryController = TextEditingController();
  final TextEditingController _readtimeController = TextEditingController();

  BlogProvider blogProvider = BlogProvider();

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
    final category = _CategoryController.text.trim();
    final readTime = _readtimeController.text.trim();

    if (title.isEmpty ||
        topic.isEmpty ||
        content.isEmpty ||
        category.isEmpty ||
        readTime.isEmpty ||
        _selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("All fields and image are required")),
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
      imageUrl: _selectedImage!.path.toString(),
    );

    // Call the addBlog method of BlogProvider to upload the blog
    blogProvider.addBlog(newBlog).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Blog uploaded successfully")),
      );
      // After successful upload, clear the text fields
      _CategoryController.clear();
      _contentController.clear();
      _readtimeController.clear();
      _titleController.clear();
      _topicController.clear();

      // Optionally, navigate back to the homepage or another screen
      Navigator.pop(context); // Goes back to the previous screen
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $error")),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Blog'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[200],
                  ),
                  child: _selectedImage == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.upload_rounded,
                                size: 40, color: Colors.grey),
                            SizedBox(height: 8),
                            Text("Upload Image",
                                style: TextStyle(color: Colors.grey)),
                          ],
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(File(_selectedImage!.path),
                              fit: BoxFit.cover, width: double.infinity),
                        ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  hintText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _topicController,
                decoration: const InputDecoration(
                  hintText: 'Topic',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _readtimeController,
                decoration: const InputDecoration(
                  hintText: 'Read Time',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _CategoryController,
                decoration: const InputDecoration(
                  hintText: 'Category',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _contentController,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText: 'Content',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _uploadBlog,
                child: const Text('Upload Blog'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
