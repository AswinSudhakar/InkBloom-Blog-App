import 'package:flutter/material.dart';

import 'package:inkbloom/ViewModel/blogprovider.dart';
import 'package:inkbloom/main.dart';
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

class _HomeScreen2State extends State<HomeScreen2> with RouteAware {
  String? name;
  String? email;
  String? avatar;
  final TextEditingController _searchController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

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
            : selectedCategory == "Search"
                ? blogProvider.searchedblogs
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
            Container(
              width: 180,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Search blogs...',
                  hintStyle: TextStyle(color: Colors.black),
                  prefixIcon:
                      const Icon(Icons.search, size: 20, color: Colors.grey),
                  border: InputBorder.none,
                ),
                onSubmitted: (query) {
                  if (query.trim().isNotEmpty) {
                    Provider.of<BlogProvider>(context, listen: false)
                        .SearchBlogs(query);
                    setState(() {
                      selectedCategory = 'Search';
                      _searchController.clear();
                    });
                  }
                },
                // onChanged: (query) {
                //   if (query.length >= 3) {
                //     Provider.of<BlogProvider>(context, listen: false)
                //         .SearchBlogs(query);
                //     setState(() => selectedCategory = 'Search');
                //   }
                // },
              ),
            ),
            SizedBox(
              width: 20,
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),

              /// 🔍 Search

              Row(
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200, // Optional: match your theme
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.grey.withOpacity(.4), // Black border
                        width: 1.2,
                      ),

                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 3), // Shadow position
                        ),
                      ],
                    ),
                    child: const Text(
                      'Trending',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ),
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
                        selectedColor: Colors.black,
                        elevation: 4,
                        shadowColor: Colors.black12,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
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

// import 'package:flutter/material.dart';
// import 'package:inkbloom/ViewModel/blogprovider.dart';
// import 'package:inkbloom/models/blog/blogmodel.dart';
// import 'package:inkbloom/service/userprofile.dart';
// import 'package:inkbloom/widgets/bloglistview.dart';
// import 'package:inkbloom/widgets/drawer.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class HomeScreen2 extends StatefulWidget {
//   const HomeScreen2({super.key});

//   @override
//   State<HomeScreen2> createState() => _HomeScreen2State();
// }

// class _HomeScreen2State extends State<HomeScreen2> {
//   String? name;
//   String? email;
//   String? avatar;

//   @override
//   void initState() {
//     super.initState();
//     fetchAndLoadUserData();

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Provider.of<BlogProvider>(context, listen: false).fetchBlogs();
//       Provider.of<BlogProvider>(context, listen: false)
//           .fetchUserCategoryBlogs();
//     });
//   }

//   Future<void> fetchAndLoadUserData() async {
//     await ProfileService().getUserProfile();
//     await _loadUserData();
//   }

//   Future<void> _loadUserData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     if (mounted) {
//       setState(() {
//         name = prefs.getString('name') ?? "Guest";
//         email = prefs.getString('email') ?? "No Email";
//         avatar = prefs.getString('avatar') ?? "";
//       });
//     }
//   }

//   final categories = [
//     "Recommended",
//     "All",
//     "Business",
//     "Culture",
//     "Education",
//     "Health",
//     "Lifestyle",
//     "Society",
//     "Sports",
//     "Technology",
//     "Work"
//   ];
//   String selectedCategory = "Recommended";

//   @override
//   Widget build(BuildContext context) {
//     final blogProvider = context.watch<BlogProvider>();
//     final blogsToShow = selectedCategory == "Recommended"
//         ? blogProvider.userprefblogs
//         : selectedCategory == "All"
//             ? blogProvider.blogs
//             : blogProvider.filteredblogs;

//     return SafeArea(
//       child: Scaffold(
//         extendBodyBehindAppBar: true,
//         drawer: AppDrawer(),
//         appBar: AppBar(
//           backgroundColor: Colors.transparent,
//           elevation: 0,
//           iconTheme: const IconThemeData(color: Colors.black),
//           actions: [
//             IconButton(
//               icon: const Icon(Icons.search, color: Colors.black),
//               onPressed: () {},
//             )
//           ],
//         ),
//         body: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Color(0xFFF9F9F9), Color(0xFFECECEC)],
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//             ),
//           ),
//           child: SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.fromLTRB(16, 60, 16, 16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   /// 👋 Greeting
//                   Row(
//                     children: [
//                       CircleAvatar(
//                         radius: 24,
//                         backgroundImage: avatar != null && avatar!.isNotEmpty
//                             ? NetworkImage(avatar!)
//                             : const AssetImage("assets/default_avatar.png")
//                                 as ImageProvider,
//                       ),
//                       const SizedBox(width: 12),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "Hi, ${name ?? 'Guest'} 👋",
//                             style: const TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                           const Text(
//                             "Explore fresh blogs just for you",
//                             style: TextStyle(
//                               fontSize: 14,
//                               color: Colors.black54,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 24),

//                   /// ✨ Section Title
//                   const Text(
//                     "Categories",
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),

//                   const SizedBox(height: 16),

//                   /// 🔖 Category Chips
//                   SingleChildScrollView(
//                     scrollDirection: Axis.horizontal,
//                     child: Row(
//                       children: categories.map((category) {
//                         final isSelected = category == selectedCategory;
//                         return Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 6),
//                           child: ChoiceChip(
//                             label: Text(
//                               category,
//                               style: TextStyle(
//                                 color:
//                                     isSelected ? Colors.white : Colors.black87,
//                                 fontWeight: FontWeight.w600,
//                                 letterSpacing: 0.5,
//                               ),
//                             ),
//                             selected: isSelected,
//                             onSelected: (selected) {
//                               if (selected) {
//                                 setState(() => selectedCategory = category);
//                                 final blogProvider = Provider.of<BlogProvider>(
//                                     context,
//                                     listen: false);

//                                 if (category == "All") {
//                                   blogProvider.fetchBlogs();
//                                 } else if (category == "Recommended") {
//                                   blogProvider.fetchUserCategoryBlogs();
//                                 } else {
//                                   blogProvider.filterCategoryBlogs(category);
//                                 }
//                               }
//                             },
//                             selectedColor: Colors.black,
//                             backgroundColor: Colors.grey[300],
//                             elevation: 4,
//                             shadowColor: Colors.black12,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                           ),
//                         );
//                       }).toList(),
//                     ),
//                   ),

//                   const SizedBox(height: 24),

//                   /// 📚 Blog List
//                   AnimatedOpacity(
//                     opacity: blogProvider.isLoading ? 0.5 : 1.0,
//                     duration: const Duration(milliseconds: 500),
//                     child: BlogListSection(
//                       blogs: blogsToShow,
//                       isLoading: blogProvider.isLoading,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
