import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:wisatabumnag/app/router/app_router.dart';
import 'package:wisatabumnag/core/extensions/context_extensions.dart';
import 'package:wisatabumnag/core/presentation/mixins/failure_message_handler.dart';
import 'package:wisatabumnag/core/utils/colors.dart';
import 'package:wisatabumnag/core/utils/dimensions.dart';
import 'package:wisatabumnag/features/authentication/presentation/widgets/auth_text_field.dart';
import 'package:wisatabumnag/features/review/presentation/blocs/review_form/review_form_bloc.dart';
import 'package:wisatabumnag/injector.dart';
import 'package:wisatabumnag/shared/orders/domain/entities/order.entity.dart';
import 'package:wisatabumnag/shared/widgets/wisata_button.dart';

class ReviewFormPage extends StatefulWidget {
  const ReviewFormPage({
    super.key,
    required this.orderDetail,
  });
  final OrderDetail orderDetail;

  @override
  State<ReviewFormPage> createState() => _ReviewFormPageState();
}

class _ReviewFormPageState extends State<ReviewFormPage>
    with FailureMessageHandler {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late ReviewFormBloc _reviewFormBloc;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController()
      ..addListener(() {
        _reviewFormBloc.add(
          ReviewFormEvent.titleChanged(
            _titleController.text,
          ),
        );
      });
    _descriptionController = TextEditingController()
      ..addListener(() {
        _reviewFormBloc.add(
          ReviewFormEvent.descriptionChanged(
            _descriptionController.text,
          ),
        );
      });
    _reviewFormBloc = getIt<ReviewFormBloc>()
      ..add(
        ReviewFormEvent.started(widget.orderDetail),
      );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _reviewFormBloc.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _reviewFormBloc,
      child: BlocListener<ReviewFormBloc, ReviewFormState>(
        listener: (context, state) {
          state.addReviewOrFailureOption.fold(
            () => null,
            (either) => either.fold(
              (l) => handleFailure(context, l),
              (r) => context
                ..displayFlash('Berhasil menambahkan Ulasan')
                ..goNamed(AppRouter.home),
            ),
          );
        },
        child: Scaffold(
          appBar: AppBar(
            title: BlocSelector<ReviewFormBloc, ReviewFormState, bool>(
              selector: (state) {
                return state.isLoading;
              },
              builder: (context, state) {
                return state
                    ? const Text('Memuat...')
                    : Text(
                        widget.orderDetail.orderableType == r'App\Models\Ticket'
                            ? widget.orderDetail.orderableDetail.name
                            : widget.orderDetail.orderableName,
                      );
              },
            ),
          ),
          body: SafeArea(
            child: BlocSelector<ReviewFormBloc, ReviewFormState, bool>(
              selector: (state) {
                return state.isLoading;
              },
              builder: (context, state) {
                if (state) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                }
                return SingleChildScrollView(
                  child: Padding(
                    padding: Dimension.aroundPadding,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: 24.h),
                          Text(
                            'Penilaian',
                            style: TextStyle(
                              color: AppColor.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 16.sp,
                            ),
                          ),
                          SizedBox(
                            height: 8.h,
                          ),
                          BlocBuilder<ReviewFormBloc, ReviewFormState>(
                            builder: (context, state) {
                              return RatingBar.builder(
                                minRating: 1,
                                itemPadding:
                                    EdgeInsets.symmetric(horizontal: 4.w),
                                itemBuilder: (context, _) => const Icon(
                                  Icons.star_rounded,
                                  color: Colors.amber,
                                ),
                                onRatingUpdate: (rating) =>
                                    context.read<ReviewFormBloc>().add(
                                          ReviewFormEvent.ratingChanged(
                                            rating.toInt(),
                                          ),
                                        ),
                              );
                            },
                          ),
                          SizedBox(
                            height: 16.h,
                          ),
                          Text(
                            'Judul',
                            style: TextStyle(
                              color: AppColor.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 16.sp,
                            ),
                          ),
                          SizedBox(
                            height: 8.h,
                          ),
                          SizedBox(
                            height: 8.h,
                          ),
                          BlocBuilder<ReviewFormBloc, ReviewFormState>(
                            builder: (context, state) {
                              return AuthTextField(
                                controller: _titleController,
                                validator: _titleController.text.isEmpty
                                    ? 'Judul tidak boleh kosong'
                                    : null,
                              );
                            },
                          ),
                          SizedBox(
                            height: 16.h,
                          ),
                          Text(
                            'Deskripsi',
                            style: TextStyle(
                              color: AppColor.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 16.sp,
                            ),
                          ),
                          SizedBox(
                            height: 16.h,
                          ),
                          BlocBuilder<ReviewFormBloc, ReviewFormState>(
                            builder: (context, state) {
                              return AuthTextField(
                                controller: _descriptionController,
                                maxLine: 9,
                                keyboardType: TextInputType.multiline,
                                validator: _descriptionController.text.isEmpty
                                    ? 'Deskripsi tidak boleh kosong'
                                    : null,
                              );
                            },
                          ),
                          SizedBox(
                            height: 16.h,
                          ),
                          Text(
                            'Tambahkan foto',
                            style: TextStyle(
                              color: AppColor.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 16.sp,
                            ),
                          ),
                          SizedBox(
                            height: 16.h,
                          ),
                          SizedBox(
                            height: 80.h,
                            child: BlocBuilder<ReviewFormBloc, ReviewFormState>(
                              builder: (context, state) {
                                return ListView.builder(
                                  itemCount: state.media.length + 1,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    if (index == state.media.length) {
                                      return InkWell(
                                        onTap: () {
                                          context.read<ReviewFormBloc>().add(
                                                const ReviewFormEvent
                                                    .photoPicked(),
                                              );
                                        },
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(4.r),
                                          child: DottedBorder(
                                            color: AppColor.darkGrey,
                                            child: Container(
                                              height: 80.w,
                                              width: 75.w,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(4.r),
                                              ),
                                              child: Icon(
                                                Icons.camera_alt_outlined,
                                                color: AppColor.darkGrey,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                    return Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            showDialog<dynamic>(
                                              context: context,
                                              builder: (_) => Dialog(
                                                child: Image.file(
                                                  File(
                                                    state.media[index].path,
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12.r),
                                            child: SizedBox(
                                              height: 80.w,
                                              width: 75.w,
                                              child: Image.file(
                                                File(
                                                  state.media[index].path,
                                                ),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 8.w,
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
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
            child: BlocBuilder<ReviewFormBloc, ReviewFormState>(
              builder: (context, state) {
                return state.isSubmitting
                    ? WisataButton.loading()
                    : WisataButton.primary(
                        onPressed: !state.isValid
                            ? null
                            : () {
                                context.read<ReviewFormBloc>().add(
                                      const ReviewFormEvent.sendButtonPressed(),
                                    );
                              },
                        text: 'Kirim Ulasan',
                      );
              },
            ),
          ),
        ),
      ),
    );
  }
}
