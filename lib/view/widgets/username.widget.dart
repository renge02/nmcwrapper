import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nmc_wrapper/repository/registerRepo/register.repo.dart';
import 'package:nmc_wrapper/utils/app_strings.dart';
import 'package:nmc_wrapper/view/shared/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

class UsernameAvailabilityField extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<bool?>? onAvailabilityChanged;

  const UsernameAvailabilityField({
    super.key,
    required this.controller,
    this.onAvailabilityChanged,
  });

  @override
  State<UsernameAvailabilityField> createState() =>
      _UsernameAvailabilityFieldState();
}

class _UsernameAvailabilityFieldState
    extends State<UsernameAvailabilityField> {
  Timer? _debounce;

  bool? isAvailable;
  String? message;
  bool isChecking = false;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _checkUserName(String username) async {
    if (username.isEmpty) return;

    setState(() {
      isChecking = true;
    });

    try {
      final response = await context
          .read<RegisterProvider>()
          .checkUserNameRegistration(username);

      if (!mounted) return;

      setState(() {
        isChecking = false;

        if (response) {
          isAvailable = true;
          message = "Username Available";
        } else {
          isAvailable = false;
          message = "Username already exists";
        }
      });

      widget.onAvailabilityChanged?.call(isAvailable);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isChecking = false;
        isAvailable = null;
        message = null;
      });

      debugPrint("Username check failed: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          title: AppStrings.translate(context, 'username'),
          showRequiredSign: true,
          length: 20,
          lines: 1,
          textInputType: TextInputType.text,
          textController: widget.controller,
          onChanged: (value) {
            _debounce?.cancel();

            final username = value!.trim();

            // Clear state while typing
            setState(() {
              isAvailable = null;
              message = null;
            });

            widget.onAvailabilityChanged?.call(null);

            if (username.isEmpty) return;

            _debounce = Timer(
              const Duration(milliseconds: 500),
              () => _checkUserName(username),
            );
          },
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return AppStrings.translate(context, 'enter_username');
            }

            if (isAvailable == false) {
              return message ??
                  AppStrings.translate(
                    context,
                    'username_registered',
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
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              message ?? 'Username Available',
              style: const TextStyle(color: Colors.green),
            ),
          ),

        if (isAvailable == false)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              message ?? 'Username already registered',
              style: const TextStyle(color: Colors.red),
            ),
          ),
      ],
    );
  }
}
