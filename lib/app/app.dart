import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'router.dart';

class CesiZenApp extends StatelessWidget {
  const CesiZenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'CesiZen',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      routerConfig: goRouter,
    );
  }
}