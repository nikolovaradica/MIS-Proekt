import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lifelog/providers/daily_entry_provider.dart';
import 'package:lifelog/providers/quote_provider.dart';
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
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LifeLog',
      theme: ThemeData(
        fontFamily: 'Inter'
      ),
      home: const LandingScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
