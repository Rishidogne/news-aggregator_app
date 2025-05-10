import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_aggregator_app/screens/favorites_page.dart';
import 'screens/home_screen.dart';
import 'screens/search_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'News App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/', // 👈 this makes HomeScreen show first
      getPages: [
        GetPage(name: '/', page: () => HomeScreen()),
        GetPage(name: '/search', page: () => const SearchPage()),
        GetPage(name: '/fav', page: () =>  FavoritesPage()),

      ],
    );
  }
}
