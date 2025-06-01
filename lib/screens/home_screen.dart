import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/article_provider.dart';
import '../screens/article_detail_screen.dart';
import '../models/article.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<ArticleProvider>(context, listen: false).fetchArticles();
  }

  @override
  Widget build(BuildContext context) {
    final articleProvider = Provider.of<ArticleProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hacker News'),
      ),
      body: articleProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: articleProvider.articles.length,
              itemBuilder: (context, index) {
                Article article = articleProvider.articles[index];

                return ListTile(
                  title: Text(article.title ?? 'Sans titre'),
                  subtitle: Text('Auteur: ${article.by ?? 'Inconnu'}'),
                  trailing: Text(
                    '${article.descendants ?? 0} 💬',
                    style: const TextStyle(fontSize: 12),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ArticleDetailScreen(article: article),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
