import 'package:flutter/material.dart';
import 'package:spark_talk_reddit/signin_button.dart';

import 'constants.dart';
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
            Constants.logo,
            height: 40
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              'Skip',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 30,),
          Text('Dive into anything', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
          const SizedBox(height: 30,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(Constants.loginEmote,height: 400,),
          ),
          const SizedBox(height: 30,),
          const SignInButton()
        ],
      ),
    );
  }
}