import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../../../../core/widgets/loading_widget.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          context.go('/main');
        } else if (state is Unauthenticated) {
          context.go('/login');
        }
      },
      child: const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shopping_cart, size: 100, color: Colors.blue),
              SizedBox(height: 20),
              Text(
                'E-Commerce App',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              LoadingWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
