import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/theme/app_theme.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _onboardingPages = [
    const OnboardingData(
      title: 'Welcome to MyShop',
      description: 'Your one-stop destination for all your shopping needs. Discover a world of products at your fingertips.',
      icon: Icons.shopping_bag_outlined,
    ),
    const OnboardingData(
      title: 'Smart Search & Filter',
      description: 'Find exactly what you are looking for with our advanced search and intuitive filtering options.',
      icon: Icons.search_rounded,
    ),
    const OnboardingData(
      title: 'Fast & Secure Delivery',
      description: 'Enjoy lightning-fast shipping and secure payment methods for a worry-free shopping experience.',
      icon: Icons.local_shipping_outlined,
    ),
  ];

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    // Persist state for production, but Splash currently ignores it for testing
    await prefs.setBool('hasSeenOnboarding', true); 
    if (mounted) {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Skip Button at Top Right
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextButton(
                  onPressed: _completeOnboarding,
                  child: const Text(
                    'Skip',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
            
            // PageView for Onboarding Pages
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _onboardingPages.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return OnboardingContent(
                    data: _onboardingPages[index],
                  );
                },
              ),
            ),
            
            // Bottom Section: Indicator and Action Button
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // 3-step Page Indicator showing current progress
                  Text(
                    '${_currentPage + 1} / ${_onboardingPages.length}',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _onboardingPages.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(right: 8),
                        height: 10,
                        width: _currentPage == index ? 24 : 10,
                        decoration: BoxDecoration(
                          color: _currentPage == index ? AppColors.primary : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),
                  
                  // Next / Get Started Button
                  ElevatedButton(
                    onPressed: () {
                      if (_currentPage == _onboardingPages.length - 1) {
                        _completeOnboarding();
                      } else {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: const Size(double.infinity, 56),
                      elevation: 0,
                    ),
                    child: Text(
                      _currentPage == _onboardingPages.length - 1 ? 'Get Started' : 'Next',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingData {
  final String title;
  final String description;
  final IconData icon;

  const OnboardingData({
    required this.title,
    required this.description,
    required this.icon,
  });
}

class OnboardingContent extends StatelessWidget {
  final OnboardingData data;

  const OnboardingContent({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration Placeholder (Responsive Icon container)
          Flexible(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 280, maxHeight: 280),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  data.icon,
                  size: 120,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 48),
          
          // Headline
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 16),
          
          // Description
          Text(
            data.description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
