import 'package:equatable/equatable.dart';

enum CheckoutStep { address, payment, review, confirmation }

class CheckoutState extends Equatable {
  final CheckoutStep step;
  final String? address;
  final String? paymentMethod;
  final String? errorMessage;

  const CheckoutState({
    this.step = CheckoutStep.address,
    this.address,
    this.paymentMethod,
    this.errorMessage,
  });

  CheckoutState copyWith({
    CheckoutStep? step,
    String? address,
    String? paymentMethod,
    String? errorMessage,
  }) {
    return CheckoutState(
      step: step ?? this.step,
      address: address ?? this.address,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [step, address, paymentMethod, errorMessage];
}
