import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/article_provider.dart';
import '../screens/article_detail_screen.dart';
import '../screens/favorites_screen.dart';
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
        title: Row(
          children: const [
            Icon(Icons.newspaper, color: Colors.white),
            SizedBox(width: 8),
            Text('Hacker News'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            tooltip: 'Voir les favoris',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FavoritesScreen()),
              );
            },
          )
        ],
        elevation: 4,
        backgroundColor: Colors.deepOrange,
      ),
      body: articleProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              itemCount: articleProvider.articles.length,
              separatorBuilder: (context, index) => const Divider(
                color: Colors.grey,
                indent: 16,
                endIndent: 16,
              ),
              itemBuilder: (context, index) {
                final article = articleProvider.articles[index];

                return ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  title: Text(
                    article.title ?? 'Sans titre',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text('Auteur : ${article.by ?? 'Inconnu'}'),
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
