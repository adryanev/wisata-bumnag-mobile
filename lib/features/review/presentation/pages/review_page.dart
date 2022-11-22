import 'package:flutter/material.dart';
import 'package:wisatabumnag/features/review/presentation/pages/review_history_page.dart';
import 'package:wisatabumnag/features/review/presentation/pages/review_waiting_page.dart';
import 'package:wisatabumnag/shared/widgets/custom_tab_view.dart';

class ReviewPage extends StatelessWidget {
  const ReviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final category = ['Menunggu diulas', 'Riwayat'];
    final widget = [const ReviewWaitingPage(), const ReviewHistoryPage()];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ulasan'),
      ),
      body: SafeArea(
        child: CustomTabView(
          itemCount: category.length,
          tabBuilder: (context, index) {
            return Tab(text: category[index]);
          },
          pageBuilder: (context, index) {
            return widget[index];
          },
        ),
      ),
    );
  }
}
