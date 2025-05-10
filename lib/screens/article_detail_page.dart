

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/news_model.dart';


class ArticleDetailPage extends StatefulWidget {
  final Article article;

  const ArticleDetailPage({Key? key, required this.article}) : super(key: key);

  @override
  State<ArticleDetailPage> createState() => _ArticleDetailPageState();
}

class _ArticleDetailPageState extends State<ArticleDetailPage> {
  bool isFavorite = false;

  void _launchURL(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open the article URL')),
      );
    }
  }

  Future<void> addToFavorites() async {
    final uri = Uri.parse('http://localhost:5000/favorites'); // ⚠️ Replace with your local IP

    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'title': widget.article.title,
          'description': widget.article.description,
          'urlToImage': widget.article.urlToImage,
          'url': widget.article.url,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          isFavorite = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Added to favorites')),
        );
      } else {
        throw Exception('Failed to save');
      }
    } catch (e) {
      print('Error saving favorite: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save favorite')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final article = widget.article;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Article Details',style: TextStyle(color: Colors.white),),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.favorite,
              color: isFavorite ? Colors.pink : Colors.grey,
            ),
            onPressed: addToFavorites,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            article.urlToImage != null && article.urlToImage!.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      article.urlToImage!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 200,
                      errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image),
                    ),
                  )
                : Container(
                    height: 200,
                    color: Colors.grey[300],
                    child: const Center(child: Text("No Image Available")),
                  ),
            const SizedBox(height: 16),

            // Title
            Text(
              article.title ?? 'No Title',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Description
            Text(
              article.description ?? 'No Description',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),

            // Content
            if (article.content != null && article.content!.isNotEmpty)
              Text(
                article.content!,
                style: const TextStyle(fontSize: 16),
              ),
            const SizedBox(height: 20),

            // Read Full Article Button
            if (article.url != null && article.url!.isNotEmpty)
              TextButton.icon(
                onPressed: () => _launchURL(context, article.url!),
                icon: const Icon(Icons.open_in_new),
                label: const Text(
                  'Read Full Article',
                  style: TextStyle(color: Colors.blue, fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
