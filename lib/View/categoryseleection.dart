import 'package:flutter/material.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Select Your Favorite Categories',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
      body: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final isSelected = selectedcategories.contains(category);

              return ListTile(
                title: Text(category),
                trailing: Checkbox(
                  value: isSelected,
                  onChanged: (bool? value) {
                    oncategoryTappped(category);
                  },
                ),
                onTap: () => oncategoryTappped(category),
              );
            },
          )),
      bottomNavigationBar: Padding(
          padding: EdgeInsets.all(20),
          child: ElevatedButton(
              onPressed: () {
                print('Selected categories: $selectedcategories');
                Navigator.pop(context, selectedcategories);
              },
              child: Text('Submit'))),
    );
  }
}
