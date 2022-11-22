import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:wisatabumnag/app/router/app_router.dart';
import 'package:wisatabumnag/core/presentation/mixins/failure_message_handler.dart';
import 'package:wisatabumnag/features/scanner/presentation/blocs/scan_ticket/scan_ticket_bloc.dart';
import 'package:wisatabumnag/gen/assets.gen.dart';
import 'package:wisatabumnag/injector.dart';

class ScanPage extends StatelessWidget with FailureMessageHandler {
  const ScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ScanTicketBloc>(),
      child: BlocListener<ScanTicketBloc, ScanTicketState>(
        listener: (context, state) {
          if (state.isLoading) {
            showDialog<dynamic>(
              context: context,
              builder: (_) {
                return Dialog(
                  child: SizedBox(
                    height: 80.h,
                    width: 40.w,
                    child: const Center(
                      child: CircularProgressIndicator.adaptive(),
                    ),
                  ),
                );
              },
            );
          }
          state.checkedOrFailureOption.fold(
            () => null,
            (either) => either.fold(
              (l) {
                Navigator.pop(context);
                handleFailure(context, l);
              },
              (r) {
                Navigator.pop(context);
                context.pushNamed(AppRouter.scanDetail, extra: r);
              },
            ),
          );
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Scan QR'),
          ),
          body: SafeArea(
            child: Stack(
              children: [
                BlocBuilder<ScanTicketBloc, ScanTicketState>(
                  builder: (context, state) {
                    return AiBarcodeScanner(
                      canPop: false,
                      hintText: '',
                      onScan: (value) {
                        debugPrint('detected: $value');
                        context.read<ScanTicketBloc>().add(
                              ScanTicketEvent.barcodeScaned(value),
                            );
                      },
                    );
                  },
                ),
                Center(
                  child: Assets.animations.scanLottie.lottie(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
