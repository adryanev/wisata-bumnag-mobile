import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:wisatabumnag/core/presentation/mixins/failure_message_handler.dart';
import 'package:wisatabumnag/core/utils/colors.dart';
import 'package:wisatabumnag/core/utils/dimensions.dart';
import 'package:wisatabumnag/features/authentication/presentation/blocs/forgot_password/forgot_password_bloc.dart';
import 'package:wisatabumnag/features/authentication/presentation/widgets/auth_text_field.dart';
import 'package:wisatabumnag/injector.dart';
import 'package:wisatabumnag/l10n/l10n.dart';
import 'package:wisatabumnag/shared/domain/formz/email_input.dart';
import 'package:wisatabumnag/shared/widgets/general_dialog.dart';
import 'package:wisatabumnag/shared/widgets/wisata_button.dart';

class ForgotPasswordPage extends StatelessWidget with FailureMessageHandler {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ForgotPasswordBloc>(),
      child: BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
        listener: (context, state) {
          state.forgotOrFailureOption.fold(
            () => null,
            (a) => a.fold(
              (l) => handleFailure(context, l),
              (r) => showDialog<dynamic>(
                barrierDismissible: false,
                context: context,
                builder: (_) => GeneralDialog.success(
                  title: 'Sukses',
                  description: 'Silahkan cek kotak masuk email '
                      'untuk mereset password akun Anda',
                  confirmText: 'Selesai',
                  onConfirm: () {
                    Navigator.pop(context);
                    context.pop();
                  },
                ),
              ),
            ),
          );
        },
        child: Scaffold(
          appBar: AppBar(),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: Dimension.aroundPadding,
                child: const ForgotPasswordWidget(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ForgotPasswordWidget extends StatefulWidget {
  const ForgotPasswordWidget({super.key});

  @override
  State<ForgotPasswordWidget> createState() => _ForgotPasswordWidgetState();
}

class _ForgotPasswordWidgetState extends State<ForgotPasswordWidget> {
  late ForgotPasswordBloc _forgotPasswordBloc;
  late TextEditingController _emailController;
  @override
  void initState() {
    super.initState();
    _forgotPasswordBloc = BlocProvider.of(context);
    _emailController = TextEditingController()
      ..addListener(() {
        _forgotPasswordBloc
            .add(ForgotPasswordEvent.emailChanged(_emailController.text));
      });
  }

  @override
  Widget build(BuildContext context) {
    final i10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: .01.sh,
        ),
        Text(
          'Butuh bantuan masuk?',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: AppColor.black,
            fontSize: 20.sp,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'Silahkan masukkan email yang telah didaftarkan',
          style: TextStyle(
            color: AppColor.black,
            fontSize: 14.sp,
          ),
        ),
        SizedBox(height: 32.h),
        BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
          builder: (context, state) {
            return AuthTextField(
              label: 'Email',
              hint: 'Masukkan Email',
              controller: _emailController,
              validator: state.emailInput.displayError?.errorMessage(i10n),
            );
          },
        ),
        SizedBox(height: 24.h),
        BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
          builder: (context, state) {
            return SizedBox(
              height: 48.h,
              child: state.isSubmitting
                  ? WisataButton.loading()
                  : WisataButton.primary(
                      onPressed: state.isValid
                          ? () {
                              context.read<ForgotPasswordBloc>().add(
                                    const ForgotPasswordEvent
                                        .sendButtonPressed(),
                                  );
                            }
                          : null,
                      text: 'Lanjut',
                    ),
            );
          },
        )
      ],
    );
  }
}
