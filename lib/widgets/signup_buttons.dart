import 'package:flutter/material.dart';
import 'package:cardioroad/shared/themes/app_colors.dart';

class SignUpButtons extends StatelessWidget {
  final VoidCallback onCreateAccountPressed;
  final VoidCallback onGoogleSignUpPressed;

  const SignUpButtons({
    super.key,
    required this.onCreateAccountPressed,
    required this.onGoogleSignUpPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
          onPressed: onCreateAccountPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'Criar Conta',
            style: TextStyle(fontSize: 18, color: AppColors.white),
          ),
        ),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: onGoogleSignUpPressed,
          icon: const Icon(Icons.g_mobiledata_outlined, color: Colors.red),
          label: const Text(
            'Registar com Google',
            style: TextStyle(color: Colors.black54),
          ),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            side: const BorderSide(color: AppColors.greyText),
          ),
        ),
      ],
    );
  }
}
