import 'dart:convert';
import 'package:cesizen_frontend/app/theme/app_theme.dart';
import 'package:cesizen_frontend/features/activities/domain/full_activity.dart';
import 'package:cesizen_frontend/features/activities/presentation/providers/activity_detail_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ActivityParticipationPage extends ConsumerStatefulWidget {
  final FullActivity activity;

  const ActivityParticipationPage({
    super.key,
    required this.activity,
  });

  @override
  ActivityParticipationPageState createState() => ActivityParticipationPageState();
}

class ActivityParticipationPageState extends ConsumerState<ActivityParticipationPage> {
  late QuillController _controller;
  late final FocusNode _editorFocusNode;

  @override
  void initState() {
    super.initState();

    final raw = widget.activity.content.trim();
    late Delta delta;
    try {
      final jsonData = jsonDecode(raw) as List<dynamic>;
      delta = Delta.fromJson(jsonData);
    } catch (_) {
      delta = Delta()..insert(raw);
    }
    final ops = delta.toList();
    if (ops.isEmpty || !(ops.last.data is String && (ops.last.data as String).endsWith('\n'))) {
      delta.insert('\n');
    }

    _controller = QuillController(
      document: Document.fromDelta(delta),
      selection: const TextSelection.collapsed(offset: 0),
      readOnly: true
    );
    _editorFocusNode = FocusNode(canRequestFocus: false);
  }

  @override
  void dispose() {
    _controller.dispose();
    _editorFocusNode.dispose();
    super.dispose();
  }

  Future<void> _showProgressModal() async {
    double progress = widget.activity.progress ?? 0;
    final saved = await showDialog<bool>(
      context: context,
      builder: (context) =>
        AlertDialog(
          title: Text('Progression', style: AppTextStyles.title),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                      '${progress.toInt()} %', style: AppTextStyles.subtitle),
                  Slider(
                    value: progress,
                    min: 0,
                    max: 100,
                    divisions: 100,
                    label: '${progress.toInt()} %',
                    onChanged: (v) => setState(() => progress = v),
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Annuler', style: AppTextStyles.button.copyWith(
                  color: AppColors.black)),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Enregistrer', style: AppTextStyles.button.copyWith(
                  color: AppColors.greenFont)),
            ),
          ],
        ),
    );
    if (saved == true && mounted) {
      try {
        await ref.read(activityDetailProvider(widget.activity.id).notifier).saveProgress(progress);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Progression sauvegardée : ${progress.toInt()} %')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur lors de l'envoi de la progression : \$e")),
        );
      }
      context.go('/activity/${widget.activity.id}');
    }
  }

  Future<bool> _onWillPop() async {
    await _showProgressModal();
    return false;
  }

  @override
  Widget build(BuildContext context) {

    return PopScope(
      child: Scaffold(
        backgroundColor: AppColors.greenBackground,
        appBar: AppBar(
          backgroundColor: AppColors.greenFont,
          title: Text(widget.activity.title, style: AppTextStyles.headline),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: AppColors.black),
            onPressed: () async => await _onWillPop(),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: QuillEditor(
                    controller: _controller,
                    focusNode: _editorFocusNode,
                    scrollController: ScrollController(),
                    config: QuillEditorConfig(
                      scrollable: true,
                      autoFocus: false,
                      expands: false,
                      padding: EdgeInsets.zero,
                      showCursor: false,
                      enableInteractiveSelection: false,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _showProgressModal,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.yellowPrincipal,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
                  ),
                  child: Text('Terminer', style: AppTextStyles.button.copyWith(color: AppColors.black)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
