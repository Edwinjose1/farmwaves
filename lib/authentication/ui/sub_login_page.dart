import 'package:flutter/material.dart';
import 'package:flutter_application_0/authentication/bloc/auth_bloc.dart';


import 'package:flutter_application_0/widgets/login_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../widgets/gradient_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error)));
          }

          // if (state is AuthSuccess) {
          //   Navigator.pushAndRemoveUntil(
          //       context,
          //       MaterialPageRoute(builder: (context) => HomePage()),
          //       (route) => false);
          // }
          // TODO: implement listener
        },
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Image.asset('assets/images/signin_balls.png'),
                const Text(
                  'Sign in',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 50,
                  ),
                ),
                const SizedBox(height: 100),
                const SizedBox(height: 15),
                LoginField(
                  hintText: 'Email',
                  controller: emailController,
                ),
                const SizedBox(height: 15),
                LoginField(
                  hintText: 'Password',
                  controller: passwordController,
                ),
                const SizedBox(height: 20),
                GradientButton(
                  onPressed: () {
                    String email = emailController.text.trim();
                    String password = passwordController.text.trim();
                    print('Email: $email');
                    print('Password: $password');

                    // Dispatch the login event with the entered credentials
                    context.read<AuthBloc>().add(AuthLoginRequested(
                          email: email,
                          password: password,
                        ));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
