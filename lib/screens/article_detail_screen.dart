import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/article.dart';
import '../services/api_service.dart';
import '../services/favorite_service.dart';

class ArticleDetailScreen extends StatefulWidget {
  final Article article;

  const ArticleDetailScreen({super.key, required this.article});

  @override
  State<ArticleDetailScreen> createState() => _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends State<ArticleDetailScreen> {
  List<Article> comments = [];
  bool isLoading = true;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    fetchComments();
    checkFavoriteStatus();
  }

  Future<void> checkFavoriteStatus() async {
    final fav = await FavoriteService.isFavorite(widget.article);
    setState(() => isFavorite = fav);
  }

  Future<void> fetchComments() async {
    if (widget.article.kids == null) return;

    List<Article> loadedComments = [];
    for (var commentId in widget.article.kids!) {
      try {
        final comment = await ApiService.fetchArticle(commentId);
        loadedComments.add(comment);
      } catch (_) {
        continue;
      }
    }

    setState(() {
      comments = loadedComments;
      isLoading = false;
    });
  }

  // Widget buildComment(Article comment, {int indent = 0}) {
  //   return Padding(
  //     padding: EdgeInsets.only(left: indent * 16.0, top: 8.0, bottom: 8.0),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(comment.by ?? 'Inconnu',
  //             style: const TextStyle(fontWeight: FontWeight.bold)),
  //         const SizedBox(height: 4),
  //         Text(comment.text ?? 'Pas de contenu',
  //             style: const TextStyle(fontSize: 14)),
  //       ],
  //     ),
  //   );
  // }
  Widget buildComment(Article comment, {int indent = 0}) {
    return FutureBuilder<List<Article>>(
      future: fetchReplies(comment.kids),
      builder: (context, snapshot) {
        final replies = snapshot.data ?? [];

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: indent > 0 ? Colors.grey.shade100 : Colors.transparent,
            border: indent > 0
                ? Border(
                    left: BorderSide(
                      color: Colors.grey.shade400,
                      width: 3,
                    ),
                  )
                : null,
          ),
          padding: EdgeInsets.only(
            left: 20.0 + (indent * 12.0), // indentation + padding
            top: 8.0,
            bottom: 8.0,
            right: 8.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                comment.by ?? 'Inconnu',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                comment.text ?? 'Pas de contenu',
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 6),
              // j'ai limité les replies à deux pour ne pas complexifier la vue 
              if (indent < 2)
                ...replies
                    .map((r) => buildComment(r, indent: indent + 1))
                    .toList(),
            ],
          ),
        );
      },
    );
  }

  Future<List<Article>> fetchReplies(List<int>? kids) async {
    if (kids == null || kids.isEmpty) return [];
    List<Article> replies = [];

    for (var kidId in kids) {
      try {
        final reply = await ApiService.fetchArticle(kidId);
        replies.add(reply);
      } catch (_) {
        continue;
      }
    }

    return replies;
  }

  @override
  Widget build(BuildContext context) {
    final article = widget.article;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Icon(Icons.newspaper, color: Colors.white),
            SizedBox(width: 8),
            Text('Détail de l\'article'),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : null,
            ),
            onPressed: () async {
              await FavoriteService.toggleFavorite(article);
              final fav = await FavoriteService.isFavorite(article);
              setState(() => isFavorite = fav);
            },
          )
        ],
        elevation: 4,
        backgroundColor: const Color.fromARGB(255, 24, 214, 214),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(article.title ?? '',
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(article.text ?? '',
                style:
                    const TextStyle(fontSize: 15)),
            const SizedBox(height: 8),
            if (article.url != null)
              InkWell(
                onTap: () async {
                  final uri = Uri.parse(article.url!);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.inAppWebView);
                  }
                },
                child: const Text(
                  'Lire l’article complet',
                  style: TextStyle(
                      color: Colors.blue, decoration: TextDecoration.underline),
                ),
              ),
            const SizedBox(height: 16),
            const Text('Commentaires',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const Divider(),
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (comments.isEmpty)
              const Text('Aucun commentaire.')
            else
              ...comments.map((c) => buildComment(c)).toList(),
          ],
        ),
      ),
    );
  }
}
