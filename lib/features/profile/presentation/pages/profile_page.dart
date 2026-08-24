import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';
import '../../../../core/widgets/loading_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthCubit>().logout();
              context.go('/login');
            },
          ),
        ],
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const LoadingWidget();
          } else if (state is ProfileError) {
            return Center(child: Text(state.message));
          } else if (state is ProfileLoaded) {
            final user = state.user;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(user.image),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '${user.firstName} ${user.lastName}',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    user.email,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 30),
                  _buildProfileItem(
                    icon: Icons.shopping_bag,
                    title: 'My Orders',
                    onTap: () => context.push('/orders'),
                  ),
                  _buildProfileItem(
                    icon: Icons.favorite,
                    title: 'My Wishlist',
                    onTap: () {
                      // Handled by Main Page navigation usually, but can push
                    },
                  ),
                  _buildProfileItem(
                    icon: Icons.location_on,
                    title: 'Shipping Address',
                    onTap: () {},
                  ),
                  _buildProfileItem(
                    icon: Icons.payment,
                    title: 'Payment Methods',
                    onTap: () {},
                  ),
                  _buildProfileItem(
                    icon: Icons.settings,
                    title: 'Settings',
                    onTap: () {},
                  ),
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildProfileItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).primaryColor),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
