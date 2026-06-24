import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nmc_wrapper/utils/app_strings.dart';
import 'package:nmc_wrapper/view/forget_password/reset_password.dart';
import 'package:nmc_wrapper/view/login/login.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

import '../../../repository/registerRepo/register.repo.dart';
import '../../../repository/registerRepo/service.locator.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String mobile;
  final String isComeFrom; //1 for registration 2 for forget password

  const OtpVerificationScreen({super.key, required this.mobile, required this.isComeFrom});

  @override
  State<OtpVerificationScreen> createState() =>
      _OtpVerificationScreenState();
}

class _OtpVerificationScreenState
    extends State<OtpVerificationScreen> {
  final TextEditingController otpController =
  TextEditingController();

  Timer? _timer;
  int _secondsRemaining = 90;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _timer?.cancel();

    setState(() {
      _secondsRemaining = 120;
    });

    _timer = Timer.periodic(
      const Duration(seconds: 1),
          (timer) {
        if (_secondsRemaining > 0) {
          setState(() {
            _secondsRemaining--;
          });
        } else {
          timer.cancel();
        }
      },
    );
  }

  String get timerText {
    final minutes = _secondsRemaining ~/ 60;
    final seconds = _secondsRemaining % 60;

    return "${minutes.toString().padLeft(2, '0')}:"
        "${seconds.toString().padLeft(2, '0')}";
  }

  Future<void> resendOtp() async {
    // Call Resend OTP API here

    startTimer();
    final success = await context
        .read<RegisterProvider>()
        .sendOtp(
      widget.mobile.trim(),
    );
    if(success){

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppStrings.translate(
              context,
              'otp_sent_success',
            ),
          ),      ),
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF8B1E1E);

    final defaultPinTheme = PinTheme(
      width: 65,
      height: 65,
      textStyle: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 700,
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.close),
                    ),
                  ),

                  const Icon(
                    Icons.phone,
                    color: primaryColor,
                    size: 60,
                  ),

                  const SizedBox(height: 24),

                    Text(
                      AppStrings.translate(
                        context,
                        'please_check_mobile',
                      ),
                      textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 10),

                  RichText(
                    textAlign: TextAlign.center,
                    text:  TextSpan(
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                      children: [
                        TextSpan(
                          text: AppStrings.translate(
                            context,
                            'sent_code_to',
                          ),
                        ),
                        TextSpan(
                          text: "******${widget.mobile.substring(widget.mobile.length - 4)}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  /// OTP FIELD
                  Pinput(
                    controller: otpController,
                    length: 6,
                    defaultPinTheme: defaultPinTheme,
                    focusedPinTheme:
                    defaultPinTheme.copyDecorationWith(
                      border: Border.all(
                        color: primaryColor,
                        width: 2,
                      ),
                    ),
                    submittedPinTheme:
                    defaultPinTheme.copyDecorationWith(
                      color: Colors.grey.shade100,
                    ),
                    onCompleted: (pin) {
                      debugPrint("OTP : $pin");
                    },
                  ),

                  const SizedBox(height: 35),

                  /// RESEND
                  if (_secondsRemaining > 0)
                    Column(
                      children: [
                          Text(
                            AppStrings.translate(
                              context,
                              'didnt_get_code',
                            ),
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "${AppStrings.translate(context, 'resend_in')} $timerText",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    )
                  else
                    TextButton(
                      onPressed: resendOtp,
                      child:   Text(
                        AppStrings.translate(
                          context,
                          'resend_otp',
                        ),
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.blue,
                          decoration:
                          TextDecoration.underline,
                        ),
                      ),
                    ),

                  const SizedBox(height: 40),

                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.center,
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
                                borderRadius:
                                BorderRadius.circular(
                                    14),
                              ),
                            ),
                            child:   Text(
                              AppStrings.translate(
                                context,
                                'cancel',
                              ),
                              style: TextStyle(
                                color:
                                Color(0xFF8B1E1E),
                                fontSize: 18,
                                fontWeight:
                                FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 24),

                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () async {
                              if(widget.isComeFrom=="1"){
                                  final success = await context
                                      .read<RegisterProvider>()
                                      .verifyOtpRegistration(
                                    widget.mobile,
                                    otpController.text.trim(),
                                  );

                                  if (!mounted) return;

                                  if (success) {
                                    final provider =
                                    context.read<RegisterProvider>();

                                    final otpToken = provider.data["data"]
                                    ["otpVerificationToken"];

                                    final requestBody =
                                        getIt<RegistrationRequest>().data;

                                    requestBody?["otpVerificationToken"] =
                                        otpToken;

                                    final registered =
                                    await provider.createUser(requestBody!);

                                    if (!mounted) return;

                                    if (registered) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                          content: Text(
                                            AppStrings.translate(
                                              context,
                                              'registration_success',
                                            ),
                                          ),
                                        ),
                                      );

                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => LoginScreen(),
                                        ),
                                            (route) => false,);
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                         //   provider.error ??
                                              AppStrings.translate(
                                                context,
                                                'registration_failed',
                                              )
                                          ),
                                        ),
                                      );
                                    }
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                        content: Text( AppStrings.translate(
                                          context,
                                          'invalid_otp',
                                        ),),
                                      ),
                                    );
                                  }


                              }else{
                                final success = await context
                                    .read<RegisterProvider>()
                                    .verifyOtp(
                                  widget.mobile,
                                  otpController.text.trim(),
                                );

                                if (!mounted) return;

                                if (success) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>   ResetPasswordScreen(otp:otpController.text.trim().toString() ,),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                      content: Text( AppStrings.translate(
                                        context,
                                        'invalid_otp',
                                      ),),
                                    ),
                                  );
                                }
                              }


                            },                            style:
                            ElevatedButton.styleFrom(
                              backgroundColor:
                              const Color(
                                  0xFF8B1E1E),
                              shape:
                              RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius
                                    .circular(14),
                              ),
                            ),
                            child:   Text(
                              AppStrings.translate(
                                context,
                                'verify',
                              ),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight:
                                FontWeight.w600,
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
      ),
    );
  }
}