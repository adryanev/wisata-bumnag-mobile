import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wisatabumnag/core/utils/constants.dart';
import 'package:wisatabumnag/shared/flash/presentation/blocs/cubit/flash_cubit.dart';

extension BuildContextX on BuildContext {
  void displayFlash(String message) {
    read<FlashCubit>().displayFlash(message);
  }

  void showSnackbar({
    required String message,
    void Function()? action,
    String? actionText,
  }) {
    rootScaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        // action: action == null && actionText != null
        //     ? null
        //     : SnackBarAction(label: actionText!, onPressed: action!),
      ),
    );
  }

  ThemeData get theme => Theme.of(this);
}
