import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThreeCardsRow extends StatefulWidget {
  final String selectedCategory;
  final Function(String) onCategoryTap;
  final VoidCallback onReset;

  const ThreeCardsRow({
    required this.selectedCategory,
    required this.onCategoryTap,
    required this.onReset,
  });

  @override
  State<ThreeCardsRow> createState() => _ThreeCardsRowState();
}

class _ThreeCardsRowState extends State<ThreeCardsRow> {
  String _lastSelectedCategory = '';

  void _handleCardTap(String category) {
    if (_lastSelectedCategory == category) {
      widget.onReset();
      _lastSelectedCategory = '';
    } else {
      widget.onCategoryTap(category);
      _lastSelectedCategory = category;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            buildCard("Makanan", widget.selectedCategory == "Makanan",
                () => _handleCardTap("Makanan")),
            buildCard("Minuman", widget.selectedCategory == "Minuman",
                () => _handleCardTap("Minuman")),
            buildCard("Kue", widget.selectedCategory == "Kue",
                () => _handleCardTap("Kue")),
            buildCard("Dessert", widget.selectedCategory == "Dessert",
                () => _handleCardTap("Dessert")),
            buildCard("Snack", widget.selectedCategory == "Snack",
                () => _handleCardTap("Snack")),
            buildCard("Bread", widget.selectedCategory == "Bread",
                () => _handleCardTap("Bread")),
            buildCard("Tea", widget.selectedCategory == "Tea",
                () => _handleCardTap("Tea")),
            buildCard("Coffee", widget.selectedCategory == "Coffee",
                () => _handleCardTap("Coffee")),
            buildCard("Juice", widget.selectedCategory == "Juice",
                () => _handleCardTap("Juice")),
          ],
        ),
      ),
    );
  }

  Widget buildCard(String title, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50.0),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Color.fromARGB(255, 231, 213, 255),
                    blurRadius: 8.0,
                    offset: Offset(0, 0),
                  )
                ]
              : [],
        ),
        child: Card(
          color: isSelected
              ? Color.fromARGB(255, 245, 198, 245)
              : Color.fromARGB(255, 255, 255, 255),
          elevation: isSelected ? 0 : 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? LinearGradient(
                        colors: [
                          Color.fromARGB(255, 167, 161, 255), // Biru
                          Color.fromARGB(255, 255, 157, 230), // Ungu agak pink
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: Center(
                child: Text(
                  title,
                  style: GoogleFonts.roboto(
                    fontSize: 10.0,
                    color: isSelected
                        ? Color.fromARGB(255, 255, 255, 255)
                        : Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
