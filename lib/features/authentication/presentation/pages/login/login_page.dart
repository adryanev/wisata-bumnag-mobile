import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:wisatabumnag/app/router/app_router.dart';
import 'package:wisatabumnag/core/utils/colors.dart';
import 'package:wisatabumnag/core/utils/dimensions.dart';
import 'package:wisatabumnag/features/authentication/presentation/blocs/login/login_bloc.dart';
import 'package:wisatabumnag/features/authentication/presentation/widgets/auth_text_field.dart';
import 'package:wisatabumnag/injector.dart';
import 'package:wisatabumnag/l10n/l10n.dart';
import 'package:wisatabumnag/shared/domain/formz/email_input.dart';
import 'package:wisatabumnag/shared/domain/formz/password_input.dart';
import 'package:wisatabumnag/shared/widgets/wisata_button.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<LoginBloc>(),
      child: Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: Padding(
            padding: Dimension.aroundPadding,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 24.h,
                  ),
                  Text(
                    'Selamat Datang',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColor.black,
                    ),
                  ),
                  Text(
                    'Silahkan Masuk',
                    style: TextStyle(
                      color: AppColor.black,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  const LoginFormWidget()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LoginFormWidget extends StatefulWidget {
  const LoginFormWidget({super.key});

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  final _loginFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController()..addListener(_onEmailChanged);
    passwordController = TextEditingController()
      ..addListener(_onPasswordChanged);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Form(
      key: _loginFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlocSelector<LoginBloc, LoginState, EmailInput>(
            selector: (state) {
              return state.emailInput;
            },
            builder: (context, state) {
              return AuthTextField(
                controller: emailController,
                hint: 'Email',
                label: 'Email',
                validator: state.displayError?.errorMessage(l10n),
              );
            },
          ),
          SizedBox(height: 16.h),
          BlocSelector<LoginBloc, LoginState, PasswordInput>(
            selector: (state) {
              return state.passwordInput;
            },
            builder: (context, state) {
              return AuthTextField(
                controller: passwordController,
                isPassword: true,
                hint: 'Password',
                label: 'Password',
                validator: state.displayError?.errorMessage(l10n),
              );
            },
          ),
          SizedBox(
            height: 8.h,
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              'Butuh bantuan masuk?',
              style: TextStyle(
                color: AppColor.primary,
                fontWeight: FontWeight.w500,
                fontSize: 12.sp,
              ),
            ),
          ),
          SizedBox(
            height: 32.h,
          ),
          SizedBox(
            width: 1.sw,
            child: WisataButton.primary(
              onPressed: _onSubmitForm,
              text: 'Masuk',
            ),
          ),
          SizedBox(
            height: 20.h,
          ),
          Align(
            child: Column(
              children: [
                Text(
                  'Belum memiliki akun?',
                  style: TextStyle(fontSize: 12.sp),
                ),
                InkWell(
                  onTap: () {
                    context.pushNamed(AppRouter.register);
                  },
                  child: Text(
                    'Daftar disini',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColor.red,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _onEmailChanged() {
    context
        .read<LoginBloc>()
        .add(LoginEvent.emailInputChanged(emailController.text));
  }

  void _onPasswordChanged() {
    context
        .read<LoginBloc>()
        .add(LoginEvent.passwordInputChanged(passwordController.text));
  }

  void _onSubmitForm() {
    if (!_loginFormKey.currentState!.validate()) return;
    context.read<LoginBloc>().add(const LoginEvent.loginButtonPressed());

    if (!mounted) return;
    FocusScope.of(context)
      ..nextFocus()
      ..unfocus();
  }
}
