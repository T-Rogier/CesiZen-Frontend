import 'package:cesizen_frontend/app/theme/app_theme.dart';
import 'package:cesizen_frontend/features/articles/presentation/providers/article_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/menu_node.dart';
import 'package:go_router/go_router.dart';

class MenuDrawer extends ConsumerWidget {
  const MenuDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menuAsync = ref.watch(menuProvider);
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: AppColors.greenFill),
              child: Text('Arborescence', style: TextStyle(fontSize: 24, color: AppColors.greenFont)),
            ),
            Expanded(
              child: menuAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e,_) => Center(child: Text('Erreur: $e')),
                data: (menus) => ListView(
                  padding: const EdgeInsets.all(8),
                  children: menus.map((m) => _buildNode(context, m, ref)).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNode(BuildContext context, MenuNode node, WidgetRef ref) {
    return ExpansionTile(
      title: Text(node.title, style: AppTextStyles.title.copyWith(fontSize: 16)),
      children: [
        // articles
        ...node.childArticles.map((a) => ListTile(
          title: Text(a.title),
          onTap: () {
            Navigator.of(context).pop();
            context.push('/article/${a.id}');
          },
        )),
        // sous-menus
        ...node.childMenus.map((c) => Padding(
          padding: const EdgeInsets.only(left: 16),
          child: _buildNode(context, c, ref),
        )),
      ],
    );
  }
}