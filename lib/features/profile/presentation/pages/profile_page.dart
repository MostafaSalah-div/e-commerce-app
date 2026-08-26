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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(
              Icons.logout,
              color: colorScheme.onSurface,
            ),
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
                    backgroundColor: colorScheme.primary,
                    backgroundImage: user.image.isNotEmpty
                        ? NetworkImage(user.image)
                        : null,
                    child: user.image.isEmpty
                        ? const Icon(
                            Icons.person,
                            size: 60,
                            color: Colors.white,
                          )
                        : null,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '${user.firstName} ${user.lastName}',
                    style: textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    user.email,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 30),
                  _buildProfileItem(
                    context,
                    icon: Icons.shopping_bag,
                    title: 'My Orders',
                    onTap: () => context.push('/orders'),
                    colorScheme: colorScheme,
                  ),
                  _buildProfileItem(
                    context,
                    icon: Icons.favorite,
                    title: 'My Wishlist',
                    onTap: () => context.push('/wishlist'),
                    colorScheme: colorScheme,
                  ),
                  _buildProfileItem(
                    context,
                    icon: Icons.location_on,
                    title: 'Shipping Address',
                    onTap: () {},
                    colorScheme: colorScheme,
                  ),
                  _buildProfileItem(
                    context,
                    icon: Icons.payment,
                    title: 'Payment Methods',
                    onTap: () {},
                    colorScheme: colorScheme,
                  ),
                  _buildProfileItem(
                    context,
                    icon: Icons.settings,
                    title: 'Settings',
                    onTap: () => context.push('/settings'),
                    colorScheme: colorScheme,
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

  Widget _buildProfileItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required ColorScheme colorScheme,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(
          icon,
          color: colorScheme.onSurface,
        ),
        title: Text(
          title,
          style: TextStyle(color: colorScheme.onSurface),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: colorScheme.onSurfaceVariant,
        ),
        onTap: onTap,
      ),
    );
  }
}
