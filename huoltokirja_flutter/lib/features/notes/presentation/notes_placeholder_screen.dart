import 'package:flutter/material.dart';

import '../../../shared/widgets/state_widgets.dart';

class NotesPlaceholderScreen extends StatelessWidget {
  const NotesPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: EmptyState(
        title: 'Notes placeholder',
        subtitle:
            'Tama naytto on korvattu dataan kytketyilla dependant-kohtaisilla note-flowlla.',
      ),
    );
  }
}
