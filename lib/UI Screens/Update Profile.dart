import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:faisal_town/Models/User Profile Model.dart';
import 'package:faisal_town/Providers/methods_provider.dart';
import 'package:faisal_town/Utils/Constants/colors.dart';
import 'package:faisal_town/Utils/Constants/images.dart';
import 'package:faisal_town/Utils/Constants/styles.dart';
import 'package:faisal_town/Utils/Constants/utils.dart';
import 'package:faisal_town/Utils/Custom/customAppbar.dart';
import 'package:faisal_town/Utils/Custom/customTextField.dart';
import 'package:faisal_town/Utils/Custom/custom_button.dart';
import 'package:faisal_town/Utils/Custom/custom_text.dart';
import '../Data/token.dart';
import '../Utils/Constants/urls.dart';

class _CountryCode {
  final String flag;
  final String name;
  final String code; // e.g. "+92"

  const _CountryCode({required this.flag, required this.name, required this.code});
}

const List<_CountryCode> _countryCodes = [
  _CountryCode(flag: '🇵🇰', name: 'Pakistan',      code: '+92'),
  _CountryCode(flag: '🇺🇸', name: 'USA',            code: '+1'),
  _CountryCode(flag: '🇬🇧', name: 'UK',             code: '+44'),
  _CountryCode(flag: '🇦🇪', name: 'UAE',            code: '+971'),
  _CountryCode(flag: '🇸🇦', name: 'Saudi Arabia',   code: '+966'),
  _CountryCode(flag: '🇮🇳', name: 'India',          code: '+91'),
  _CountryCode(flag: '🇧🇩', name: 'Bangladesh',     code: '+880'),
  _CountryCode(flag: '🇨🇦', name: 'Canada',         code: '+1'),
  _CountryCode(flag: '🇦🇺', name: 'Australia',      code: '+61'),
  _CountryCode(flag: '🇩🇪', name: 'Germany',        code: '+49'),
  _CountryCode(flag: '🇫🇷', name: 'France',         code: '+33'),
  _CountryCode(flag: '🇶🇦', name: 'Qatar',          code: '+974'),
  _CountryCode(flag: '🇰🇼', name: 'Kuwait',         code: '+965'),
  _CountryCode(flag: '🇴🇲', name: 'Oman',           code: '+968'),
  _CountryCode(flag: '🇧🇭', name: 'Bahrain',        code: '+973'),
  _CountryCode(flag: '🇹🇷', name: 'Turkey',         code: '+90'),
  _CountryCode(flag: '🇲🇾', name: 'Malaysia',       code: '+60'),
  _CountryCode(flag: '🇸🇬', name: 'Singapore',      code: '+65'),
  _CountryCode(flag: '🇨🇳', name: 'China',          code: '+86'),
  _CountryCode(flag: '🇯🇵', name: 'Japan',          code: '+81'),
];

class EditProfileScreen extends StatefulWidget {
  final Data? profile;
  const EditProfileScreen({super.key, this.profile});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _emailController    = TextEditingController();
  final _phoneController    = TextEditingController();
  final _addressController  = TextEditingController();
  final _currentPassCtrl    = TextEditingController();
  final _newPassCtrl        = TextEditingController();
  final _confirmPassCtrl    = TextEditingController();

  bool _obscureCurrent = true;
  bool _obscureNew     = true;
  bool _obscureConfirm = true;

  File? _pickedImage;
  final _picker = ImagePicker();

  // Default country code: Pakistan
  _CountryCode _selectedCountry = _countryCodes.first;

  @override
  void initState() {
    super.initState();
    final p = widget.profile;

    _emailController.text =
    (p?.email != null && p!.email!.isNotEmpty && p.email != 'dummy@dummy.com')
        ? p.email! : '';

    // If phone already has a country code prefix stored, try to match it
    final rawPhone = (p?.phone != null && p!.phone!.isNotEmpty) ? p.phone! : '';
    _initPhoneAndCode(rawPhone);

    _addressController.text =
    (p?.address != null && p!.address!.isNotEmpty) ? p.address! : '';
  }

  /// Splits a stored phone like "+923001234567" into code "+92" and local "3001234567"
  void _initPhoneAndCode(String rawPhone) {
    if (rawPhone.isEmpty) return;

    // Try to match longest code first (to handle +1 vs +971 edge cases)
    final sorted = List<_CountryCode>.from(_countryCodes)
      ..sort((a, b) => b.code.length.compareTo(a.code.length));

    for (final cc in sorted) {
      if (rawPhone.startsWith(cc.code)) {
        _selectedCountry = cc;
        _phoneController.text = rawPhone.substring(cc.code.length);
        return;
      }
    }
    // No matching prefix → just show the raw number
    _phoneController.text = rawPhone;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _currentPassCtrl.dispose();
    _newPassCtrl.dispose();
    _confirmPassCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? f = await _picker.pickImage(source: source, imageQuality: 80);
    if (f != null) setState(() => _pickedImage = File(f.path));
  }

  void _showPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.btnColor,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (_) => Padding(
        padding: EdgeInsets.fromLTRB(6.w, 1.5.h, 6.w, 4.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10.w, height: 4,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.25),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            SizedBox(height: 2.h),
            CustomText(text: 'Choose Photo',
                style: basicColorBold(16, AppColors.primary)

            ),
            SizedBox(height: 2.5.h),
            Row(
              children: [
                Expanded(child: _SheetTile(
                  icon: Icons.camera_alt_outlined, label: 'Camera',
                  onTap: () { Navigator.pop(context); _pickImage(ImageSource.camera); },
                )),
                SizedBox(width: 4.w),
                Expanded(child: _SheetTile(
                  icon: Icons.photo_library_outlined, label: 'Gallery',
                  onTap: () { Navigator.pop(context); _pickImage(ImageSource.gallery); },
                )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Shows the country-code picker bottom sheet
  void _showCountryPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.btnColor,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (_) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.55,
          maxChildSize: 0.85,
          builder: (_, scrollCtrl) => Column(
            children: [
              SizedBox(height: 1.5.h),
              Container(
                width: 10.w, height: 4,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              SizedBox(height: 1.5.h),
              CustomText( text: 'Select Country Code',
                  style: basicColorBold(15, AppColors.primary)

              ),
              SizedBox(height: 1.h),
              Divider(color: AppColors.primary.withOpacity(0.15)),
              Expanded(
                child: ListView.builder(
                  controller: scrollCtrl,
                  itemCount: _countryCodes.length,
                  itemBuilder: (_, i) {
                    final cc = _countryCodes[i];
                    final isSelected = cc.code == _selectedCountry.code &&
                        cc.name == _selectedCountry.name;
                    return ListTile(
                      leading: CustomText(text:cc.flag,
                          style: const TextStyle(fontSize: 24)),
                      title: CustomText( text:cc.name,
                          style:isSelected? basicColorBold(14, AppColors.darkBrown):basicColor(14, AppColors.darkBrown)
                    ),
                      trailing: CustomText(text:cc.code,
                          style: basicColor(14.5, AppColors.primary)
                    ),
                      tileColor: isSelected
                          ? AppColors.primary.withOpacity(0.07) : null,
                      onTap: () {
                        setState(() => _selectedCountry = cc);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _onSave() {
    final bool changing =
        _newPassCtrl.text.isNotEmpty || _confirmPassCtrl.text.isNotEmpty;

    if (changing) {
      if (_currentPassCtrl.text.isEmpty) {
        showToast("Enter your current password"); return;
      }
      if(_currentPassCtrl.text.trim()!=UserToken.user_password){
        showToast("Your current password is wrong"); return;

      }
      if (_newPassCtrl.text.length < 6) {
        showToast("New password must be at least 6 characters"); return;
      }
      if (_newPassCtrl.text != _confirmPassCtrl.text) {
        showToast("New passwords do not match"); return;
      }

    }

    // Concatenate country code + phone number (strip leading 0 from local if needed)
    final localPhone = _phoneController.text.trim();
    final fullPhone  = '${_selectedCountry.code}$localPhone'; // e.g. "+923001234567"

    var provider = Provider.of<MethodsViewModel>(context, listen: false);
    var url = "${AppEndPoints.baseUrl}${UserToken.slung}";

    dynamic params = {
      'action'           : 'update_profile',
      'id'               : UserToken.user_id,
      'project'          : 0,
      'cnic'             : widget.profile?.cnic  ?? '',
      'name'             : widget.profile?.name  ?? '',
      'country_code'     : _selectedCountry.code,   // e.g. "+92"
      'phone'            : localPhone,               // local part only
      'email'            : _emailController.text.trim(),
      'address'          : _addressController.text.trim(),
      'password'         : _newPassCtrl.text.trim(),
      'confirm_password' : _confirmPassCtrl.text.trim(),
      'profile_picture': _pickedImage
    };

   /* provider.login(
      context,
      url,
      params,
      UserToken.slung,
      false,
        UserToken.slungId

    ); */
    provider.updateProfile(
      context,
      url,
      params,
    );
  }

  @override
  Widget build(BuildContext context) {
    final p      = widget.profile;
    final name   = (p?.name  != null && p!.name!.isNotEmpty)  ? p.name!  : 'N/A';
    final cnic   = p?.cnic   ?? 'N/A';
    final imgUrl = p?.image  ?? '';

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Container(
          width: 100.w, height: 100.h,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppImages.bg), fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              CustomAppBar(text: "Edit Profile"),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // ── Avatar ────────────────────────────────────────────
                      Center(child: _buildAvatar(imgUrl)),
                      SizedBox(height: 3.h),

                      // ── Read-only strip (name + cnic) ─────────────────────
                      _ReadOnlyStrip(name: name, cnic: cnic),
                      SizedBox(height: 3.h),

                      // ── Contact Details ───────────────────────────────────
                      _SectionLabel(title: 'Contact Details'),
                      SizedBox(height: 1.5.h),

                      CustomTextfield(
                        controller: _emailController,
                        obscureText: false,
                        cornerColor: AppColors.primary,
                        hintText: "Email Address",
                        size: 14.sp,
                      ),
                      SizedBox(height: 1.8.h),

                      // ── Phone with country code ───────────────────────────
                      _PhoneField(
                        phoneController : _phoneController,
                        selectedCountry : _selectedCountry,
                        onTapCode       : _showCountryPicker,
                      ),
                      SizedBox(height: 1.8.h),

                      CustomTextfield(
                        controller: _addressController,
                        obscureText: false,
                        cornerColor: AppColors.primary,
                        hintText: "Address",
                        size: 14.sp,
                      ),
                      SizedBox(height: 3.h),

                      // ── Change Password ───────────────────────────────────
                      _SectionLabel(title: 'Change Password'),
                      SizedBox(height: 1.5.h),

                      CustomTextfield(
                        controller: _currentPassCtrl,
                        obscureText: _obscureCurrent,
                        cornerColor: AppColors.primary,
                        hintText: "Current Password",
                        size: 14.sp,
                        isPasswordField: true,
                        passwordIcon: _obscureCurrent
                            ? CupertinoIcons.eye : CupertinoIcons.eye_slash,
                        onPressed: () =>
                            setState(() => _obscureCurrent = !_obscureCurrent),
                      ),
                      SizedBox(height: 1.5.h),

                      CustomTextfield(
                        controller: _newPassCtrl,
                        obscureText: _obscureNew,
                        cornerColor: AppColors.primary,
                        hintText: "New Password",
                        size: 14.sp,
                        isPasswordField: true,
                        passwordIcon: _obscureNew
                            ? CupertinoIcons.eye : CupertinoIcons.eye_slash,
                        onPressed: () =>
                            setState(() => _obscureNew = !_obscureNew),
                      ),
                      SizedBox(height: 1.8.h),

                      CustomTextfield(
                        controller: _confirmPassCtrl,
                        obscureText: _obscureConfirm,
                        cornerColor: AppColors.primary,
                        hintText: "Confirm New Password",
                        size: 14.sp,
                        isPasswordField: true,
                        passwordIcon: _obscureConfirm
                            ? CupertinoIcons.eye : CupertinoIcons.eye_slash,
                        onPressed: () =>
                            setState(() => _obscureConfirm = !_obscureConfirm),
                      ),
                      SizedBox(height: 4.h),

                      // ── Save Button ───────────────────────────────────────
                      Consumer<MethodsViewModel>(
                        builder: (context, provider, _) => CustomButton(
                          color: provider.loading
                              ? AppColors.iconInactive : AppColors.primary,
                          text: provider.loading ? "SAVING..." : "SAVE CHANGES",
                          style: basicColor(16, AppColors.btnColor),
                          onPressedCallback: provider.loading ? null : _onSave,
                        ),
                      ),
                      SizedBox(height: 3.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(String imageUrl) {
    return GestureDetector(
      onTap: _showPicker,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary, width: 2.5),
            ),
            child: Container(
              width: 28.w, height: 28.w,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              clipBehavior: Clip.antiAlias,
              child: _pickedImage != null
                  ? Image.file(_pickedImage!, fit: BoxFit.cover)
                  : (imageUrl.isNotEmpty && imageUrl.contains('http')
                  ? Image.network(imageUrl, fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _defaultAvatar())
                  : _defaultAvatar()),
            ),
          ),
         /* Positioned(
            bottom: 0, right: -1,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary, shape: BoxShape.circle,
                border: Border.all(color: AppColors.btnColor, width: 2.5),
              ),
              child: Icon(Icons.camera_alt_rounded, size: 14, color: AppColors.btnColor),
            ),
          ),*/
        ],
      ),
    );
  }

  Widget _defaultAvatar() => Container(
    color: AppColors.btnColor,
    child: Icon(Icons.person, size: 14.w, color: AppColors.primary),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// Phone field with country code prefix button
// ─────────────────────────────────────────────────────────────────────────────
class _PhoneField extends StatelessWidget {
  final TextEditingController phoneController;
  final _CountryCode selectedCountry;
  final VoidCallback onTapCode;

  const _PhoneField({
    required this.phoneController,
    required this.selectedCountry,
    required this.onTapCode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary, width: 1.5),
        color: AppColors.btnColor.withOpacity(0.05),
      ),
      child: Row(
        children: [
          // ── Country code button ──────────────────────────────────────────
          GestureDetector(
            onTap: onTapCode,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.8.h),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.08),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(11),
                  bottomLeft: Radius.circular(11),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(selectedCountry.flag,
                      style: TextStyle(fontSize: 16.sp)),
                  SizedBox(width: 1.w),
                  CustomText(
                   text:  selectedCountry.code,
                    style: basicColor(14, Colors.black)

                  ),
                  SizedBox(width: 0.5.w),
                  Icon(Icons.arrow_drop_down,
                      color: Colors.black, size: 18),
                ],
              ),
            ),
          ),

          // ── Divider ──────────────────────────────────────────────────────
          Container(width: 1.5, height: 5.h, color: AppColors.primary.withOpacity(0.35)),

          // ── Phone number input ───────────────────────────────────────────
          Expanded(
            child: TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              style:  basicColor(15, Colors.black),
              decoration: InputDecoration(
                hintText: 'Mobile Number',
                hintStyle: basicColor(15,AppColors.primary),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 3.w),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Read-only strip
// ─────────────────────────────────────────────────────────────────────────────
class _ReadOnlyStrip extends StatelessWidget {
  final String name;
  final String cnic;
  const _ReadOnlyStrip({required this.name, required this.cnic});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.8.h),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.07),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.primary.withOpacity(0.8)),
      ),
      child: Row(
        children: [
          Icon(Icons.lock_outline, size: 17, color: AppColors.primary),
          SizedBox(width: 2.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(text: name, style: basicColorBold(14.5, AppColors.primary)),
                SizedBox(height: 0.4.h),
                CustomText(text: cnic, style: basicColor(14.5, AppColors.primary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Section label
// ─────────────────────────────────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String title;
  const _SectionLabel({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
       /* Container(
          width: 4, height: 20,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        SizedBox(width: 2.w),*/
        CustomText(
         text: title.toUpperCase(),
          style: basicColorBold(14.5, AppColors.darkBrown)
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Bottom sheet tile
// ─────────────────────────────────────────────────────────────────────────────
class _SheetTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _SheetTile({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 2.h),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.primary.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
              child: Icon(icon, size: 20, color: AppColors.btnColor),
            ),
            SizedBox(height: 1.h),
            CustomText(text: label,
                style: basicColor(14.5, AppColors.darkBrown)
            ),
          ],
        ),
      ),
    );
  }
}