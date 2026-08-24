import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/loading_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _controller.forward();
    _navigateToNext();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _navigateToNext() async {
    // Hold splash for 3 seconds total
    await Future.delayed(const Duration(seconds: 3));
    
    if (!mounted) return;

    // FOR DEVELOPMENT: Temporarily ignore 'hasSeenOnboarding' 
    // to test the onboarding flow every time the app starts.
    // In production, uncomment the logic below.
    
    /*
    final prefs = await SharedPreferences.getInstance();
    final bool hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;

    if (hasSeenOnboarding) {
      context.go('/login');
    } else {
      context.go('/onboarding');
    }
    */
    
    context.go('/onboarding');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Prominent App Logo
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.shopping_bag_rounded,
                      size: 100,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'MyShop',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      letterSpacing: 2.0,
                    ),
                  ),
                  const SizedBox(height: 64),
                  // Elegant loading indicator
                  const SizedBox(
                    width: 32,
                    height: 32,
                    child: LoadingWidget(),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 50,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  'YOUR SMART SHOPPING PARTNER',
                  style: TextStyle(
                    color: AppColors.textSecondary.withOpacity(0.5),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 3.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
