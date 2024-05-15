
import 'package:flutter/material.dart';
import 'package:flutter_application_0/authentication/bloc/auth_bloc.dart';
import 'package:flutter_application_0/authentication/ui/login_screen1.dart';
import 'package:flutter_application_0/constants/pallete.dart';
import 'package:flutter_application_0/home/ui/original_home_screen.dart';
import 'package:flutter_application_0/profile/profileScreen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignupScreen extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  SignupScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    final Brightness brightness = Theme.of(context).brightness;
    Color textColor =
        brightness == Brightness.dark ? Colors.white : Colors.black;

    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            print("enthaaaaaa");
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.black,
              content: Text(
                state.error,
                style: const TextStyle(color: Colors.white),
              ),
            ));
          }

          if (state is SignupSuccess) {
             print("sucess");
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const Home1()),
              (route) => false,
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              SizedBox(height: 0),
              Center(
                child: Image.asset(
                  "assets/images/quickmed.png",
                  height: 80,
                  width: 200,
                  alignment: Alignment.center,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Sign Up',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              
              Text(
                'Create an account to get started',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              TextFormField(
                style: TextStyle(color: textColor),
                controller: usernameController,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.person,
                    color: Colors.grey,
                  ),
                  labelText: "Username",
                  enabledBorder: myInputBorder(),
                  focusedBorder: myFocusBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                style: TextStyle(color: textColor),
                controller: emailController,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.email,
                    color: Colors.grey,
                  ),
                  labelText: "Email",
                  enabledBorder: myInputBorder(),
                  focusedBorder: myFocusBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                style: TextStyle(color: textColor),
                controller: passwordController,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.lock,
                    color: Colors.grey,
                  ),
                  labelText: "Password",
                  enabledBorder: myInputBorder(),
                  focusedBorder: myFocusBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: 10),
              TextFormField(
                style: TextStyle(color: textColor),
                controller: confirmPasswordController,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.lock,
                    color: Colors.grey,
                  ),
                  labelText: "Confirm Password",
                  enabledBorder: myInputBorder(),
                  focusedBorder: myFocusBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  String username = usernameController.text.trim();
                  String email = emailController.text.trim();
                  String password = passwordController.text.trim();
                  String confirmPassword =
                      confirmPasswordController.text.trim();

                  context.read<AuthBloc>().add(
                        AuthSignupRequested(
                          username: username,
                          email: email,
                          password: password,
                          // confirmPassword: confirmPassword,
                        ),
                      );
                      
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  backgroundColor: Pallete.greenColor,
                ),
                child: const Text(
                  'Sign up',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 10),
              SignInButton(
                Buttons.Google,
                onPressed: () {
                  _handleGoogleSignIn(context);
                },
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account?',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    child: Text(
                      'Log in',
                      style: TextStyle(
                        color: Pallete.greenColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              // Text(
              //   'By signing up, you agree to our Terms of Service and Privacy Policy. © 2024',
              //   style: TextStyle(
              //     color: Color.fromARGB(255, 116, 114, 114),
              //   ),
              //   textAlign: TextAlign.center,
              // ),
            ],
          ),
        ),
      ),
    );
  }

  OutlineInputBorder myInputBorder() {
    return OutlineInputBorder(
      borderSide: BorderSide(
        style: BorderStyle.solid,
        color: Color.fromARGB(255, 193, 190, 190),
        width: 1.3,
      ),
      borderRadius: BorderRadius.circular(30),
    );
  }

  OutlineInputBorder myFocusBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: BorderSide(
        style: BorderStyle.solid,
        color: Color.fromARGB(255, 193, 190, 190),
        width: 1.3,
      ),
    );
  }

  Future<void> _handleGoogleSignIn(BuildContext context) async {
    final GoogleSignIn _googleSignIn = GoogleSignIn();

    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleSignInAccount.authentication;
        final String? accessToken = googleAuth.accessToken;
        final String? idToken = googleAuth.idToken;

        // Once you have the tokens, you can pass them to your authentication bloc or handler
        // For example:
        // authBloc.add(GoogleSignInEvent(accessToken: accessToken, idToken: idToken));
      } else {
        print('Google Sign-In cancelled.');
      }
    } catch (error) {
      print('Error signing in with Google: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error signing in with Google.'),
        ),
      );
    }
  }
}
