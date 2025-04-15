import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inkbloom/models/blog/blogmodel.dart';
import 'package:inkbloom/ViewModel/blogprovider.dart';
import 'package:inkbloom/View/blogscreens/home2.dart';
import 'package:provider/provider.dart';

class EditBlog extends StatefulWidget {
  final BlogModel blog;
  const EditBlog({super.key, required this.blog});

  @override
  State<EditBlog> createState() => _AddBlogState();
}

class _AddBlogState extends State<EditBlog> {
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

  void _EditBlog(BlogModel blog) {
    print('');

    final newBlog = BlogModel(
      id: widget.blog.id,
      category: _CategoryController.text,
      topic: _topicController.text,
      title: _titleController.text,
      readTime: _readtimeController.text,
      content: _contentController.text,
      createdAt: widget.blog.createdAt,
      updatedAt: DateTime.now().toString(),
      imageUrl: _selectedImage != null
          ? _selectedImage!.path.toString()
          : widget.blog.imageUrl ?? '',
    );

    final blogProvider = Provider.of<BlogProvider>(context, listen: false);

    blogProvider.editBlog(newBlog).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Blog updated successfully")),
      );

      blogProvider.fetchBlogs();

      _CategoryController.clear();
      _contentController.clear();
      _readtimeController.clear();
      _titleController.clear();
      _topicController.clear();

      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen2(),
          ));
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $error")),
      );
    });
  }

  @override
  void initState() {
    super.initState();

    // Pre-fill controllers with existing blog data
    _titleController.text = widget.blog.title!;
    _contentController.text = widget.blog.content!;
    _CategoryController.text = widget.blog.category!;
    _readtimeController.text = widget.blog.readTime!;
    _topicController.text = widget.blog.topic!;
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
                      ? (widget.blog.imageUrl != null &&
                              widget.blog.imageUrl!.isNotEmpty
                          ? Image.network(widget.blog.imageUrl!,
                              fit: BoxFit.cover)
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.upload_rounded,
                                    size: 40, color: Colors.grey),
                                SizedBox(height: 8),
                                Text("Upload Image",
                                    style: TextStyle(color: Colors.grey)),
                              ],
                            ))
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
                onPressed: () {
                  _EditBlog(widget.blog);
                },
                child: const Text('Update Blog'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
