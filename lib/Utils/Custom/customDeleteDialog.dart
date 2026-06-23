import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../Constants/colors.dart';
import '../Constants/styles.dart';
import 'custom_button.dart';
import 'custom_text.dart';


class DeleteConfirmationDialog {
  static void show({
    required BuildContext context,
    required String title,
    required String message,
    required VoidCallback onDelete,
    VoidCallback? onCancel,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            width: 90.w,
            padding: EdgeInsets.all(5.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Warning Icon and Title
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.warning_rounded,
                        color: Colors.red.shade600,
                        size: 24.sp,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: title,
                            style: basicColorBold(17, Colors.black87),
                          ),
                          SizedBox(height: 0.5.h),
                          CustomText(
                            text: message,
                            style: basicColor(15.5, Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 3.h),

                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomButton(
                      width: 28.w,
                      padding: 1.5.h,
                      color: Colors.transparent,
                      text: "Cancel",
                      borderRadius: 8,
                      borderColor: AppColors.textInactive,
                      style: basicColorBold(15.5, Colors.grey.shade700),
                      onPressedCallback: () {
                        Navigator.pop(context);
                        if (onCancel != null) {
                          onCancel();
                        }
                      },
                    ),
                    SizedBox(width: 3.w),
                    CustomButton(
                      width: 28.w,
                      padding: 1.5.h,
                      color: Colors.red.shade600,
                      text: "Delete",
                      borderRadius: 8,
                      style: basicColorBold(15.5, Colors.white),
                      onPressedCallback: () {
                        Navigator.pop(context);
                        onDelete();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

