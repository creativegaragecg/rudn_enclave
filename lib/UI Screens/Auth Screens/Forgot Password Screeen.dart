import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:faisal_town/Providers/methods_provider.dart';
import 'package:faisal_town/Utils/Constants/colors.dart';
import 'package:faisal_town/Utils/Constants/images.dart';
import 'package:faisal_town/Utils/Constants/styles.dart';
import 'package:faisal_town/Utils/Constants/urls.dart';
import 'package:faisal_town/Utils/Constants/utils.dart';
import 'package:faisal_town/Utils/Custom/customTextField.dart';
import 'package:faisal_town/Utils/Custom/custom_button.dart';
import 'package:faisal_town/Utils/Custom/custom_text.dart';

import '../../Data/token.dart';
import '../../Models/CompaniesModel.dart';
import '../../Utils/Constants/icons.dart';
import 'Login Screen.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _cnicController = TextEditingController();
  String? selectedSlug;


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider= Provider.of<MethodsViewModel>(context, listen: false);
      // fetch companies when screen loads

      await provider.fetchCompanies(context, "https://mis.faisaltown.com.pk/faisal_town/web/MemberportalAPIs.php?action=companies");
      selectedSlug=provider.companiesModel?.data?[0].slug;
    });
  }

  @override
  void dispose() {
    _cnicController.dispose();
    super.dispose();
  }



  void _onSubmit(MethodsViewModel provider) async {
    final cnic = _cnicController.text.trim();

    if (cnic.isEmpty) {
      showToast("Please enter your CNIC");
      return;
    }

    await UserToken().loadUserInfo();
    final url = "${AppEndPoints.baseUrl}${selectedSlug}";
    provider.forgotPassword(context, url, cnic);
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

                  // ─── Logo ─────────────────────────────────────────────
                  Container(
                    height: 12.h,
                    width: 70.w,
                    child: SvgPicture.asset(AppIcons.appLogo, fit: BoxFit.contain,color: AppColors.btnColor,),
                  ),

                  SizedBox(height: 8.h),

                  // ─── Back arrow + Title row ───────────────────────────
                  Row(

                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                          size: 20.sp,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      CustomText(
                        text: "FORGOT PASSWORD",
                        style: basicColorBold(18, Colors.white),
                      ),
                    ],
                  ),

                  SizedBox(height: 1.5.h),

                  // ─── Subtitle ─────────────────────────────────────────
                  CustomText(
                    text:
                    "Enter your registered CNIC below. We will send your password reset instructions.",
                    style: basicColor(14.5, Colors.white),
                    align: TextAlign.center,
                  ),

                  SizedBox(height: 5.h),
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

                          });
                        },
                      );
                    },
                  ),
                  SizedBox(height: 2.h),

                  // ─── CNIC Field ───────────────────────────────────────
                  CustomTextfield(
                    controller: _cnicController,
                    obscureText: false,
                    cornerColor: AppColors.btnColor,
                    hintText: "CNIC",
                    size: 15.5.sp,
                  ),

                  SizedBox(height: 5.h),

                  // ─── Submit Button ────────────────────────────────────
                  Consumer<MethodsViewModel>(
                    builder: (context, provider, child) {
                      return CustomButton(
                        color: provider.loading
                            ? AppColors.iconInactive
                            : AppColors.btnColor,
                        text: provider.loading ? "SUBMITTING..." : "SUBMIT",
                        style: basicColor(17, AppColors.primary),
                        onPressedCallback:
                        provider.loading ? null : () => _onSubmit(provider),
                      );
                    },
                  ),

                  SizedBox(height: 2.5.h),

                  // ─── Back to Login ────────────────────────────────────
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(
                          text: 'Remembered it? ',
                          style: basicColor(15, Colors.white),
                        ),
                        CustomText(
                          text: 'SIGN IN',
                          style: basicColorBold(15, Colors.white),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 6.h),


                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}