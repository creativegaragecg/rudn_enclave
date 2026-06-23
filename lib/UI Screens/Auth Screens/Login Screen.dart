import 'package:faisal_town/Models/CompaniesModel.dart';
import 'package:faisal_town/UI%20Screens/Home%20Screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:faisal_town/Providers/methods_provider.dart';
import 'package:faisal_town/Repository/methods_repository.dart';
import 'package:faisal_town/Utils/Constants/colors.dart';
import 'package:faisal_town/Utils/Constants/images.dart';
import 'package:faisal_town/Utils/Constants/styles.dart';
import 'package:faisal_town/Utils/Custom/customTextField.dart';
import 'package:faisal_town/Utils/Custom/custom_button.dart';
import 'package:faisal_town/Utils/Custom/custom_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Utils/Constants/icons.dart';
import '../../Utils/Constants/urls.dart';
import '../../Utils/Constants/utils.dart';
import 'Forgot Password Screeen.dart';
import 'Signup page.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}


class _LoginPageState extends State<LoginPage> {
  TextEditingController cnicController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isPassword = true;
  String? selectedSlug;   // ← stores the selected slug
  String? selectedSlugId;   // ← stores the selected slug

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider= Provider.of<MethodsViewModel>(context, listen: false);
      // fetch companies when screen loads

       await provider.fetchCompanies(context, "https://mis.faisaltown.com.pk/faisal_town/web/MemberportalAPIs.php?action=companies");
      selectedSlug=provider.companiesModel?.data?[0].slug;
      selectedSlugId=provider.companiesModel?.data?[0].id;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Container(
          height: 100.h,
          width: 100.w,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppImages.loginBg),
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 6.5.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 4.h),
                  Container(
                    height: 12.h,
                    width: 70.w,
                    child: SvgPicture.asset(AppIcons.appLogo, fit: BoxFit.contain,color: AppColors.btnColor,),
                  ),
                  SizedBox(height: 7.h),

                  // ─── COMPANIES DROPDOWN ─────────────────────────────────
                  Consumer<MethodsViewModel>(
                    builder: (context, provider, child) {
                      final companies = provider.companiesModel?.data ?? [];

                      return CustomDropdown<Datum>(
                        items: companies,
                        value: companies.isEmpty
                            ? null
                            : companies.firstWhere(
                              (d) => d.slug == selectedSlug,
                          orElse: () => companies.first,
                        ),
                        isLoading: provider.loading && companies.isEmpty,
                        hintText: "SELECT COMPANY",
                        cornerColor: AppColors.btnColor,
                        size: 15.5.sp,
                        itemLabel: (d) => d.name ?? '',
                        onChanged: (datum) {
                          setState(() {
                            selectedSlug = datum?.slug;
                            selectedSlugId=datum?.id;
                            print("IDDD:$selectedSlugId");
                          });
                        },
                      );
                    },
                  ),
                  // ───────────────────────────────────────────────────────

                  SizedBox(height: 2.2.h),
                  CustomTextfield(
                    controller: cnicController,
                    obscureText: false,
                    cornerColor: AppColors.btnColor,
                    hintText: "CNIC",
                    size: 15.5.sp,
                  ),
                  SizedBox(height: 2.2.h),
                  CustomTextfield(
                    controller: passwordController,
                    obscureText: isPassword,
                    cornerColor: AppColors.btnColor,
                    hintText: "PASSWORD",
                    size: 15.5.sp,
                    isPasswordField: true,
                    passwordIcon: isPassword
                        ? CupertinoIcons.eye
                        : CupertinoIcons.eye_slash,
                    onPressed: () => setState(() => isPassword = !isPassword),
                  ),
                  SizedBox(height: 1.5.h),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ForgotPasswordPage()),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CustomText(
                          text: "FORGOT PASSWORD?",
                          style: basicColor(15, Colors.white),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Consumer<MethodsViewModel>(
                    builder: (context, provider, child) {
                      return CustomButton(
                        color: provider.loading
                            ? AppColors.iconInactive
                            : AppColors.btnColor,
                        text: provider.loading ? "SIGNING IN" : "SIGN IN",
                        style: basicColor(17, AppColors.primary),
                        onPressedCallback: provider.loading
                            ? null
                            : () {
                          if (selectedSlug == null) {
                            showToast("Please select a company");
                            return;
                          }
                          if (cnicController.text.isEmpty ||
                              passwordController.text.isEmpty) {
                            showToast("Please enter CNIC and Password");
                            return;
                          }
                          dynamic params={
                            'action': 'login',
                            'username': cnicController.text.trim(),
                            'password': passwordController.text.trim(), // ← send slug to API
                          };
                          provider.login(
                            context,
                            "${AppEndPoints.baseUrl}$selectedSlug",
                            params,
                            selectedSlug??"",
                            true,
                            selectedSlugId!
                          );
                        },
                      );
                    },
                  ),
                  SizedBox(height: 2.h),
                  GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SignupPage())),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(text: 'New Member? ', style:  basicColor(15, Colors.white)),
                        CustomText(text: ' REGISTER', style:  basicColorBold(15, Colors.white)),

                      ],
                    ),
                  ),

                  SizedBox(height: 4.h),

                  // ─── Contact Us ───────────────────────────────────────
                  Column(
                    children: [
                      CustomText(
                        text: "Contact Us",
                        style: basicColorBold(16, AppColors.mustard),
                        align: TextAlign.center,
                      ),
                      SizedBox(height: 1.2.h),
                      CustomText(
                        text: "In case of any query kindly email us at:",
                        style: basicColor(15, AppColors.mustard),
                        align: TextAlign.center,
                      ),
                      SizedBox(height: 0.5.h),
                      GestureDetector(
                        onTap: (){
                          launchEmail("memberportal@faisaltown.com.pk");
                        },
                        child: CustomText(
                          text: "memberportal@faisaltown.com.pk",
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontFamily: "SF_PRO",
                            color: AppColors.mustard,
                            decoration: TextDecoration.underline,
                            decorationColor: AppColors.mustard,
                          ),
                          align: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 1.5.h),
                      CustomText(
                        text: "UAN 051-111-324-725",
                        style: basicColorBold(15, AppColors.mustard),
                        align: TextAlign.center,
                      ),
                    ],
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> login(
      BuildContext context,
      String cnic,
      String password,
      String slug,          // ← receives selected slug
      MethodsViewModel provider,
      ) =>
      provider.postData<Map<String, dynamic>>(
        context,
            () => MethodsRepository().postRequest(
          "${AppEndPoints.baseUrl}$selectedSlug",
          params: {
            'action': 'login',
            'username': cnic,
            'password': password, // ← send slug to API
          },
        ),
            (val) {},
        onSuccess: (val) async {
          final bool success = val?['status'] ?? false;
          final String payload = val?['payload'] ?? '';
          if (success) {
            final prefs = await SharedPreferences.getInstance();
            prefs.setBool("login", true);
            showToast(payload);
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
                  (route) => false,
            );
          } else {
            showToast(payload.isNotEmpty ? payload : 'Login failed');
          }
        },
      );
}


// ═══════════════════════════════════════════════════════════════════
//  CustomDropdown — same visual design as CustomTextfield
// ═══════════════════════════════════════════════════════════════════

class CustomDropdown<T> extends StatelessWidget {
  final List<T> items;
  final T? value;
  final String? hintText;
  final Color? cornerColor;
  final Color? bgcolor;
  final Color? hintColor;
  final double? size;
  final double? height;
  final double? width;
  final BorderRadiusGeometry? borderRadius;
  final EdgeInsetsGeometry? padding;
  final ValueChanged<T?>? onChanged;
  final String Function(T) itemLabel;   // ← extracts display text from object
  final bool isLoading;

  const CustomDropdown({
    super.key,
    required this.items,
    required this.itemLabel,
    this.value,
    this.hintText,
    this.cornerColor,
    this.bgcolor,
    this.hintColor,
    this.size,
    this.height,
    this.width,
    this.borderRadius,
    this.padding,
    this.onChanged,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? EdgeInsets.symmetric(horizontal: 3.w),
      height: (height ?? 6).h,
      width: (width ?? 100).w,
      decoration: BoxDecoration(
        color: bgcolor ?? AppColors.btnColor,
        borderRadius: borderRadius ?? BorderRadius.circular(25),
        border: Border.all(color: cornerColor ?? Colors.transparent),
      ),
      child: DropdownButtonHideUnderline(
        child: isLoading
        // show a small spinner while companies are loading
            ? Row(
          children: [
            SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.primary,
              ),
            ),
            SizedBox(width: 3.w),
            Text(
              "Loading...",
              style: TextStyle(
                fontSize: size ?? 11.sp,
                fontFamily: "SF_PRO",
                color: hintColor ?? AppColors.primary,
              ),
            ),
          ],
        )
            : DropdownButton<T>(
          value: value,
          isExpanded: true,
          icon: Icon(
            CupertinoIcons.chevron_down,
            size: 18,
            color: hintColor ?? AppColors.primary,
          ),
          dropdownColor: AppColors.btnColor,
          hint: Text(
            hintText ?? '',
            style: TextStyle(
              fontSize: size ?? 11.sp,
              fontFamily: "SF_PRO",
              color: hintColor ?? AppColors.primary,
            ),
          ),
          style: TextStyle(
            fontSize: size ?? 11.sp,
            fontFamily: "SF_PRO",
            color: hintColor ?? AppColors.primary,
          ),
          items: items.map((item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Text(itemLabel(item)),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}