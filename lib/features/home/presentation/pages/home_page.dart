import 'package:flutter/material.dart';

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
        ]),
      ),
    );
  }
}