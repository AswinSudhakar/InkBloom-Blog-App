import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:inkbloom/View/blogscreens/recommentedblogs.dart';
import 'package:inkbloom/View/blogscreens/searchscreen.dart';
import 'package:inkbloom/widgets/shimmer.dart';
import 'package:lottie/lottie.dart';
import 'package:inkbloom/ViewModel/blogprovider.dart';
import 'package:inkbloom/ViewModel/themeprovider.dart';
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
  State<HomeScreen2> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen2> with RouteAware {
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
  void didPopNext() {
    fetchAndLoadUserData();
    Provider.of<BlogProvider>(context, listen: false).refreshblogs();
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
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   Provider.of<BlogProvider>(context, listen: false)
    //       .fetchUserCategoryBlogs();
    // });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<BlogProvider>(context, listen: false);
      provider.refreshblogs();
    });
  }

  Future<void> fetchAndLoadUserData() async {
    await ProfileService().getUserProfile();
    await _loadUserData();
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
  String selectedCategory = "All";

  @override
  Widget build(BuildContext context) {
    final userprefblog = BlogProvider().userprefblogs;
    final displayedblogs =
        userprefblog.length > 5 ? userprefblog.take(5).toList() : userprefblog;

    final themeprovider = Provider.of<ThemeProvider>(context);
    final blogProvider = context.watch<BlogProvider>();
    final blogsToShow = selectedCategory == "All"
        ? blogProvider.blogs
        : selectedCategory == "Search"
            ? blogProvider.searchedblogs
            : blogProvider.filteredblogs;

    return SafeArea(
      child: Scaffold(
        drawer: AppDrawer(),
        appBar: AppBar(
          elevation: 0,
          title: Text(
            'Explore',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              fontFamily: 'CrimsonText-Bold',
            ),
          ),
          actions: [
            InkWell(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Searchscreen(),
                    )),
                child: Icon(Icons.search)),
            // InkWell(
            //     onTap: () => Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //           builder: (context) => Searchscreen(),
            //         )),
            //     child: Icon(Icons.search)
            // AnimSearchBar(
            //   searchIconColor:
            //       themeprovider.isDarkMode ? Colors.white : Colors.black,
            //   textFieldColor: Colors.grey.shade200,
            //   boxShadow: false,
            //   color: themeprovider.isDarkMode ? Colors.black : Colors.white,
            //   width: 280,
            //   textController: _searchController,
            //   onSuffixTap: () {
            //     setState(() {
            //       _searchController.clear();
            //     });
            //   },
            //   onSubmitted: (query) {
            //     if (query.trim().isNotEmpty) {
            //       Provider.of<BlogProvider>(context, listen: false)
            //           .SearchBlogs(query);
            //       setState(() {
            //         selectedCategory = 'Search';
            //         _searchController.clear();
            //       });
            //     }
            //   },
            //   closeSearchOnSuffixTap: true,
            //   helpText: 'Search blogs...',
            //   animationDurationInMilli: 300,
            // ),
            // ),
            if (selectedCategory == 'Search')
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      selectedCategory = 'All';
                    });
                    _searchController.clear();
                    blogProvider.refreshblogs();
                  },
                  icon: Icon(Icons.clear),
                  label: Text('Clear'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.withOpacity(0.7),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            SizedBox(width: 10),
          ],
        ),
        body: blogProvider.isLoading
            ? Center(child: Shimmerloading(context)
                // Padding(
                //   padding: EdgeInsets.symmetric(vertical: 100),
                //   child:
                //   CircularProgressIndicator(),
                // ),
                )
            : RefreshIndicator(
                onRefresh: blogProvider.refreshblogs,
                child: ListView(
                  padding: const EdgeInsets.only(bottom: 20, top: 10),
                  children: [
                    if (blogProvider.userprefblogs.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 20,
                                ),
                                Chip(
                                  elevation: 3,
                                  shadowColor: Colors.grey.shade400,
                                  side: BorderSide.none,
                                  label: Text(
                                    'Recommended',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'CrimsonText-Bold',
                                    ),
                                  ),
                                  backgroundColor: Colors.grey.shade300,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            HorizontalBlogList(
                              blogs:
                                  context.watch<BlogProvider>().userprefblogs,
                              isLoading:
                                  context.watch<BlogProvider>().isLoading,
                            ),
                            SizedBox(height: 10),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: categories.map((category) {
                            final isSelected = category == selectedCategory;
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 6),
                              child: ChoiceChip(
                                label: Text(
                                  category,
                                  style:
                                      TextStyle(fontFamily: 'CrimsonText-Bold'),
                                ),
                                selected: isSelected,
                                side: BorderSide.none,
                                onSelected: (selected) {
                                  if (selected) {
                                    setState(() {
                                      selectedCategory = category;
                                    });
                                    final blogProvider =
                                        Provider.of<BlogProvider>(context,
                                            listen: false);
                                    if (category == "All" &&
                                        blogProvider.blogs.isEmpty) {
                                      blogProvider.fetchBlogs();
                                    } else if (category == "Recommended") {
                                      blogProvider.fetchUserCategoryBlogs();
                                    } else {
                                      blogProvider
                                          .filterCategoryBlogs(category);
                                    }
                                  }
                                },
                                selectedColor: Colors.black,
                                backgroundColor: Colors.grey.shade300,
                                elevation: 3,
                                shadowColor: Colors.grey.shade400,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                labelStyle: TextStyle(
                                  color:
                                      isSelected ? Colors.white : Colors.black,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    BlogListSection(
                      blogs: blogsToShow,
                      isLoading: blogProvider.isLoading,
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
