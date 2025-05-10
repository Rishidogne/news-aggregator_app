import 'package:flutter/material.dart';
import 'package:get/get.dart';
//import 'package:news_aggregator_app/screens/favorites_page.dart';
import '../controllers/news_controller.dart';
//import '../models/news_model.dart';
import '../screens/article_detail_page.dart';
import '../screens/search_page.dart';
class HomeScreen extends StatelessWidget {
  final NewsController controller = Get.put(NewsController());

  final categories = [
    'general',
    'technology',
    'business',
    'sports',
    'health',
    'science',
    'entertainment'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
appBar: AppBar(
  backgroundColor: Colors.black, // AppBar background color
  iconTheme: const IconThemeData(color: Colors.white), // Icon color
  title: const Text(
    'Latest News',
    style: TextStyle(color: Colors.white), // Title text color
  ),
  actions: [
    IconButton(
      icon: const Icon(Icons.search, color: Colors.white), // Icon color
      onPressed: () {
Get.to(() => SearchPage());
      },
    ),
    TextButton(
      onPressed: () {
        Get.toNamed('/fav');
      },
      child: const Text(
        'Favorite articles',
        style: TextStyle(color: Colors.white), // Button text color
      ),
    ),
  ],
),

      body: Column(
        children: [
          _buildCategoryBar(),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.newsList.isEmpty) {
                return const Center(child: Text("No articles found for this category."));
              }
              return ListView.builder(
  itemCount: controller.newsList.length,
  itemBuilder: (context, index) {
    final article = controller.newsList[index];
    return GestureDetector(
      onTap: () {
        Get.to(() => ArticleDetailPage(article: article));
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: article.urlToImage != null && article.urlToImage!.isNotEmpty
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
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    article.description ?? 'No Description Available',
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  },
);

            }),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryBar() {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = controller.selectedCategory.value == category;

          return GestureDetector(
            onTap: () => controller.changeCategory(category),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue : Colors.grey[300],
                borderRadius: BorderRadius.circular(20),
              ),
              alignment: Alignment.center,
              child: Text(
                category.capitalizeFirst!,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
