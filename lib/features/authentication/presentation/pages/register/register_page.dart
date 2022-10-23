import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:wisatabumnag/core/extensions/context_extensions.dart';
import 'package:wisatabumnag/core/presentation/mixins/failure_message_handler.dart';
import 'package:wisatabumnag/core/utils/colors.dart';
import 'package:wisatabumnag/core/utils/dimensions.dart';
import 'package:wisatabumnag/features/authentication/presentation/blocs/register/register_bloc.dart';
import 'package:wisatabumnag/features/authentication/presentation/widgets/auth_text_field.dart';
import 'package:wisatabumnag/injector.dart';
import 'package:wisatabumnag/l10n/l10n.dart';
import 'package:wisatabumnag/shared/domain/formz/email_input.dart';
import 'package:wisatabumnag/shared/domain/formz/name_input.dart';
import 'package:wisatabumnag/shared/domain/formz/password_confirmation_input.dart';
import 'package:wisatabumnag/shared/domain/formz/password_input.dart';
import 'package:wisatabumnag/shared/widgets/checkbox_form_field.dart';
import 'package:wisatabumnag/shared/widgets/wisata_button.dart';

class RegisterPage extends StatelessWidget with FailureMessageHandler {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<RegisterBloc>(),
      child: BlocListener<RegisterBloc, RegisterState>(
        listener: (context, state) {
          state.registerOrFailureOption.fold(
            () => null,
            (either) => either.fold(
              (l) => handleFailure(context, l),
              (r) {
                context
                  ..displayFlash('Berhasil mendaftarkan akun')
                  ..pop();
              },
            ),
          );
        },
        child: Scaffold(
          appBar: AppBar(),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: Dimension.aroundPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 24.h,
                    ),
                    Text(
                      'Daftar Terlebih Dahulu',
                      style: TextStyle(
                        color: AppColor.black,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    const RegisterFormWidget(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RegisterFormWidget extends StatefulWidget {
  const RegisterFormWidget({super.key});

  @override
  State<RegisterFormWidget> createState() => _RegisterFormWidgetState();
}

class _RegisterFormWidgetState extends State<RegisterFormWidget> {
  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final TextEditingController confirmPasswordController;

  final _registerFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController()
      ..addListener(() {
        context.read<RegisterBloc>().add(
              RegisterEvent.nameInputChanged(
                nameController.text,
              ),
            );
      });
    emailController = TextEditingController()
      ..addListener(() {
        context.read<RegisterBloc>().add(
              RegisterEvent.emailInputChanged(
                emailController.text,
              ),
            );
      });
    passwordController = TextEditingController()
      ..addListener(() {
        context.read<RegisterBloc>().add(
              RegisterEvent.passwordInputChanged(
                passwordController.text,
              ),
            );
      });
    confirmPasswordController = TextEditingController()
      ..addListener(() {
        context.read<RegisterBloc>().add(
              RegisterEvent.confirmPasswordInputChanged(
                confirmPasswordController.text,
              ),
            );
      });
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (!_registerFormKey.currentState!.validate()) return;

    context
        .read<RegisterBloc>()
        .add(const RegisterEvent.registerButtonPressed());

    if (!mounted) return;

    FocusScope.of(context)
      ..nextFocus()
      ..unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Form(
      key: _registerFormKey,
      child: Column(
        children: [
          BlocSelector<RegisterBloc, RegisterState, NameInput>(
            selector: (state) {
              return state.nameInput;
            },
            builder: (context, state) {
              return AuthTextField(
                key: const Key('register_name_input'),
                label: 'Nama',
                hint: 'Masukkan nama',
                controller: nameController,
                validator: state.displayError?.errorMessage(l10n),
              );
            },
          ),
          SizedBox(height: 16.h),
          BlocSelector<RegisterBloc, RegisterState, EmailInput>(
            selector: (state) {
              return state.emailInput;
            },
            builder: (context, state) {
              return AuthTextField(
                key: const Key('register_email_input'),
                hint: 'Masukkan email',
                label: 'Email',
                controller: emailController,
                validator: state.displayError?.errorMessage(l10n),
              );
            },
          ),
          SizedBox(height: 16.h),
          BlocSelector<RegisterBloc, RegisterState, PasswordInput>(
            selector: (state) {
              return state.passwordInput;
            },
            builder: (context, state) {
              return AuthTextField(
                key: const Key('register_password_input'),
                isPassword: true,
                hint: 'Masukkan password',
                label: 'Password',
                controller: passwordController,
                validator: state.displayError?.errorMessage(l10n),
              );
            },
          ),
          SizedBox(height: 16.h),
          BlocSelector<RegisterBloc, RegisterState, PasswordConfirmationInput>(
            selector: (state) {
              return state.passwordConfirmationInput;
            },
            builder: (context, state) {
              return AuthTextField(
                key: const Key('register_confirm_password_input'),
                isPassword: true,
                hint: 'Ulangi password',
                label: 'Konfirmasi Password',
                controller: confirmPasswordController,
                validator: state.displayError?.errorMessage(l10n),
              );
            },
          ),
          SizedBox(
            height: 16.h,
          ),
          BlocSelector<RegisterBloc, RegisterState, bool>(
            selector: (state) {
              return state.isAgreeToToC;
            },
            builder: (context, state) {
              return CheckboxFormField(
                title: Wrap(
                  children: [
                    Text(
                      'Saya setuju dengan ',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColor.black,
                      ),
                    ),
                    Text(
                      'Syarat dan Ketentuan',
                      style: TextStyle(
                        color: AppColor.primary,
                        fontWeight: FontWeight.w500,
                        fontSize: 12.sp,
                      ),
                    )
                  ],
                ),
                onSaved: (bool? value) {
                  if (value == null) return;
                  if (value) {
                    context
                        .read<RegisterBloc>()
                        .add(const RegisterEvent.tocAgreed());
                  } else {
                    context
                        .read<RegisterBloc>()
                        .add(const RegisterEvent.tocDisagreed());
                  }
                },
                validator: (bool? value) {
                  if (value == null || value == false) {
                    return 'Syarat dan ketentuan wajib disetujui';
                  }
                  return null;
                },
              );
            },
          ),
          SizedBox(
            height: 10.h,
          ),
          SizedBox(
            width: 1.sw,
            child: BlocBuilder<RegisterBloc, RegisterState>(
              builder: (context, state) {
                return state.status == RegisterStatus.loading
                    ? WisataButton.loading()
                    : WisataButton.primary(
                        onPressed: _onSubmit,
                        text: 'Daftar',
                      );
              },
            ),
          ),
          SizedBox(
            height: 20.h,
          ),
          Align(
            child: Column(
              children: [
                Text(
                  'Sudah memiliki akun?',
                  style: TextStyle(fontSize: 12.sp, color: AppColor.black),
                ),
                InkWell(
                  onTap: () {
                    context.pop();
                  },
                  child: Text(
                    'Silahkan Masuk',
                    style: TextStyle(
                      color: AppColor.red,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
