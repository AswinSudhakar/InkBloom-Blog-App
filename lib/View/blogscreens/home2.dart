import 'package:flutter/material.dart';
import 'package:inkbloom/View/test/welcomescreen.dart';
import 'package:inkbloom/ViewModel/blogprovider.dart';
import 'package:inkbloom/View/blogscreens/blogdetail.dart';

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
    final blogProvider = Provider.of<BlogProvider>(context);

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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Welcomescreen(),
                      ));
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
                        onSelected: (selected) {},
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
                height: 30,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    HorizontalBlogList(
                      blogs: context.watch<BlogProvider>().blogs,
                      isLoading: context.watch<BlogProvider>().isLoading,
                    )
                    // SizedBox(
                    //   width: 20,
                    // ),
                    // Container(
                    //   height: 180,
                    //   width: 230,
                    //   decoration: BoxDecoration(
                    //       color: Colors.grey,
                    //       borderRadius: BorderRadius.circular(20)),
                    // ),
                    // SizedBox(
                    //   width: 20,
                    // ),
                    // Container(
                    //   height: 180,
                    //   width: 230,
                    //   decoration: BoxDecoration(
                    //       color: Colors.grey,
                    //       borderRadius: BorderRadius.circular(20)),
                    // ),
                    // SizedBox(
                    //   width: 20,
                    // ),
                    // Container(
                    //   height: 180,
                    //   width: 230,
                    //   decoration: BoxDecoration(
                    //       color: Colors.grey,
                    //       borderRadius: BorderRadius.circular(20)),
                    // ),
                    // SizedBox(
                    //   width: 20,
                    // ),
                    // Container(
                    //   height: 180,
                    //   width: 230,
                    //   decoration: BoxDecoration(
                    //       color: Colors.grey,
                    //       borderRadius: BorderRadius.circular(20)),
                    // ),
                    // SizedBox(
                    //   width: 20,
                    // ),
                    // Container(
                    //   height: 180,
                    //   width: 230,
                    //   decoration: BoxDecoration(
                    //       color: Colors.grey,
                    //       borderRadius: BorderRadius.circular(20)),
                    // ),
                    // SizedBox(
                    //   width: 20,
                    // ),
                  ],
                ),
              ),
              // SizedBox(
              //   height: 30,
              // ),
              // Consumer<BlogProvider>(
              //   builder: (context, blogProvider, child) {
              //     if (blogProvider.isLoading) {
              //       return const Center(child: CircularProgressIndicator());
              //     } else if (blogProvider.blogs.isEmpty) {
              //       return const Center(child: Text('No blogs found'));
              //     }

              //     return ListView.builder(
              //       shrinkWrap:
              //           true, // ✅ Let it size itself inside the scroll view
              //       physics:
              //           NeverScrollableScrollPhysics(), // ✅ Prevent nested scroll conflicts
              //       itemCount: blogProvider.blogs.length,
              //       itemBuilder: (context, index) {
              //         final blog = blogProvider.blogs[index];

              //         return InkWell(
              //           onTap: () => Navigator.push(
              //               context,
              //               MaterialPageRoute(
              //                 builder: (context) => BlogDetail(blog: blog),
              //               )),
              //           child: Card(
              //             margin: const EdgeInsets.symmetric(
              //                 horizontal: 12, vertical: 8),
              //             elevation: 4,
              //             shape: RoundedRectangleBorder(
              //                 borderRadius: BorderRadius.circular(12)),
              //             child: Container(
              //               height: 180, // Slightly taller card
              //               padding: const EdgeInsets.all(15),
              //               child: Row(
              //                 children: [
              //                   // Blog Image
              //                   ClipRRect(
              //                     borderRadius: BorderRadius.circular(10),
              //                     child: Image.network(
              //                       blog.imageUrl ??
              //                           'https://as1.ftcdn.net/v2/jpg/05/03/24/40/1000_F_503244059_fRjgerSXBfOYZqTpei4oqyEpQrhbpOML.jpg',
              //                       height: double.infinity,
              //                       width: 110,
              //                       fit: BoxFit.cover,
              //                     ),
              //                   ),
              //                   SizedBox(width: 12),
              //                   // Blog Details
              //                   Expanded(
              //                     child: Column(
              //                       crossAxisAlignment:
              //                           CrossAxisAlignment.start,
              //                       mainAxisAlignment:
              //                           MainAxisAlignment.spaceBetween,
              //                       children: [
              //                         Text(
              //                           blog.title ?? 'No Title',
              //                           style: TextStyle(
              //                             fontSize: 26,
              //                             fontWeight: FontWeight.w600,
              //                           ),
              //                           maxLines: 1,
              //                           overflow: TextOverflow.ellipsis,
              //                         ),
              //                         SizedBox(height: 5),
              //                         Text(
              //                           blog.content ?? '',
              //                           maxLines:
              //                               4, // ✅ Show 3–4 lines of preview content
              //                           overflow: TextOverflow.ellipsis,
              //                           style: TextStyle(
              //                               fontSize: 13,
              //                               color: Colors.grey[700]),
              //                         ),
              //                         SizedBox(height: 5),
              //                         Row(
              //                           mainAxisAlignment:
              //                               MainAxisAlignment.spaceBetween,
              //                           children: [
              //                             Text(
              //                               'Readtime :${blog.readTime}' ??
              //                                   'Read time',
              //                               style: TextStyle(
              //                                   fontSize: 15,
              //                                   color: Colors.grey[600]),
              //                             ),
              //                           ],
              //                         ),
              //                       ],
              //                     ),
              //                   ),
              //                 ],
              //               ),
              //             ),
              //           ),
              //         );
              //       },
              //     );
              //   },
              // ),
              // BlogListSection(
              //   blogs: context.read<BlogProvider>().filteredblogs,
              //   isLoading: context.watch<BlogProvider>().isLoading,
              // )
              // If you just want user category blogs directly
              BlogListSection(
                blogs: context.watch<BlogProvider>().filteredblogs,
                isLoading: context.watch<BlogProvider>().isLoading,
              )
            ],
          ),
        ),
      ),
    );
  }
}







// ListTile(
//                           // leading: blog.imageUrl != null
//                           //     ? Image.network(
//                           //         "${Apis().baseurl}/${blog.imageUrl}",
//                           //         width: 50,
//                           //         height: 50,
//                           //         fit: BoxFit.cover,
//                           //       )
//                           //     : const Icon(Icons.image_not_supported),
//                           title: Text(blog.title ?? "No Title"),
//                           subtitle: Text(blog.category ?? "No read time"),
//                           trailing: Text(blog.readTime ?? "no email"),
//                           onTap: () {
//                             Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => BlogDetail(
//                                     blog: blog,
//                                   ),
//                                 ));
//                           },
//                         ),