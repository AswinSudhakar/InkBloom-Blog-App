// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:inkbloom/models/blog/blogmodel.dart';
// import 'package:inkbloom/ViewModel/blogprovider.dart';
// import 'package:inkbloom/View/blogscreens/home2.dart';
// import 'package:provider/provider.dart';

// class EditBlog extends StatefulWidget {
//   final BlogModel blog;
//   const EditBlog({super.key, required this.blog});

//   @override
//   State<EditBlog> createState() => _AddBlogState();
// }

// class _AddBlogState extends State<EditBlog> {
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

//   void _editBlog(BlogModel blog) {
//     print('');

//     final newBlog = BlogModel(
//       id: widget.blog.id,
//       category: _selectedCategory,
//       topic: _topicController.text,
//       title: _titleController.text,
//       readTime: _readtimeController.text,
//       content: _contentController.text,
//       createdAt: widget.blog.createdAt,
//       updatedAt: DateTime.now().toString(),
//       imageUrl: _selectedImage != null
//           ? _selectedImage!.path.toString()
//           : widget.blog.imageUrl ?? '',
//     );

//     final blogProvider = Provider.of<BlogProvider>(context, listen: false);

//     blogProvider.editBlog(newBlog).then((_) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Blog updated successfully")),
//       );

//       blogProvider.fetchBlogs();

//       _contentController.clear();
//       _readtimeController.clear();
//       _titleController.clear();
//       _topicController.clear();

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
//   void initState() {
//     super.initState();

//     // Pre-fill controllers with existing blog data
//     _titleController.text = widget.blog.title!;
//     _contentController.text = widget.blog.content!;
//     _selectedCategory = widget.blog.category!;
//     _readtimeController.text = widget.blog.readTime!;
//     _topicController.text = widget.blog.topic!;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Edit Blog'),
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
//                       ? (widget.blog.imageUrl != null &&
//                               widget.blog.imageUrl!.isNotEmpty
//                           ? Image.network(widget.blog.imageUrl!,
//                               fit: BoxFit.cover)
//                           : Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Icon(Icons.upload_rounded,
//                                     size: 40, color: Colors.grey),
//                                 SizedBox(height: 8),
//                                 Text("Upload Image",
//                                     style: TextStyle(color: Colors.grey)),
//                               ],
//                             ))
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
//                   suffixText: ' Min',
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
//                 onPressed: () {
//                   _editBlog(widget.blog);
//                 },
//                 child: const Text('Update Blog'),
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

class EditBlog extends StatefulWidget {
  final BlogModel blog;
  const EditBlog({super.key, required this.blog});

  @override
  State<EditBlog> createState() => _EditBlogState();
}

class _EditBlogState extends State<EditBlog> {
  XFile? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _topicController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _readtimeController = TextEditingController();

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

  void _editBlog(BlogModel blog) {
    final updatedBlog = BlogModel(
      id: widget.blog.id,
      category: _selectedCategory,
      topic: _topicController.text.trim(),
      title: _titleController.text.trim(),
      readTime: _readtimeController.text.trim(),
      content: _contentController.text.trim(),
      createdAt: widget.blog.createdAt,
      updatedAt: DateTime.now().toString(),
      imageUrl: _selectedImage != null
          ? _selectedImage!.path
          : widget.blog.imageUrl ?? '',
    );

    final blogProvider = Provider.of<BlogProvider>(context, listen: false);
    blogProvider.editBlog(updatedBlog).then((_) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text("Blog updated successfully")),
      // );
      CustomToastMessagee.show(
        message: 'Blog updated successfully',
      );

      blogProvider.fetchBlogs();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Mainhome()),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $error")),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.blog.title ?? '';
    _topicController.text = widget.blog.topic ?? '';
    _contentController.text = widget.blog.content ?? '';
    _readtimeController.text = widget.blog.readTime ?? '';
    _selectedCategory = widget.blog.category;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Edit Blog",
            style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                fontFamily: 'CrimsonText-Bold'),
          ),
        ),
        backgroundColor: const Color(0xFFF9F9F9),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: double.infinity,
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(15),
                    image: _selectedImage != null
                        ? DecorationImage(
                            image: FileImage(File(_selectedImage!.path)),
                            fit: BoxFit.cover,
                          )
                        : (widget.blog.imageUrl != null &&
                                widget.blog.imageUrl!.isNotEmpty)
                            ? DecorationImage(
                                image: NetworkImage(widget.blog.imageUrl!),
                                fit: BoxFit.cover,
                              )
                            : null,
                  ),
                  child: (_selectedImage == null &&
                          (widget.blog.imageUrl == null ||
                              widget.blog.imageUrl!.isEmpty))
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
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.category),
                  hintText: 'Select Category',
                  hintStyle: TextStyle(fontFamily: 'CrimsonText-Bold'),
                  border: OutlineInputBorder(),
                ),
                items: _categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
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
                      onPressed: () => _editBlog(widget.blog),
                      icon: const Icon(Icons.save_rounded),
                      label: const Text("Upload Blog"),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: Colors.black87,
                        foregroundColor: Colors.white,
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
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: Colors.grey.shade300,
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
  }

  Widget _buildInputField(
    TextEditingController controller,
    String hintText,
    IconData icon, {
    bool isNumber = false,
  }) {
    return TextField(
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
}
