import 'package:flutter/material.dart';
import 'package:wordsview/View/blogscreens/mainhome.dart';
import 'package:wordsview/ViewModel/blogprovider.dart';
import 'package:wordsview/ViewModel/categoryprovider.dart';
import 'package:provider/provider.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  BlogProvider blogProvider = BlogProvider();

  List<String> categories = [
    'Business',
    'Culture',
    'Education',
    'Health',
    'Lifestyle',
    'Society',
    'Sports',
    'Technology',
    'Work',
  ];

  final List<String> selectedcategories = [];

  void oncategoryTappped(String category) {
    setState(() {
      if (selectedcategories.contains(category)) {
        selectedcategories.remove(category);
      } else {
        selectedcategories.add(category);
      }
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = Provider.of<CategoryProvider>(context, listen: false);
      await provider.fetchusercategory();

      setState(() {
        selectedcategories.addAll(provider.usercategory);
      });
    });

    super.initState();
  }

  void clearAllCategories() {
    setState(() {
      selectedcategories.clear();
      Provider.of<CategoryProvider>(context, listen: false)
          .updateUserCategories(selectedcategories);
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).colorScheme.onPrimary,
            )),
        title: Text(
          'Select Your Favorite Categories',
          style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontWeight: FontWeight.w600,
              fontFamily: 'CrimsonText-SemiBoldItalic'),
        ),
        backgroundColor: Colors.grey.withOpacity(.3),
        foregroundColor: Colors.black,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: categories.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 2.5,
                      ),
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        final isSelected =
                            selectedcategories.contains(category);

                        return GestureDetector(
                          onTap: () => oncategoryTappped(category),
                          child: Card(
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(
                                color: isSelected
                                    ? Colors.grey
                                    : Colors.grey.shade300,
                                width: 2,
                              ),
                            ),
                            color: isSelected
                                ? Colors.grey.withOpacity(0.8)
                                : Colors.white,
                            child: Center(
                              child: Text(
                                category,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'CrimsonText-SemiBoldItalic',
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.black87,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: clearAllCategories,
                      child: const Text(
                        'Clear All Categories',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.red,
                          fontFamily: 'CrimsonText-SemiBoldItalic',
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Theme.of(context).colorScheme.error,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontFamily: 'CrimsonText-SemiBoldItalic',
                  ),
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: selectedcategories.isEmpty
                    ? null
                    : () {
                        Provider.of<CategoryProvider>(context, listen: false)
                            .updateUserCategories(selectedcategories);
                        debugPrint('Selected categories: $selectedcategories');

                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => Mainhome()),
                          (route) => false,
                        );
                      },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.grey.shade300,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Submit',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontFamily: 'CrimsonText-SemiBoldItalic',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
