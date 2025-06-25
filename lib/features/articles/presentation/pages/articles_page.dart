import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/articles_notifier.dart';
import '../widgets/article_card.dart';
import 'package:cesizen_frontend/shared/widgets/inputs/app_search_bar.dart';
import 'package:go_router/go_router.dart';

class ArticlesPage extends ConsumerStatefulWidget {
  const ArticlesPage({super.key});

  @override
  ConsumerState<ArticlesPage> createState() => _ArticlesPageState();
}

class _ArticlesPageState extends ConsumerState<ArticlesPage> {
  String searchQuery = '';
  Timer? _debounce;
  final _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollCtrl.addListener(() {
      if (_scrollCtrl.position.pixels >=
          _scrollCtrl.position.maxScrollExtent - 100) {
        ref.read(articlesProvider.notifier).loadMore();
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(articlesProvider.notifier).loadMore();
    });
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String val) {
    setState(() => searchQuery = val);
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      ref.read(articlesProvider.notifier).searchArticles(query: searchQuery);
    });
  }

  @override
  Widget build(BuildContext context) {
    final asyncState = ref.watch(articlesProvider);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            AppSearchBar(
              hintText: 'Rechercher un article…',
              value: searchQuery,
              onChanged: _onSearchChanged,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: asyncState.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e,_) => Center(child: Text('Erreur: $e')),
                data: (state) {
                  if (state.articles.isEmpty) {
                    return const Center(
                      child: Text(
                        'Aucun article trouvé',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    );
                  }
                  return ListView.builder(
                    controller: _scrollCtrl,
                    itemCount: state.articles.length + (state.hasMore ? 1 : 0),
                    itemBuilder: (ctx, i) {
                      if (i < state.articles.length) {
                        final art = state.articles[i];
                        return ArticleCard(
                          article: art,
                          onTap: () => context.push('/article/${art.id}'),
                        );
                      } else {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                    },
                  );
                }
              ),
            ),
          ],
        ),
      ),
    );
  }
}