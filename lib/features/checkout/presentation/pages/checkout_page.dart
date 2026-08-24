import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../cubit/checkout_cubit.dart';
import '../cubit/checkout_state.dart';
import '../../../cart/presentation/cubit/cart_cubit.dart';
import '../../../cart/presentation/cubit/cart_state.dart';
import '../../../orders/presentation/cubit/orders_cubit.dart';
import '../../../orders/data/models/order_model.dart';
import '../../../../core/theme/app_theme.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: BlocConsumer<CheckoutCubit, CheckoutState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage!)),
            );
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              _buildStepper(state.step),
              Expanded(
                child: _buildStepContent(context, state),
              ),
              _buildBottomBar(context, state),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStepper(CheckoutStep step) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          _stepIndicator('Address', step.index >= 0),
          _stepDivider(step.index >= 1),
          _stepIndicator('Payment', step.index >= 1),
          _stepDivider(step.index >= 2),
          _stepIndicator('Review', step.index >= 2),
        ],
      ),
    );
  }

  Widget _stepIndicator(String label, bool active) {
    return Column(
      children: [
        CircleAvatar(
          radius: 12,
          backgroundColor: active ? AppColors.primary : Colors.grey[300],
          child: Icon(Icons.check, size: 16, color: active ? Colors.white : Colors.transparent),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12, color: active ? AppColors.primary : Colors.grey)),
      ],
    );
  }

  Widget _stepDivider(bool active) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 20),
        color: active ? AppColors.primary : Colors.grey[300],
      ),
    );
  }

  Widget _buildStepContent(BuildContext context, CheckoutState state) {
    switch (state.step) {
      case CheckoutStep.address:
        return _buildAddressStep(context, state);
      case CheckoutStep.payment:
        return _buildPaymentStep(context, state);
      case CheckoutStep.review:
        return _buildReviewStep(context, state);
      default:
        return const SizedBox();
    }
  }

  Widget _buildAddressStep(BuildContext context, CheckoutState state) {
    final addresses = ['Home: 123 Main St, Springfield', 'Work: 456 Office Blvd, Metropolis'];
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: addresses.length,
      itemBuilder: (context, index) {
        return RadioListTile<String>(
          title: Text(addresses[index]),
          value: addresses[index],
          groupValue: state.address,
          onChanged: (val) => context.read<CheckoutCubit>().setAddress(val!),
        );
      },
    );
  }

  Widget _buildPaymentStep(BuildContext context, CheckoutState state) {
    final methods = ['Credit Card', 'PayPal', 'Cash on Delivery'];
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: methods.length,
      itemBuilder: (context, index) {
        return RadioListTile<String>(
          title: Text(methods[index]),
          value: methods[index],
          groupValue: state.paymentMethod,
          onChanged: (val) => context.read<CheckoutCubit>().setPaymentMethod(val!),
        );
      },
    );
  }

  Widget _buildReviewStep(BuildContext context, CheckoutState state) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, cartState) {
        if (cartState is! CartLoaded) return const SizedBox();
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Shipping Address', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(state.address ?? ''),
              const SizedBox(height: 16),
              const Text('Payment Method', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(state.paymentMethod ?? ''),
              const SizedBox(height: 16),
              const Text('Order Items', style: TextStyle(fontWeight: FontWeight.bold)),
              ...cartState.items.map((item) => ListTile(
                title: Text(item.product.title),
                trailing: Text('\$${(item.product.price * item.quantity).toStringAsFixed(2)}'),
                subtitle: Text('Qty: ${item.quantity}'),
              )),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total Amount', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text('\$${cartState.total.toStringAsFixed(2)}', 
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomBar(BuildContext context, CheckoutState state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 5)]),
      child: Row(
        children: [
          if (state.step != CheckoutStep.address)
            Expanded(
              child: OutlinedButton(
                onPressed: () => context.read<CheckoutCubit>().previousStep(),
                child: const Text('Back'),
              ),
            ),
          if (state.step != CheckoutStep.address) const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                if (state.step == CheckoutStep.review) {
                  _placeOrder(context, state);
                } else {
                  context.read<CheckoutCubit>().nextStep();
                }
              },
              child: Text(state.step == CheckoutStep.review ? 'Place Order' : 'Next'),
            ),
          ),
        ],
      ),
    );
  }

  void _placeOrder(BuildContext context, CheckoutState state) {
    final cartState = context.read<CartCubit>().state;
    if (cartState is CartLoaded) {
      final order = OrderModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        date: DateTime.now(),
        items: cartState.items,
        total: cartState.total,
        address: state.address!,
        paymentMethod: state.paymentMethod!,
        status: 'Processing',
      );
      context.read<OrdersCubit>().createOrder(order);
      context.read<CartCubit>().clearCart();
      context.read<CheckoutCubit>().resetCheckout();
      context.go('/orders');
    }
  }
}
