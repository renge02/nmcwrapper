import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nmc_wrapper/repository/language/LanguageProvider.dart';
import 'package:nmc_wrapper/repository/registerRepo/register.repo.dart';
import 'package:nmc_wrapper/utils/app_strings.dart';
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


  final TextEditingController dobController = TextEditingController();




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
                                    Text(
                                      AppStrings.translate(context,'citizen_registration'),
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF7A1236),
                                    ),
                                  ),
                                ],
                              ),
                              CustomTextField(
                                title: AppStrings.translate(context,'full_name'),                                showRequiredSign: true,
                                textInputAction: TextInputAction.next,
                                length: 80,
                                lines: 1,
                                textController: fullNameController,
                                validator: (value) {
                                  if (value!.trim().isEmpty) {
                                    return AppStrings.translate(
                                        context,
                                        'please_enter_full_name'
                                    );                                  }

                                  return null;
                                },
                              ),
                              CustomTextField(
                                title: AppStrings.translate(context,'dob'),
                                showRequiredSign: true,
                                textInputAction: TextInputAction.next,
                                textController: dobController,
                                readOnly: true,
                                onTap: () async {
                                  final locale = context.read<LanguageProvider>().locale;

                                  var dob = await pickDate(
                                    locale: locale,
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
                                    return AppStrings.translate(
                                        context,
                                        'select_dob'
                                    );                                  }

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
                                child:
                                CustomTextField(
                                  title: AppStrings.translate(context,'mobile'),
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
                                      return AppStrings.translate(
                                          context,
                                          'enter_mobile'
                                      );                                    }

                                    if (!isMobileAvailable) {
                                      return AppStrings.translate(
                                          context,
                                          'mobile_registered'
                                      );                                    }

                                    return null;
                                  },
                                ),
                              ),
                              CustomTextField(
                                title: AppStrings.translate(context,'username'),
                                showRequiredSign: true,
                                textInputType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                length: 20,
                                lines: 1,
                                textController: userNameController,
                                validator: (value) {
                                  if (value!.trim().isEmpty) {
                                    return AppStrings.translate(
                                        context,
                                        'enter_username'
                                    );                                  }

                                  return null;
                                },
                              ),
                              CustomTextField(
                                textInputType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                length: 20,
                                lines: 1,
                                title: AppStrings.translate(context,'password'),
                                showRequiredSign: true,
                                textController: passwordController,
                                isPassword: true,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return AppStrings.translate(
                                        context,
                                        'enter_password'
                                    );                                  }

                                  if (value.length < 8) {
                                    return AppStrings.translate(
                                        context,
                                        'password_8'
                                    );                                  }

                                  return null;
                                },
                              ),
                              CustomTextField(
                                textInputType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                length: 20,
                                lines: 1,
                                title: AppStrings.translate(
                                    context,
                                    'confirm_password'
                                ),
                                showRequiredSign: true,
                                textController: confirmPasswordController,
                                isPassword: true,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return AppStrings.translate(
                                        context,
                                        'confirm_password_enter'
                                    );                                  }

                                  if (value.length < 8) {
                                    return AppStrings.translate(
                                        context,
                                        'password_8'
                                    );                                  }

                                  if (value != passwordController.text) {
                                    return AppStrings.translate(
                                        context,
                                        'password_not_match'
                                    );                                  }

                                  return null;
                                },
                              ),
                              CustomTextField(
                                title: AppStrings.translate(
                                    context,
                                    'email'
                                ),
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
                                    return AppStrings.translate(
                                        context,
                                        'enter_email'
                                    );                                  }

                                  if (!validEmail(value.trim())) {
                                    return AppStrings.translate(
                                        context,
                                        'invalid_email'
                                    );                                  }

                                  if (isEmailAvailable == false) {
                                    return emailMessage ??
                                    emailMessage ??
                                  AppStrings.translate(
                                  context,
                                  'email_registered'
                                  );                                  }

                                  return null;
                                },
                              ),
                              CustomTextField(
                                title: AppStrings.translate(
                                    context,
                                    'gender'
                                ),
                                showRequiredSign: true,
                                textInputAction: TextInputAction.done,
                                textController: genderController,
                                readOnly: true,
                                onTap: () async {
                                  var selected = await pickGender(context);
                                  if (selected != null) {
                                    selectedGender = selected; // Male

                                    genderController.text =
                                        AppStrings.translate(
                                          context,
                                          selected.toLowerCase(),
                                        ); // पुरुष
                                  }
                                  },
                                suffix: Icon(Icons.arrow_drop_down, size: 24),
                                validator: (value) {
                                  if (value!.trim().isEmpty) {
                                    return AppStrings.translate(
                                        context,
                                        'select_gender'
                                    );                                  }

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
                                        "gender": selectedGender!.toUpperCase(),
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
                                  child:   Text(
                                    AppStrings.translate(
                                        context,
                                        'register'
                                    ),
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
                                    Text(
                                      AppStrings.translate(
                                          context,
                                          'already_account'
                                      ),
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
                                    child:   Text(
                                      AppStrings.translate(
                                          context,
                                          'log_in'
                                      ),
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
                                Text(
                                  AppStrings.translate(
                                      context,
                                      'version'
                                  ),
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
                  child:   Text(
                    AppStrings.translate(
                        context,
                        'copyright'
                    ),
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
