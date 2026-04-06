import 'package:flutter/material.dart';

import '../../../shared/widgets/state_widgets.dart';

class SchedulersPlaceholderScreen extends StatelessWidget {
  const SchedulersPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: EmptyState(
        title: 'Schedulers placeholder',
        subtitle:
            'Tama naytto on korvattu dataan kytketyilla dependant-kohtaisilla scheduler-flowlla.',
      ),
    );
  }
}
