import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../Constants/colors.dart';
import '../Constants/styles.dart';
import 'custom_text.dart';

class CustomHeader extends StatefulWidget {
  const CustomHeader({super.key, required this.headingText, required this.items});
  final String headingText;
  final String items;
  @override
  State<CustomHeader> createState() => _CustomHeaderState();
}

class _CustomHeaderState extends State<CustomHeader> {
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: EdgeInsets.symmetric(
          horizontal: 5.w, vertical: 1.h),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.arrow_back_ios,color: AppColors.textPrimary,size: 20,)),
              SizedBox(width: 3.w,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  CustomText(
                    text: widget.headingText,
                    style: basicColorBold(18, AppColors.textPrimary),
                  ),
                  CustomText(
                    text:
                    '${widget.items} items',
                    style: basicColor(
                        15, AppColors.textSecondary),
                  ),
                ],
              ),

            ],
          ),

          SizedBox(height: 1.h,),
          Divider(
              height: 1,
              color: Colors.grey.shade300),

        ],
      ),
    );
  }
}
