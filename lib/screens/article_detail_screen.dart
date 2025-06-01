import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/article.dart';
import '../services/api_service.dart';

class ArticleDetailScreen extends StatefulWidget {
  final Article article;

  const ArticleDetailScreen({super.key, required this.article});

  @override
  State<ArticleDetailScreen> createState() => _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends State<ArticleDetailScreen> {
  List<Article> comments = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchComments();
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

  Widget buildComment(Article comment, {int indent = 0}) {
    return Padding(
      padding: EdgeInsets.only(left: indent * 16.0, top: 8.0, bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(comment.by ?? 'Inconnu', style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(comment.text ?? '', style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final article = widget.article;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Détail de l\'article'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(article.title ?? '', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
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
                  style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                ),
              ),
            const SizedBox(height: 16),
            const Text('Commentaires', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
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
