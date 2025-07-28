import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wordsview/View/blogscreens/mainhome.dart';
import 'package:wordsview/models/blog/blogmodel.dart';
import 'package:wordsview/ViewModel/blogprovider.dart';
import 'package:wordsview/View/widgets/toastmessage.dart';

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
  bool _isUploading = false;

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
    if (_isUploading) return;
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
    setState(() => _isUploading = true);

    final blogProvider = Provider.of<BlogProvider>(context, listen: false);
    blogProvider.editBlog(updatedBlog).then((_) {
      CustomToastMessagee.show(
        message: 'Blog updated successfully',
      );

      blogProvider.refreshblogs();

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
        backgroundColor: Theme.of(context).colorScheme.primary,
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
                    color: Theme.of(context).colorScheme.onSurface,
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
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.category),
                  hintText: 'Select Category',
                  hintStyle: TextStyle(
                    fontFamily: 'CrimsonText-Bold',
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
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
                    fontFamily: 'CrimsonText-Bold',
                    color: Theme.of(context).colorScheme.onPrimary),
                controller: _contentController,
                maxLines: 6,
                cursorColor: Theme.of(context).colorScheme.onPrimary,
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
                      onPressed: () => _editBlog(widget.blog),
                      icon: const Icon(Icons.save_rounded),
                      label: const Text("Upload Blog"),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor:
                            Theme.of(context).colorScheme.onSurface,
                        foregroundColor: Theme.of(context).colorScheme.primary,
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
                        backgroundColor: Theme.of(context).colorScheme.error,
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
      style: TextStyle(
        color: Theme.of(context).colorScheme.onPrimary,
        fontFamily: 'CrimsonText-Bold',
      ),
      controller: controller,
      cursorColor: Theme.of(context).colorScheme.onPrimary,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(fontFamily: 'CrimsonText-Bold'),
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
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
