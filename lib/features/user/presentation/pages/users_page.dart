import 'dart:async';

import 'package:cesizen_frontend/app/theme/app_theme.dart';
import 'package:cesizen_frontend/features/user/presentation/providers/user_notifier.dart';
import 'package:cesizen_frontend/features/user/presentation/widgets/user_card.dart';
import 'package:cesizen_frontend/features/user/presentation/widgets/users_filters_dropdown.dart';
import 'package:cesizen_frontend/shared/widgets/inputs/app_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class UsersPage extends ConsumerStatefulWidget {
  const UsersPage({super.key});

  @override
  ConsumerState<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends ConsumerState<UsersPage> {
  bool _showFilters = false;
  String searchQuery = '';
  final _scrollCtrl = ScrollController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _scrollCtrl.addListener(() {
      if (_scrollCtrl.position.pixels >=
          _scrollCtrl.position.maxScrollExtent - 100) {
        ref.read(userProvider.notifier).loadMore();
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(userProvider.notifier).loadMore();
    });
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String val) {
    setState(() => searchQuery = val);
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      ref.read(userProvider.notifier).searchUsers(query: searchQuery);
    });
  }

  @override
  Widget build(BuildContext context) {
    final asyncState = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Utilisateurs'),
        backgroundColor: AppColors.greenFill,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: AppSearchBar(
                    hintText: 'Rechercher un utilisateur...',
                    value: searchQuery,
                    onChanged: _onSearchChanged,
                  ),
                ),
                const SizedBox(width: 14),
                IconButton(
                  onPressed: () =>
                      setState(() => _showFilters = !_showFilters),
                  icon: Icon(
                    Icons.filter_list,
                    color: AppColors.greenFont,
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.greenFill,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: AppColors.greenFont),
                    ),
                    padding: const EdgeInsets.all(12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            asyncState.when(
              loading: () => const Expanded(
                child: Center(child: Text('')),
              ),
              error: (e, _) => Expanded(child: Center(child: Text('Erreur : $e'))),
              data: (state) {
                return Column( children: [
                  if (_showFilters)
                    UsersFiltersDropdown(
                      isVisible: _showFilters,
                      onToggle: () => setState(() => _showFilters = !_showFilters),
                      selectedRole: state.selectedRole,
                      disabled: state.disabled,

                      onRoleChanged: (role) {
                        ref.read(userProvider.notifier).searchUsers(
                          query: searchQuery,
                          role: role,
                          disabled: state.disabled,
                        );
                      },
                      onDisabledChanged: (disabled) {
                        ref.read(userProvider.notifier).searchUsers(
                          query: searchQuery,
                          role: state.selectedRole,
                          disabled: disabled,
                        );
                      },
                    ),
                ],);
              },
            ),
            const SizedBox(height: 12),
            Expanded(
              child: asyncState.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error:   (e,_) => Center(child: Text('Erreur : $e')),
                data:    (state) {
                  if (state.users.isEmpty) {
                    return const Center(
                      child: Text(
                        'Aucun utilisateur trouvé',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    );
                  }
                  return ListView.builder(
                    controller: _scrollCtrl,
                    itemCount: state.users.length + (state.hasMore ? 1 : 0),
                    itemBuilder: (context, i) {
                      if (i < state.users.length) {
                        final user = state.users[i];
                        return UserCard(
                          user: user,
                          onTap: () {
                            context.push('/user/${user.id}');
                          },
                          onDisable: () {
                            ref.read(userProvider.notifier).disableUser(user.id);
                          },
                        );
                      }
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
