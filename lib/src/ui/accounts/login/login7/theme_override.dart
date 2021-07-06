import 'package:flutter/material.dart';
import 'package:gradient_input_border/gradient_input_border.dart';

class ThemeOverride extends StatelessWidget {
  ThemeOverride({Key key, this.child}) : super(key: key);
  final Widget child;

  final LinearGradient gradient = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        Colors.deepOrange,
        Colors.deepOrange,
      ]);
  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark
        ? Theme(
            child: child,
            data: ThemeData(
                brightness: Brightness.dark,
                primaryColor: Colors.deepOrange[800],
                accentColor: Colors.deepOrange[600],
                backgroundColor: isDark ? Colors.black : Colors.white,
                scaffoldBackgroundColor: isDark ? Colors.black : Colors.white,
                buttonColor: Colors.deepOrange,
                buttonTheme: ButtonThemeData(
                  buttonColor: Colors.deepOrange,
                  //shape: StadiumBorder(),
                  textTheme: ButtonTextTheme.primary,
                  height: 45.0,
                  colorScheme: new ColorScheme(
                      primary: Colors.deepOrange,
                      primaryVariant:  Colors.deepOrange,
                      secondary: Colors.deepOrange,
                      secondaryVariant: Colors.deepOrange,
                      background: const Color(0xff000000),
                      surface: const Color(0xff121212),
                      error: Color(0xffb00020),
                      onPrimary: Colors.black,
                      onSecondary: Colors.black,
                      onSurface: Colors.black,
                      onBackground: Colors.black,
                      onError: Colors.white,
                      brightness: Brightness.light),
                ),
                inputDecorationTheme: InputDecorationTheme(
                    hintStyle: TextStyle(color: Colors.black),
                    border: InputBorder.none,
                    fillColor: Colors.grey.shade400,
                    filled: true)),
          )
        : Theme(
            child: child,
            data: ThemeData(
                brightness: Brightness.light,
                primaryColor: Colors.deepOrange[500],
                accentColor: Colors.deepOrange[600],
                backgroundColor: isDark ? Colors.black : Colors.white,
                scaffoldBackgroundColor: isDark ? Colors.black : Colors.white,
                buttonColor: Colors.deepOrange,
                buttonTheme: ButtonThemeData(
                  buttonColor: Colors.deepOrange,
                  textTheme: ButtonTextTheme.primary,
                  height: 45.0,
                  colorScheme: ColorScheme(
                      primary: Colors.deepOrange, //Color(0xff6200ee),
                      primaryVariant:
                          Colors.deepOrange,//const Color(0xff3700b3),
                      secondary: Colors.deepOrange,
                      secondaryVariant: const Color(0xff018786),
                      surface: Colors.white,
                      background: Colors.white,
                      error: Color(0xffb00020),
                      onPrimary: Colors.white,
                      onSecondary: Colors.white,
                      onSurface: Colors.white,
                      onBackground: Colors.white,
                      onError: Colors.red,
                      brightness: Brightness.light),
                ),
                inputDecorationTheme: InputDecorationTheme(
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    fillColor: Color(0xfff3f3f4),
                    filled: true)),
          );
  }
}
