import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../Utils/Constants/colors.dart';
import '../Utils/Constants/styles.dart';
import '../Utils/Custom/custom_text.dart';

class CreateTransferRequestScreen extends StatefulWidget {
  const CreateTransferRequestScreen({super.key});

  @override
  State<CreateTransferRequestScreen> createState() =>
      _CreateTransferRequestScreenState();
}

class _CreateTransferRequestScreenState
    extends State<CreateTransferRequestScreen> {

  final _formKey = GlobalKey<FormState>();

  final TextEditingController membershipController = TextEditingController();
  final TextEditingController remarksController = TextEditingController();

  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.golden,
        title: CustomText(
          text: "Create Transfer Request",
          style: GoogleFonts.playfairDisplay(
              fontSize: 18.sp,
              color: Colors.white
          ),
        ),
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.white), // 👈 THIS
      ),
      body: Padding(
        padding: EdgeInsets.all(5.w),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(
                controller: membershipController,
                label: "Membership No",
                hint: "Enter membership number",
                icon: Icons.card_membership,
                maxLines: 1,
              ),


              SizedBox(height: 2.h),


              /// Date Picker
              GestureDetector(
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );

                  if (picked != null) {
                    setState(() {
                      selectedDate = picked;
                    });
                  }
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                      horizontal: 4.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: Colors.brown.shade50.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.brown.shade300),
                  ),
                  child: CustomText(
                    text: selectedDate == null
                        ? "Select Transfer Date"
                        : "${selectedDate!.day}-${selectedDate!
                        .month}-${selectedDate!.year}",
                    style: basicColor(14.5, selectedDate == null
                        ? Colors.brown.shade300
                        : Colors.black,),

                  ),
                ),
              ),

              SizedBox(height: 2.h),

              /// Remarks
              _buildTextField(
                controller: remarksController,
                label: "Remarks",
                hint: "Enter remarks",
                icon: Icons.card_membership,
                maxLines: 1,
              ),


              SizedBox(height: 4.h),

              /// Submit Button
              SizedBox(
                width: double.infinity,
                height: 6.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.golden,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: _submitForm,
                  child: Text(
                    "Submit Request",
                    style: GoogleFonts.playfairDisplay(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
            text: label,
            style: basicColorBold(14.5, Colors.brown.shade700,)
        ),
        SizedBox(height: 0.8.h),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          textAlignVertical: TextAlignVertical.center,
          style: TextStyle(fontSize: 14.5.sp, color: Colors.brown.shade900),
          decoration: InputDecoration(

            hintText: hint,
            hintStyle:
            TextStyle(fontSize: 14.5.sp, color: Colors.brown.shade300),
            prefixIcon:
            Icon(icon, size: 16.sp, color: Colors.brown.shade400),
            filled: true,
            fillColor: Colors.brown.shade50.withOpacity(0.6),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
              BorderSide(color: Colors.brown.shade200, width: 1.2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
              BorderSide(color: Colors.brown.shade500, width: 1.5),
            ),
            contentPadding: EdgeInsets.zero,

          ),
        ),
      ],
    );
  }

  /* /// TextField Widget
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Required";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }*/

  /// Submit Logic
  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;

    if (selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select date")),
      );
      return;
    }

    final data = {
      "membership_no": membershipController.text,
      "transfer_date": selectedDate.toString(),
      "remarks": remarksController.text,
    };

    print("Submit Data: $data");

    // TODO: Call API here using Provider

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Request Submitted")),
    );

    Navigator.pop(context);
  }
}