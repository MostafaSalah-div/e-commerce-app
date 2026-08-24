import 'package:flutter_bloc/flutter_bloc.dart';
import 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit() : super(const CheckoutState());

  void setAddress(String address) {
    emit(state.copyWith(address: address));
  }

  void setPaymentMethod(String method) {
    emit(state.copyWith(paymentMethod: method));
  }

  void nextStep() {
    if (state.step == CheckoutStep.address) {
      if (state.address == null || state.address!.isEmpty) {
        emit(state.copyWith(errorMessage: 'Please select an address'));
        return;
      }
      emit(state.copyWith(step: CheckoutStep.payment, errorMessage: null));
    } else if (state.step == CheckoutStep.payment) {
      if (state.paymentMethod == null || state.paymentMethod!.isEmpty) {
        emit(state.copyWith(errorMessage: 'Please select a payment method'));
        return;
      }
      emit(state.copyWith(step: CheckoutStep.review, errorMessage: null));
    }
  }

  void previousStep() {
    if (state.step == CheckoutStep.payment) {
      emit(state.copyWith(step: CheckoutStep.address));
    } else if (state.step == CheckoutStep.review) {
      emit(state.copyWith(step: CheckoutStep.payment));
    }
  }

  void resetCheckout() {
    emit(const CheckoutState());
  }
}
