import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nmc_wrapper/utils/extensions.dart';

import '../app.theme.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField(
      {super.key,
      this.isPassword = false,
      this.textInputType = TextInputType.text,
      this.length,
      this.textCapitalization = TextCapitalization.none,
      this.textController,
      this.validator,
      this.onChanged,
      this.unfocusTapOutside = false,
      this.onFieldSubmitted,
      this.cornerRadius,
      this.title,
      this.placeHolderText,
      this.textAlign,
      this.prefixText,
      this.prefix,
      this.textInputAction,
      this.id,
      this.lines,
      this.minLines,
      this.focusNode,
      this.showCounterText = false,
      this.suffix,
      this.readOnly = false,
      this.onTap,
      this.formFieldKey,
      this.enabled = true,
      this.inputFormatters,
      this.contentPadding,
      this.showRequiredSign = false});

  final Function()? onTap;
  final bool readOnly;
  final bool isPassword;
  final String? title;
  final String? placeHolderText;
  final TextInputType textInputType;
  final bool enabled;
  final bool unfocusTapOutside;
  final int? length;
  final Key? formFieldKey;
  final TextAlign? textAlign;
  final TextCapitalization textCapitalization;
  final TextEditingController? textController;
  final int? lines;
  final int? minLines;
  final bool? showCounterText;
  final double? cornerRadius;
  final String? prefixText;
  final String? id;
  final Widget? suffix;
  final Widget? prefix;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final String? Function(String?)? onChanged;
  final String? Function(String?)? onFieldSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final bool? showRequiredSign;
  final EdgeInsetsGeometry? contentPadding;

  @override
  State<StatefulWidget> createState() => CustomTextFieldState();
}

class CustomTextFieldState extends State<CustomTextField> {
  bool obscureText = false;

  @override
  void initState() {
    setState(() {
      obscureText = widget.isPassword;
    });
    super.initState();
  }

  void visibilityTap() {
    setState(() {
      obscureText = obscureText == true ? false : true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        widget.title != null
            ? FittedBox(
                child: RichText(
                  text: TextSpan(
                    text: widget.title ?? '',
                    style:
                        context.bodyMedium()?.bold(fontWeight: FontWeight.w400),
                    children: widget.showRequiredSign == true
                        ? const [
                            TextSpan(
                              text: ' *',
                              style: TextStyle(color: Colors.red),
                            ),
                          ]
                        : [],
                  ),
                ),
              )
            : const SizedBox.shrink(),
        4.height(),
        TextFormField(
          key: widget.formFieldKey,
          focusNode: widget.focusNode,
          enabled: widget.enabled,
          inputFormatters: widget.inputFormatters,
          /* buildCounter: (_,
                  {required currentLength, maxLength, required isFocused}) =>
              getCounter(currentLength, maxLength),*/
          style:
              context.bodyMedium()?.size(18).bold(fontWeight: FontWeight.w600),
          readOnly: widget.readOnly,
          onTap: widget.onTap,
          onTapOutside: widget.unfocusTapOutside
              ? (event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                }
              : null,
          validator: widget.validator,
          cursorColor: AppTheme.cursorColor,
          maxLines: widget.lines == 0 ? null : widget.lines ?? 1,
          minLines: widget.minLines == 0 ? null : widget.minLines ?? 1,
          textAlign: widget.textAlign ?? TextAlign.start,
          textCapitalization: widget.textCapitalization,
          controller: widget.textController,
          maxLength: widget.length,
          textInputAction: widget.textInputAction,
          obscureText: obscureText,
          onFieldSubmitted: widget.onFieldSubmitted,
          onChanged: widget.onChanged,
          keyboardType: widget.textInputType,
          decoration: InputDecoration(
              // labelText: widget.title,
              contentPadding: widget.contentPadding,
              labelStyle: context.bodyMedium()?.size(18),
              focusColor: AppTheme.cursorColor,
              hintText: widget.placeHolderText,
              counterText: (widget.showCounterText ?? false) ? null : '',
              prefixIcon: widget.prefix,
              prefixText: widget.prefixText,
              hintStyle: context.bodyMedium(),
              prefixStyle: context.bodyMedium()?.bold(),
              errorMaxLines: 2,
              suffixIcon: widget.isPassword
                  ? IconButton(
                      splashRadius: 24,
                      splashColor: Colors.transparent,
                      onPressed: () {
                        visibilityTap();
                      },
                      icon: Icon(
                        obscureText == true
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                    )
                  : widget.suffix),
        )
      ],
    );
  }

  getCounter(currentLength, maxLength) {
    if (widget.showCounterText == true) {
      return Align(
          alignment: Alignment.centerRight,
          child: Text(
            "$currentLength/$maxLength",
            style: context.bodySmall(),
          ));
    }
    return null;
  }
}
