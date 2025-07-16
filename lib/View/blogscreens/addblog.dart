import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inkbloom/View/blogscreens/mainhome.dart';
import 'package:inkbloom/models/blog/blogmodel.dart';
import 'package:inkbloom/ViewModel/blogprovider.dart';
import 'package:inkbloom/View/widgets/toastmessage.dart';

import 'package:provider/provider.dart';

class AddBlog extends StatefulWidget {
  const AddBlog({super.key});

  @override
  State<AddBlog> createState() => _AddBlogState();
}

class _AddBlogState extends State<AddBlog> {
  XFile? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;

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
          title: Text(
            'Discard changes?',
            style: TextStyle(
              fontFamily: 'CrimsonText-Bold',
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          content: Text(
            'You have unsaved changes. Are you sure you want to leave?',
            style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontFamily: 'CrimsonText-Bold'),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontFamily: 'CrimsonText-Bold'),
                )),
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
                child: Text(
                  'Discard',
                  style: TextStyle(
                    fontFamily: 'CrimsonText-Bold',
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                )),
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
    if (_isUploading) return;

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

    setState(() => _isUploading = true);

    blogProvider.addBlog(newBlog).then((_) {
      CustomToastMessagee.show(
        message: 'Blog updated successfully',
      );

      blogProvider.refreshblogs();

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
          backgroundColor: Theme.of(context).colorScheme.primary,
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
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(15),
                      image: _selectedImage != null
                          ? DecorationImage(
                              image: FileImage(File(_selectedImage!.path)),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: _selectedImage == null
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.image,
                                  size: 50,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                                SizedBox(height: 8),
                                Text("Tap to upload image",
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
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
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    border: const OutlineInputBorder(),
                    alignLabelWithHint: true,
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
                  style: TextStyle(
                    fontFamily: 'CrimsonText-Bold',
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                  dropdownColor: Theme.of(context).colorScheme.surface,
                  items: _categories.map((category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(
                        category,
                        style: TextStyle(
                          fontFamily: 'CrimsonText-Bold',
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.onPrimary,
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
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontFamily: 'CrimsonText-Bold'),
                  controller: _contentController,
                  cursorColor: Theme.of(context).colorScheme.onPrimary,
                  maxLines: 6,
                  decoration: InputDecoration(
                    hintText: 'Content',
                    hintStyle: TextStyle(fontFamily: 'CrimsonText-Bold'),
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
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
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _uploadBlog,
                        icon: const Icon(Icons.cloud_upload_rounded),
                        label: const Text(
                          "Upload Blog",
                          style: TextStyle(fontFamily: 'CrimsonText-Bold'),
                        ),
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
                          backgroundColor: Theme.of(context).colorScheme.error,
                          foregroundColor:
                              Theme.of(context).colorScheme.onPrimary,
                          textStyle: const TextStyle(fontSize: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(fontFamily: 'CrimsonText-Bold'),
                        ),
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
      style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
          fontFamily: 'CrimsonText-Bold'),
      controller: controller,
      cursorColor: Theme.of(context).colorScheme.onPrimary,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(fontFamily: 'CrimsonText-Bold'),
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
        alignLabelWithHint: true,
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
    );
  }
}
