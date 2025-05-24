import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IslamicThemeDemoPage extends StatelessWidget {
  // Define your new colors from your list
  final Color midnight = Color(0xFF191970);
  final Color black = Color(0xFF003151);
  final Color green = Color(0xFF008080);
  final Color undercool = Color(0xFF7EC3E0);
  final Color blue = Color(0xFF4682B4);
  final Color darkBlue = Color(0xFF0047AB);
  final Color ok = Color(0xFF034694);
  final Color deftBlue = Color(0xFF1F305E);
  final Color slickBlue = Color(0xFF70CBD6);
  final Color splashy = Color(0xFF009096);
  final Color darkGreen = Color(0xFF1B4D3E);
  final Color alterGreen = Color(0xFF008000);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: undercool, // Light soft blue as background
      appBar: AppBar(
        backgroundColor: darkGreen, // Dark green for strong brand color
        title: Text(
          'Bayt Al-Ilm',
          style: GoogleFonts.cairo(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: undercool, // contrast with dark green
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dive Into Islamic Wisdom',
              style: GoogleFonts.amiri(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: black, // deep color for main heading
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Explore the profound teachings of Islamic wisdom, offering insights to navigate life\'s journey with clarity and purpose.',
              style: GoogleFonts.notoSans(
                fontSize: 18,
                color: splashy, // calm teal-blue for body text
                height: 1.5,
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: alterGreen, // fresh vibrant green button
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                // Action here
              },
              child: Text(
                'Discover Now',
                style: GoogleFonts.cairo(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: undercool, // light contrast text on button
                ),
              ),
            ),
            SizedBox(height: 40),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildBookCard('July 22, 2018', midnight, alterGreen),
                  _buildBookCard('Iftar Party', deftBlue, alterGreen),
                  _buildBookCard('Islamic New Year', darkBlue, splashy),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookCard(String title, Color bgColor, Color textColor) {
    return Container(
      width: 100,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: black.withOpacity(0.4),
            blurRadius: 5,
            offset: Offset(2, 4),
          ),
        ],
      ),
      padding: EdgeInsets.all(12),
      child: Center(
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: GoogleFonts.amiri(
            fontSize: 16,
            color: textColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
