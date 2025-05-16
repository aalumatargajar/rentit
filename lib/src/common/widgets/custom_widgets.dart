import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:rentit/src/common/const/app_images.dart';
import 'package:rentit/src/common/const/global_variable.dart';
import 'package:shimmer/shimmer.dart';

class CustomWidgets {
  //! Shimmer Loader
  static Shimmer shimmerLoader({
    required BuildContext context,
    required double height,
    double width = double.infinity,
  }) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SingleChildScrollView(
        // ✅ Added to prevent overflow
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Container(
            height: height,
            width: width,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme(context).surface,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 6,
                  spreadRadius: 2,
                  offset: const Offset(2, 3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //! Empty Widget
  static Container emptyWidget({
    required BuildContext context,
    required String title,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AppImages.onboarding,
              height: 150,
              width: double.infinity,
              fit: BoxFit.fitHeight,
            ),
            const SizedBox(height: 10),
            Text(title, style: txtTheme(context).titleSmall),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  //! SeeAllRow
  static Row seeAllRow({
    required BuildContext context,
    required String title,
    required VoidCallback onTap,
  }) {
    return Row(
      children: [
        Text(
          title,
          style: txtTheme(
            context,
          ).bodyLarge!.copyWith(fontWeight: FontWeight.w600),
        ),
        const Spacer(),
        TextButton(
          onPressed: onTap,

          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            backgroundColor: colorScheme(context).surface,
            foregroundColor: colorScheme(context).secondary,
          ),

          child: Text(
            "View All",
            style: txtTheme(
              context,
            ).bodySmall?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  static customNameAndDropDownMenu2({
    required String title,
    required String? selectedItem,
    required List<String> itemsList,
    required Function(Object?)? onChanged,
    required BuildContext context,
    String? hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: txtTheme(context).labelLarge),
        const SizedBox(height: 3),
        Container(
          height: 47,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: colorScheme(
                context,
              ).onSurface.withValues(alpha: 0.30 * 255),
            ),
          ),
          child: Center(
            child: DropdownButtonFormField2<String>(
              value: selectedItem,
              isExpanded: false,
              decoration: const InputDecoration(
                isDense: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(vertical: 12),
                border: InputBorder.none,
              ),
              items:
                  itemsList.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: const TextStyle(fontSize: 14)),
                    );
                  }).toList(),
              hint: Text(hint ?? 'Select', style: txtTheme(context).bodySmall),
              onChanged: onChanged,
              buttonStyleData: const ButtonStyleData(
                width: 120,
                padding: EdgeInsets.symmetric(horizontal: 8),
              ),
              dropdownStyleData: DropdownStyleData(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
