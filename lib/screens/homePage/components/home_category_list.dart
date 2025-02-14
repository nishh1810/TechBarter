import 'package:flutter/material.dart';

class CategoryList extends StatefulWidget {
  const CategoryList({super.key});

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {

  List<String> categories = [
    "Laptops",
    "Mobiles",
    "Tablets",
    "Webcams",
    "Gaming Consoles",
    "Cameras",
    "Headphones",
    "Smartwatches"
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.purpleAccent),
      ),
      child: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              categories[index],
              style: TextStyle(color: Colors.black),
            ),
            // trailing: Icon(Icons.arrow_forward_ios, size: 14),
            onTap: () {
              // Handle category click
            },
          );
        },
      ),
    );
  }
}
