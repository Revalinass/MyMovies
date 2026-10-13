import 'package:flutter/material.dart';

class AppColors {
  // Warna utama (primary) - soft blue
  static const Color primary = Color(0xFF8FB8DE); // biru pastel
  static const Color primaryDark = Color(0xFF6A9BC3); // biru pastel lebih gelap, untuk AppBar/teks aksen
  static const Color primaryLight = Color(0xFFD7E8F5); // biru pastel sangat muda, untuk background

  // Warna sekunder (secondary) - mint
  static const Color secondary = Color(0xFFA8DCC6); // mint pastel
  static const Color secondaryDark = Color(0xFF6FBE9F); // mint lebih gelap, untuk button/highlight
  static const Color secondaryLight = Color(0xFFE3F5EC); // mint sangat muda

  // Background & surface
  static const Color background = Color(0xFFF2F8FB); // putih kebiruan, background utama
  static const Color cardBackground = Colors.white;

  // Teks
  static const Color textDark = Color(0xFF3A4A52);
  static const Color textGrey = Color(0xFF8A9AA2);

  // Aksen lain
  static const Color favoriteRed = Color(0xFFE98A9C); // pink pastel untuk love icon
  static const Color star = Color(0xFFF2C46D); // kuning pastel untuk rating
  static const Color error = Color(0xFFE48A8A); // merah pastel untuk error

  // Warna gelap lembut untuk overlay di atas gambar (bukan hitam pekat,
  // supaya tetap terasa pastel walau perlu kontras untuk teks putih)
  static const Color overlayDark = Color(0xFF2E4756);

  // Gradient untuk login & hero header
  static const List<Color> gradientBackground = [
    Color(0xFFD7E8F5), // soft blue
    Color(0xFFE3F5EC), // soft mint
  ];

  // Gradient lebih berani untuk featured/hero card di Home
  static const List<Color> gradientHero = [
    Color(0xFF9DC6E8), // biru pastel lebih jenuh
    Color(0xFF8FD9C4), // mint pastel lebih jenuh
  ];

  // Gradient overlay gelap->transparan untuk teks di atas backdrop
  static const List<Color> gradientOverlay = [
    Color(0xCC2E4756),
    Color(0x002E4756),
  ];
}