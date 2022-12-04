import 'package:flutter/material.dart';
import 'package:wisatabumnag/features/settings/presentation/widgets/update_profile_form_widget.dart';

class UpdateProfilePage extends StatelessWidget {
  const UpdateProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ubah Profil'),
      ),
      body: SafeArea(child: UpdateProfileFormWidget()),
    );
  }
}
