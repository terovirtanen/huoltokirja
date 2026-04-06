import 'package:go_router/go_router.dart';

import '../../features/dependants/presentation/dependant_detail_screen.dart';
import '../../features/dependants/presentation/dependant_list_screen.dart';
import '../../features/notes/presentation/note_editor_screen.dart';
import '../../features/schedulers/presentation/scheduler_editor_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (_, _) => const DependantListScreen(),
      routes: [
        GoRoute(
          path: 'dependants/:id',
          builder: (_, state) {
            final dependantId = int.parse(state.pathParameters['id']!);
            return DependantDetailScreen(dependantId: dependantId);
          },
          routes: [
            GoRoute(
              path: 'notes/new',
              builder: (_, state) {
                final dependantId = int.parse(state.pathParameters['id']!);
                return NoteEditorScreen(dependantId: dependantId);
              },
            ),
            GoRoute(
              path: 'notes/:noteId/edit',
              builder: (_, state) {
                final dependantId = int.parse(state.pathParameters['id']!);
                final noteId = int.parse(state.pathParameters['noteId']!);
                return NoteEditorScreen(
                  dependantId: dependantId,
                  noteId: noteId,
                );
              },
            ),
            GoRoute(
              path: 'schedulers/new',
              builder: (_, state) {
                final dependantId = int.parse(state.pathParameters['id']!);
                return SchedulerEditorScreen(dependantId: dependantId);
              },
            ),
            GoRoute(
              path: 'schedulers/:schedulerId/edit',
              builder: (_, state) {
                final dependantId = int.parse(state.pathParameters['id']!);
                final schedulerId = int.parse(
                  state.pathParameters['schedulerId']!,
                );
                return SchedulerEditorScreen(
                  dependantId: dependantId,
                  schedulerId: schedulerId,
                );
              },
            ),
          ],
        ),
      ],
    ),
  ],
);
