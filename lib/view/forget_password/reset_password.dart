import 'package:flutter/material.dart';
import 'package:nmc_wrapper/repository/registerRepo/register.repo.dart';
import 'package:nmc_wrapper/utils/app_strings.dart';
import 'package:nmc_wrapper/view/login/login.dart';
 import 'package:provider/provider.dart';


class ResetPasswordScreen extends StatefulWidget {
  final String otp;
  const ResetPasswordScreen({super.key, required this.otp});

  @override
  State<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState
    extends State<ResetPasswordScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController =
  TextEditingController();

  bool _hidePassword = true;
  bool _hideConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF8B1E1E);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 1200,
              ),
              child: Column(
                children: [
                  /// HEADER
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.close,
                          size: 32,
                        ),
                      ),
                    ],
                  ),

                  const Icon(
                    Icons.security,
                    size: 40,
                    color: primaryColor,
                  ),

                  const SizedBox(height: 40),

                  /// USERNAME
                  _buildLabel(  AppStrings.translate(
                    context,
                    'username',
                  ),),

                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _usernameController,
                    decoration: _inputDecoration(
                      AppStrings.translate(
                        context,
                        'enter_username',
                      ),                    ),
                  ),

                  const SizedBox(height: 30),

                  /// PASSWORD
                  _buildLabel(  AppStrings.translate(
                    context,
                    'new_password',
                  ),),

                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _passwordController,
                    obscureText: _hidePassword,
                    decoration: _inputDecoration(
                      AppStrings.translate(
                        context,
                        'enter_new_password',
                      ),
                    ).copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(
                          _hidePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _hidePassword =
                            !_hidePassword;
                          });
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// CONFIRM PASSWORD
                  _buildLabel( AppStrings.translate(
                    context,
                    'confirm_password',
                  ),),

                  const SizedBox(height: 12),

                  TextFormField(
                    controller:
                    _confirmPasswordController,
                    obscureText:
                    _hideConfirmPassword,
                    decoration: _inputDecoration(
                      AppStrings.translate(
                        context,
                        'confirm_new_password',
                      ),
                    ).copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(
                          _hideConfirmPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _hideConfirmPassword =
                            !_hideConfirmPassword;
                          });
                        },
                      ),

                    ),
                  ),

                  const SizedBox(height: 50),

                  /// BUTTONS
                  ConstrainedBox(
                    constraints:
                    const BoxConstraints(
                      maxWidth: 450,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 48,
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.pop(
                                    context);
                              },
                              style:
                              OutlinedButton
                                  .styleFrom(
                                shape:
                                RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius
                                      .circular(
                                      14),
                                ),
                                side:
                                const BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                              child:   Text(
                                AppStrings.translate(
                                  context,
                                  'cancel',
                                ),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight:
                                  FontWeight
                                      .w600,
                                  color:
                                  primaryColor,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 20),

                        Expanded(
                          child: SizedBox(
                            height: 48,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_passwordController
                                    .text !=
                                    _confirmPasswordController
                                        .text) {
                                  ScaffoldMessenger.of(
                                      context)
                                      .showSnackBar(
                                      SnackBar(
                                      content: Text(
                                        AppStrings.translate(
                                          context,
                                          'password_not_match',
                                        ),                                      ),
                                    ),
                                  );
                                  return;
                                }

                                // Reset Password API
                                final success = await context
                                    .read<RegisterProvider>()
                                    .confirmForgetPassword(
                                  username: _usernameController.text.trim(),
                                  newPassword: _passwordController.text.trim(),
                                  confirmPassword:
                                  _confirmPasswordController.text.trim(),
                                  otpReference: widget.otp,
                                );

                                if (success) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                      content: Text(  AppStrings.translate(
                                        context,
                                        'password_reset_success',
                                      ),),
                                    ),
                                  );

                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const LoginScreen(),
                                    ),
                                  );
                                }
                              },
                              style:
                              ElevatedButton
                                  .styleFrom(
                                backgroundColor:
                                primaryColor,
                                shape:
                                RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius
                                      .circular(
                                      14),
                                ),
                              ),
                              child:   Text(
                                AppStrings.translate(
                                  context,
                                  'confirm',
                                ),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight:
                                  FontWeight
                                      .w600,
                                  color:
                                  Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String title) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Text(
          " *",
          style: TextStyle(
            color: Colors.red,
            fontSize: 20,
          ),
        ),
        const SizedBox(width: 8),
        const Icon(
          Icons.info_outline,
          size: 22,
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(
      String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(
        fontSize: 18,
        color: Colors.grey,
      ),
      contentPadding:
      const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 22,
      ),
      border: OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(12),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(12),
        borderSide: BorderSide(
          color: Colors.grey.shade300,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFF8B1E1E),
          width: 2,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}