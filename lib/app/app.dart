import 'package:cesizen_frontend/app/theme/app_theme.dart';
import 'package:flutter/material.dart';
import '../core/router/router.dart';

class CesiZenApp extends StatelessWidget {
  const CesiZenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'CesiZen',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: goRouter(context),
    );
  }
}