import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'pay_event.dart';
part 'pay_state.dart';

class PayBloc extends Bloc<PayEvent, PayState> {
  PayBloc() : super(PayInitial()) {
    on<PayEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
