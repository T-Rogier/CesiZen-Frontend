import 'package:cesizen_frontend/features/articles/presentation/providers/article_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cesizen_frontend/app/theme/app_theme.dart';

class ArticleDetailPage extends ConsumerWidget {
  final String articleId;
  const ArticleDetailPage({required this.articleId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(articleDetailProvider(articleId));

    return detailAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, st) => Scaffold(
        appBar: AppBar(
          title: const Text('Article'),
          backgroundColor: AppColors.greenFill,
        ),
        body: Center(child: Text('Erreur : $e')),
      ),
      data: (article) => Scaffold(
        appBar: AppBar(
          title: Text(article.title, style: AppTextStyles.headline),
          backgroundColor: AppColors.greenFill,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Titre
                Text(
                  article.title,
                  style: AppTextStyles.title.copyWith(fontSize: 24),
                ),
                const SizedBox(height: 16),
                // Contenu
                Text(
                  article.content,
                  style: AppTextStyles.subtitle.copyWith(fontSize: 16, height: 1.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
