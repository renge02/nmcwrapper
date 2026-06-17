import 'package:flutter/material.dart';
import 'package:nmc_wrapper/repository/registerRepo/register.repo.dart';

import 'package:nmc_wrapper/utils/extensions.dart';
import 'package:nmc_wrapper/view/shared/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';
import 'otp_verify.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final mobileController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                child: Container(
                  constraints: const BoxConstraints(
                    maxWidth: 800,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 30,
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.phone,
                        size: 40,
                        color: Color(0xFF8B1E1E),
                      ),

                      const SizedBox(height: 30),

                      const Text(
                        "Forgot Password? Enter registered mobile number",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF102020),
                        ),
                      ),

                      20.height(),

                      /// Mobile Number Field
                      CustomTextField(
                        showRequiredSign: true,
                        textInputType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        length: 10,
                        lines: 1,
                        prefixText: "+91  ",
                        textController: mobileController,
                        validator: (value) {
                          if (value!.trim().isEmpty || value.length != 10) {
                            return 'Please enter 10 digit mobile';
                          }

                          return null;
                        },
                      ),

                      20.height(),

                      /// Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 48,
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                    color: Color(0xFF6F7A7A),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                child: const Text(
                                  "Cancel",
                                  style: TextStyle(
                                    color: Color(0xFF8B1E1E),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          20.width(),
                          Expanded(
                            child: SizedBox(
                              height: 48,
                              child: ElevatedButton(
                                onPressed: () async {
                                  // Send OTP API
                                  final success = await context
                                      .read<RegisterProvider>()
                                      .sendOtp(mobileController.text.trim());

                                  if (!mounted) return;

                                  if (success) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => OtpVerificationScreen(
                                          mobile: mobileController.text
                                              .trim()
                                              .toString(),
                                          isComeFrom: "2",
                                        ),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Failed to send OTP'),
                                      ),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF8B1E1E),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                child: const Text(
                                  "Send OTP",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            /// Close Button
            Positioned(
              top: 20,
              right: 20,
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.close,
                  size: 35,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
