import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cesizen_frontend/app/theme/app_theme.dart';
import 'package:cesizen_frontend/core/router/router.dart';

class CesiZenApp extends ConsumerWidget {
  const CesiZenApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'CesiZen',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: router,
      localizationsDelegates: [
        FlutterQuillLocalizations.delegate,
      ],
    );
  }
}
