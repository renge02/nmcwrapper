import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nmc_wrapper/repository/registerRepo/register.repo.dart';
import 'package:nmc_wrapper/utils/app_strings.dart';
import 'package:nmc_wrapper/view/shared/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

class MobileAvailabilityField extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<bool?>? onAvailabilityChanged;

  const MobileAvailabilityField({
    super.key,
    required this.controller,
    this.onAvailabilityChanged,
  });

  @override
  State<MobileAvailabilityField> createState() =>
      _MobileAvailabilityFieldState();
}

class _MobileAvailabilityFieldState
    extends State<MobileAvailabilityField> {
  Timer? _debounce;

  bool? isAvailable;
  String? message;
  bool isChecking = false;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _checkMobile(String mobile) async {
    setState(() {
      isChecking = true;
    });

    try {
      await context
          .read<RegisterProvider>()
          .checkRegistrationMobile(mobile);

      final response = context.read<RegisterProvider>().data;

      if (!mounted) return;

      final available =
          response?['mobile']?['status'] == 'AVAILABLE';

      setState(() {
        isChecking = false;
        isAvailable = available;
        message = response?['mobile']?['message'];
      });

      widget.onAvailabilityChanged?.call(available);
    } catch (_) {
      if (!mounted) return;

      setState(() {
        isChecking = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          title: AppStrings.translate(context, 'mobile'),
          showRequiredSign: true,
          length: 10,
          textInputType: TextInputType.phone,
          textController: widget.controller,
          onChanged: (value) {
            _debounce?.cancel();

            if (value!.trim().length != 10) {
              setState(() {
                isAvailable = null;
                message = null;
              });

              widget.onAvailabilityChanged?.call(null);
              return;
            }

            _debounce = Timer(
              const Duration(milliseconds: 500),
              () => _checkMobile(value.trim()),
            );
          },
          validator: (value) {
            if (value == null ||
                value.trim().isEmpty ||
                value.length != 10) {
              return AppStrings.translate(
                context,
                'enter_mobile',
              );
            }

            if (isAvailable == false) {
              return message ??
                  AppStrings.translate(
                    context,
                    'mobile_registered',
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
              'Mobile available',
              style: TextStyle(color: Colors.green),
            ),
          ),

        if (isAvailable == false)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              message ?? 'Mobile already registered',
              style: const TextStyle(color: Colors.red),
            ),
          ),
      ],
    );
  }
}
enum AvailabilityStatus {
  initial,
  checking,
  available,
  unavailable,
}