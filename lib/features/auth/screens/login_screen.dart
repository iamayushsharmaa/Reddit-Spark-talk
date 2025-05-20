import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spark_talk_reddit/core/common/loader.dart';
import 'package:spark_talk_reddit/core/common/signin_button.dart';
import 'package:spark_talk_reddit/features/auth/controller/auth_controller.dart';
import 'package:spark_talk_reddit/responsive/responsive.dart';

import '../../../core/constant/constants.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({Key? key}) : super(key: key);

  void signInAsGuest(WidgetRef ref, BuildContext context){
    ref.read(authControllerProvider.notifier).signInAsGuest(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLogin = ref.watch(authControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(Constants.logo, height: 40),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () => signInAsGuest(ref, context),
            child: const Text(
              'Skip',
              style: TextStyle(
                fontSize: 16,
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body:
          isLogin
              ? const Loader()
              : Column(
                children: [
                  const SizedBox(height: 30),
                  Text(
                    'Dive into anything',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(Constants.loginEmote, height: 400),
                  ),
                  const SizedBox(height: 30),
                  Responsive(child: const SignInButton()),
                ],
              ),
    );
  }
}
