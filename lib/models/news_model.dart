class NewsModel {
  final List<Article> articles;

  NewsModel({required this.articles});

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      articles: List<Article>.from(json['articles'].map((x) => Article.fromJson(x))),
    );
  }
}
class Article {
  final String? title;
  final String? description;
  final String? url;
  final String? urlToImage;
  final String? content;

  Article({
    this.title,
    this.description,
    this.url,
    this.urlToImage,
    this.content,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'],
      description: json['description'],
      url: json['url'],
      urlToImage: json['urlToImage'],
      content: json['content'],
    );
  }
}
