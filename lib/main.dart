import 'package:family_competition/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TCP Socket',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        primarySwatch: metallicPrimaryColor,
        useMaterial3: true,
      ),
      home: const HomePage(title: 'Family Competition'),
      //home: SimonSaysGame(),
    );
  }
}
