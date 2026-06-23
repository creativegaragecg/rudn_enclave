import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../Constants/colors.dart';
import '../Constants/styles.dart';


class CustomTextfield extends StatefulWidget {
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final VoidCallback? onPressed;
  String? iconPath;
  final String? hintText;
  double? width;
  Color? bgcolor;
  Color? cornerColor;
  Color? hintColor;
  double? height;
  double? size;
  bool? readMode;
  VoidCallback? onTap;
  int? maxLine;
  EdgeInsetsGeometry? padding;
  String? text;
  Color? iconcolor;
  double? iconHeight;
  double? iconwidth;
  IconData? iconName;
  IconData? passwordIcon;
   BorderRadiusGeometry? borderRadius;
   double? iconSize;
   bool? isPasswordField;

  CustomTextfield({
    super.key,
    this.isPasswordField,
    this.iconcolor,
    this.iconSize,
    this.iconName,
    this.borderRadius,
    this.iconHeight,
    this.iconwidth,
    this.text,
    this.maxLine,
    this.onTap,
    this.readMode,
    this.size,
    this.padding,
    this.height,
    this.bgcolor,
    this.hintColor,
    this.cornerColor,
    this.width,
    required this.controller,
    required this.obscureText,
    this.keyboardType,
    this.onPressed,
    this.iconPath,
    this.hintText,
    this.passwordIcon
  });

  @override
  State<CustomTextfield> createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends State<CustomTextfield> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding:widget.padding?? EdgeInsets.symmetric(horizontal: 2.w),
      height: widget.height?.h ?? 6.h,
      width: widget.width?.w ?? 100.w,
      decoration: BoxDecoration(
       color: widget.bgcolor?? AppColors.btnColor,
          borderRadius:widget.borderRadius??BorderRadius.circular(25),
     border: Border.all(color: widget.cornerColor??Colors.transparent)
      ),
      child:
      Row(
        children: [

       /// customize icon
          if(widget.iconName!=null)
          Icon(
            widget.iconName,
            size: widget.iconSize??23,
            color: widget.iconcolor ?? AppColors.iconInactive,
          ),
          if(widget.iconName!=null)

          SizedBox(width: 3.w,),
          SizedBox(width: 3.w,),

          Expanded(
            child: TextField(
              maxLines: widget.maxLine ?? 1,
              onTap: widget.onTap,
              readOnly: widget.readMode ?? false,
              controller: widget.controller,
              obscureText: widget.obscureText,
              keyboardType: widget.keyboardType,
              style:  basicColor(15, Colors.black),

              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(

                contentPadding: EdgeInsets.zero,
                //    fillColor: Colors.blue,
                border: InputBorder.none,
                isCollapsed: true,
                hintText: widget.hintText,
                hintStyle: TextStyle(

                  fontSize: widget.size ?? 11.sp,
                  fontFamily: "SF_PRO",
                  color: widget.hintColor??AppColors.primary,
                ), // Return null if iconPath is empty or null

              ),

            ),
          ),

          if(widget.isPasswordField==true)
            GestureDetector(
             onTap: widget.onPressed,
              child: Icon(
                widget.passwordIcon,
                size: widget.iconSize??21,
                color: widget.iconcolor ?? AppColors.primary,
              ),
            ),
        ],
      ),
    );
  }
}