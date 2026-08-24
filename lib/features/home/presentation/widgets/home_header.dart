import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        String name = 'Guest';
        String imageUrl = '';
        if (state is Authenticated) {
          name = state.user.firstName;
          imageUrl = state.user.image;
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Hello,',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  Text(
                    name,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              CircleAvatar(
                radius: 25,
                backgroundImage: imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
                child: imageUrl.isEmpty ? const Icon(Icons.person) : null,
              ),
            ],
          ),
        );
      },
    );
  }
}
