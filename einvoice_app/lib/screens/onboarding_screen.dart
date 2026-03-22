import 'package:flutter/material.dart';
import 'main_navigation.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 280,
                    width: 280,
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        colors: [const Color(0xFF34A853).withOpacity(0.15), Colors.white],
                      ),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Container(
                    height: 180,
                    width: 180,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF34A853).withOpacity(0.2),
                          blurRadius: 30,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.account_balance_wallet_rounded,
                      size: 90,
                      color: Color(0xFF34A853),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 64),
              const Text(
                'E-Invoice',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1.5,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Manage your business invoicing and billing with ease and precision.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.grey.shade600,
                    height: 1.5,
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 64,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF34A853),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const MainNavigation()),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Get Started',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward_rounded, size: 20),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
