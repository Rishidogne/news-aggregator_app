import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/news_model.dart'; // Make sure your Article model matches Currents API fields

class NewsController extends GetxController {
  var newsList = <Article>[].obs;  // List of articles to display
  var isLoading = false.obs;  // Loading state flag
  var selectedCategory = 'general'.obs;  // Default selected category

  @override
  void onInit() {
    super.onInit();
    fetchNews(selectedCategory.value);  // Initial news fetch
  }

  // Change category and fetch news for that category
  void changeCategory(String category) {
    selectedCategory.value = category;
    fetchNews(category);  // Fetch news based on the new category
  }

  // Fetch news based on the selected category
  Future<void> fetchNews(String category) async {
    isLoading.value = true;  // Show loader while fetching news

    try {
      // Call your backend API to fetch the news for the selected category
      final response = await http.get(Uri.parse(
        'http://localhost:5000/news?category=$category',  // Make sure this endpoint works
      ));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);  // Parse the response

        // Assuming 'news' key contains the articles
        final news = jsonData['articles'];

        if (news != null && news.isNotEmpty) {
          // Map the articles to your model and update the news list
          newsList.value = List<Article>.from(news.map((item) => Article.fromJson(item)));
        } else {
          newsList.clear();  // Clear list if no news found
        }
      } else {
        newsList.clear();
        print("Failed to fetch news: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching news: $e");
      newsList.clear();
    } finally {
      isLoading.value = false;  // Hide loader after fetching
    }
  }
}
