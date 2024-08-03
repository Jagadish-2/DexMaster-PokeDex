import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokedex/Screens/home_screen.dart';
import 'package:pokedex/Screens/signup_screen.dart';
import 'package:pokedex/riverpod/auth_pod.dart';
import 'package:pokedex/utils/context_extension.dart';
import 'package:pokedex/widgets/custom_formfield.dart';

class LoginScreen extends ConsumerWidget {
  LoginScreen({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();


  // Email validation function
  String? validateEmail(String email) {
    if (email.isEmpty) {
      return 'Email cannot be empty';
    }
    // Simple regex for email validation
    final emailRegEx = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegEx.hasMatch(email)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  // Password validation function
  String? validatePassword(String password) {
    if (password.isEmpty) {
      return 'Password cannot be empty';
    }
    if (password.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authNotifier = ref.watch(authProvider);
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/background.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset('assets/images/login_screen_1.png'),
                          Image.asset(
                            'assets/images/login_screen_2.png',
                            width: constraints.maxWidth * 0.5,
                            height: constraints.maxHeight * 0.15,
                          ),
                          CustomFormField(
                            controller: _emailController,
                            hintText: 'Email',
                            obscureText: false,
                            iconsType: Icons.email,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 20),
                          CustomFormField(
                            controller: _passwordController,
                            hintText: 'Password',
                            obscureText: true,
                            iconsType: Icons.lock,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 20),
                          authNotifier.isLoading
                              ? const Center(
                                  child: SizedBox(
                                    height: 50,
                                    width: 50,
                                    child: CircularProgressIndicator(
                                      color: Colors.red,
                                    ),
                                  ),
                                )
                              : InkWell(
                                  child: Container(
                                    height: 50,
                                    width: constraints.maxWidth * 0.9,
                                    decoration: BoxDecoration(
                                      color: Colors.amber,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        'Login',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 24),
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    FocusScope.of(context).unfocus();
                                    final emailError = validateEmail(_emailController.text);
                                    final passwordError = validatePassword(_passwordController.text);

                                    if (emailError != null || passwordError != null) {
                                      // Show error message
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Container(
                                            padding: const EdgeInsets.all(1),
                                            height: 80,
                                            width: MediaQuery.of(context).size.width,
                                            decoration: const BoxDecoration(
                                              color: Colors.red,
                                              borderRadius: BorderRadius.all(Radius.circular(10),
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                const SizedBox(width: 8),
                                                const Icon(Icons.warning,color: Colors.white,size: 40,),
                                                const SizedBox(width: 8),
                                                Expanded(
                                                  child: Center(
                                                    child: Text(
                                                      emailError ?? passwordError!,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          behavior: SnackBarBehavior.floating,
                                          backgroundColor: Colors.transparent,
                                          elevation: 3,
                                        ),
                                      );
                                      return;
                                    }
                                    authNotifier
                                        .loginUserWithFirebase(
                                            _emailController.text,
                                            _passwordController.text)
                                        .then((value) {
                                      context.navigateToScreen(
                                          isReplace: true,
                                          child: const HomeScreen());

                                    });
                                  },
                                ),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: GestureDetector(
                              child: const Text(
                                'A New Pokemon Trainer? Sign up Instead',
                                style: TextStyle(color: Colors.black),
                              ),
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                context.navigateToScreen(isReplace:true,child: SignupScreen());
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
