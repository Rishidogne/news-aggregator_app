import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:news_aggregator_app/screens/article_detail_page.dart';
import 'dart:convert';
import '../models/news_model.dart';
 // Make sure this import exists

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<Article> _favorites = [];

  Future<void> _fetchFavorites() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:5000/favorites'));
      if (response.statusCode == 200) {
        final List articles = json.decode(response.body);
        setState(() {
          _favorites = articles.map((json) => Article.fromJson(json)).toList();
        });
      }
    } catch (e) {
      print('Error fetching favorites: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        title: const Text('Favorites',style: TextStyle(color: Colors.white),),
        
      ),
      body: _favorites.isEmpty
          ? const Center(child: Text('No favorites yet'))
          : ListView.builder(
  itemCount: _favorites.length,
  itemBuilder: (context, index) {
    final article = _favorites[index];
    return GestureDetector(
      onTap: () {
        Get.to(() => ArticleDetailPage(article: article));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: (article.urlToImage != null &&
                        article.urlToImage!.isNotEmpty &&
                        Uri.tryParse(article.urlToImage!)?.hasAbsolutePath == true)
                    ? Image.network(
                        article.urlToImage!,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/code-error.png',
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.fitHeight,
                          );
                        },
                      )
                    : Image.asset(
                        'assets/code-error.png',
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.fitHeight,
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.title ?? 'No Title',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      article.description ?? '',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  },
),

    );
  }
}
