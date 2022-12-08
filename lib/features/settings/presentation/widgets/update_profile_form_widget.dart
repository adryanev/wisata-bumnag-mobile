import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisatabumnag/features/authentication/presentation/widgets/auth_text_field.dart';
import 'package:wisatabumnag/features/settings/presentation/blocs/profile_form/profile_form_bloc.dart';
import 'package:wisatabumnag/l10n/l10n.dart';
import 'package:wisatabumnag/shared/domain/formz/name_input.dart';
import 'package:wisatabumnag/shared/domain/formz/nik_input.dart';
import 'package:wisatabumnag/shared/domain/formz/phone_input.dart';

class UpdateProfileFormWidget extends StatefulWidget {
  const UpdateProfileFormWidget({super.key});

  @override
  State<UpdateProfileFormWidget> createState() =>
      _UpdateProfileFormWidgetState();
}

class _UpdateProfileFormWidgetState extends State<UpdateProfileFormWidget> {
  late ProfileFormBloc _profileFormBloc;
  late TextEditingController _nameController;
  late TextEditingController _nikController;
  late TextEditingController _phoneController;
  final _profileKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _profileFormBloc = BlocProvider.of(context)
      ..add(
        const ProfileFormEvent.started(),
      );
    _nameController = TextEditingController()..addListener(_nameChanged);
    _nikController = TextEditingController()..addListener(_nikChanged);
    _phoneController = TextEditingController()..addListener(_phoneChanged);
  }

  @override
  Widget build(BuildContext context) {
    final i10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _PhotoProfile(),
        SizedBox(
          height: 24.h,
        ),
        Form(
          key: _profileKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              BlocConsumer<ProfileFormBloc, ProfileFormState>(
                listenWhen: (previous, current) =>
                    previous.nameInput != current.nameInput,
                listener: (context, state) {
                  debugPrint(state.nameInput.value);
                  _nameController.value = TextEditingValue(
                    text: state.nameInput.value,
                    selection: TextSelection.fromPosition(
                      TextPosition(
                        offset: state.nameInput.value.length,
                      ),
                    ),
                  );
                },
                buildWhen: (previous, current) =>
                    previous.nameInput != current.nameInput,
                builder: (context, state) {
                  return AuthTextField(
                    key: const Key('nama_lengkap_form'),
                    label: 'Nama',
                    hint: 'Nama Lengkap',
                    controller: _nameController,
                    validator: state.nameInput.displayError?.errorMessage(i10n),
                  );
                },
              ),
              SizedBox(
                height: 8.h,
              ),
              BlocConsumer<ProfileFormBloc, ProfileFormState>(
                listenWhen: (previous, current) =>
                    previous.nikInput != current.nikInput,
                listener: (context, state) {
                  _nikController.value = TextEditingValue(
                    text: state.nikInput.value,
                    selection: TextSelection.fromPosition(
                      TextPosition(
                        offset: state.nikInput.value.length,
                      ),
                    ),
                  );
                },
                buildWhen: (previous, current) =>
                    previous.nikInput != current.nikInput,
                builder: (context, state) {
                  return AuthTextField(
                    key: const Key('nik_form'),
                    label: 'Nik',
                    hint: 'NIK',
                    controller: _nikController,
                    validator: state.nikInput.displayError?.description(),
                  );
                },
              ),
              SizedBox(
                height: 8.h,
              ),
              BlocConsumer<ProfileFormBloc, ProfileFormState>(
                listenWhen: (previous, current) =>
                    previous.phoneInput != current.phoneInput,
                listener: (context, state) {
                  _phoneController.value = TextEditingValue(
                    text: state.phoneInput.value,
                    selection: TextSelection.fromPosition(
                      TextPosition(
                        offset: state.phoneInput.value.length,
                      ),
                    ),
                  );
                },
                buildWhen: (previous, current) =>
                    previous.phoneInput != current.phoneInput,
                builder: (context, state) {
                  return AuthTextField(
                    key: const Key('phoneNumber_form'),
                    label: 'Nomor Telepon',
                    hint: '628xxxxxxxxx',
                    controller: _phoneController,
                    validator: state.phoneInput.displayError?.description(),
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

  void _phoneChanged() {
    _profileFormBloc
        .add(ProfileFormEvent.phoneNumberChanged(_phoneController.text));
  }

  void _nikChanged() {
    _profileFormBloc.add(ProfileFormEvent.nikChanged(_nikController.text));
  }

  void _nameChanged() {
    _profileFormBloc.add(ProfileFormEvent.nameChanged(_nameController.text));
  }
}

class _PhotoProfile extends StatelessWidget {
  const _PhotoProfile();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileFormBloc, ProfileFormState>(
      builder: (context, state) {
        return InkWell(
          onTap: () {
            context
                .read<ProfileFormBloc>()
                .add(const ProfileFormEvent.avatarPressed());
          },
          child: Container(
            padding: const EdgeInsets.all(4),
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 60,
                  child: BlocBuilder<ProfileFormBloc, ProfileFormState>(
                    // buildWhen: (p, c) => p.photoUrl != c.photoUrl,
                    builder: (context, state) {
                      if (state.avatar != null) {
                        if (state.avatarInput != null) {
                          return CircleAvatar(
                            backgroundColor: Colors.transparent,
                            backgroundImage: FileImage(state.avatarInput!),
                            radius: 60,
                          );
                        } else {
                          return CircleAvatar(
                            backgroundColor: Colors.black87.withAlpha(80),
                            backgroundImage:
                                CachedNetworkImageProvider(state.avatar!),
                            radius: 60,
                          );
                        }
                      } else {
                        return CircleAvatar(
                          backgroundColor: Colors.transparent,
                          backgroundImage: CachedNetworkImageProvider(
                            state.avatar ?? 'https://picsum.photos/200',
                          ),
                          radius: 60,
                        );
                      }
                    },
                  ),
                ),
                Text(
                  'Ganti avatar',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (state.status == ProfileFormStatus.updateAvatar) ...[
                  const CircularProgressIndicator.adaptive()
                ]
              ],
            ),
          ),
        );
      },
    );
  }
}
