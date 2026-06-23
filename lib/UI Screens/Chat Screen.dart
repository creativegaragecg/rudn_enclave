import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../Utils/Constants/colors.dart';
import '../Utils/Constants/styles.dart';
import '../Utils/Custom/custom_text.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  final TextEditingController messageController = TextEditingController();
  final List<Map<String, dynamic>> messages = [];

  @override
  void initState() {
    super.initState();

    messages.add({
      "text": "Hello 👋\nWelcome to Rudn Support.\nHow can I help you today?",
      "isMe": false
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.golden,
        title: CustomText(
          text:    "Live Support",
          style: GoogleFonts.playfairDisplay(
              fontSize: 18.sp,
              color: Colors.white
          ),
        ),
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.white), // 👈 THIS
      ),
      backgroundColor: AppColors.background,
      body: Column(
        children: [



          /// ── Chat Messages ──
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(4.w),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                final isMe = msg['isMe'];

                return Align(
                  alignment:
                  isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 1.5.h),
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: isMe
                          ? AppColors.golden
                          : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (msg['image'] != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              msg['image'],
                              height: 120,
                              width: 120,
                              fit: BoxFit.cover,
                            ),
                          ),

                        if (msg['text'] != null)
                          CustomText(
                           text: msg['text'],
                            style: basicColor(15.5, isMe ? Colors.white : Colors.black, ),

                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          /// ── Improved Input Area ──
          SafeArea(
            child: Container(
              padding: EdgeInsets.fromLTRB(3.w, 1.h, 3.w, 1.5.h),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  )
                ],
              ),
              child: Row(
                children: [

                  /// Image Button
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.golden.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.image, color: AppColors.golden),
                      onPressed: () {
                        messages.add({
                          "image": "https://via.placeholder.com/150",
                          "isMe": true
                        });
                        setState(() {});
                      },
                    ),
                  ),

                  SizedBox(width: 2.w),

                  /// Text Field (Premium)
                  Expanded(
                    child: Container(
                      padding: EdgeInsetsGeometry.symmetric(horizontal: 2.w),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: messageController,
                              style: TextStyle(fontSize: 15.sp),
                              decoration: InputDecoration(
                                hintText: "Type message...",
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 4.w, vertical: 1.5.h),
                              ),
                            ),
                          ),

                          /// Send Button inside field
                          GestureDetector(
                            onTap: () {
                              if (messageController.text.isEmpty) return;

                              messages.add({
                                "text": messageController.text,
                                "isMe": true
                              });

                              messageController.clear();
                              setState(() {});
                            },
                            child: Container(
                              margin: EdgeInsets.all(1.w),
                              padding: EdgeInsets.all(2.w),
                              decoration: BoxDecoration(
                                color: AppColors.golden,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.send,
                                  color: Colors.white, size: 18),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// ── Ticket Button ──
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(3.w),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.darkBrown,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>CreateTicketScreen()));
              },
              icon: const Icon(Icons.confirmation_number, color: Colors.white),
              label: CustomText(
               text: "Generate Ticket",
                style: GoogleFonts.playfairDisplay(
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }


}


class CreateTicketScreen extends StatefulWidget {
  const CreateTicketScreen({super.key});

  @override
  State<CreateTicketScreen> createState() => _CreateTicketScreenState();
}

class _CreateTicketScreenState extends State<CreateTicketScreen> {

  final TextEditingController titleController = TextEditingController();
  final TextEditingController membershipController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController remarksController = TextEditingController();

  String? selectedType;
  String? selectedPriority;

  final List<String> ticketTypes = [
    "General Inquiry",
    "Complaint",
    "Payment Issue",
    "Technical Issue",
  ];

  final List<String> priorities = [
    "Low",
    "Medium",
    "High",
  ];

  String? selectedFileName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.golden,
        title: CustomText(
          text: "Create Ticket Request",
          style: GoogleFonts.playfairDisplay(
              fontSize: 18.sp, color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(5.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// TITLE
            _buildTextField(
              controller: titleController,
              label: "Title",
              hint: "Enter title",
              icon: Icons.title,
            ),

            SizedBox(height: 2.h),

            /// TYPE
            _buildDropdown(
              label: "Type",
              value: selectedType,
              hint: "Select Ticket Type",
              items: ticketTypes,
              onChanged: (val) => setState(() => selectedType = val),
            ),

            SizedBox(height: 2.h),

            /// PRIORITY ⭐
            _buildDropdown(
              label: "Priority",
              value: selectedPriority,
              hint: "Select Priority",
              items: priorities,
              onChanged: (val) => setState(() => selectedPriority = val),
            ),

            SizedBox(height: 2.h),




            /// PHONE ⭐
            _buildTextField(
              controller: phoneController,
              label: "Phone Number",
              hint: "Enter phone number",
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
            ),

            SizedBox(height: 2.h),

            /// DOCUMENT UPLOAD ⭐
            _buildUploadSection(),

            SizedBox(height: 2.h),

            /// REMARKS
            _buildTextField(
              controller: remarksController,
              label: "Remarks",
              hint: "Enter remarks",
              icon: Icons.notes,
              maxLines: 1,
            ),

            SizedBox(height: 4.h),

            /// SUBMIT
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
                onPressed: () {},
                child: Text(
                  "Submit Ticket",
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  /// DROPDOWN (Reusable)
  Widget _buildDropdown({
    required String label,
    required String? value,
    required String hint,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: label,
          style: basicColorBold(14.5, Colors.brown.shade700),
        ),
        SizedBox(height: 0.8.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 3.w),
          decoration: BoxDecoration(
            color: Colors.brown.shade50.withOpacity(0.6),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.brown.shade200),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              hint: CustomText(
                text: hint,
                style: basicColor(14.5, Colors.brown.shade300),
              ),
              isExpanded: true,
              icon: Icon(Icons.keyboard_arrow_down,
                  color: Colors.brown.shade400),
              items: items.map((item) {
                return DropdownMenuItem(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  /// TEXT FIELD (Same style as yours)
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
            style: basicColorBold(14.5, Colors.brown.shade700)),
        SizedBox(height: 0.8.h),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
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
          ),
        ),
      ],
    );
  }

  /// FILE UPLOAD UI
  Widget _buildUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: "Attach Document",
          style: basicColorBold(14.5, Colors.brown.shade700),
        ),
        SizedBox(height: 0.8.h),
        GestureDetector(
          onTap: () {
            // UI only
            setState(() {
              selectedFileName = "sample_document.pdf";
            });
          },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 2.h),
            decoration: BoxDecoration(
              color: Colors.brown.shade50.withOpacity(0.6),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.brown.shade200,
                style: BorderStyle.solid,
              ),
            ),
            child: Column(
              children: [
                Icon(Icons.upload_file,
                    color: Colors.brown.shade400, size: 22),
                SizedBox(height: 0.5.h),
                CustomText(
                  text: selectedFileName ?? "Upload File",
                  style: basicColor(
                      14, selectedFileName == null
                      ? Colors.brown.shade300
                      : Colors.brown.shade800),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}