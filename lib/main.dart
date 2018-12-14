import 'package:flutter/material.dart';
import 'package:flutter_movie_app/Screens/homescreen.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
     title: 'Movies',
     debugShowCheckedModeBanner: false,
     theme: buildThemeData(),
      home: HomeScreen(),
    );
  }

  ThemeData buildThemeData() {

    final baseTheme = ThemeData.light();
    return baseTheme.copyWith(
      primaryColor: Color(0xFFc62828),
      primaryColorLight: Color(0xFFff5f52),
      primaryColorDark: Color(0xFF8e0000),
      accentColor: Color(0xFF0097a7),
    );
  }
}






