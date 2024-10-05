import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Color(0xFF004D40), // Deep Teal
    scaffoldBackgroundColor: Colors.white,
    cardColor: Colors.grey[100],

    // AppBar theme
    appBarTheme: AppBarTheme(
      color: Color(0xFF004D40), // Deep Teal for AppBar
      elevation: 4,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),

    // ListTile theme
    listTileTheme: ListTileThemeData(
      tileColor: Colors.white,
      iconColor: Colors.black87,
      textColor: Colors.black87,
    ),

    // Card theme
    cardTheme: CardTheme(
      color: Colors.grey[100], // Light grey for cards
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),

    tabBarTheme: TabBarTheme(
      labelColor: Color(0xFFF9A825), // Muted Gold for selected tab
      unselectedLabelColor:
          Colors.white.withOpacity(0.8), // 80% white for unselected tab
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(
          width: 3.0,
          color: Color(0xFFF9A825), // Muted Gold for the underline indicator
        ),
      ),
      labelStyle: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
      ),
      unselectedLabelStyle: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.normal,
      ),
    ),

    // TextButton theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        backgroundColor: Color(0xFFF9A825), // Muted Gold for TextButton
        foregroundColor: Colors.black, // Text color inside TextButton
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      ),
    ),

    // BottomNavigationBar theme
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: Color(0xFF004D40), // Deep Teal for selected item
      unselectedItemColor: Colors.grey, // Grey for unselected items
      selectedIconTheme: IconThemeData(size: 28),
      unselectedIconTheme: IconThemeData(size: 24),
      showSelectedLabels: true,
      showUnselectedLabels: false,
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true, // To have a filled background color
      fillColor: Colors.grey[100], // Light background for light mode
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4.0), // Circular border
        borderSide: BorderSide(
          color: Color(0xFF004D40), // Deep Teal border color
          width: 1.5,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4.0),
        borderSide: BorderSide(
          color: Color(0xFFF9A825), // Muted Gold for focused border color
          width: 2.0,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4.0),
        borderSide: BorderSide(
          color: Color(0xFF004D40), // Deep Teal for enabled border color
          width: 1.5,
        ),
      ),
    ),

    // Color scheme
    colorScheme: ColorScheme.light(
      primary: Color(0xFF004D40), // Deep Teal
      secondary: Color(0xFFF9A825), // Muted Gold
      onPrimary: Colors.white, // Text color on primary elements
      onSecondary: Colors.black, // Text color on secondary elements
      surface: Colors.white, // For background of cards and panels
      onSurface: Colors.black87, // Text color on cards and panels
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Color(0xFF004D40), // Deep Teal
    scaffoldBackgroundColor: Color(0xFF121212),
    cardColor: Color(0xFF1C1C1E),

    // AppBar theme
    appBarTheme: AppBarTheme(
      color: Color(0xFF004D40), // Deep Teal for AppBar
      elevation: 4,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),

    // ListTile theme
    listTileTheme: ListTileThemeData(
      tileColor: Color(0xFF1C1C1E),
      iconColor: Colors.white70,
      textColor: Colors.white70,
    ),

    // Card theme
    cardTheme: CardTheme(
      color: Color(0xFF1C1C1E), // Dark grey for cards
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),

    tabBarTheme: TabBarTheme(
      labelColor: Color(0xFFF9A825), // Muted Gold for selected tab
      unselectedLabelColor:
          Colors.white.withOpacity(0.6), // 60% white for unselected tab
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(
          width: 3.0,
          color: Color(0xFFF9A825), // Muted Gold for the underline indicator
        ),
      ),
      labelStyle: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
      ),
      unselectedLabelStyle: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.normal,
      ),
    ),

    // TextButton theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        backgroundColor: Color(0xFFF9A825), // Muted Gold for TextButton
        foregroundColor: Colors.black, // Text color inside TextButton
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      ),
    ),

    // BottomNavigationBar theme
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF1C1C1E), // Dark background
      selectedItemColor: Color(0xFFF9A825), // Muted Gold for selected item
      unselectedItemColor: Colors.white70, // Light grey for unselected items
      selectedIconTheme: IconThemeData(size: 28),
      unselectedIconTheme: IconThemeData(size: 24),
      showSelectedLabels: true,
      showUnselectedLabels: false,
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true, // To have a filled background color
      fillColor: Color(0xFF1C1C1E), // Dark background for dark mode
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4.0), // Circular border
        borderSide: BorderSide(
          color: Color(0xFFF9A825), // Muted Gold border color
          width: 1.5,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4.0),
        borderSide: BorderSide(
          color: Color(0xFFF9A825), // Muted Gold for focused border color
          width: 2.0,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4.0),
        borderSide: BorderSide(
          color: Color(0xFFF9A825), // Muted Gold for enabled border color
          width: 1.5,
        ),
      ),
    ),

    // Color scheme
    colorScheme: ColorScheme.dark(
      primary: Color(0xFF004D40), // Deep Teal
      secondary: Color(0xFFF9A825), // Muted Gold
      onPrimary: Colors.white, // Text color on primary elements
      onSecondary: Colors.black, // Text color on secondary elements
      surface: Color(0xFF1C1C1E), // For background of cards and panels
      onSurface: Colors.white70, // Text color on cards and panels
    ),
  );
}
