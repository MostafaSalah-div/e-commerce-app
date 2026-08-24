import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../cubit/orders_cubit.dart';
import '../cubit/orders_state.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/theme/app_theme.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
        // Improved back navigation logic
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/main');
            }
          },
        ),
      ),
      body: BlocBuilder<OrdersCubit, OrdersState>(
        builder: (context, state) {
          if (state is OrdersLoading) {
            return const LoadingWidget();
          } else if (state is OrdersError) {
            return Center(child: Text(state.message));
          } else if (state is OrdersLoaded) {
            if (state.orders.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.receipt_long, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text('You haven\'t placed any orders yet.', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.orders.length,
              itemBuilder: (context, index) {
                final order = state.orders[index];
                // Safe check for ID length
                final String displayId = order.id.length > 6 
                    ? order.id.substring(order.id.length - 6) 
                    : order.id;

                return Card(
                  // FIX: Use EdgeInsets.only instead of invalid constructor
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ExpansionTile(
                    title: Text('Order #$displayId'),
                    subtitle: Text(DateFormat('MMM dd, yyyy HH:mm').format(order.date)),
                    trailing: Text(
                      '\$${order.total.toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Items:', style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            ...order.items.map((item) => Padding(
                              padding: const EdgeInsets.only(bottom: 4.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('${item.quantity}x ${item.product.title}'),
                                  Text('\$${(item.product.price * item.quantity).toStringAsFixed(2)}'),
                                ],
                              ),
                            )),
                            const Divider(),
                            Text('Status: ${order.status}', style: const TextStyle(fontWeight: FontWeight.w500)),
                            Text('Payment: ${order.paymentMethod}'),
                            Text('Address: ${order.address}'),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
