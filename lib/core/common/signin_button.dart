import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/controller/auth_controller.dart';
import '../constant/constants.dart';

class SignInButton extends ConsumerWidget {
  final bool isFromLogin;

  const SignInButton({super.key, this.isFromLogin = true});

  void signInWithGoogle(BuildContext context, WidgetRef ref) {
    ref.read(authControllerProvider.notifier).signInWithGoogle(context);
    print('sign in clicked');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: ElevatedButton.icon(
        onPressed: () => signInWithGoogle(context, ref),
        icon: Image.asset(Constants.google, width: 35),
        label: Text(
          'Continue with Google',
          style: TextStyle(fontSize: 17, color: Colors.black),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[50],
          minimumSize: const Size(double.infinity, 55),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}
