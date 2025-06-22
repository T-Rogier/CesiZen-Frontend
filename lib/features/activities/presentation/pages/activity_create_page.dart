import 'dart:convert';

import 'package:cesizen_frontend/app/theme/app_theme.dart';
import 'package:cesizen_frontend/shared/widgets/inputs/app_quill_editor.dart';
import 'package:cesizen_frontend/features/activities/domain/create_activity_request.dart';
import 'package:cesizen_frontend/features/activities/presentation/providers/providers.dart';
import 'package:cesizen_frontend/features/activities/presentation/widgets/custom_filter_chip.dart';
import 'package:cesizen_frontend/features/categories/presentation/providers/category_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ActivityCreatePage extends ConsumerStatefulWidget {
  const ActivityCreatePage({super.key});

  @override
  ConsumerState<ActivityCreatePage> createState() => _ActivityCreatePageState();
}

class _ActivityCreatePageState extends ConsumerState<ActivityCreatePage> {
  final _formKey = GlobalKey<FormState>();
  final _editorKey = GlobalKey<AppQuillEditorState>();
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _thumbCtrl = TextEditingController();
  TimeOfDay? _duration;
  bool _activated = true;
  final List<String> _selectedCategories = [];
  String? _selectedType;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _thumbCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDuration() async {
    final t = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 0, minute: 10),
    );
    if (t != null) setState(() => _duration = t);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final isoDuration =
        '${_duration!.hour.toString().padLeft(2,'0')}:'
        '${_duration!.minute.toString().padLeft(2,'0')}:00';

    final delta = _editorKey.currentState!.quillCtrl.document.toDelta();
    final contentJson = jsonEncode(delta.toJson());

    final dto = CreateActivityRequest(
      title: _titleCtrl.text,
      description: _descCtrl.text,
      content: contentJson,
      thumbnailImageLink: _thumbCtrl.text,
      estimatedDuration: isoDuration,
      activated: _activated,
      categories: _selectedCategories,
      type: _selectedType!,
    );

    try {
      final repo = ref.read(activityRepositoryProvider);
      await repo.createActivity(dto);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Activité créée avec succès')),
        );
        context.pop();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur : $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final catsAsync = ref.watch(categoriesProvider);
    final typesAsync = ref.watch(activityTypesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Créer une activité'),
        backgroundColor: AppColors.greenFont,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 32, 16, 60),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title
              TextFormField(
                controller: _titleCtrl,
                decoration: const InputDecoration(labelText: 'Titre'),
                validator: (v) => v?.isEmpty == true ? 'Requis' : null,
              ),
              const SizedBox(height: 12),

              // Description
              TextFormField(
                controller: _descCtrl,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
                validator: (v) => v?.isEmpty == true ? 'Requis' : null,
              ),
              const SizedBox(height: 12),

              // Content (WYSIWYG)
              const Text('Contenu'),
              const SizedBox(height: 6),
              AppQuillEditor(key: _editorKey),
              const SizedBox(height: 12),

              // Thumbnail URL
              TextFormField(
                controller: _thumbCtrl,
                decoration: const InputDecoration(labelText: 'Image (URL)'),
                validator: (v) => v?.isEmpty == true ? 'Requis' : null,
              ),
              const SizedBox(height: 12),

              // Duration
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _duration == null
                          ? 'Durée estimée'
                          : '${_duration!.hour.toString().padLeft(2,'0')}:'
                          '${_duration!.minute.toString().padLeft(2,'0')}',
                    ),
                  ),
                  TextButton(
                    onPressed: _pickDuration,
                    child: const Text('Sélectionner'),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Activated
              SwitchListTile(
                title: const Text('Activé'),
                value: _activated,
                onChanged: (v) => setState(() => _activated = v),
              ),
              const SizedBox(height: 12),

              // Categories (multi-select chips)
              catsAsync.when(
                data: (cats) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Catégories'),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: cats.map((c) {
                        return CustomFilterChip(
                          label: c.name,
                          selected: _selectedCategories.contains(c.name),
                          onSelected: (yes) {
                            setState(() {
                              if (yes) {
                                _selectedCategories.add(c.name);
                              } else {
                                _selectedCategories.remove(c.name);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
                loading: () => const CircularProgressIndicator(),
                error: (e, _) => Text('Erreur : $e'),
              ),
              const SizedBox(height: 30),

              // Type (dropdown)
              typesAsync.when(
                data: (types) => DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Type'),
                  items: types
                      .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                      .toList(),
                  value: _selectedType,
                  onChanged: (v) => setState(() => _selectedType = v),
                  validator: (v) => v == null ? 'Requis' : null,
                ),
                loading: () => const CircularProgressIndicator(),
                error: (e, _) => Text('Erreur : $e'),
              ),
              const SizedBox(height: 24),

              // Submit
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.yellowPrincipal,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32)),
                ),
                child: const Text('Créer', style: AppTextStyles.button),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
