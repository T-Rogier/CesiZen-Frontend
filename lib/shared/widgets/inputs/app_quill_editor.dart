import 'dart:convert';
import 'dart:io' as io show Directory, File;
import 'package:cesizen_frontend/app/theme/app_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:path/path.dart' as path;

class AppQuillEditor extends StatefulWidget {
  const AppQuillEditor({super.key});

  @override
  State<AppQuillEditor> createState() => AppQuillEditorState();
}

class AppQuillEditorState extends State<AppQuillEditor> {
  late final QuillController quillCtrl;
  late final FocusNode _editorFocusNode;
  late final ScrollController _editorScrollController;
  bool _showToolbar = false;

  @override
  void initState() {
    super.initState();
    quillCtrl = QuillController.basic(
      config: QuillControllerConfig(
        clipboardConfig: QuillClipboardConfig(
          enableExternalRichPaste: true,
          onImagePaste: (imageBytes) async {
            if (kIsWeb) return null;
            final newFileName = 'image-file-${DateTime.now().toIso8601String()}.png';
            final newPath = path.join(io.Directory.systemTemp.path, newFileName);
            final file = await io.File(newPath).writeAsBytes(imageBytes, flush: true);
            return file.path;
          },
        ),
      ),
    );
    _editorFocusNode = FocusNode();
    _editorScrollController = ScrollController();
  }

  @override
  void dispose() {
    quillCtrl.dispose();
    _editorFocusNode.dispose();
    _editorScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.greenFont),
            borderRadius: BorderRadius.circular(8),
          ),
          child: QuillEditor(
            controller: quillCtrl,
            focusNode: _editorFocusNode,
            scrollController: _editorScrollController,
            config: QuillEditorConfig(
              placeholder: "Remplissez le contenu de l'activité...",
              padding: const EdgeInsets.all(16),
              embedBuilders: [
                ...FlutterQuillEmbeds.editorBuilders(
                  imageEmbedConfig: QuillEditorImageEmbedConfig(
                    imageProviderBuilder: (context, imageUrl) {
                      // https://pub.dev/packages/flutter_quill_extensions#-image-assets
                      if (imageUrl.startsWith('assets/')) {
                        return AssetImage(imageUrl);
                      }
                      return null;
                    },
                  ),
                  videoEmbedConfig: QuillEditorVideoEmbedConfig(
                    customVideoBuilder: (videoUrl, readOnly) {
                      // To load YouTube videos https://github.com/singerdmx/flutter-quill/releases/tag/v10.8.0
                      return null;
                    },
                  ),
                ),
                TimeStampEmbedBuilder(),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            label: const Text("Barre d'outils"),
            icon: Icon(_showToolbar ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
            onPressed: () => setState(() => _showToolbar = !_showToolbar),
          ),
        ),
        if (_showToolbar)
          QuillSimpleToolbar(
            controller: quillCtrl,
            config: QuillSimpleToolbarConfig(
              embedButtons: FlutterQuillEmbeds.toolbarButtons(),
              showClipboardPaste: true,
              customButtons: [
                QuillToolbarCustomButtonOptions(
                  icon: const Icon(Icons.add_alarm_rounded),
                  onPressed: () {
                    final pos = quillCtrl.selection.extentOffset;
                    quillCtrl.document.insert(pos, TimeStampEmbed(DateTime.now().toString()));
                    quillCtrl.updateSelection(
                      TextSelection.collapsed(offset: pos + 1),
                      ChangeSource.local,
                    );
                  },
                ),
              ],
              buttonOptions: QuillSimpleToolbarButtonOptions(
                base: QuillToolbarBaseButtonOptions(
                  afterButtonPressed: () {
                    final isDesktop = {
                      TargetPlatform.linux,
                      TargetPlatform.windows,
                      TargetPlatform.macOS,
                    }.contains(defaultTargetPlatform);
                    if (isDesktop) _editorFocusNode.requestFocus();
                  },
                ),
                linkStyle: QuillToolbarLinkStyleButtonOptions(
                  validateLink: (_) => true,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class TimeStampEmbed extends Embeddable {
  const TimeStampEmbed(String value) : super(timeStampType, value);
  static const String timeStampType = 'timeStamp';

  static TimeStampEmbed fromDocument(Document doc) => TimeStampEmbed(jsonEncode(doc.toDelta().toJson()));

  Document get document => Document.fromJson(jsonDecode(data));
}

class TimeStampEmbedBuilder extends EmbedBuilder {
  @override
  String get key => TimeStampEmbed.timeStampType;

  @override
  String toPlainText(Embed node) => node.value.data as String;

  @override
  Widget build(BuildContext context, EmbedContext embedContext) {
    return Row(
      children: [const Icon(Icons.access_time_rounded), Text(embedContext.node.value.data as String)],
    );
  }
}
