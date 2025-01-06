import 'package:flutter/material.dart';

import '../../../../core/theme/app_palate.dart';
import '../widgets/auth_field.dart';
import '../widgets/auth_gradient_button.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Sign Up.",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
              AuthField(hintText: 'Name', controller: nameController),
              SizedBox(height: 30,),
              AuthField(hintText: 'Email', controller: emailController),
              SizedBox(height: 30,),
              AuthField(hintText: 'Password',controller: passwordController,isObscureText: true,),
              SizedBox(height: 30,),
              AuthGradientButton(buttonText: 'Sign Up', onPressed: (){}),
              RichText(
                text: TextSpan(
                  text: 'Already have an account? ',
                  style: Theme.of(context).textTheme.titleMedium,
                  children: [
                    TextSpan(
                      text: 'Sign In',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(
                        color: AppPallete.gradient2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
