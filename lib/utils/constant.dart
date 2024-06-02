import 'package:affordable/utils/extension.dart';
import 'package:flutter/material.dart';

import '../model/language_model.dart';

const appName = 'Affordable';
const secondColor = Color(0xFF4E4E4E);
const primaryColor = Color(0xFF2F79F6);
const dangerColor = Colors.red;
const supBaseUrl = 'https://aexwhrxcxowpwscvgotn.supabase.co';
const publicKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFleHdocnhjeG93cHdzY3Znb3RuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDE2MjQwMjksImV4cCI6MjAxNzIwMDAyOX0.P_eqo9J1JBoZpQGkSNEazbipkDmakE-WmpBdmR7tUvo';
const loginSup = 'epgfree@gmail.com';
const passwordSup = 'supabaseAffordable_1';
const webClientId = '364558966176-18hb7p4esbb2idi4b22ttgb2i6dspkqd.apps.googleusercontent.com';
const iosClientId = '364558966176-1ubfsh3ntc44a7n5itcs0b1nb6j5srie.apps.googleusercontent.com';
final colorList = <Color>[
  Colors.red,
  Colors.yellow,
  Colors.green,
  Colors.deepPurpleAccent,
  Colors.blueAccent,
  Colors.pink,
  Colors.deepOrange
];
List<LanguageModel> languagesList = [
  LanguageModel(id: 1, name: 'Русский', code: 'ru'),
  LanguageModel(id: 2, name: 'English', code: 'en'),
  LanguageModel(id: 3, name: 'España', code: 'es')
];
var themeLight = ThemeData(
  fontFamily: 'Poppins',
  textSelectionTheme: const TextSelectionThemeData(
      cursorColor: primaryColor,
      selectionHandleColor: primaryColor
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(color: secondColor),
    displayMedium: TextStyle(color: secondColor),
    bodyMedium: TextStyle(color: secondColor),
    titleMedium: TextStyle(color: secondColor),
  ), colorScheme: ColorScheme.fromSwatch(primarySwatch: secondColor.asMaterialColor).copyWith(background: Colors.white)
);

var themeDark = ThemeData(
  fontFamily: 'Poppins',
  textSelectionTheme: const TextSelectionThemeData(
      cursorColor: Color(0xFFFFFFFF),
      selectionHandleColor: Color(0xFFFFFFFF)
  ),
  appBarTheme: const AppBarTheme(backgroundColor: Colors.black87, elevation: 6, shadowColor: Colors.black12),
  bottomAppBarTheme: const BottomAppBarTheme(color: Colors.black87, elevation: 6, shadowColor: Colors.black12),
  textTheme: const TextTheme(
    displayLarge: TextStyle(color: Color(0xFFFFFFFF)),
    displayMedium: TextStyle(color: Color(0xFFFFFFFF)),
    bodyMedium: TextStyle(color: Color(0xFFFFFFFF)),
    titleMedium: TextStyle(color: Color(0xFFFFFFFF)),
  ),
  colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      background: Colors.black87,
      primary: Colors.white,
      onPrimary: Colors.white,
      secondary: Colors.white,
      onSecondary: Colors.white,
      error: dangerColor,
      onError: dangerColor,
      onBackground: secondColor,
      surface: Colors.white,
      onSurface: Colors.white
  ),
);
String smtpServerStr = 'smtp.mail.ru';
String emailAddress = 'epgfree@mail.ru';
String emailPassword = 'a3T84dF07jwNpRw6ksFt';