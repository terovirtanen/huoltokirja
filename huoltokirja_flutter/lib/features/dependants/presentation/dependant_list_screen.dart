import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../domain/models/dependant.dart';
import '../../../shared/widgets/state_widgets.dart';
import 'dependant_editor_dialog.dart';

class DependantListScreen extends ConsumerWidget {
  const DependantListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dependantsAsync = ref.watch(dependantListControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Huoltokirja')),
      body: dependantsAsync.when(
        data: (dependants) {
          if (dependants.isEmpty) {
            return EmptyState(
              title: 'Ei riippuvaisia viela',
              subtitle: 'Lisaa ensimmainen riippuvainen aloittaaksesi.',
              action: FilledButton.icon(
                onPressed: () => _showAddDialog(context, ref),
                icon: const Icon(Icons.person_add),
                label: const Text('Lisaa riippuvainen'),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () =>
                ref.read(dependantListControllerProvider.notifier).refresh(),
            child: ListView.builder(
              itemCount: dependants.length,
              itemBuilder: (context, index) {
                final dependant = dependants[index];
                return Card(
                  child: ListTile(
                    title: Text(dependant.listTitle),
                    subtitle: Text('ID: ${dependant.id}'),
                    onTap: () => context.push('/dependants/${dependant.id}'),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'edit') {
                          _showEditDialog(context, ref, dependant);
                        }
                        if (value == 'delete') {
                          _deleteDependant(context, ref, dependant.id!);
                        }
                      },
                      itemBuilder: (context) => const [
                        PopupMenuItem(value: 'edit', child: Text('Muokkaa')),
                        PopupMenuItem(value: 'delete', child: Text('Poista')),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
        error: (error, _) => ErrorState(
          error: error,
          onRetry: () =>
              ref.read(dependantListControllerProvider.notifier).refresh(),
        ),
        loading: () => const LoadingState(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddDialog(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('Lisaa'),
      ),
    );
  }

  Future<void> _showAddDialog(BuildContext context, WidgetRef ref) async {
    final result = await showDialog<Dependant>(
      context: context,
      builder: (_) => const DependantEditorDialog(),
    );
    if (result != null) {
      await ref.read(dependantListControllerProvider.notifier).create(result);
    }
  }

  Future<void> _showEditDialog(
    BuildContext context,
    WidgetRef ref,
    Dependant dependant,
  ) async {
    final result = await showDialog<Dependant>(
      context: context,
      builder: (_) => DependantEditorDialog(initial: dependant),
    );
    if (result != null) {
      await ref
          .read(dependantListControllerProvider.notifier)
          .updateDependant(result);
    }
  }

  Future<void> _deleteDependant(
    BuildContext context,
    WidgetRef ref,
    int dependantId,
  ) async {
    await ref
        .read(dependantListControllerProvider.notifier)
        .delete(dependantId);
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Riippuvainen poistettu')));
    }
  }
}
