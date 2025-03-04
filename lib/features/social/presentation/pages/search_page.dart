import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:where_is_my_bus/core/constants/constants.dart';
import 'package:where_is_my_bus/core/theme/colors.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: OGS_THEME.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Animation for the Search Bar
              Hero(
                tag: SEARCHPAGETAG,
                child: Material(
                  color:
                      Colors.transparent, // Prevents "No Material widget" error
                  child: Container(
                    margin: EdgeInsets.all(10),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    height: 50,
                    width: screenWidth,
                    decoration: BoxDecoration(
                      color: OGS_THEME.offWhite,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: TextField(
                      autofocus: true,
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                      scrollPadding: const EdgeInsets.all(10),
                      decoration: InputDecoration(
                        hintText: 'Explore Events and more...',
                        hintStyle: GoogleFonts.roboto(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey,
                        ),
                        suffixIcon: const Icon(Icons.search),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 10),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // First Row of Search Cards
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  searchCard(screenHeight, screenWidth,
                      "assets/images/search_page_image_1.jpeg"),
                  searchCard(screenHeight, screenWidth,
                      "assets/images/search_page_image_2.jpeg"),
                ],
              ),

              // Second Row of Search Cards
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  searchCard(screenHeight, screenWidth,
                      "assets/images/search_page_image_3.jpeg"),
                  searchCard(screenHeight, screenWidth,
                      "assets/images/search_page_image_4.jpeg"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget for Individual Search Cards
Widget searchCard(double height, double width, String asset) {
  return Container(
    padding: const EdgeInsets.all(5),
    margin: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: OGS_THEME.offWhite,
      borderRadius: BorderRadius.circular(10),
    ),
    height: height / 8,
    width: width / 2.3,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Stack(
        fit: StackFit.expand, // Ensures the image covers the container fully
        children: [
          Image.asset(
            asset,
            fit: BoxFit.cover, // Makes the image fill the container
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.symmetric(
                  vertical: 5, horizontal: 10), // Padding for text
              decoration: BoxDecoration(
                color: Colors.black
                    .withOpacity(0.5), // Semi-transparent background for text
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)),
              ),
              child: Text(
                "NIT Campus",
                style: GoogleFonts.outfit(color: OGS_THEME.white, fontSize: 14),
              ),
            ),
          )
        ],
      ),
    ),
  );
}
