import 'package:flutter/material.dart';
import '../services/favorite_service.dart';
import '../models/article.dart';
import 'article_detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Article> favorites = [];

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    final favs = await FavoriteService.getFavorites();
    setState(() => favorites = favs);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Icon(Icons.favorite, color: Colors.white),
            SizedBox(width: 8),
            Text('Mes Favoris'),
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 24, 214, 214),
        elevation: 4,
      ),
      body: favorites.isEmpty
          ? const Center(child: Text("Aucun favori."))
          : ListView.separated(
              itemCount: favorites.length,
              separatorBuilder: (context, index) => const Divider(
                color: Colors.grey,
                indent: 16,
                endIndent: 16,
              ),
              itemBuilder: (context, index) {
                final article = favorites[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  title: Text(
                    article.title ?? 'Sans titre',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text('Auteur : ${article.by ?? 'Inconnu'}'),
                  trailing: const Icon(Icons.chevron_right),
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
