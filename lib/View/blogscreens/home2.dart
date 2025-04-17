import 'package:flutter/material.dart';

import 'package:inkbloom/ViewModel/blogprovider.dart';
import 'package:inkbloom/service/userprofile.dart';
import 'package:inkbloom/widgets/bloglistview.dart';
import 'package:inkbloom/widgets/bloglistviewhoriz.dart';
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

  @override
  void initState() {
    super.initState();
    fetchAndLoadUserData();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BlogProvider>(context, listen: false).fetchBlogs();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<BlogProvider>(context, listen: false);
      provider.fetchUserCategoryBlogs(); // 👈 THIS is what triggers it
    });
  }

  Future<void> fetchAndLoadUserData() async {
    await ProfileService().getUserProfile(); // Ensure profile is fetched
    await _loadUserData(); // Then load from SharedPreferences
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        name = prefs.getString('name') ?? "Guest";
        email = prefs.getString('email') ?? "No Email";
        avatar = prefs.getString('avatar') ?? "";
      });
    }
  }

  final categories = [
    "Recommended",
    "All",
    "Business",
    "Culture",
    "Education",
    "Health",
    "Lifestyle",
    "Society",
    "Sports",
    "Technology",
    "Work"
  ];
  String selectedCategory = "Recommended";

  @override
  Widget build(BuildContext context) {
    final blogProvider = context.watch<BlogProvider>();
    final blogsToShow = selectedCategory == "Recommended"
        ? blogProvider.userprefblogs
        : selectedCategory == "All"
            ? blogProvider.blogs
            : blogProvider.filteredblogs;

    return SafeArea(
      child: Scaffold(
        drawer: AppDrawer(),
        appBar: AppBar(
          backgroundColor: Colors.grey.withOpacity(.3),
          title: Text(
            'Explore',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => Welcomescreen(),
                  //     ));
                },
                icon: Icon(Icons.search))
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Trending',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    HorizontalBlogList(
                      blogs: context.watch<BlogProvider>().userprefblogs,
                      isLoading: context.watch<BlogProvider>().isLoading,
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: categories.map((category) {
                    final isSelected = category == selectedCategory;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: ChoiceChip(
                        label: Text(category),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              selectedCategory = category;
                            });

                            final blogProvider = Provider.of<BlogProvider>(
                                context,
                                listen: false);

                            if (category == "All") {
                              blogProvider.fetchBlogs();
                            } else if (category == "Recommended") {
                              blogProvider.fetchUserCategoryBlogs();
                            } else {
                              blogProvider.filterCategoryBlogs(category);
                            }
                          }
                        },
                        selectedColor: Colors.black87,
                        labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.black),
                        backgroundColor: Colors.grey[300],
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(
                height: 10,
              ),

              BlogListSection(
                blogs: blogsToShow,
                isLoading: blogProvider.isLoading,
              )

              // BlogListSection(
              //   blogs: context.watch<BlogProvider>().blogs,
              //   isLoading: context.watch<BlogProvider>().isLoading,
              // )
            ],
          ),
        ),
      ),
    );
  }
}
