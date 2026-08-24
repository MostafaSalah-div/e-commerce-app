import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../theme/app_theme.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SpinKitDoubleBounce(
        color: AppColors.primary,
        size: 50.0,
      ),
    );
  }
}
