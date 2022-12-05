import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisatabumnag/features/authentication/presentation/widgets/auth_text_field.dart';
import 'package:wisatabumnag/features/settings/presentation/blocs/password_form/password_form_bloc.dart';
import 'package:wisatabumnag/l10n/l10n.dart';
import 'package:wisatabumnag/shared/domain/formz/password_confirmation_input.dart';
import 'package:wisatabumnag/shared/domain/formz/password_input.dart';

class UpdatePasswordFormWidget extends StatefulWidget {
  const UpdatePasswordFormWidget({super.key});

  @override
  State<UpdatePasswordFormWidget> createState() =>
      _UpdatePasswordFormWidgetState();
}

class _UpdatePasswordFormWidgetState extends State<UpdatePasswordFormWidget> {
  late PasswordFormBloc _profileFormBloc;
  late TextEditingController _oldPasswordController;
  late TextEditingController _newPasswordController;
  late TextEditingController _confirmPasswordController;
  final _profileKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _profileFormBloc = BlocProvider.of(context);
    _oldPasswordController = TextEditingController()
      ..addListener(_oldPasswordChanged);
    _newPasswordController = TextEditingController()
      ..addListener(_newPasswordChanged);
    _confirmPasswordController = TextEditingController()
      ..addListener(_confirmPasswordChanged);
  }

  @override
  Widget build(BuildContext context) {
    final i10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Form(
          key: _profileKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              BlocConsumer<PasswordFormBloc, PasswordFormState>(
                listenWhen: (previous, current) =>
                    previous.oldPassword != current.oldPassword,
                listener: (context, state) {
                  debugPrint(state.oldPassword.value);
                  _oldPasswordController.value = TextEditingValue(
                    text: state.oldPassword.value,
                    selection: TextSelection.fromPosition(
                      TextPosition(
                        offset: state.oldPassword.value.length,
                      ),
                    ),
                  );
                },
                buildWhen: (previous, current) =>
                    previous.oldPassword != current.oldPassword,
                builder: (context, state) {
                  return AuthTextField(
                    key: const Key('oldPassword_form'),
                    label: 'Password Lama',
                    hint: 'Password Lama',
                    controller: _oldPasswordController,
                    isPassword: true,
                    validator:
                        state.oldPassword.displayError?.errorMessage(i10n),
                  );
                },
              ),
              SizedBox(
                height: 8.h,
              ),
              BlocConsumer<PasswordFormBloc, PasswordFormState>(
                listenWhen: (previous, current) =>
                    previous.newPassword != current.newPassword,
                listener: (context, state) {
                  _newPasswordController.value = TextEditingValue(
                    text: state.newPassword.value,
                    selection: TextSelection.fromPosition(
                      TextPosition(
                        offset: state.newPassword.value.length,
                      ),
                    ),
                  );
                },
                buildWhen: (previous, current) =>
                    previous.newPassword != current.newPassword,
                builder: (context, state) {
                  return AuthTextField(
                    key: const Key('newPassword_form'),
                    label: 'Password Baru',
                    hint: 'Password Baru',
                    controller: _newPasswordController,
                    isPassword: true,
                    validator:
                        state.newPassword.displayError?.errorMessage(i10n),
                  );
                },
              ),
              SizedBox(
                height: 8.h,
              ),
              BlocConsumer<PasswordFormBloc, PasswordFormState>(
                listenWhen: (previous, current) =>
                    previous.confirmPassword != current.confirmPassword,
                listener: (context, state) {
                  _confirmPasswordController.value = TextEditingValue(
                    text: state.confirmPassword.value,
                    selection: TextSelection.fromPosition(
                      TextPosition(
                        offset: state.confirmPassword.value.length,
                      ),
                    ),
                  );
                },
                buildWhen: (previous, current) =>
                    previous.confirmPassword != current.confirmPassword,
                builder: (context, state) {
                  return AuthTextField(
                    key: const Key('confirmPassword_form'),
                    label: 'Konfirmasi Password',
                    hint: 'Konfirmasi Password',
                    controller: _confirmPasswordController,
                    isPassword: true,
                    validator:
                        state.confirmPassword.displayError?.errorMessage(i10n),
                  );
                },
              ),
              SizedBox(
                height: 80.h,
              )
            ],
          ),
        )
      ],
    );
  }

  void _confirmPasswordChanged() {
    _profileFormBloc.add(
      PasswordFormEvent.confirmationPasswordChanged(
        _confirmPasswordController.text,
      ),
    );
  }

  void _newPasswordChanged() {
    _profileFormBloc
        .add(PasswordFormEvent.newPasswordChanged(_newPasswordController.text));
  }

  void _oldPasswordChanged() {
    _profileFormBloc
        .add(PasswordFormEvent.oldPasswordChanged(_oldPasswordController.text));
  }
}
