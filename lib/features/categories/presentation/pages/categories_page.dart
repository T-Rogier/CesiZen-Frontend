import 'dart:async';
import 'package:cesizen_frontend/app/theme/app_theme.dart';
import 'package:cesizen_frontend/features/categories/presentation/providers/category_notifier.dart';
import 'package:cesizen_frontend/features/categories/presentation/widgets/category_card.dart';
import 'package:cesizen_frontend/shared/widgets/inputs/app_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CategoriesPage extends ConsumerStatefulWidget {
  const CategoriesPage({super.key});
  @override
  ConsumerState<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends ConsumerState<CategoriesPage> {
  final _scrollCtrl = ScrollController();
  String _name = '';
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _scrollCtrl.addListener(() {
      if (_scrollCtrl.position.pixels >= _scrollCtrl.position.maxScrollExtent - 100) {
        ref.read(categoryProvider.notifier).loadMore();
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(categoryProvider.notifier).searchCategories();
    });
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String val) {
    setState(() => _name = val);
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      ref.read(categoryProvider.notifier).searchCategories(name: _name);
    });
  }

  @override
  Widget build(BuildContext context) {
    final asyncCat = ref.watch(categoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catégories'),
        backgroundColor: AppColors.greenFill,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: AppSearchBar(
              hintText: 'Rechercher une catégorie...',
              value: _name,
              onChanged: _onSearchChanged,
            ),
          ),
          Expanded(
            child: asyncCat.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error:   (e,_) => Center(child: Text('Erreur: $e')),
              data:    (state) {
                if (state.categories.isEmpty) {
                  return const Center(child: Text('Aucune catégorie trouvée'));
                }
                return ListView.builder(
                  controller: _scrollCtrl,
                  itemCount: state.categories.length + (state.hasMore ? 1 : 0),
                  itemBuilder: (_, i) {
                    if (i < state.categories.length) {
                      final cat = state.categories[i];
                      return CategoryCard(
                        category: cat,
                        onTap: () {
                          context.push('/category/${cat.id}');
                        },
                        onDelete: () {
                          ref.read(categoryProvider.notifier).deleteCategory(cat.id);
                        },
                      );
                    }
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
