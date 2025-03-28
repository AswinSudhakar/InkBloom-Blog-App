import 'package:flutter/material.dart';
import 'package:inkbloom/models/blog/blogmodel.dart';

import 'package:inkbloom/screens/detailscreen.dart';
import 'package:inkbloom/service/blogservice.dart';
import 'package:inkbloom/service/userprofile.dart';
import 'package:inkbloom/widgets/drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen2 extends StatefulWidget {
  const HomeScreen2({super.key});

  @override
  State<HomeScreen2> createState() => _HomeScreen2State();
}

class _HomeScreen2State extends State<HomeScreen2> {
  final Blogservice blogService = Blogservice();
  late Future<List<BlogModel>?> blogsFuture;
  final user = ProfileService().getUserProfile();

  String? name;
  String? email;
  String? avatar;

  @override
  void initState() {
    super.initState();
    blogsFuture = blogService.getAllBlogs();
    fetchAndLoadUserData();
  }

  Future<void> fetchAndLoadUserData() async {
    await ProfileService().getUserProfile(); // Ensure profile is fetched
    await _loadUserData(); // Then load from SharedPreferences
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name') ?? " Guest";
      email = prefs.getString('email') ?? "No Email";
      avatar = prefs.getString('avatar') ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(title: Text('welcome  $name')),
      body: FutureBuilder<List<BlogModel>?>(
        future: blogsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No blogs found'));
          }

          final blogs = snapshot.data!;

          return ListView.builder(
            itemCount: blogs.length,
            itemBuilder: (context, index) {
              final blog = blogs[index];

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  leading: blog.imageUrl != null
                      ? Image.network(
                          "/users/profile/${blog.imageUrl}",
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        )
                      : const Icon(Icons.image_not_supported),
                  title: Text(blog.title ?? "No Title"),
                  subtitle: Text(blog.topic ?? "No Topic"),
                  trailing: Text(blog.readTime ?? ""),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PostDetailScreen(),
                        ));
                    // Navigate to blog details page if needed
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
