import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'package_order_event.dart';
part 'package_order_state.dart';
part 'package_order_bloc.freezed.dart';

@injectable
class PackageOrderBloc extends Bloc<PackageOrderEvent, PackageOrderState> {
  PackageOrderBloc() : super(_Initial()) {
    on<PackageOrderEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
