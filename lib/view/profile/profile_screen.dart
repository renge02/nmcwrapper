import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nmc_wrapper/repository/language/LanguageProvider.dart';
import 'package:nmc_wrapper/repository/registerRepo/register.repo.dart';
import 'package:nmc_wrapper/utils/app_strings.dart';
import 'package:nmc_wrapper/utils/extensions.dart';
import 'package:nmc_wrapper/utils/validators.dart';
import 'package:nmc_wrapper/view/shared/app.theme.dart';
import 'package:nmc_wrapper/view/shared/widgets/custom_date_picker.dart';
import 'package:nmc_wrapper/view/shared/widgets/custom_text_field.dart';
import 'package:nmc_wrapper/view/shared/widgets/dialog_gender.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final cityController = TextEditingController();
  final mobileController = TextEditingController(text: '9637202243');
  final emailController = TextEditingController(
    text: 'rutujarenge02@gmail.com',
  );
  final dobController = TextEditingController();

  final genderController = TextEditingController();
  String? selectedGender;

  Timer? _emailDebounce;

  bool isEmailAvailable = true;
  String? emailMessage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2E9E8),

      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),

          onPressed: () {
            context.pop();
          },
        ),
        elevation: 0,
        titleSpacing: 0,
        backgroundColor: AppTheme.appBarColor,
        title: Text(
          AppStrings.translate(context, "edit_profile"),
          style: GoogleFonts.notoSans(fontSize: 14, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        // padding: const EdgeInsets.all(16),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
              children: [
                CustomTextField(
                  title: AppStrings.translate(context, 'username'),
                  showRequiredSign: true,
                  textInputType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  length: 20,
                  lines: 1,
                  textController: nameController,
                  validator: (value) {
                    if (value!.trim().isEmpty) {
                      return AppStrings.translate(context, 'enter_username');
                    }

                    return null;
                  },
                ),

                8.height(),

                CustomTextField(
                  title: AppStrings.translate(context, 'gender'),
                  showRequiredSign: true,
                  textInputAction: TextInputAction.done,
                  textController: genderController,
                  readOnly: true,
                  onTap: () async {
                    var selected = await pickGender(context);
                    if (selected != null) {
                      selectedGender = selected; // Male

                      genderController.text = AppStrings.translate(
                        context,
                        selected.toLowerCase(),
                      ); // पुरुष
                    }
                  },
                  suffix: Icon(Icons.arrow_drop_down, size: 24),
                  validator: (value) {
                    if (value!.trim().isEmpty) {
                      return AppStrings.translate(context, 'select_gender');
                    }

                    return null;
                  },
                ),

                8.height(),

                CustomTextField(
                  textInputType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  length: 20,
                  lines: 1,
                  title: AppStrings.translate(context, 'city'),
                  textController: cityController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return AppStrings.translate(context, 'enter_city');
                    }

                    return null;
                  },
                ),

                8.height(),

                CustomTextField(
                  title: AppStrings.translate(context, 'mobile_no'),
                  showRequiredSign: true,
                  readOnly: true,
                  textInputType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  length: 10,
                  lines: 1,
                  textController: mobileController,
                ),

                8.height(),

                CustomTextField(
                  title: AppStrings.translate(context, 'email'),
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

                        final response = context.read<RegisterProvider>().data;

                        if (mounted &&
                            response != null &&
                            response['email'] != null) {
                          setState(() {
                            isEmailAvailable =
                                response['email']['status'] == 'AVAILABLE';

                            emailMessage = response['email']['message'];
                          });
                        }
                      },
                    );
                    return null;
                  },
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return AppStrings.translate(context, 'enter_email');
                    }

                    if (!validEmail(value.trim())) {
                      return AppStrings.translate(context, 'invalid_email');
                    }

                    if (isEmailAvailable == false) {
                      return emailMessage ??
                          emailMessage ??
                          AppStrings.translate(context, 'email_registered');
                    }

                    return null;
                  },
                ),

                8.height(),

                CustomTextField(
                  title: AppStrings.translate(context, 'dob'),
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
                      return AppStrings.translate(context, 'select_dob');
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
                    onPressed: () async {},
                    child: Text(
                      AppStrings.translate(context, 'save'),
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
