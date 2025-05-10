import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/news_model.dart';
import 'article_detail_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Article> _searchResults = [];
  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _searchNews(String keyword) async {
    if (keyword.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final response = await http.get(Uri.parse('http://localhost:5000/search?query=$keyword')); // Use IP if on real device

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List articles = data['articles'];

        setState(() {
          _searchResults = articles.map((json) => Article.fromJson(json)).toList();
        });
      } else {
        setState(() {
          _errorMessage = 'Search failed with status: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error during search: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildArticleItem(Article article) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      leading: article.urlToImage != null && article.urlToImage!.isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                article.urlToImage!,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // Show the default news.jpg image if the URL image fails
                  return Image.asset(
                    'assets/code-error.png', // Your default image
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  );
                },
              ),
            )
          : Image.asset(
              'assets/code-error.png', // Show default image if URL is empty or null
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
      title: Text(article.title ?? 'No Title', maxLines: 2, overflow: TextOverflow.ellipsis),
      subtitle: Text(article.description ?? '', maxLines: 2, overflow: TextOverflow.ellipsis),
      onTap: () {
        Get.to(() => ArticleDetailPage(article: article));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Search News',style: TextStyle(color: Colors.white),),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              onSubmitted: _searchNews,
              decoration: InputDecoration(
                hintText: 'Search news...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchResults.clear());
                  },
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (_errorMessage.isNotEmpty)
            Center(child: Text(_errorMessage, style: const TextStyle(color: Colors.red)))
          else if (_searchResults.isEmpty)
            const Expanded(child: Center(child: Text('No articles found')))
          else
            Expanded(
              child: ListView.separated(
                itemCount: _searchResults.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) => _buildArticleItem(_searchResults[index]),
              ),
            ),
        ],
      ),
    );
  }
}
