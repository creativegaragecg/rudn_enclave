import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:faisal_town/Utils/Constants/styles.dart';
import 'package:url_launcher/url_launcher.dart';


import '../Custom/custom_text.dart';
import 'colors.dart';


extension StringCasingExtension on String {
  String toCapitalized() => length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';

  String toTitleCase() => replaceAll(RegExp(' +'), ' ').split(' ').map((str) => str.toCapitalized()).join(' ');
}

void close(BuildContext context) {
  Navigator.of(context, rootNavigator: true).pop('dialog');
}

ColorFilter getSvgColor(Color color) {
  return ColorFilter.mode(color, BlendMode.srcIn);
}


void showToast(String str) {
  Fluttertoast.showToast(
    msg: str,
    fontSize: 15.sp,
    toastLength: Toast.LENGTH_SHORT,
    backgroundColor:AppColors.primary,
    // fontAsset: "assets/fonts/PS-R.ttf"
  );
}


/// Returns true if the given email is in a valid format.
bool isValidEmail(String email) {
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$', caseSensitive: false);
  return emailRegex.hasMatch(email);
}


// Helper method to extract message
String extractErrorMessage(String exceptionString) {
try {
// Check if it contains JSON
if (exceptionString.contains('{') && exceptionString.contains('}')) {
// Extract JSON part
int startIndex = exceptionString.indexOf('{');
int endIndex = exceptionString.lastIndexOf('}') + 1;
String jsonString = exceptionString.substring(startIndex, endIndex);

// Parse JSON
Map<String, dynamic> errorJson = jsonDecode(jsonString);

// Return message
return errorJson['message'] ?? 'An error occurred';
}

// If no JSON, return original
return exceptionString;
} catch (e) {
return 'An error occurred';
}
}

Widget buildSectionCard({required List<Widget> children}) {
  return Container(
    padding: EdgeInsets.all(4.w),
    decoration: BoxDecoration(
      color: AppColors.cardWhite,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.03),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    ),
  );
}




// Custom function to convert DateTime to API format (yyyy-MM-dd)
String convertDateToApiFormat(DateTime date) {
  return DateFormat('yyyy-MM-dd').format(date);
}


Widget buildDropdownField({
  required String value,
  required List<String> items,
  required Function(String?) onChanged,
  double? height,
}) {
  return Container(
    height: height??6.h,
    padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.5.h),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey.shade300),
    ),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: value,
        isExpanded: true,
        icon:  Icon(Icons.keyboard_arrow_down),
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: CustomText(text: item,style: basicColor(16.5, AppColors.textPrimary),),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    ),
  );
}


Widget buildDateField({required TextEditingController date, required VoidCallback onTap,required Color iconColor}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      height: 6.h,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(text: date.text, style: basicColor(16.4, AppColors.textPrimary)),
          Icon(Icons.calendar_today, size: 16,  color:iconColor),
        ],
      ),
    ),
  );
}

String getMonthName(int month) {
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];
  return months[month - 1];
}



Widget buildTextField({
  required TextEditingController controller,
  required String hintText,
  int maxLines = 1,
}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey.shade300),
    ),
    child: TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.zero,
        hintText: hintText,
        hintStyle: basicColor(16, Colors.grey.shade400,),

        border: InputBorder.none,
      ),
    ),
  );
}

String formatDate(String dateString) {
  if(dateString=="N/A"){
    return '--';
  }
  if(dateString=="--"){
    return '--';
  }
  // Parse the date string
  DateTime dateTime = DateTime.parse(dateString);

  // List of month names
  const List<String> monthNames = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  // Get month name, day, and year
  String month = monthNames[dateTime.month - 1];
  String day = dateTime.day.toString();
  String year = dateTime.year.toString();

  // Return formatted date
  return '$month $day, $year';
}

String convertTo12Hour(String time24) {
  if (time24 == null || time24 == "--") return "--";

  final parts = time24.split(':');
  int hour = int.parse(parts[0]);
  int minute = int.parse(parts[1]);

  String period = hour >= 12 ? 'PM' : 'AM';
  hour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);

  return '$hour:${minute.toString().padLeft(2, '0')} $period';
}


buildTile(BuildContext context, IconData icon, String text) {
  return Row(
    children: [
      Icon(icon, color: AppColors.darkBlueCardColor, size: 18,),
      SizedBox(width: 4.w,),
      CustomText(text: text, style: basicColor(15.5, AppColors.textPrimary)),

    ],
  );
}


// Launch Helpers
// ─────────────────────────────────────────────────────────────────────────────
Future<void> launchPhone(String phone) async {
  final cleaned = phone.replaceAll(' ', '').replaceAll('-', '');
  final uri = Uri.parse('tel:+$cleaned');
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    debugPrint('Could not launch phone: $phone');
  }
}

Future<void> launchEmail(String email) async {
  final uri = Uri.parse('mailto:$email');
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    debugPrint('Could not launch email: $email');
  }
}

Future<void> launchWebsite(String url) async {
  final fullUrl = url.startsWith('http') ? url : 'https://$url';
  final uri = Uri.parse(fullUrl);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } else {
    debugPrint('Could not launch website: $url');
  }
}

Future<void> launchWhatsApp(String phone) async {
  final cleaned = phone.replaceAll(' ', '').replaceAll('-', '');
  final appUri = Uri.parse('whatsapp://send?phone=$cleaned');
  final webUri = Uri.parse('https://wa.me/$cleaned');
  if (await canLaunchUrl(appUri)) {
    await launchUrl(appUri);
  } else if (await canLaunchUrl(webUri)) {
    await launchUrl(webUri, mode: LaunchMode.externalApplication);
  } else {
    debugPrint('Could not launch WhatsApp: $phone');
  }
}

Future<void> openInBrowser(BuildContext context,url) async {
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Could not open the document')),
    );
  }
}

