import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cesizen_frontend/features/auth/presentation/providers/auth_provider.dart';
import 'package:cesizen_frontend/features/auth/domain/auth_state.dart';

class DebugPage extends ConsumerWidget {
  const DebugPage({super.key});

  Future<Map<String, Object>> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final map = <String, Object>{};

    for (final key in prefs.getKeys()) {
      map[key] = prefs.get(key) ?? 'null';
    }

    return map;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Debug Auth'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: FutureBuilder<Map<String, Object>>(
          future: _loadPrefs(),
          builder: (context, snapshot) {
            final prefs = snapshot.data;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('🔐 Auth status: ${auth.value?.status.name ?? 'inconnu'}'),
                const SizedBox(height: 8),
                Text('✅ Authenticated: ${auth.value?.status == AuthStatus.authenticated}'),
                const SizedBox(height: 8),
                Text('🧾 Token: ${auth.value?.session?.accessToken ?? 'Aucun'}'),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 8),
                const Text('📦 SharedPreferences:'),
                if (prefs != null)
                  ...prefs.entries.map((e) => Text('${e.key}: ${e.value}'))
                else
                  const Text('Chargement...'),
              ],
            );
          },
        ),
      ),
    );
  }
}
