import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nmc_wrapper/repository/registerRepo/register.repo.dart';
import 'package:nmc_wrapper/utils/app_strings.dart';
import 'package:nmc_wrapper/view/shared/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

class EmailAvailabilityField extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<bool?>? onAvailabilityChanged;

  const EmailAvailabilityField({
    super.key,
    required this.controller,
    this.onAvailabilityChanged,
  });

  @override
  State<EmailAvailabilityField> createState() =>
      _EmailAvailabilityFieldState();
}

class _EmailAvailabilityFieldState
    extends State<EmailAvailabilityField> {
  Timer? _debounce;

  bool? isAvailable;
  String? message;
  bool isChecking = false;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _checkEmail(String email) async {
    setState(() {
      isChecking = true;
    });

    try {
      await context
          .read<RegisterProvider>()
          .checkRegistrationEmail(email);

      final response = context.read<RegisterProvider>().data;

      if (!mounted) return;

      final available =
          response?['email']?['status'] == 'AVAILABLE';

      setState(() {
        isChecking = false;
        isAvailable = available;
        message = response?['email']?['message'];
      });

      widget.onAvailabilityChanged?.call(available);
    } catch (_) {
      if (!mounted) return;

      setState(() {
        isChecking = false;
      });
    }
  }

  bool validEmail(String email) {
    return RegExp(
      r'^[\w\-.]+@([\w-]+\.)+[\w-]{2,4}$',
    ).hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          title: AppStrings.translate(context, 'email'),
          showRequiredSign: true,
          textInputType: TextInputType.emailAddress,
          textController: widget.controller,
          onChanged: (value) {
            _debounce?.cancel();

            if (!validEmail(value!.trim())) {
              setState(() {
                isAvailable = null;
                message = null;
              });

              widget.onAvailabilityChanged?.call(null);
              return;
            }

            _debounce = Timer(
              const Duration(milliseconds: 500),
              () => _checkEmail(value.trim()),
            );
          },
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return AppStrings.translate(
                context,
                'enter_email',
              );
            }

            if (!validEmail(value.trim())) {
              return AppStrings.translate(
                context,
                'invalid_email',
              );
            }

            if (isAvailable == false) {
              return message ??
                  AppStrings.translate(
                    context,
                    'email_registered',
                  );
            }

            return null;
          },
        ),

        if (isChecking)
          const Padding(
            padding: EdgeInsets.only(top: 4),
            child: SizedBox(
              height: 14,
              width: 14,
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            ),
          ),

        if (isAvailable == true)
          const Padding(
            padding: EdgeInsets.only(top: 4),
            child: Text(
              'Email available',
              style: TextStyle(color: Colors.green),
            ),
          ),

        if (isAvailable == false)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              message ?? 'Email already registered',
              style: const TextStyle(color: Colors.red),
            ),
          ),
      ],
    );
  }
}