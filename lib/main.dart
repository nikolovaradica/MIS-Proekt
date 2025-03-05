import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lifelog/providers/daily_entry_provider.dart';
import 'package:lifelog/providers/quote_provider.dart';
import 'package:lifelog/providers/theme_provider.dart';
import 'package:lifelog/providers/user_provider.dart';
import 'package:lifelog/screens/landing_screen.dart';
import 'package:provider/provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => DailyEntryProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => QuoteProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'LifeLog',
      themeMode: themeProvider.themeMode,
      theme: ThemeData(
        fontFamily: 'Inter',
        primaryColor: Colors.white,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black),
        ),
      ),
      darkTheme: ThemeData(
        fontFamily: 'Inter',
        brightness: Brightness.dark,
        primaryColor: Colors.black,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
        ),
      ),
      home: const LandingScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
