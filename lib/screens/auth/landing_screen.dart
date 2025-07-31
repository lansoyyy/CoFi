import 'package:cofi/screens/auth/login_screen.dart';
import 'package:cofi/screens/auth/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../utils/colors.dart';

import '../../widgets/button_widget.dart';
import '../../widgets/text_widget.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.black,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                // Logo
                Center(
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 125,
                    height: 125,
                    fit: BoxFit.contain,
                  ),
                ),

                // Headline
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget(
                      text: 'Find Cafes',
                      fontSize: 48,
                      color: Colors.grey[300]!,
                      align: TextAlign.center,
                      isBold: true,
                    ),
                    TextWidget(
                      text: 'you love',
                      fontSize: 48,
                      color: Colors.grey[300]!,
                      align: TextAlign.center,
                      isBold: true,
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                // Social Login Buttons
                _buildSocialButton(
                  icon: FontAwesomeIcons.google,
                  text: 'Continue with Google',
                  backgroundColor: Colors.white,
                  textColor: Colors.black,
                  iconColor: Colors.red,
                ),
                const SizedBox(height: 16),
                _buildSocialButton(
                  icon: FontAwesomeIcons.facebook,
                  text: 'Continue with Facebook',
                  backgroundColor: Colors.white,
                  textColor: Colors.black,
                  iconColor: const Color(0xFF1877F2),
                ),
                const SizedBox(height: 16),
                _buildSocialButton(
                  icon: FontAwesomeIcons.apple,
                  text: 'Continue with Apple',
                  backgroundColor: Colors.white,
                  textColor: Colors.black,
                  iconColor: Colors.black,
                ),
                const SizedBox(height: 32),
                // Separator
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 1,
                        color: Colors.grey[300],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextWidget(
                        text: 'or',
                        fontSize: 16,
                        color: Colors.grey[300],
                        align: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 1,
                        color: Colors.grey[300],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                // Create Account Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ButtonWidget(
                    radius: 100,
                    label: 'Create a free account',
                    fontSize: 16,
                    color: Colors.red[700]!,
                    textColor: Colors.white,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignupScreen(),
                        ),
                      );
                      // Handle create account
                    },
                  ),
                ),
                const SizedBox(height: 24),
                // Login Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextWidget(
                      text: 'Already have an account? ',
                      fontSize: 14,
                      color: Colors.grey[300],
                      align: TextAlign.center,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                        // Handle login navigation
                      },
                      child: TextWidget(
                        text: 'Log in',
                        fontSize: 14,
                        color: Colors.white,
                        align: TextAlign.center,
                        isBold: true,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String text,
    required Color backgroundColor,
    required Color textColor,
    required Color iconColor,
  }) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        color: backgroundColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            // Handle social login
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                FaIcon(
                  icon,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 35),
                TextWidget(
                  text: text,
                  fontSize: 16,
                  color: Colors.white,
                  align: TextAlign.start,
                  isBold: false,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
