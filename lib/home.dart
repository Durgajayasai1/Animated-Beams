import 'package:animated_beam/components/animated_beam.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Screen dimensions
    final screenSize = MediaQuery.of(context).size;
    final centerX = screenSize.width / 5;
    final centerY = screenSize.height / 2.5;

    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(40),
          child: AppBar(
            title: Text(
              "_insane.dev",
              style: GoogleFonts.sora(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          )),
      body: Stack(
        children: [
          // Beams
          _buildBeam(
              Offset(centerX, centerY), Offset(centerX + 200, centerY - 150)),
          _buildBeam(
              Offset(centerX, centerY), Offset(centerX + 200, centerY - 75)),
          _buildBeam(Offset(centerX, centerY), Offset(centerX + 200, centerY)),
          _buildBeam(
              Offset(centerX, centerY), Offset(centerX + 200, centerY + 75)),
          _buildBeam(
              Offset(centerX, centerY), Offset(centerX + 200, centerY + 150)),

          // Main icon
          Positioned(
            left: centerX - 25,
            top: centerY - 25,
            child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Color(0xff28282B),
                    borderRadius: BorderRadius.circular(50)),
                child: Icon(Iconsax.profile_circle,
                    color: Colors.grey[300], size: 30)),
          ),

          // Icons
          _buildIcon('assets/gdrive.png', centerX + 200, centerY - 150),
          _buildIcon('assets/docx.png', centerX + 200, centerY - 75),
          _buildIcon('assets/whatsapp.png', centerX + 200, centerY),
          _buildIcon('assets/messenger.png', centerX + 200, centerY + 75),
          _buildIcon('assets/notion.png', centerX + 200, centerY + 150),
        ],
      ),
    );
  }

  // Function for icons
  Widget _buildIcon(String assetPath, double left, double top) {
    return Positioned(
      left: left - 20,
      top: top - 20,
      child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Color(0xff28282B),
              borderRadius: BorderRadius.circular(50)),
          child: Image.asset(assetPath, width: 40, height: 40)),
    );
  }

  // Function to create beams
  Widget _buildBeam(Offset fromOffset, Offset toOffset) {
    return AnimatedBeam(
      fromOffset: fromOffset,
      toOffset: toOffset,
      pathColor: Colors.grey.withValues(alpha: 0.2),
      gradientStartColor: Colors.deepOrange,
      gradientStopColor: Colors.purple,
      curvature: 10.0,
      duration: const Duration(seconds: 2),
      reverse: false,
    );
  }
}
