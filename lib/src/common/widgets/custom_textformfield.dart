// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:rentit/src/common/const/global_variable.dart';

// class CustomTextFormField extends StatelessWidget {
//   final int? maxline;
//   final int? maxLength;
//   final double? height;
//   final double? hintSize;
//   final double? borderRadius;
//   final double? horizontalPadding;
//   final double? verticalPadding;
//   final EdgeInsetsGeometry? contentPadding;
//   final String? hint;
//   final String? labelText;
//   final String? initialValue;
//   final bool? obscureText;
//   final bool? filled;
//   final bool? isCollapsed;
//   final bool? isDense;
//   final bool? isEnabled;
//   final bool? readOnly;
//   final Color? fillColor;
//   final Color? hintColor;
//   final Color? inputColor;
//   final Color? borderColor;
//   final Color? focusBorderColor;
//   final Color? cursorColor;
//   final Widget? suffixIcon;
//   final Widget? prefixIcon;
//   final FocusNode? focusNode;
//   final TextInputType? keyboardType;
//   final TextInputAction? inputAction;
//   final AutovalidateMode? autoValidateMode;
//   final TextStyle? textStyle;
//   final TextStyle? errorTextStyle;
//   final InputDecoration? customDecoration;
//   final String? semanticLabel;
//   final List<TextInputFormatter>? inputFormatters;
//   final void Function()? onTap;
//   final void Function(String)? onChanged;
//   final void Function(String)? onFieldSubmitted;
//   final void Function(PointerDownEvent)? onTapOutside;
//   final TextEditingController? controller;
//   final ValidationType? validationType;

//   const CustomTextFormField({
//     super.key,
//     this.maxline,
//     this.maxLength,
//     this.height,
//     this.hintSize,
//     this.borderRadius,
//     this.horizontalPadding,
//     this.verticalPadding,
//     this.contentPadding,
//     this.hint,
//     this.labelText,
//     this.initialValue,
//     this.obscureText,
//     this.filled = true,
//     this.isCollapsed,
//     this.isDense,
//     this.isEnabled,
//     this.readOnly,
//     this.fillColor,
//     this.hintColor,
//     this.inputColor,
//     this.borderColor,
//     this.focusBorderColor,
//     this.cursorColor,
//     this.suffixIcon,
//     this.prefixIcon,
//     this.focusNode,
//     this.keyboardType,
//     this.inputAction,
//     this.autoValidateMode,
//     this.textStyle,
//     this.errorTextStyle,
//     this.customDecoration,
//     this.semanticLabel,
//     this.inputFormatters,
//     this.onTap,
//     this.onChanged,
//     this.onFieldSubmitted,
//     this.onTapOutside,
//     this.controller,
//     this.validationType,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: height ?? 50,
//       child: TextFormField(
//         controller: controller,
//         focusNode: focusNode,
//         maxLength: maxLength,
//         obscureText: obscureText ?? false,
//         cursorColor: cursorColor,
//         maxLines:
//             (obscureText ?? false)
//                 ? 1
//                 : (maxline ?? 1), // Ensure obscureText is single line
//         textInputAction: inputAction,
//         initialValue: initialValue,
//         style: textStyle ?? txtTheme(context).bodyMedium,
//         autofocus: false,
//         keyboardType: keyboardType,
//         onChanged: onChanged,
//         inputFormatters: inputFormatters ?? _getInputFormatters(),
//         autovalidateMode: autoValidateMode,
//         readOnly: readOnly ?? false,
//         enabled: isEnabled ?? true,
//         decoration:
//             customDecoration ??
//             InputDecoration(
//               labelText: labelText,
//               counterText: '',
//               hintText: hint,
//               hintStyle: GoogleFonts.nunito(
//                 color: hintColor ?? colorScheme(context).outline,
//                 fontSize: hintSize ?? 14,
//               ),
//               filled: filled ?? true,
//               fillColor: fillColor ?? colorScheme(context).surface,
//               prefixIcon: prefixIcon,
//               suffixIcon: suffixIcon,
//               contentPadding:
//                   contentPadding ??
//                   EdgeInsets.symmetric(
//                     horizontal: horizontalPadding ?? 20.0,
//                     vertical: verticalPadding ?? 12,
//                   ),
//               errorStyle: errorTextStyle,
//               errorMaxLines: 2,
//               isCollapsed: isCollapsed ?? false,
//               isDense: isDense,
//               enabledBorder: OutlineInputBorder(
//                 borderSide: BorderSide(
//                   color: borderColor ?? colorScheme(context).onSurface,
//                   width: 1,
//                 ),
//                 borderRadius: BorderRadius.circular(borderRadius ?? 6),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderSide: BorderSide(
//                   color: focusBorderColor ?? colorScheme(context).onSurface,
//                   width: 2,
//                 ),
//                 borderRadius: BorderRadius.circular(borderRadius ?? 6),
//               ),
//               errorBorder: OutlineInputBorder(
//                 borderSide: BorderSide(
//                   color: colorScheme(context).outline,
//                   width: 1,
//                 ),
//                 borderRadius: BorderRadius.circular(borderRadius ?? 6),
//               ),
//               focusedErrorBorder: OutlineInputBorder(
//                 borderSide: BorderSide(
//                   color: colorScheme(context).outline,
//                   width: 1,
//                 ),
//                 borderRadius: BorderRadius.circular(borderRadius ?? 6),
//               ),
//               disabledBorder: OutlineInputBorder(
//                 borderSide: BorderSide(
//                   color: colorScheme(context).outline,
//                   width: 1,
//                 ),
//                 borderRadius: BorderRadius.circular(borderRadius ?? 10),
//               ),
//             ),
//         validator: (value) => _validateInput(value),
//         onFieldSubmitted: onFieldSubmitted,
//         onTapOutside:
//             onTapOutside ??
//             (event) {
//               FocusManager.instance.primaryFocus?.unfocus();
//             },
//       ),
//     );
//   }

//   String? _validateInput(String? value) {
//     switch (validationType) {
//       case ValidationType.email:
//         if (value == null || !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
//           return 'Please enter a valid email address';
//         }
//         break;
//       case ValidationType.password:
//         if (value == null || value.length < 8) {
//           return 'Password must be at least 8 characters long';
//         }
//         break;
//       case ValidationType.phoneNumber:
//         if (value == null || !RegExp(r'^\d{10,11}$').hasMatch(value)) {
//           return 'Please enter a valid phone number';
//         }
//         break;
//       case ValidationType.cnic:
//         if (value == null || !RegExp(r'^\d{13}$').hasMatch(value)) {
//           return 'CNIC must be 13 digits';
//         }
//         break;
//       case ValidationType.name:
//         if (value == null || !RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
//           return 'Please enter a valid name';
//         }
//         break;
//       case ValidationType.url:
//         if (value == null ||
//             !RegExp(r'^(https?|ftp)://[^\s/$.?#].[^\s]*$').hasMatch(value)) {
//           return 'Please enter a valid URL';
//         }
//         break;
//       case ValidationType.number:
//         if (value == null ||
//             value.length < 8 ||
//             !RegExp(r'^\d+$').hasMatch(value)) {
//           return 'Please enter a valid number';
//         }
//         break;
//       case ValidationType.none:
//       default:
//         break;
//     }
//     return null;
//   }

//   List<TextInputFormatter>? _getInputFormatters() {
//     switch (validationType) {
//       case ValidationType.email:
//         return [FilteringTextInputFormatter.deny(RegExp(r'\s'))];
//       case ValidationType.phoneNumber:
//       case ValidationType.cnic:
//       case ValidationType.number:
//         return [FilteringTextInputFormatter.digitsOnly];
//       case ValidationType.name:
//         return [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'))];
//       case ValidationType.password:
//         return [FilteringTextInputFormatter.singleLineFormatter];
//       case ValidationType.url:
//       case ValidationType.none:
//       default:
//         return null;
//     }
//   }
// }

// enum ValidationType {
//   none,
//   email,
//   password,
//   phoneNumber,
//   cnic,
//   name,
//   url,
//   number,
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rentit/src/common/const/global_variable.dart';

class CustomTextFormField extends StatelessWidget {
  final int? maxline;
  final int? maxLength;
  final double? height;
  final double? hintSize;
  final double? borderRadius;
  final double? horizontalPadding;
  final double? verticalPadding;
  final EdgeInsetsGeometry? contentPadding;
  final String? hint;
  final String? labelText;
  final String? initialValue;
  final bool? obscureText;
  final bool? filled;
  final bool? isCollapsed;
  final bool? isDense;
  final bool? isEnabled;
  final bool? readOnly;
  final Color? fillColor;
  final Color? hintColor;
  final Color? inputColor;
  final Color? borderColor;
  final Color? focusBorderColor;
  final Color? cursorColor;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final TextInputAction? inputAction;
  final AutovalidateMode? autoValidateMode;
  final TextStyle? textStyle;
  final TextStyle? errorTextStyle;
  final InputDecoration? customDecoration;
  final String? semanticLabel;
  final List<TextInputFormatter>? inputFormatters;
  final void Function()? onTap;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final void Function(PointerDownEvent)? onTapOutside;
  final TextEditingController? controller;
  final ValidationType? validationType;
  final TextCapitalization textCapitalization;

  const CustomTextFormField({
    super.key,
    this.maxline,
    this.maxLength,
    this.height,
    this.hintSize,
    this.borderRadius,
    this.horizontalPadding,
    this.verticalPadding,
    this.contentPadding,
    this.hint,
    this.labelText,
    this.initialValue,
    this.obscureText,
    this.filled = true,
    this.isCollapsed,
    this.isDense,
    this.isEnabled,
    this.readOnly,
    this.fillColor,
    this.hintColor,
    this.inputColor,
    this.borderColor,
    this.focusBorderColor,
    this.cursorColor,
    this.suffixIcon,
    this.prefixIcon,
    this.focusNode,
    this.keyboardType,
    this.inputAction,
    this.autoValidateMode,
    this.textStyle,
    this.errorTextStyle,
    this.customDecoration,
    this.semanticLabel,
    this.inputFormatters,
    this.onTap,
    this.onChanged,
    this.onFieldSubmitted,
    this.onTapOutside,
    this.controller,
    this.validationType,
    this.textCapitalization = TextCapitalization.none,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        maxLength: maxLength,
        obscureText: obscureText ?? false,
        cursorColor: cursorColor,
        maxLines:
            (obscureText ?? false)
                ? 1
                : (maxline ?? 1), // Ensure obscureText is single line
        textInputAction: inputAction,
        initialValue: initialValue,
        style: textStyle ?? txtTheme(context).bodyMedium,
        autofocus: false,
        keyboardType: keyboardType,
        onChanged: onChanged,
        inputFormatters: inputFormatters ?? _getInputFormatters(),
        autovalidateMode: autoValidateMode,
        readOnly: readOnly ?? false,
        enabled: isEnabled ?? true,
        textCapitalization: textCapitalization,
        decoration:
            customDecoration ??
            InputDecoration(
              labelText: labelText,
              labelStyle: GoogleFonts.nunito(
                color: colorScheme(context).onSurface.withValues(alpha: 0.6),
                fontSize: 14,
              ),
              counterText: '',
              hintText: hint,
              hintStyle: GoogleFonts.nunito(
                color: hintColor ?? Colors.black38,
                fontSize: hintSize ?? 14,
              ),
              filled: filled ?? true,
              fillColor: fillColor ?? Colors.white,
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
              contentPadding:
                  contentPadding ??
                  EdgeInsets.symmetric(
                    horizontal: horizontalPadding ?? 20.0,
                    vertical: verticalPadding ?? 12,
                  ),
              errorStyle: errorTextStyle,
              errorMaxLines: 2,
              isCollapsed: isCollapsed ?? false,
              isDense: isDense,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color:
                      borderColor ??
                      colorScheme(context).onSurface.withValues(alpha: 0.25),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(borderRadius ?? 5),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color:
                      focusBorderColor ??
                      colorScheme(context).onSurface.withValues(alpha: 0.25),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(borderRadius ?? 5),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: colorScheme(context).outline,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(borderRadius ?? 5),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: colorScheme(context).outline,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(borderRadius ?? 5),
              ),
              disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: colorScheme(context).outline,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(borderRadius ?? 5),
              ),
            ),
        validator: (value) => _validateInput(value),
        onFieldSubmitted: onFieldSubmitted,
        onTapOutside:
            onTapOutside ??
            (event) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
      ),
    );
  }

  String? _validateInput(String? value) {
    switch (validationType) {
      case ValidationType.empty:
        if (value == null || value.isEmpty) {
          return 'Field is required';
        }
        break;
      case ValidationType.email:
        if (value == null || !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return 'Please enter a valid email address';
        }
        break;
      case ValidationType.password:
        if (value == null || value.length < 8) {
          return 'Password must be at least 8 characters long';
        }
        break;
      case ValidationType.id:
        if (value == null || value.length < 8) {
          return 'Id must be at least 8 characters long';
        }
        break;
      case ValidationType.phoneNumber:
        if (value == null || !RegExp(r'^\d{10,11}$').hasMatch(value)) {
          return 'Please enter a valid phone number';
        }
        break;
      case ValidationType.cnic:
        if (value == null || !RegExp(r'^\d{13}$').hasMatch(value)) {
          return 'CNIC must be 13 digits';
        }
        break;
      case ValidationType.name:
        if (value == null || !RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
          return 'Please enter a valid name';
        }
        break;
      case ValidationType.url:
        if (value == null ||
            !RegExp(r'^(https?|ftp)://[^\s/$.?#].[^\s]*$').hasMatch(value)) {
          return 'Please enter a valid URL';
        }
        break;
      case ValidationType.number:
        if (value == null ||
            value.length < 8 ||
            !RegExp(r'^\d+$').hasMatch(value)) {
          return 'Please enter a valid number';
        }
        break;
      case ValidationType.none:
      default:
        break;
    }
    return null;
  }

  List<TextInputFormatter>? _getInputFormatters() {
    switch (validationType) {
      case ValidationType.email:
        return [FilteringTextInputFormatter.deny(RegExp(r'\s'))];
      case ValidationType.phoneNumber:
      case ValidationType.cnic:
      case ValidationType.number:
        return [FilteringTextInputFormatter.digitsOnly];
      case ValidationType.name:
        return [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'))];
      case ValidationType.password:
        return [FilteringTextInputFormatter.singleLineFormatter];
      case ValidationType.id:
        return [FilteringTextInputFormatter.singleLineFormatter];
      case ValidationType.url:
      case ValidationType.none:
      default:
        return null;
    }
  }
}

enum ValidationType {
  empty,
  none,
  email,
  password,
  id,
  phoneNumber,
  cnic,
  name,
  url,
  number,
}
