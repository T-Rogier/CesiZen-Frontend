import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Accueil CesiZen")),
      body: const Center(
        child: Text("Bienvenue sur l'application de gestion du stress !"),
      ),
    );
  }
}