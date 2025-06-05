import 'package:flutter/material.dart';
import 'package:news_app/model/article.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticleDetailsPage extends StatelessWidget {
  final Article article;

  const ArticleDetailsPage({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(40, 0, 0, 0),
        title: Text(article.title ?? "Article Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.urlToImage != null)
              Image.network(
                article.urlToImage!,
                fit: BoxFit.cover,
              ),
            Text(article.source?.name ?? ""),
            const SizedBox(height: 15),
            Text(
              article.title ?? "No Title",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(article.publishedAt ?? ""),
            const SizedBox(height: 20),
            if (article.description != null)
              Text(
                article.description ?? "No Description",
                style: TextStyle(fontSize: 19),
              ),
            const Spacer(),
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: Text("Author(s): ${article.author ?? ""} "),
             ),
            Container(
              padding: EdgeInsets.all(10),
              color: const Color.fromARGB(28, 0, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () {
                      if (article.url != null) {
                        final url = Uri.parse(article.url!);
                        _launchUrl(url);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Invalid URL")),
                        );
                      }
                    },
                    child: const Text("Read Full Article", style: TextStyle(fontSize: 25, color: Colors.green),),
                  ),
                 
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> _launchUrl(Uri url) async {
  if (!await launchUrl(url)) {
    throw Exception("Could not launch $url");
  }
}
