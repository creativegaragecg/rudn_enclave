import 'dart:io';
import 'package:faisal_town/Models/CompaniesModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:faisal_town/Providers/methods_provider.dart';
import 'package:faisal_town/Utils/Constants/colors.dart';
import 'package:faisal_town/Utils/Constants/images.dart';
import 'package:faisal_town/Utils/Constants/styles.dart';
import 'package:faisal_town/Utils/Custom/customTextField.dart';
import 'package:faisal_town/Utils/Custom/custom_button.dart';
import 'package:faisal_town/Utils/Custom/custom_text.dart';
import 'package:faisal_town/Utils/Constants/utils.dart';
import '../../Utils/Constants/icons.dart';
import '../../Utils/Constants/urls.dart';
import 'Login Screen.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  // Controllers
  final _registrationNumberController = TextEditingController();
  final _firstNameController          = TextEditingController();
  final _lastNameController           = TextEditingController();
  final _emailController              = TextEditingController();
  final _phoneController              = TextEditingController();
  final _motherNameController         = TextEditingController();
  final _cityController               = TextEditingController();
  final _cnicController               = TextEditingController();
  final _passportNumberController     = TextEditingController();
  final _primaryWhatsappController    = TextEditingController();
  final _alternateMobileController    = TextEditingController();
  final _mailingAddressController     = TextEditingController();
  final _permanentAddressController   = TextEditingController();

  // Dropdown / date state
  String? _selectedSlug;
  String? _selectedSlugId;
  String? _selectedNationality = 'Pakistan';
  DateTime? _dateOfBirth;
  DateTime? _cnicExpiry;
  DateTime? _passportExpiry;

  // Phone country codes
  String _phoneCode     = '+92';
  String _whatsappCode  = '+92';
  String _alternateCode = '+92';

  // File picks
  File? _cnicFront;
  File? _cnicBack;
  File? _allotmentLetter;
  File? _profilePicture;

  bool _confirmed = false;
  // Add this new state variable
  bool _hasValidated = false;

  // ── Validation state ──────────────────────────────────────────────
  bool _cnicCheckPassed       = false;
  bool _membershipCheckPassed = false;
  bool _isValidating          = false;

  // Submit enabled only when both API checks succeed
  bool get _canSubmit => _cnicCheckPassed && _membershipCheckPassed;

  final _picker = ImagePicker();final _registrationFocusNode = FocusNode();


  static const List<String> _countryCodes  = ['+92', '+1', '+44', '+971', '+966', '+49', '+33', '+86'];
  static const List<String> _nationalities = [
    'Pakistan', 'Saudi Arabia', 'UAE', 'USA', 'UK', 'Canada', 'Germany', 'France', 'China', 'Other'
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = Provider.of<MethodsViewModel>(context, listen: false);
      await provider.fetchCompanies(
          context, "https://mis.faisaltown.com.pk/faisal_town/web/MemberportalAPIs.php?action=companies");
      if (provider.companiesModel?.data?.isNotEmpty == true) {
        setState(() {
          _selectedSlug   = provider.companiesModel!.data![0].slug;
          _selectedSlugId = provider.companiesModel!.data![0].id;
        });
      }
    });

    _registrationFocusNode.addListener(() {
      if (!_registrationFocusNode.hasFocus) {
        _onRegistrationNumberChanged();
      }
    });
  }

  // ── Fires on every keystroke, debounces 800ms then chains both APIs
  void _onRegistrationNumberChanged() {
    final regNo = _registrationNumberController.text.trim();

    if (_cnicCheckPassed || _membershipCheckPassed || _hasValidated) {
      setState(() {
        _cnicCheckPassed       = false;
        _membershipCheckPassed = false;
        _hasValidated          = false;
      });
    }

    if (regNo.length < 3) return;

    _runValidationChain(regNo); // call directly, no Future.delayed
  }


  // ── Step 1: checkCnic → Step 2: validateMembership ───────────────
  Future<void> _runValidationChain(String regNo) async {
    if (_selectedSlugId == null || _selectedSlug == null) {
      showToast("Please select a project first");
      return;
    }

    setState(() => _isValidating = true);

    final provider = Provider.of<MethodsViewModel>(context, listen: false);
    final String url = "${AppEndPoints.baseUrl}$_selectedSlug";

    // ── Step 1: checkCnic ─────────────────────────────────────────
    await provider.checkCnic(
      context,
      url,
      {
        'action'              : 'checkcnic',
        'project'             : _selectedSlugId,
        'registration_number' : regNo,
      },
      onResult: (cnicSuccess, cnicData) async {
        if (!mounted) return;

        if (!cnicSuccess) {
          setState(() {
            _cnicCheckPassed = false;
            _isValidating    = false;
          });
          return;
        }

        // Auto-fill CNIC from API response if available
        print("dd:$cnicData");
        final returnedCnic = cnicData?['data']?.toString() ?? '';
        print("object: $returnedCnic");
        if (returnedCnic.isNotEmpty) {
          _cnicController.text = returnedCnic;
        }

        setState(() => _cnicCheckPassed = true);

        // ── Step 2: validateMembership ──────────────────────────
        await provider.checkCnic(
          context,
          url,
          {
            'action'              : 'validatemembership',
            'project'             : _selectedSlugId,
            'registration_number' : regNo,
          },
          onResult: (membershipSuccess, _) {
            if (!mounted) return;
            setState(() {
              _membershipCheckPassed = membershipSuccess;
              _isValidating          = false;
              _hasValidated          = true; // <-- add this

            });
            if (!membershipSuccess) {
            /*  showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  backgroundColor: const Color(0xFF1E2A3A),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  title: Row(
                    children: [
                      Icon(CupertinoIcons.xmark_circle_fill, color: Colors.redAccent, size: 22),
                      SizedBox(width: 8),
                      Text(
                        "Membership Failed",
                        style: TextStyle(
                          fontFamily: "SF_PRO",
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  content: Text(
                    "Membership validation failed. Please check your registration number.",
                    style: TextStyle(
                      fontFamily: "SF_PRO",
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        "OK",
                        style: TextStyle(
                          fontFamily: "SF_PRO",
                          color: AppColors.btnColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              );*/
            }
          },
        );
      },
    );
  }

  @override
  void dispose() {

    _registrationNumberController.removeListener(_onRegistrationNumberChanged);
    _registrationNumberController.dispose();
    _registrationFocusNode.dispose();

    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _motherNameController.dispose();
    _cityController.dispose();
    _cnicController.dispose();
    _passportNumberController.dispose();
    _primaryWhatsappController.dispose();
    _alternateMobileController.dispose();
    _mailingAddressController.dispose();
    _permanentAddressController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(Function(File) onPicked) async {
    final picked = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked != null) onPicked(File(picked.path));
  }

  Future<void> _pickDate(DateTime? current, Function(DateTime) onPicked) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: current ?? DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(2100),
      builder: (ctx, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: ColorScheme.dark(primary: AppColors.btnColor, surface: const Color(0xFF1E2A3A)),
        ),
        child: child!,
      ),
    );
    if (picked != null) onPicked(picked);
  }

  String _formatDate(DateTime? date) =>
      date == null ? 'mm/dd/yyyy' : '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}';

  String _formatDateForApi(DateTime? date) =>
      date == null ? '' : '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  void _submit(MethodsViewModel provider) {
    if (!_canSubmit)                                { showToast("Registration number validation failed"); return; }
    if (_selectedSlug == null)                      { showToast("Please select a project"); return; }
    if (_firstNameController.text.isEmpty)          { showToast("First name is required"); return; }
    if (_lastNameController.text.isEmpty)           { showToast("Last name is required"); return; }
    if (_emailController.text.isEmpty)              { showToast("Email is required"); return; }
    if (_phoneController.text.isEmpty)              { showToast("Phone number is required"); return; }
    if (_dateOfBirth == null)                       { showToast("Date of birth is required"); return; }
    if (_motherNameController.text.isEmpty)         { showToast("Mother name is required"); return; }
    if (_cityController.text.isEmpty)               { showToast("City is required"); return; }
    if (_cnicController.text.isEmpty)               { showToast("CNIC/NICOP is required"); return; }
    if (_cnicExpiry == null)                        { showToast("CNIC expiry date is required"); return; }
    if (_primaryWhatsappController.text.isEmpty)    { showToast("Primary WhatsApp is required"); return; }
    if (_allotmentLetter == null)                   { showToast("Allotment letter is required"); return; }
    if (_profilePicture == null)                    { showToast("Profile picture is required"); return; }
    if (_mailingAddressController.text.isEmpty)     { showToast("Mailing address is required"); return; }
    if (_permanentAddressController.text.isEmpty)   { showToast("Permanent address is required"); return; }
    if (!_confirmed)                                { showToast("Please confirm your information"); return; }

    provider.signupForm(
      context,
      "${AppEndPoints.baseUrl}$_selectedSlug",
      registrationNumber : _registrationNumberController.text.trim(),
      firstName          : _firstNameController.text.trim(),
      lastName           : _lastNameController.text.trim(),
      email              : _emailController.text.trim(),
      phone              : '$_phoneCode ${_phoneController.text.trim()}',
      dob                : _formatDateForApi(_dateOfBirth),
      motherName         : _motherNameController.text.trim(),
      nationality        : _selectedNationality ?? 'Pakistan',
      city               : _cityController.text.trim(),
      cnic               : _cnicController.text.trim(),
      cnicExpiry         : _formatDateForApi(_cnicExpiry),
      passportNumber     : _passportNumberController.text.trim(),
      passportExpiry     : _formatDateForApi(_passportExpiry),
      primaryWhatsapp    : '$_whatsappCode ${_primaryWhatsappController.text.trim()}',
      alternateMobile    : '$_alternateCode ${_alternateMobileController.text.trim()}',
      mailingAddress     : _mailingAddressController.text.trim(),
      permanentAddress   : _permanentAddressController.text.trim(),
      cnicFront          : _cnicFront,
      cnicBack           : _cnicBack,
      allotmentLetter    : _allotmentLetter!,
      profileImage       : _profilePicture!,
    );
  }

  // ─── BUILD ────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Container(
          width: 100.w,
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage(AppImages.loginBg), fit: BoxFit.cover),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 6.5.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 2.h),
                  Container(
                    height: 12.h,
                    width: 70.w,
                    child: SvgPicture.asset(AppIcons.appLogo, fit: BoxFit.contain,color: AppColors.btnColor,),
                  ),
                  SizedBox(height: 3.h),
                  _sectionTitle("MEMBER DETAILS FORM"),
                  SizedBox(height: 3.h),

                  // Project dropdown
                  Consumer<MethodsViewModel>(
                    builder: (context, provider, _) {
                      final companies = provider.companiesModel?.data ?? [];
                      return CustomDropdown<Datum>(
                        items: companies,
                        value: companies.isEmpty ? null
                            : companies.firstWhere((d) => d.slug == _selectedSlug, orElse: () => companies.first),
                        isLoading: provider.loading && companies.isEmpty,
                        hintText: "SELECT PROJECT",
                        cornerColor: AppColors.btnColor,
                        size: 15.5.sp,
                        itemLabel: (d) => d.name ?? '',
                        onChanged: (datum) => setState(() {
                          _selectedSlug          = datum?.slug;
                          _selectedSlugId        = datum?.id;
                          _cnicCheckPassed       = false;
                          _membershipCheckPassed = false;
                        }),
                      );
                    },
                  ),
                  SizedBox(height: 2.2.h),

                  // ── Registration Number with live validation
                  _buildRegistrationField(),
                  SizedBox(height: 2.2.h),

                  _twoColumnRow(
                    _buildField("FIRST NAME *", _firstNameController),
                    _buildField("LAST NAME *", _lastNameController),
                  ),
                  SizedBox(height: 2.2.h),

                  _twoColumnRow(
                    _buildField("EMAIL *", _emailController, keyboardType: TextInputType.emailAddress),
                    _buildPhoneField("PHONE NO. *", _phoneController, _phoneCode,
                            (v) => setState(() => _phoneCode = v)),
                  ),
                  SizedBox(height: 2.2.h),

                  _twoColumnRow(
                    _buildDateField("DATE OF BIRTH *", _dateOfBirth,
                            () => _pickDate(_dateOfBirth, (d) => setState(() => _dateOfBirth = d))),
                    _buildField("MOTHER NAME *", _motherNameController),
                  ),
                  SizedBox(height: 2.2.h),

                  _twoColumnRow(
                    _buildNationalityDropdown(),
                    _buildField("CITY *", _cityController),
                  ),
                  SizedBox(height: 2.2.h),

                  _twoColumnRow(
                    _buildField("CNIC / NICOP *", _cnicController, keyboardType: TextInputType.number),
                    _buildDateField("CNIC/NICOP EXPIRY DATE *", _cnicExpiry,
                            () => _pickDate(_cnicExpiry, (d) => setState(() => _cnicExpiry = d))),
                  ),
                  SizedBox(height: 2.2.h),

                  _twoColumnRow(
                    _buildField("PASSPORT NUMBER", _passportNumberController),
                    _buildDateField("PASSPORT EXPIRY DATE", _passportExpiry,
                            () => _pickDate(_passportExpiry, (d) => setState(() => _passportExpiry = d))),
                  ),
                  SizedBox(height: 2.2.h),

                  _twoColumnRow(
                    _buildPhoneField("PRIMARY WHATSAPP NO *", _primaryWhatsappController,
                        _whatsappCode, (v) => setState(() => _whatsappCode = v)),
                    _buildPhoneField("ALTERNATE MOBILE NUMBER", _alternateMobileController,
                        _alternateCode, (v) => setState(() => _alternateCode = v)),
                  ),
                  SizedBox(height: 2.2.h),

                  _twoColumnRow(
                    _buildFilePicker("UPLOAD CNIC FRONT *", _cnicFront,
                            () => _pickImage((f) => setState(() => _cnicFront = f))),
                    _buildFilePicker("UPLOAD CNIC BACK *", _cnicBack,
                            () => _pickImage((f) => setState(() => _cnicBack = f))),
                  ),
                  SizedBox(height: 2.2.h),

                  _twoColumnRow(
                    _buildFilePicker("UPLOAD ALLOTMENT LETTER *", _allotmentLetter,
                            () => _pickImage((f) => setState(() => _allotmentLetter = f))),
                    _buildFilePicker("UPLOAD PROFILE PICTURE *", _profilePicture,
                            () => _pickImage((f) => setState(() => _profilePicture = f))),
                  ),
                  SizedBox(height: 2.2.h),

                  _buildTextAreaField("MAILING & DELIVERY ADDRESS *", _mailingAddressController),
                  SizedBox(height: 2.2.h),

                  _buildTextAreaField("PERMANENT ADDRESS *", _permanentAddressController),
                  SizedBox(height: 3.h),

                  _buildConfirmationRow(),
                  SizedBox(height: 3.h),

                  // ── Submit with validation badges
                  Consumer<MethodsViewModel>(
                    builder: (context, provider, _) {
                      final bool isActive = _canSubmit && !provider.loading && !_isValidating;
                      return Column(
                        children: [
                          // Show badges only after user has typed a reg number
                          if (_hasValidated && _registrationNumberController.text.trim().isNotEmpty)
                            _buildValidationBadges(),
                          SizedBox(height: 1.5.h),
                          CustomButton(
                            color: isActive ? AppColors.btnColor : AppColors.iconInactive,
                            text: provider.loading ? "SUBMITTING..." : "SUBMIT",
                            style: basicColor(17, AppColors.primary),
                            onPressedCallback: isActive ? () => _submit(provider) : null,
                          ),
                        ],
                      );
                    },
                  ),
                  SizedBox(height: 3.h),

                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: RichText(
                      text: TextSpan(
                        text: "Already Registered? ",
                        style: basicColor(15, Colors.white),
                        children: [
                          TextSpan(text: "LOGIN", style: basicColorBold(15, AppColors.btnColor)),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ─── Registration number field with inline spinner / tick / cross ─

  Widget _buildRegistrationField() {
    final hasText   = _registrationNumberController.text.trim().isNotEmpty;
    final bothPass  = _cnicCheckPassed && _membershipCheckPassed;
    final anyFail  = hasText && _hasValidated && !_isValidating && !bothPass; // only show error AFTER validation

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label("REGISTRATION NUMBER *"),
        Container(
          height: 6.h,
          decoration: BoxDecoration(
            color: AppColors.btnColor,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: _isValidating
                  ? AppColors.btnColor
                  : bothPass
                  ? Colors.greenAccent
                  : anyFail
                  ? Colors.redAccent
                  : AppColors.btnColor,
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _registrationNumberController,
                  focusNode: _registrationFocusNode, // <-- add this
                  style: TextStyle(fontSize: 14.5.sp, fontFamily: "SF_PRO", color: AppColors.primary),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 4.w),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 4.w),
                child: _isValidating
                    ? SizedBox(
                  width: 18, height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                )
                    : bothPass
                    ? Icon(CupertinoIcons.checkmark_circle_fill, color: Colors.greenAccent, size: 20)
                    : anyFail
                    ? Icon(CupertinoIcons.xmark_circle_fill, color: Colors.redAccent, size: 20)
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Two small badges showing individual check results ─────────────
  Widget _buildValidationBadges() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _badge("CNIC Check", _cnicCheckPassed),
        SizedBox(width: 3.w),
        _badge("Membership", _membershipCheckPassed),
      ],
    );
  }

  Widget _badge(String label, bool passed) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.6.h),
      decoration: BoxDecoration(
        color: passed ? Colors.greenAccent.withOpacity(0.12) : Colors.redAccent.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: passed ? Colors.greenAccent : Colors.redAccent),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            passed ? CupertinoIcons.checkmark_circle_fill : CupertinoIcons.xmark_circle_fill,
            color: passed ? Colors.greenAccent : Colors.redAccent,
            size: 14,
          ),
          SizedBox(width: 1.w),
          Text(label,
              style: TextStyle(fontSize: 12.sp, fontFamily: "SF_PRO",
                  color: passed ? Colors.greenAccent : Colors.redAccent)),
        ],
      ),
    );
  }

  // ─── Shared helpers ───────────────────────────────────────────────

  Widget _sectionTitle(String text) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 1.8.h, horizontal: 4.w),
      decoration: BoxDecoration(
        color: AppColors.btnColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.btnColor.withOpacity(0.4)),
      ),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(children: [
          TextSpan(text: "MEMBER ",
              style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.bold, fontFamily: "SF_PRO", color: AppColors.primary)),
          TextSpan(text: "DETAILS FORM",
              style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.bold, fontFamily: "SF_PRO", color: AppColors.primary)),
        ]),
      ),
    );
  }

  Widget _twoColumnRow(Widget left, Widget right) => Row(
    children: [Expanded(child: left), SizedBox(width: 3.w), Expanded(child: right)],
  );

  Widget _label(String text) => Padding(
    padding: EdgeInsets.only(bottom: 0.8.h),
    child: CustomText(text: text, style: basicColor(13.5, Colors.white70)),
  );

  Widget _buildField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _label(label),
      CustomTextfield(controller: controller, obscureText: false,
          cornerColor: AppColors.btnColor, hintText: "", size: 14.5.sp, keyboardType: keyboardType),
    ]);
  }

  Widget _buildPhoneField(String label, TextEditingController controller,
      String selectedCode, ValueChanged<String> onCodeChanged) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _label(label),
      Container(
        height: 6.h,
        decoration: BoxDecoration(color: AppColors.btnColor,
            borderRadius: BorderRadius.circular(25), border: Border.all(color: AppColors.btnColor)),
        child: Row(children: [
          Container(
            padding: EdgeInsets.only(left: 3.w),
            child: DropdownButtonHideUnderline(child: DropdownButton<String>(
              value: selectedCode, dropdownColor: AppColors.btnColor,
              style: TextStyle(fontSize: 14.sp, fontFamily: "SF_PRO", color: AppColors.primary),
              icon: Icon(CupertinoIcons.chevron_down, size: 14, color: AppColors.primary),
              items: _countryCodes.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (v) { if (v != null) onCodeChanged(v); },
            )),
          ),
          Container(width: 1, height: 3.h, color: AppColors.primary.withOpacity(0.3)),
          Expanded(child: TextField(
            controller: controller, keyboardType: TextInputType.phone,
            style: TextStyle(fontSize: 14.sp, fontFamily: "SF_PRO", color: AppColors.primary),
            decoration: InputDecoration(border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 3.w)),
          )),
        ]),
      ),
    ]);
  }

  Widget _buildDateField(String label, DateTime? date, VoidCallback onTap) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _label(label),
      GestureDetector(
        onTap: onTap,
        child: Container(
          height: 6.h,
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          decoration: BoxDecoration(color: AppColors.btnColor,
              borderRadius: BorderRadius.circular(25), border: Border.all(color: AppColors.btnColor)),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            CustomText(text: _formatDate(date),
                style: basicColor(14.5, date == null ? AppColors.primary.withOpacity(0.6) : AppColors.primary)),
            Icon(CupertinoIcons.calendar, size: 18, color: AppColors.primary),
          ]),
        ),
      ),
    ]);
  }

  Widget _buildNationalityDropdown() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _label("NATIONALITY *"),
      Container(
        height: 6.h, padding: EdgeInsets.symmetric(horizontal: 3.w),
        decoration: BoxDecoration(color: AppColors.btnColor,
            borderRadius: BorderRadius.circular(25), border: Border.all(color: AppColors.btnColor)),
        child: DropdownButtonHideUnderline(child: DropdownButton<String>(
          value: _selectedNationality, isExpanded: true, dropdownColor: AppColors.btnColor,
          icon: Icon(CupertinoIcons.chevron_down, size: 16, color: AppColors.primary),
          style: TextStyle(fontSize: 14.sp, fontFamily: "SF_PRO", color: AppColors.primary),
          items: _nationalities.map((n) => DropdownMenuItem(value: n, child: Text(n))).toList(),
          onChanged: (v) => setState(() => _selectedNationality = v),
        )),
      ),
    ]);
  }

  Widget _buildFilePicker(String label, File? file, VoidCallback onTap) {
    final bool picked = file != null;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _label(label),
      GestureDetector(
        onTap: onTap,
        child: Container(
          height: 6.h, padding: EdgeInsets.symmetric(horizontal: 3.w),
          decoration: BoxDecoration(
            color: AppColors.btnColor, borderRadius: BorderRadius.circular(25),
            border: Border.all(color: picked ? Colors.greenAccent.withOpacity(0.6) : AppColors.btnColor),
          ),
          child: Row(children: [
            Icon(picked ? CupertinoIcons.checkmark_circle_fill : CupertinoIcons.photo,
                size: 18, color: picked ? Colors.greenAccent : AppColors.primary),
            SizedBox(width: 2.w),
            Expanded(child: CustomText(
              text: picked ? file.path.split('/').last : "Choose file",
              style: basicColor(13.5, AppColors.primary), overflow: TextOverflow.ellipsis,
            )),
          ]),
        ),
      ),
    ]);
  }

  Widget _buildTextAreaField(String label, TextEditingController controller) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _label(label),
      Container(
        decoration: BoxDecoration(color: AppColors.btnColor,
            borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.btnColor)),
        child: TextField(
          controller: controller, maxLines: 3,
          style: TextStyle(fontSize: 14.sp, fontFamily: "SF_PRO", color: AppColors.primary),
          decoration: InputDecoration(border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h)),
        ),
      ),
    ]);
  }

  Widget _buildConfirmationRow() {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      GestureDetector(
        onTap: () => setState(() => _confirmed = !_confirmed),
        child: Container(
          width: 22, height: 22,
          decoration: BoxDecoration(
            color: _confirmed ? AppColors.btnColor : Colors.transparent,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: AppColors.btnColor, width: 2),
          ),
          child: _confirmed ? Icon(Icons.check, size: 14, color: AppColors.primary) : null,
        ),
      ),
      SizedBox(width: 3.w),
      Expanded(child: CustomText(
        text: "I confirm that the above information is true to the best of my knowledge.",
        style: basicColor(15, Colors.white),
      )),
    ]);
  }
}