import 'package:flutter/material.dart';

class DefaultTheme {
  static ThemeData lightThemeData(BuildContext context) {
    //  Color primary = Color(0xFFD22828);
    //  Color secudary = Color(0xFFD22828);
    //  Color secudaryLight = Color.fromARGB(120, 216, 61, 61);
    //  Color tertiary = Color.fromARGB(255, 87, 16, 16);
    //  Color white = Colors.white;
    //  Color black = Colors.black;

    Color primary = const Color(0xFF013d4c);
    Color tertiary = const Color.fromARGB(255, 1, 37, 46);
    Color white = Colors.white;
    Color black = Colors.black;
    Color secodaryLight = const Color.fromARGB(120, 76, 194, 224);
    return ThemeData(
      primaryColor: const Color(0xFF013d4c),
      //primaryColorLight: Color(0xFF013d4c),
      primaryColorDark: const Color(0xFF013d4c),
      primaryColorLight: const Color.fromARGB(120, 76, 194, 224),

      appBarTheme: AppBarTheme(
        surfaceTintColor: white,
        backgroundColor: white,
        foregroundColor: primary,
      ),
      popupMenuTheme: PopupMenuThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: white,
        iconColor: primary,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(primary),
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: primary,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        foregroundColor: white,
        backgroundColor: primary,
      ),
      navigationBarTheme: NavigationBarThemeData(
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: tertiary);
          }
          return IconThemeData(
            color: black,
          );
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return TextStyle(
              color: black,
              fontWeight: FontWeight.bold,
            );
          }
          return TextStyle(
            color: black,
          );
        }),
        backgroundColor: white,
        indicatorColor: secodaryLight,
      ),
      scaffoldBackgroundColor: white,
      useMaterial3: true,
    );
  }

  static ThemeData darkThemeData() {
    Color primary = const Color(0xFF013d4c);
    Color secondary = const Color(0xFFD22828);
    Color white = Colors.white;
    Color whiteLight = Colors.white12;
    Color black = const Color.fromARGB(255, 22, 36, 39);

    return ThemeData(
      appBarTheme: AppBarTheme(
        titleTextStyle: TextStyle(
          color: white,
          fontSize: 24,
          fontFamily: 'Imaki',
        ),
        surfaceTintColor: white,
        backgroundColor: black,
        foregroundColor: white,
      ),
      popupMenuTheme: PopupMenuThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: black,
        iconColor: white,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.all(black),
          backgroundColor: WidgetStateProperty.all(secondary),
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: primary,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        foregroundColor: primary,
        backgroundColor: white,
      ),
      navigationBarTheme: NavigationBarThemeData(
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: white);
          }
          return IconThemeData(
            color: white,
          );
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return TextStyle(
              color: white,
              fontWeight: FontWeight.bold,
            );
          }
          return TextStyle(
            color: white,
          );
        }),
        backgroundColor: black,
        indicatorColor: whiteLight,
      ),
      scaffoldBackgroundColor: black,
      useMaterial3: true,
    );
  }
}
