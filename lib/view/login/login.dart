import 'package:flutter/material.dart';

import 'package:nmc_wrapper/repository/loginRepo/login.repo.dart';
import 'package:nmc_wrapper/utils/extensions.dart';
import 'package:nmc_wrapper/view/dashboard/dashboard.dart';
import 'package:nmc_wrapper/view/forget_password/forget_screen.dart';
import 'package:nmc_wrapper/view/registration/registration.dart';
import 'package:nmc_wrapper/view/shared/widgets/custom_alert.dart';
import 'package:nmc_wrapper/view/shared/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final userNameController = TextEditingController(text: 'NMC_CITIZEN');
  final passwordController = TextEditingController(text: 'Nmc@4321');
  final _formKey = GlobalKey<FormState>();
  final provider = LoginProvider();

  @override
  void dispose() {
    provider.dispose();
    userNameController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0F4C75),
      body: ChangeNotifierProvider.value(
        value: provider,
        child: Consumer<LoginProvider>(
          builder: (ctx, provider, _) {
            provider.isLoading ? context.showLoader(fullScreen: true) : context.hideLoader();

            if (provider.error != null) {
              showAlert(context,
                  'Unable to login, kindly check your internet connection');
            }

            if (provider.data != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.pushReplacementWidget(const DashboardScreen());
              });
            }
            return SafeArea(
              child: Column(
                children: [
                  Center(
                    child: SingleChildScrollView(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Form(
                          key: _formKey,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/nmc_logo.png',
                                height: 44,
                              ),
                              6.height(),

                              Image.asset(
                                'assets/images/app_logo.png',
                                fit: BoxFit.cover,
                              ).size(height: 150, width: double.infinity),
                              15.height(),

                              Row(
                                children: [
                                  const Text(
                                    'Citizen Login',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF7A1236),
                                    ),
                                  ),
                                ],
                              ),

                              12.height(),

                              CustomTextField(
                                title: 'User Name',
                                showRequiredSign: true,
                                textInputType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                length: 80,
                                lines: 1,
                                textController: userNameController,
                                validator: (value) {
                                  if (value!.trim().isEmpty) {
                                    return 'Please enter username';
                                  }

                                  return null;
                                },
                              ),

                              12.height(),

                              /// PASSWORD
                              CustomTextField(
                                title: 'Password',
                                showRequiredSign: true,
                                textInputType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.done,
                                length: 10,
                                lines: 1,
                                textController: passwordController,
                                isPassword: true,
                                validator: (value) {
                                  if (value!.trim().isEmpty ||
                                      value.length < 6) {
                                    return 'Enter 6 digit password';
                                  }

                                  return null;
                                },
                              ),
                              12.height(),

                              /// FORGOT PASSWORD
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      context
                                          .pushWidget(ForgotPasswordScreen());
                                    },
                                    child: const Text(
                                      'Forgot Password?',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        decoration: TextDecoration.underline,
                                        decorationColor: Colors.blue,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              12.height(),

                              SizedBox(
                                width: double.infinity,
                                height: 48,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF7A1236),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () {
                                    if (_formKey.currentState?.validate() ??
                                        false) {
                                      //simulating api delay
                                      provider.login(
                                        userNameController.text.trim(),
                                        passwordController.text.trim(),
                                      );
                                    }
                                  },
                                  child: const Text(
                                    'Continue',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),

                              12.height(),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Don’t have an account? ",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      // Navigate to Register Screen
                                      context.pushWidget(RegistrationScreen());
                                    },
                                    child: const Text(
                                      "Register here",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              12.height(),

                              const Text(
                                'Version v1.1',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ).expanded(),
                  Container(
                    width: double.infinity,
                    color: const Color(0xFF7A1236),
                    padding: const EdgeInsets.all(12),
                    child: const Text(
                      '© 2026 Copyright | Nashik Municipal Corporation | Government of Maharashtra | All rights Reserved',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 11),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
