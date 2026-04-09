import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/providers.dart';
import '../../../core/l10n/app_localizations_ext.dart';
import '../../../domain/models/note.dart';
import '../../../shared/widgets/app_menu_button.dart';
import '../../../shared/widgets/state_widgets.dart';
import '../../dependants/presentation/dependant_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView(
          controller: _pageController,
          onPageChanged: (index) => setState(() => _currentPage = index),
          children: const [DependantListScreen(), _AllNotesPage()],
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 12,
          child: IgnorePointer(
            child: SafeArea(
              top: false,
              child: Center(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.surface.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        2,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: _currentPage == index ? 18 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _currentPage == index
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.outlineVariant,
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AllNotesPage extends ConsumerWidget {
  const _AllNotesPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final allNotesAsync = ref.watch(allNotesFeedProvider);
    final dateFormat = DateFormat('yyyy-MM-dd');

    return Scaffold(
      drawer: const AppMenuDrawer(),
      appBar: AppBar(
        title: Text(l10n.allNotesTitle),
        leading: const AppMenuButton(),
      ),
      body: allNotesAsync.when(
        loading: () => const LoadingState(),
        error: (error, _) => ErrorState(
          error: error,
          onRetry: () => ref.invalidate(allNotesFeedProvider),
        ),
        data: (items) {
          if (items.isEmpty) {
            return EmptyState(
              title: l10n.allNotesEmptyTitle,
              subtitle: l10n.allNotesEmptySubtitle,
            );
          }

          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(allNotesFeedProvider),
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final subtitleLines = <String>[
                  dateFormat.format(item.note.noteDate),
                  l10n.targetNameLabel(item.dependant.name),
                  _noteTypeLabel(context, item.note.type),
                  if (item.note.body.trim().isNotEmpty) item.note.body.trim(),
                ];

                return Card(
                  child: ListTile(
                    title: Text(item.note.title),
                    subtitle: Text(subtitleLines.join('\n')),
                    onTap: item.note.id == null || item.dependant.id == null
                        ? null
                        : () => context.push(
                            '/dependants/${item.dependant.id}/notes/${item.note.id}/edit',
                          ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  String _noteTypeLabel(BuildContext context, NoteType type) {
    final l10n = context.l10n;
    return switch (type) {
      NoteType.plain => l10n.plainNote,
      NoteType.service => l10n.serviceNote,
      NoteType.inspection => l10n.inspectionNote,
    };
  }
}
