import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nmc_wrapper/repository/registerRepo/register.repo.dart';
import 'package:nmc_wrapper/utils/extensions.dart';
import 'package:nmc_wrapper/utils/logger.dart';
import 'package:nmc_wrapper/utils/validators.dart';
import 'package:nmc_wrapper/view/login/login.dart';
import 'package:nmc_wrapper/view/shared/widgets/custom_date_picker.dart';
import 'package:nmc_wrapper/view/shared/widgets/custom_text_field.dart';
import 'package:nmc_wrapper/view/shared/widgets/dialog_gender.dart';
import 'package:provider/provider.dart';

import '../../../repository/registerRepo/service.locator.dart';
import '../forget_password/otp_verify.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  final fullNameController = TextEditingController();
  final userNameController = TextEditingController();
  final mobileController = TextEditingController();
  final addressController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final genderController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  Timer? _emailDebounce;

  bool isEmailAvailable = true;
  bool isMobileAvailable = true;
  String? emailMessage;
  String? selectedGender;

  final List<String> genders = ['Male', 'Female', 'Other'];

  final TextEditingController dobController = TextEditingController();

  Future<void> selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        dobController.text =
            "${pickedDate.day.toString().padLeft(2, '0')}-"
            "${pickedDate.month.toString().padLeft(2, '0')}-"
            "${pickedDate.year}";
      });
    }
  }

  InputDecoration customDecoration({
    required String hintText,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: Colors.blue),
      ),
    );
  }

  Widget buildLabel(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget spacing() {
    return const SizedBox(height: 16);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0F4C75),
      body: Consumer<RegisterProvider>(
        builder: (BuildContext context, RegisterProvider provider, Widget? child) {
          provider.isLoading ? context.showLoader() : context.hideLoader();

          if (provider.error != null) {}

          if (provider.data != null) {
            logger(provider.data.toString());
          }
          return SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BackButton(color: Colors.white),
                Expanded(
                  child: Center(
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
                            spacing: 8,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/nmc_logo.png',
                                // replace with your logo
                                height: 44,
                              ),
                              6.height(),
                              Row(
                                children: [
                                  const Text(
                                    'Citizen Registration',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF7A1236),
                                    ),
                                  ),
                                ],
                              ),
                              CustomTextField(
                                title: 'Full Name',
                                showRequiredSign: true,
                                textInputAction: TextInputAction.next,
                                length: 80,
                                lines: 1,
                                textController: fullNameController,
                                validator: (value) {
                                  if (value!.trim().isEmpty) {
                                    return 'Please enter full name';
                                  }

                                  return null;
                                },
                              ),
                              CustomTextField(
                                title: 'DOB',
                                showRequiredSign: true,
                                textInputAction: TextInputAction.next,
                                textController: dobController,
                                readOnly: true,
                                onTap: () async {
                                  var dob = await pickDate(
                                    context: context,
                                    initialDate: DateTime.now(),
                                  );
                                  if (dob != null) {
                                    dobController.text =
                                        '${dob.day.toString().padLeft(2, '0')}-${dob.month.toString().padLeft(2, '0')}-${dob.year}';
                                  }
                                },
                                suffix: Icon(Icons.calendar_month, size: 24),
                                validator: (value) {
                                  if (value!.trim().isEmpty) {
                                    return 'select DOB';
                                  }

                                  return null;
                                },
                              ),
                              Focus(
                                onFocusChange: (hasFocus) async {
                                  if (!hasFocus &&
                                      mobileController.text.trim().length ==
                                          10) {
                                    await context
                                        .read<RegisterProvider>()
                                        .checkRegistrationMobile(
                                          mobileController.text.trim(),
                                        );

                                    final response = context
                                        .read<RegisterProvider>()
                                        .data;

                                    if (response != null &&
                                        response['mobile'] != null) {
                                      setState(() {
                                        isMobileAvailable =
                                            response['mobile']['status'] ==
                                            'AVAILABLE';
                                      });

                                      _formKey.currentState?.validate();
                                    }
                                  }
                                },
                                child: CustomTextField(
                                  title: 'Mobile',
                                  showRequiredSign: true,
                                  textInputType: TextInputType.phone,
                                  textInputAction: TextInputAction.next,
                                  length: 10,
                                  lines: 1,
                                  textController: mobileController,
                                  validator: (value) {
                                    if (value == null ||
                                        value.trim().isEmpty ||
                                        value.length != 10) {
                                      return 'Please enter 10 digit mobile';
                                    }

                                    if (!isMobileAvailable) {
                                      return 'Mobile number already registered';
                                    }

                                    return null;
                                  },
                                ),
                              ),
                              CustomTextField(
                                title: 'User Name',
                                showRequiredSign: true,
                                textInputType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                length: 20,
                                lines: 1,
                                textController: userNameController,
                                validator: (value) {
                                  if (value!.trim().isEmpty) {
                                    return 'Please enter username';
                                  }

                                  return null;
                                },
                              ),
                              CustomTextField(
                                textInputType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                length: 20,
                                lines: 1,
                                title: 'Password ',
                                showRequiredSign: true,
                                textController: passwordController,
                                isPassword: true,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Please enter password';
                                  }

                                  if (value.length < 8) {
                                    return 'Password must be at least 8 characters';
                                  }

                                  return null;
                                },
                              ),
                              CustomTextField(
                                textInputType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                length: 20,
                                lines: 1,
                                title: 'Confirm Password',
                                showRequiredSign: true,
                                textController: confirmPasswordController,
                                isPassword: true,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Please confirm password';
                                  }

                                  if (value.length < 8) {
                                    return 'Password must be at least 8 characters';
                                  }

                                  if (value != passwordController.text) {
                                    return 'Passwords do not match';
                                  }

                                  return null;
                                },
                              ),
                              CustomTextField(
                                title: 'Email Id',
                                showRequiredSign: true,
                                textInputType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.done,
                                length: 90,
                                lines: 1,
                                textController: emailController,
                                onChanged: (value) {
                                  _emailDebounce?.cancel();

                                  if (value!.isEmpty || validEmail(value)) {
                                    setState(() {
                                      emailMessage = null;
                                    });
                                    return;
                                  }

                                  _emailDebounce = Timer(
                                    const Duration(milliseconds: 500),
                                    () async {
                                      await context
                                          .read<RegisterProvider>()
                                          .checkRegistrationEmail(value);

                                      final response = context
                                          .read<RegisterProvider>()
                                          .data;

                                      if (mounted &&
                                          response != null &&
                                          response['email'] != null) {
                                        setState(() {
                                          isEmailAvailable =
                                              response['email']['status'] ==
                                              'AVAILABLE';

                                          emailMessage =
                                              response['email']['message'];
                                        });
                                      }
                                    },
                                  );
                                  return null;
                                },
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Please enter email';
                                  }

                                  if (!validEmail(value.trim())) {
                                    return 'Enter valid email';
                                  }

                                  if (isEmailAvailable == false) {
                                    return emailMessage ??
                                        'Email already registered';
                                  }

                                  return null;
                                },
                              ),
                              CustomTextField(
                                title: 'Gender',
                                showRequiredSign: true,
                                textInputAction: TextInputAction.done,
                                textController: genderController,
                                readOnly: true,
                                onTap: () async {
                                  var selected = await pickGender(context);
                                  if (selected != null) {
                                    genderController.text = selected;
                                  }
                                },
                                suffix: Icon(Icons.arrow_drop_down, size: 24),
                                validator: (value) {
                                  if (value!.trim().isEmpty) {
                                    return 'select gender';
                                  }

                                  return null;
                                },
                              ),
                              8.height(),
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
                                  onPressed: () async {
                                    if (_formKey.currentState?.validate() ??
                                        false) {
                                      final requestBody = {
                                        "email": emailController.text.trim(),
                                        "password": passwordController.text
                                            .trim(),
                                        "firstName": fullNameController.text
                                            .trim(),
                                        "lastName": ".",
                                        "mobile": mobileController.text.trim(),
                                        "address": addressController.text
                                            .trim(),
                                        "stakeholderType": "applicant",
                                        "roleId": 2,
                                        "tenant": "nmc",
                                        "username": userNameController.text
                                            .trim(),
                                        "gender": genderController.text
                                            .trim()
                                            .toUpperCase(),
                                        "dateOfBirth": _formatDobForApi(
                                          dobController.text.trim(),
                                        ),
                                        "otpVerificationToken": "",
                                      };

                                      getIt<RegistrationRequest>().data =
                                          requestBody;

                                      logger("Stored Request: $requestBody");

                                      final success = await context
                                          .read<RegisterProvider>()
                                          .sendOtpRegistration(
                                            mobileController.text.trim(),
                                          );

                                      if (!mounted) return;

                                      if (success) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                OtpVerificationScreen(
                                                  mobile: mobileController.text
                                                      .trim(),
                                                  isComeFrom: "1",
                                                ),
                                          ),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              context
                                                      .read<RegisterProvider>()
                                                      .error ??
                                                  "Failed to send OTP",
                                            ),
                                          ),
                                        );
                                      }
                                    }
                                  },
                                  child: const Text(
                                    'Register',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              15.height(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Already have an account? ",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      // Navigate to Register Screen
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => LoginScreen(),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      "Log In",
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
                  ),
                ),

                /// FOOTER
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
    );
  }

  String _formatDobForApi(String dob) {
    final parts = dob.split('-');

    return "${parts[2]}-${parts[1]}-${parts[0]}";
  }

  @override
  void dispose() {
    _emailDebounce?.cancel();
    emailController.dispose();
    super.dispose();
  }
}
