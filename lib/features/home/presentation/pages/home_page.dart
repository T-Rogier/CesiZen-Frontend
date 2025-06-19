import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/presentation/providers/auth_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Bienvenue sur la page de d'accueil !"),
          ElevatedButton(
          onPressed: () => context.read<AuthProvider>().logout(),
            child: const Text("Déconnexion"),
          )
        ]),
      ),
    );
  }
}