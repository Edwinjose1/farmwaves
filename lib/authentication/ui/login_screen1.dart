import 'package:flutter/material.dart';
import 'package:flutter_application_0/authentication/bloc/auth_bloc.dart';
import 'package:flutter_application_0/constants/pallete.dart';
import 'package:flutter_application_0/home/ui/original_home_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    // Delay the display of the main content for one second
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Brightness brightness = Theme.of(context).brightness;
    Color textColor = brightness == Brightness.dark ? Colors.white : Colors.black;

    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.black,
              content: Text(
                state.error,
                style: const TextStyle(color: Colors.white),
              ),
            ));
          }

          if (state is AuthSuccess) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const Home1()),
              (route) => false,
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ListView(
                  children: [
                    const SizedBox(height: 30),
                    Image.asset(
                      "assets/images/quickmed.png",
                      height: 70,
                      width: 250,
                    ),
                    const SizedBox(height: 50),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Enter phone number to send one time Password',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    const SizedBox(height: 30),
                    TextField(
                      style: TextStyle(color: textColor),
                      controller: usernameController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.person,
                          color: Colors.grey,
                        ),
                        labelText: "Email",
                        enabledBorder: myInputBorder(),
                        floatingLabelStyle: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                        ),
                        focusedBorder: myFocusBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      style: TextStyle(color: textColor),
                      controller: passwordController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: Colors.grey,
                        ),
                        labelText: "Password",
                        alignLabelWithHint: false,
                        enabledBorder: myInputBorder(),
                        floatingLabelStyle: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                        ),
                        focusedBorder: myFocusBorder(),
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 20),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                      child: ElevatedButton(
                        onPressed: () {
                          String email =
                              usernameController.text.trim();
                          String password =
                              passwordController.text.trim();

                          context.read<AuthBloc>().add(
                            AuthLoginRequested(
                              email: email,
                              password: password,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets
                              .symmetric(vertical: 15.0),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(30.0),
                          ),
                          backgroundColor: Pallete.greenColor,
                        ),
                        child: const Text(
                          'Log in',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/goog.png',
                          height: 30,
                          width: 30,
                        ),
                        const SizedBox(width: 30),
                        const Text(
                          'Continue with Google',
                          style: TextStyle(
                            fontSize: 20,
                            letterSpacing: 1.2,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 80),
                    const Text(
                      'By continuing, you agree to our Terms of Service and Privacy Policy. © 2024',
                      style: TextStyle(
                        color: Color.fromARGB(255, 116, 114, 114),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  OutlineInputBorder myInputBorder() {
    return OutlineInputBorder(
      borderSide: const BorderSide(
        style: BorderStyle.solid,
        color: Color.fromARGB(255, 193, 190, 190),
        width: 1.3,
      ),
      borderRadius: BorderRadius.circular(30.0),
    );
  }

  OutlineInputBorder myFocusBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(30.0),
      borderSide: const BorderSide(
        style: BorderStyle.solid,
        color: Color.fromARGB(255, 193, 190, 190),
        width: 1.3,
      ),
    );
  }
}