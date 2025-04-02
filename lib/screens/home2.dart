import 'package:flutter/material.dart';
import 'package:inkbloom/api/api.dart';
import 'package:inkbloom/providers/blogprovider.dart';
import 'package:inkbloom/screens/detailscreen.dart';
import 'package:inkbloom/screens/loginpage.dart';
import 'package:inkbloom/service/userprofile.dart';
import 'package:inkbloom/widgets/drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

class HomeScreen2 extends StatefulWidget {
  const HomeScreen2({super.key});

  @override
  State<HomeScreen2> createState() => _HomeScreen2State();
}

class _HomeScreen2State extends State<HomeScreen2> {
  String? name;
  String? email;
  String? avatar;

  BlogProvider blogProvider = BlogProvider();

  @override
  void initState() {
    super.initState();
    fetchAndLoadUserData();
  }

  Future<void> fetchAndLoadUserData() async {
    await ProfileService().getUserProfile(); // Ensure profile is fetched
    await _loadUserData(); // Then load from SharedPreferences
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name') ?? "Guest";
      email = prefs.getString('email') ?? "No Email";
      avatar = prefs.getString('avatar') ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Welcome $name'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ));
              },
              icon: Icon(Icons.refresh))
        ],
      ),
      body: Consumer<BlogProvider>(
        builder: (context, blogProvider, child) {
          if (blogProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (blogProvider.error != null) {
            return Center(child: Text('Error: ${blogProvider.error}'));
          } else if (blogProvider.blogs.isEmpty) {
            return const Center(child: Text('No blogs found'));
          }

          return ListView.builder(
            itemCount: blogProvider.blogs.length,
            itemBuilder: (context, index) {
              final blog = blogProvider.blogs[index];

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  leading: blog.imageUrl != null
                      ? Image.network(
                          "${Apis().baseurl}/${blog.imageUrl}",
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
