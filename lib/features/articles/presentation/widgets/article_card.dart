import 'package:flutter/material.dart';
import 'package:cesizen_frontend/app/theme/app_theme.dart';
import '../../domain/article.dart';

class ArticleCard extends StatelessWidget {
  final Article article;
  final VoidCallback onTap;
  const ArticleCard({
    super.key,
    required this.article,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final snippet =
    article.content.length > 80 ? '${article.content.substring(0, 80)}…' : article.content;
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(article.title, style: AppTextStyles.title.copyWith(fontSize: 18)),
              const SizedBox(height: 8),
              Text(snippet, style: AppTextStyles.subtitle, maxLines: 2),
            ],
          ),
        ),
      ),
    );
  }
}