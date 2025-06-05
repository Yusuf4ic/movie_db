import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:news_app/constants.dart';
import 'package:news_app/detail.dart';
import 'package:news_app/model/article.dart';
import 'package:url_launcher/url_launcher.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    _getNews();
  }

  final Dio dio = Dio();
  List<Article> articles = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News'),
        centerTitle: true,
      ),
      body: Center(child: _buildUI()),
    );
  }

  Widget _buildUI() {
    return ListView.builder(
      itemCount: articles.length,
      itemBuilder: (context, index) {
        final article = articles[index];
        return Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
            color: const Color.fromARGB(23, 0, 0, 0),
            child: ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ArticleDetailsPage(article: article),
                  ),
                );
              },
              leading: Image.network(
                  height: 250,
                  width: 100,
                  fit: BoxFit.cover,
                  article.urlToImage ?? PLACEHOLDER_IMAGE_LINK),
              title: Text(
                article.title ?? "",
                style: const TextStyle(color: Colors.black),
              ),
              subtitle: Text(
                  "${article.publishedAt ?? ""}\n${article.source?.name ?? ""}"),
            ),
          ),
        );
      },
    );
  }

  Future<void> _getNews() async {
    try {
      final response = await dio.get(
          "https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=$API_KEY");
      if (response.statusCode == 200) {
        final articlesJson = response.data["articles"] as List;
        setState(() {
          articles = articlesJson
              .map((a) => Article.fromJson(a))
              .where((a) => a.title != "[Removed]")
              .toList();
        });
      } else {
        print("Ошибка при загрузке новостей: ${response.statusCode}");
      }
    } catch (e) {
      print("Произошла ошибка: $e");
    }
  }
}
