import 'package:faisal_town/Utils/Constants/styles.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../Constants/colors.dart';
import 'custom_text.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.2.h),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Icon(Icons.arrow_back, color: AppColors.btnColor, size: 20),
            ),
          ),
          Expanded(
            child: CustomText(
            text : text,
              align: TextAlign.center,
              style: basicColorBold(18, AppColors.primary)
            ),
          ),
          SizedBox(width: 13.w),
        ],
      ),
    );
  }

}
