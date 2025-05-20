import 'package:flutter/material.dart';
import 'package:inkbloom/View/blogscreens/home2.dart';
import 'package:inkbloom/View/blogscreens/mainhome.dart';
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
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'Select Your Favorite Categories',
          style: TextStyle(
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
            // // Clear All Button
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   children: [
            //     ElevatedButton(
            //       onPressed: () {
            //         clearAllCategories();
            //       },
            //       style: ElevatedButton.styleFrom(
            //         padding: EdgeInsets.symmetric(vertical: 16),
            //         backgroundColor: const Color.fromARGB(255, 212, 107, 107),
            //         shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(10),
            //         ),
            //       ),
            //       child: Text(
            //         'Clear All',
            //         style: TextStyle(
            //           fontSize: 18,
            //           color: Colors.white,
            //           fontFamily: 'CrimsonText-SemiBoldItalic',
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            SizedBox(
              height: 20,
            ),
            Expanded(
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
                          color:
                              isSelected ? Colors.grey : Colors.grey.shade300,
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
          ],
        ),
      ),
      // bottomNavigationBar: Container(
      //   padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      //   child: ElevatedButton(
      //     style: ElevatedButton.styleFrom(
      //       padding: EdgeInsets.symmetric(vertical: 16),
      //       backgroundColor: Colors.grey.shade300,
      //       shape: RoundedRectangleBorder(
      //         borderRadius: BorderRadius.circular(30),
      //       ),
      //       elevation: 5,
      //     ),
      //     onPressed: () {
      //       Provider.of<CategoryProvider>(context, listen: false)
      //           .updateUserCategories(selectedcategories);
      //       print('Selected categories: $selectedcategories');
      //       Navigator.push(
      //           context,
      //           MaterialPageRoute(
      //             builder: (context) => HomeScreen2(),
      //           ));
      //     },
      //     child: Text(
      //       'Submit',
      //       style: TextStyle(
      //           fontSize: 18,
      //           color: Colors.black,
      //           fontFamily: 'CrimsonText-SemiBoldItalic'),
      //     ),
      //   ),
      // ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // 👈 Cancels and goes back
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: const Color.fromARGB(255, 153, 224, 226),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
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
