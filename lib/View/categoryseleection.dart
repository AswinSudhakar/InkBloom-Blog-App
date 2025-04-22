import 'package:flutter/material.dart';
import 'package:inkbloom/ViewModel/blogprovider.dart';
import 'package:inkbloom/ViewModel/categoryprovider.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<CategoryProvider>(context, listen: false);
      provider.updateUserCategories(
          selectedcategories); // 👈 THIS is what triggers it
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'Select Your Favorite Categories',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.grey.withOpacity(.3),
        foregroundColor: Colors.black,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: categories.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 columns
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 2.5,
          ),
          itemBuilder: (context, index) {
            final category = categories[index];
            final isSelected = selectedcategories.contains(category);

            return GestureDetector(
              onTap: () => oncategoryTappped(category),
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: isSelected ? Colors.grey : Colors.grey.shade300,
                    width: 2,
                  ),
                ),
                color: isSelected ? Colors.grey.withOpacity(0.8) : Colors.white,
                child: Center(
                  child: Text(
                    category,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : Colors.black87,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Colors.grey.shade300,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 5,
          ),
          onPressed: () {
            Provider.of<CategoryProvider>(context, listen: false)
                .updateUserCategories(selectedcategories);
            print('Selected categories: $selectedcategories');
            Navigator.pop(context, selectedcategories);
          },
          child: Text(
            'Submit',
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
      ),
    );
  }
}
