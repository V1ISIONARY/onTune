import 'package:flutter/material.dart';

import '../../../resources/schema.dart';

class CategorySelector extends StatefulWidget {
  const CategorySelector({Key? key}) : super(key: key);

  @override
  _CategorySelectorState createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  // Track the selected category, default is 'All'
  String _selectedCategory = 'All';  // Set the default selected category

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 30,  // Adjusted height for better visibility
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(  // Changed to Row to display items horizontally
          children: [
            const SizedBox(width: 20),
            _buildCategoryItem('All'),
            _buildCategoryItem('Music'),
            _buildCategoryItem('Pod Cast'),
            _buildCategoryItem('Radio'),
            _buildCategoryItem('Local'),
            const SizedBox(width: 10)
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(String label) {

    bool isSelected = _selectedCategory == label; // Check if this category is selected
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = label; // Update the selected category
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 10), // Added margin between items
        padding: const EdgeInsets.symmetric(horizontal: 20), // Added padding to make it wider
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : primary_color, // Highlight selected category
          borderRadius: BorderRadius.circular(50), // Oval shape
        ),
        height: 30, // Specify height directly here
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.white70, // Change text color for selected
              fontSize: 11, // Font size for better readability
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
