import 'package:flutter/material.dart';
import 'package:glong_ya_connect/Screens/Information.dart';
import 'package:glong_ya_connect/Utilities/LocalDataProvider.dart';
import 'package:provider/provider.dart';
import 'Konstants/konstants.dart';
import 'Screens/home_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => LocalDataProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    K k = K();
    Provider.of<LocalDataProvider>(context, listen: false).loadDatabase();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: k.white,
      ),
      home: const HomeScreen(),
    );
  }
}
