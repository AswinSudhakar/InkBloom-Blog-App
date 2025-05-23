//second improved home
// import 'package:anim_search_bar/anim_search_bar.dart';
// import 'package:flutter/material.dart';
// import 'package:inkbloom/View/blogscreens/recommentedblogs.dart';

// import 'package:inkbloom/ViewModel/blogprovider.dart';
// import 'package:inkbloom/ViewModel/themeprovider.dart';
// import 'package:inkbloom/main.dart';
// import 'package:inkbloom/service/userprofile.dart';
// import 'package:inkbloom/widgets/bloglistview.dart';
// import 'package:inkbloom/widgets/bloglistviewhoriz.dart';
// import 'package:inkbloom/widgets/drawer.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:provider/provider.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> with RouteAware {
//   String? name;
//   String? email;
//   String? avatar;
//   final TextEditingController _searchController = TextEditingController();

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     routeObserver.subscribe(this, ModalRoute.of(context)!);
//   }

//   @override
//   void didPopNext() {
//     fetchAndLoadUserData();
//     Provider.of<BlogProvider>(context, listen: false).refreshblogs();
//   }

//   @override
//   void dispose() {
//     routeObserver.unsubscribe(this);
//     super.dispose();
//   }

//   @override
//   void initState() {
//     super.initState();
//     fetchAndLoadUserData();

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final provider = Provider.of<BlogProvider>(context, listen: false);
//       provider.refreshblogs();
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
//   String selectedCategory = "All";

//   @override
//   Widget build(BuildContext context) {
//     final themeprovider = Provider.of<ThemeProvider>(context);
//     final blogProvider = context.watch<BlogProvider>();
//     final blogsToShow = selectedCategory == "All"
//         ? blogProvider.blogs
//         : selectedCategory == "Search"
//             ? blogProvider.searchedblogs
//             : blogProvider.filteredblogs;

//     return SafeArea(
//       child: Scaffold(
//         drawer: AppDrawer(),
//         appBar: AppBar(
//           elevation: 0,
//           title: Text(
//             'Explore',
//             style: TextStyle(
//               fontSize: 28,
//               fontWeight: FontWeight.bold,
//               fontFamily: 'CrimsonText-Bold',
//             ),
//           ),
//           actions: [
//             AnimSearchBar(
//               searchIconColor:
//                   themeprovider.isDarkMode ? Colors.white : Colors.black,
//               textFieldColor: Colors.grey.shade200,
//               boxShadow: false,
//               color: themeprovider.isDarkMode ? Colors.black : Colors.white,
//               width: 280,
//               textController: _searchController,
//               onSuffixTap: () {
//                 setState(() {
//                   _searchController.clear();
//                 });
//               },
//               onSubmitted: (query) {
//                 if (query.trim().isNotEmpty) {
//                   Provider.of<BlogProvider>(context, listen: false)
//                       .SearchBlogs(query);
//                   setState(() {
//                     selectedCategory = 'Search';
//                     _searchController.clear();
//                   });
//                 }
//               },
//               closeSearchOnSuffixTap: true,
//               helpText: 'Search blogs...',
//               animationDurationInMilli: 300,
//             ),
//             if (selectedCategory == 'Search')
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 8),
//                 child: ElevatedButton.icon(
//                   onPressed: () {
//                     setState(() {
//                       selectedCategory = 'All';
//                     });
//                     _searchController.clear();
//                     blogProvider.refreshblogs();
//                   },
//                   icon: Icon(Icons.clear),
//                   label: Text('Clear'),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.redAccent.withOpacity(0.7),
//                     foregroundColor: Colors.white,
//                     padding: const EdgeInsets.symmetric(horizontal: 12),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                 ),
//               ),
//             SizedBox(width: 10),
//           ],
//         ),
//         body: blogProvider.isLoading
//             ? const Center(
//                 child: Padding(
//                   padding: EdgeInsets.symmetric(vertical: 100),
//                   child: CircularProgressIndicator(),
//                 ),
//               )
//             : RefreshIndicator(
//                 onRefresh: blogProvider.refreshblogs,
//                 child: ListView(
//                   padding: const EdgeInsets.only(bottom: 20, top: 10),
//                   children: [
//                     if (blogProvider.userprefblogs.isNotEmpty)
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 12),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Chip(
//                               label: Text(
//                                 'Recommended',
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.w600,
//                                   fontFamily: 'CrimsonText-Bold',
//                                 ),
//                               ),
//                               backgroundColor: Colors.orange.shade100,
//                             ),
//                             TextButton(
//                               onPressed: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) => RecommentedBlogs()),
//                                 );
//                               },
//                               child: Text(
//                                 'View All →',
//                                 style: TextStyle(
//                                   fontFamily: 'CrimsonText-Bold',
//                                   fontSize: 14,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     SizedBox(height: 10),
//                     HorizontalBlogList(
//                       blogs: context.watch<BlogProvider>().userprefblogs,
//                       isLoading: context.watch<BlogProvider>().isLoading,
//                     ),
//                     SizedBox(height: 20),
//                     Padding(
//                       padding: const EdgeInsets.only(left: 10),
//                       child: SingleChildScrollView(
//                         scrollDirection: Axis.horizontal,
//                         child: Row(
//                           children: categories.map((category) {
//                             final isSelected = category == selectedCategory;
//                             return Padding(
//                               padding:
//                                   const EdgeInsets.symmetric(horizontal: 6),
//                               child: ChoiceChip(
//                                 label: Text(
//                                   category,
//                                   style:
//                                       TextStyle(fontFamily: 'CrimsonText-Bold'),
//                                 ),
//                                 selected: isSelected,
//                                 onSelected: (selected) {
//                                   if (selected) {
//                                     setState(() {
//                                       selectedCategory = category;
//                                     });
//                                     final blogProvider =
//                                         Provider.of<BlogProvider>(context,
//                                             listen: false);
//                                     if (category == "All" &&
//                                         blogProvider.blogs.isEmpty) {
//                                       blogProvider.fetchBlogs();
//                                     } else if (category == "Recommended") {
//                                       blogProvider.fetchUserCategoryBlogs();
//                                     } else {
//                                       blogProvider
//                                           .filterCategoryBlogs(category);
//                                     }
//                                   }
//                                 },
//                                 selectedColor: Colors.black,
//                                 backgroundColor: Colors.grey.shade300,
//                                 elevation: 3,
//                                 shadowColor: Colors.grey.shade400,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                 ),
//                                 labelStyle: TextStyle(
//                                   color:
//                                       isSelected ? Colors.white : Colors.black,
//                                 ),
//                               ),
//                             );
//                           }).toList(),
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 10),
//                     BlogListSection(
//                       blogs: blogsToShow,
//                       isLoading: blogProvider.isLoading,
//                     ),
//                   ],
//                 ),
//               ),
//       ),
//     );
//   }
// }





//first homescreen

// import 'package:anim_search_bar/anim_search_bar.dart';
// import 'package:flutter/material.dart';
// import 'package:inkbloom/View/blogscreens/recommentedblogs.dart';

// import 'package:inkbloom/ViewModel/blogprovider.dart';
// import 'package:inkbloom/ViewModel/themeprovider.dart';
// import 'package:inkbloom/main.dart';
// import 'package:inkbloom/service/userprofile.dart';
// import 'package:inkbloom/widgets/bloglistview.dart';
// import 'package:inkbloom/widgets/bloglistviewhoriz.dart';
// import 'package:inkbloom/widgets/drawer.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:provider/provider.dart';

// class HomeScreen2 extends StatefulWidget {
//   const HomeScreen2({super.key});

//   @override
//   State<HomeScreen2> createState() => _HomeScreen2State();
// }

// class _HomeScreen2State extends State<HomeScreen2> with RouteAware {
//   String? name;
//   String? email;
//   String? avatar;
//   final TextEditingController _searchController = TextEditingController();

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     routeObserver.subscribe(this, ModalRoute.of(context)!);
//   }

//   @override
//   void didPopNext() {
//     // Called when coming back to this screen
//     fetchAndLoadUserData();
//     Provider.of<BlogProvider>(context, listen: false).refreshblogs();
//   }

//   @override
//   void dispose() {
//     routeObserver.unsubscribe(this);
//     super.dispose();
//   }

//   @override
//   void initState() {
//     super.initState();
//     fetchAndLoadUserData();

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final provider = Provider.of<BlogProvider>(context, listen: false);
//       // provider.fetchBlogs();
//       // provider.fetchUserCategoryBlogs();
//       provider.refreshblogs();
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
//     // "Recommended",
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
//   String selectedCategory = "All";

//   @override
//   Widget build(BuildContext context) {
//     final themeprovider = Provider.of<ThemeProvider>(context);
//     final blogProvider = context.watch<BlogProvider>();
//     final blogsToShow = selectedCategory == "All"
//         ? blogProvider.blogs
//         : selectedCategory == "Search"
//             ? blogProvider.searchedblogs
//             : blogProvider.filteredblogs;

//     return SafeArea(
//       child: Scaffold(
//         drawer: AppDrawer(),
//         appBar: AppBar(
//           // backgroundColor: Colors.white,
//           title: Text(
//             'Explore',
//             style: TextStyle(
//                 fontSize: 30,
//                 fontWeight: FontWeight.w600,
//                 fontFamily: 'CrimsonText-Bold'),
//           ),
//           actions: [
//             AnimSearchBar(
              
//               searchIconColor:
//                   themeprovider.isDarkMode ? Colors.white : Colors.black,
//               textFieldColor: Colors.grey.shade300,
//               boxShadow: false,
//               color: themeprovider.isDarkMode ? Colors.black : Colors.white,
//               width: 300,
//               textController: _searchController,
//               onSuffixTap: () {
//                 setState(() {
//                   _searchController.clear();
//                 });
//               },
//               onSubmitted: (query) {
//                 if (query.trim().isNotEmpty) {
//                   Provider.of<BlogProvider>(context, listen: false)
//                       .SearchBlogs(query);
//                   setState(() {
//                     selectedCategory = 'Search';
//                     _searchController.clear();
//                   });
//                 }
//               },
//               closeSearchOnSuffixTap: true,
//               helpText: 'Search...',
//               animationDurationInMilli: 400
//             )

//             // Container(
//             //   width: 180,
//             //   height: 36,
//             //   decoration: BoxDecoration(
//             //     color: Colors.grey.shade50,
//             //     borderRadius: BorderRadius.circular(12),
//             //     border: Border.all(color: Colors.grey.shade300),
//             //   ),
//             //   child: TextField(
//             //     controller: _searchController,
//             //     style: const TextStyle(fontSize: 17),
//             //     decoration: InputDecoration(
//             //       hintText: 'Search blogs...',
//             //       hintStyle: TextStyle(
//             //           color: Colors.black, fontFamily: 'CrimsonText-Bold'),
//             //       prefixIcon:
//             //           const Icon(Icons.search, size: 20, color: Colors.grey),
//             //       border: InputBorder.none,
//             //     ),
//             //     onSubmitted: (query) {
//             //       if (query.trim().isNotEmpty) {
//             //         Provider.of<BlogProvider>(context, listen: false)
//             //             .SearchBlogs(query);
//             //         setState(() {
//             //           selectedCategory = 'Search';
//             //           _searchController.clear();
//             //         });
//             //       }
//             //     },
//             //     onChanged: (query) {
//             //       if (query.length >= 3) {
//             //         Provider.of<BlogProvider>(context, listen: false)
//             //             .SearchBlogs(query);
//             //         setState(() => selectedCategory = 'Search');
//             //       }
//             //     },
//             //   ),
//             // ),
//             // SizedBox(
//             //   width: 20,
//             // )
//             ,
//             if (selectedCategory == 'Search')
//               SizedBox(
//                 height: 50,
//                 width: 150,
//                 child: Padding(
//                   padding: const EdgeInsets.only(left: 10, top: 10),
//                   child: ElevatedButton.icon(
//                     onPressed: () {
//                       setState(() {
//                         selectedCategory = 'All';
//                       });
//                       _searchController.clear();
//                       blogProvider.refreshblogs();
//                     },
//                     icon: Icon(Icons.clear),
//                     label: Text('Clear Search'),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.grey.withOpacity(.3),
//                       foregroundColor: Colors.white,
//                       padding:
//                           EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             SizedBox(
//               width: 5,
//             )
//           ],
//         ),
//         body: blogProvider.isLoading
//             ? const Center(
//                 child: Padding(
//                   padding: EdgeInsets.symmetric(vertical: 100),
//                   child: CircularProgressIndicator(),
//                 ),
//               )
//             : RefreshIndicator(
//                 onRefresh: blogProvider.refreshblogs,
//                 child: ListView(
//                   padding: const EdgeInsets.only(bottom: 20),
//                   children: [
//                     if (blogProvider.userprefblogs.isNotEmpty)
//                       Column(
//                         children: [
//                           SizedBox(
//                             height: 20,
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Row(
//                                 children: [
//                                   SizedBox(
//                                     width: 10,
//                                   ),
//                                   Container(
//                                     padding: const EdgeInsets.symmetric(
//                                         horizontal: 10, vertical: 8),
//                                     decoration: BoxDecoration(
//                                       color: Colors.grey
//                                           .shade200, // Optional: match your theme
//                                       borderRadius: BorderRadius.circular(12),
//                                       border: Border.all(
//                                         color: Colors.grey
//                                             .withOpacity(.4), // Black border
//                                         width: 1.2,
//                                       ),

//                                       boxShadow: [
//                                         BoxShadow(
//                                           color: Colors.grey.withOpacity(0.3),
//                                           blurRadius: 8,
//                                           offset: const Offset(
//                                               0, 3), // Shadow position
//                                         ),
//                                       ],
//                                     ),
//                                     child: const Text(
//                                       'Recommended',
//                                       style: TextStyle(
//                                           fontSize: 15,
//                                           fontWeight: FontWeight.w500,
//                                           color: Colors.black,
//                                           fontFamily: 'CrimsonText-Bold'),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               SizedBox(
//                                 width: 20,
//                               ),
//                               TextButton(
//                                   onPressed: () {
//                                     Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (context) =>
//                                               RecommentedBlogs(),
//                                         ));
//                                   },
//                                   child: Text(
//                                     'View All->',
//                                     style: TextStyle(
//                                         fontSize: 14,
//                                         color: themeprovider.isDarkMode
//                                             ? Colors.white
//                                             : Colors.black,
//                                         fontFamily: 'CrimsonText-Bold'),
//                                   ))
//                             ],
//                           ),
//                         ],
//                       ),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     SingleChildScrollView(
//                       scrollDirection: Axis.horizontal,
//                       child: Row(
//                         children: [
//                           SizedBox(
//                             width: 10,
//                           ),
//                           HorizontalBlogList(
//                             blogs: context.watch<BlogProvider>().userprefblogs,
//                             isLoading: context.watch<BlogProvider>().isLoading,
//                           )
//                         ],
//                       ),
//                     ),
//                     SizedBox(
//                       height: 30,
//                     ),

//                     SingleChildScrollView(
//                       scrollDirection: Axis.horizontal,
//                       child: Row(
//                         children: categories.map((category) {
//                           final isSelected = category == selectedCategory;
//                           return Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 6),
//                             child: ChoiceChip(
//                               label: Text(
//                                 category,
//                                 style: TextStyle(
//                                     fontFamily: 'CrimsonText-Bold',
//                                     fontSize: 15),
//                               ),
//                               selected: isSelected,
//                               onSelected: (selected) {
//                                 if (selected) {
//                                   setState(() {
//                                     selectedCategory = category;
//                                   });

//                                   final blogProvider =
//                                       Provider.of<BlogProvider>(context,
//                                           listen: false);

//                                   if (category == "All" &&
//                                       blogProvider.blogs.isEmpty) {
//                                     blogProvider.fetchBlogs();
//                                   } else if (category == "Recommended") {
//                                     blogProvider.fetchUserCategoryBlogs();
//                                   } else {
//                                     blogProvider.filterCategoryBlogs(category);
//                                   }
//                                 }
//                               },
//                               selectedColor: Colors.black,
//                               elevation: 4,
//                               shadowColor: Colors.black12,
//                               shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(12)),
//                               labelStyle: TextStyle(
//                                   color:
//                                       isSelected ? Colors.white : Colors.black),
//                               backgroundColor: Colors.grey[300],
//                             ),
//                           );
//                         }).toList(),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 10,
//                     ),

//                     BlogListSection(
//                       blogs: blogsToShow,
//                       isLoading: blogProvider.isLoading,
//                     )

//                     // BlogListSection(
//                     //   blogs: context.watch<BlogProvider>().blogs,
//                     //   isLoading: context.watch<BlogProvider>().isLoading,
//                     // )
//                   ],
//                 ),
//               ),
//       ),
//     );
//   }
// }
