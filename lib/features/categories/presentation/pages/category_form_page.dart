import 'package:cesizen_frontend/app/theme/app_theme.dart';
import 'package:cesizen_frontend/features/categories/domain/category.dart';
import 'package:cesizen_frontend/features/categories/domain/category_request.dart';
import 'package:cesizen_frontend/features/categories/presentation/providers/category_notifier.dart';
import 'package:cesizen_frontend/features/categories/presentation/providers/category_provider.dart';
import 'package:cesizen_frontend/shared/widgets/inputs/app_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CategoryFormPage extends ConsumerWidget {
  final String? categoryId;
  const CategoryFormPage({super.key, this.categoryId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncCat = categoryId != null
        ? ref.watch(categoryDetailProvider(categoryId!))
        : AsyncValue.data(null);

    return asyncCat.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e,_) => Scaffold(
        body: Center(child: Text('Erreur: \$e')),
      ),
      data: (existing) {
        return _CategoryFormBody(
          category: existing,
        );
      },
    );
  }
}

class _CategoryFormBody extends ConsumerStatefulWidget {
  final Category? category;
  const _CategoryFormBody({this.category});

  @override
  ConsumerState<_CategoryFormBody> createState() => _CategoryFormBodyState();
}


class _CategoryFormBodyState extends ConsumerState<_CategoryFormBody> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _iconCtrl;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.category?.name ?? '');
    _iconCtrl = TextEditingController(text: widget.category?.iconLink ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _iconCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);

    final dto = CategoryRequest(
      name: _nameCtrl.text,
      iconLink: _iconCtrl.text,
    );

    try {
      final repo = ref.read(categoryRepositoryProvider);
      late Category result;
      if (widget.category == null) {
        // Création
        result = await repo.createCategory(dto);
      } else {
        // Mise à jour
        result = await repo.updateCategory(widget.category!.id, dto);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Catégorie "${dto.name}" créée !')),
        );
        context.pop();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la création : $e')),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category == null ? 'Créer une catégorie' : 'Modifier la catégorie'),
        backgroundColor: AppColors.greenFont,
        foregroundColor: AppColors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 40, 16, 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppTextFormField(
                controller: _nameCtrl,
                labelText: 'Nom de la catégorie',
                validator: (v) => v?.trim().isEmpty == true ? 'Requis' : null,
              ),
              const SizedBox(height: 16),
              AppTextFormField(
                controller: _iconCtrl,
                labelText: 'URL de l’icône',
                keyboardType: TextInputType.url,
                validator: (v) {
                  if (v?.trim().isEmpty == true) return 'Requis';
                  final uri = Uri.tryParse(v!.trim());
                  if (uri == null || !uri.hasAbsolutePath) return 'URL invalide';
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isSubmitting ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.yellowPrincipal,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32)),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: AppColors.black,
                    strokeWidth: 2,
                  ),
                )
                    : Text(widget.category == null ? 'Créer' : 'Enregister', style: AppTextStyles.button),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
