import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:wisatabumnag/core/extensions/context_extensions.dart';
import 'package:wisatabumnag/core/presentation/mixins/failure_message_handler.dart';
import 'package:wisatabumnag/core/utils/colors.dart';
import 'package:wisatabumnag/core/utils/dimensions.dart';
import 'package:wisatabumnag/features/settings/presentation/blocs/profile_form/profile_form_bloc.dart';
import 'package:wisatabumnag/features/settings/presentation/widgets/update_profile_form_widget.dart';
import 'package:wisatabumnag/injector.dart';
import 'package:wisatabumnag/shared/widgets/wisata_button.dart';

class UpdateProfilePage extends StatelessWidget with FailureMessageHandler {
  const UpdateProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ProfileFormBloc>(),
      child: BlocListener<ProfileFormBloc, ProfileFormState>(
        listener: (context, state) {
          state.fetchProfileOrFailureOption.fold(
            () => null,
            (either) => either.fold(
              (l) => handleFailure(context, l),
              (r) => null,
            ),
          );
          state.updateAvatarOrFailureOption.fold(
            () => null,
            (either) => either.fold(
              (l) => handleFailure(context, l),
              (r) => null,
            ),
          );
          state.updateProfileOrFailureOption.fold(
            () => null,
            (either) => either.fold(
              (l) => handleFailure(context, l),
              (r) => context
                ..displayFlash('Berhasil mengubah profil')
                ..pop(),
            ),
          );
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Ubah Profil'),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: Dimension.aroundPadding,
                child: const UpdateProfileFormWidget(),
              ),
            ),
          ),
          bottomSheet: Container(
            height: 80.h,
            width: 1.sw,
            padding: Dimension.aroundPadding,
            decoration: const BoxDecoration(
              color: AppColor.white,
              boxShadow: [
                BoxShadow(
                  blurStyle: BlurStyle.outer,
                  spreadRadius: 1,
                  blurRadius: 1,
                  color: AppColor.borderStroke,
                ),
              ],
            ),
            child: BlocBuilder<ProfileFormBloc, ProfileFormState>(
              builder: (context, state) {
                return state.status == ProfileFormStatus.updateProfile
                    ? WisataButton.loading()
                    : WisataButton.primary(
                        onPressed: !state.isValid
                            ? null
                            : () {
                                context.read<ProfileFormBloc>().add(
                                      const ProfileFormEvent
                                          .updateButtonPressed(),
                                    );
                              },
                        text: 'Ubah Profil',
                      );
              },
            ),
          ),
        ),
      ),
    );
  }
}
