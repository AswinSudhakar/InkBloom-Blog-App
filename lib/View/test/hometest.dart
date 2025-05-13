
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
