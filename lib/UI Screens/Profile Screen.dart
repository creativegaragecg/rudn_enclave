import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:faisal_town/Data/token.dart';
import 'package:faisal_town/Models/User Profile Model.dart';
import 'package:faisal_town/Providers/methods_provider.dart';
import 'package:faisal_town/UI%20Screens/Auth%20Screens/Login%20Screen.dart';
import 'package:faisal_town/Utils/Constants/styles.dart';
import 'package:faisal_town/Utils/Constants/urls.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Utils/Constants/colors.dart';
import '../Utils/Constants/images.dart';
import '../Utils/Custom/customAppbar.dart';
import '../Utils/Custom/custom_text.dart';
import 'Update Profile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => fetchData());
  }

  fetchData() {
    UserToken().loadUserInfo();
    var provider = Provider.of<MethodsViewModel>(context, listen: false);
    var url = "${AppEndPoints.baseUrl}${UserToken.slung}";
    dynamic params={
      'action': 'login',
      'username': UserToken.user_name,
      'password': UserToken.user_password, // ← send slug to API
    };
    provider.login(
        context,
        url,
        params,
        UserToken.slung,
      false,
      UserToken.slungId
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Consumer<MethodsViewModel>(
          builder: (context, value, child) {
            final profile = value.profileModel?.data;

            return Container(
              width: 100.w,
              height: 100.h,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(AppImages.bg),
                  fit: BoxFit.cover,
                ),
              ),
              child: value.loading
                  ? const Center(
                  child: CircularProgressIndicator(color: AppColors.golden))
                  : Column(
                children: [
                  CustomAppBar(text: "Profile"),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                          horizontal: 4.w, vertical: 2.h),
                      child: Column(
                        children: [
                          _AvatarCard(profile: profile),
                          SizedBox(height: 2.h),
                          _SectionCard(
                            title: 'Basic Information',
                            icon: Icons.person_pin_outlined,
                            accentColor:  AppColors.primary,
                            children: [
                              _FieldRow(
                                icon: Icons.person_outline,
                                label: 'Full Name',
                                value: profile?.name,
                                iconBg: const Color(0xFF1E2D4E),
                                iconOnDark: true,
                              ),
                              _FieldRow(
                                icon: Icons.email_outlined,
                                label: 'Email',
                                value: (profile?.email != null &&
                                    profile!.email!.isNotEmpty &&
                                    profile.email !=
                                        'dummy@dummy.com')
                                    ? profile.email
                                    : null,
                                iconBg: Colors.indigo.shade700,
                                iconOnDark: true,
                              ),
                              _FieldRow(
                                icon: Icons.badge_outlined,
                                label: 'CNIC',
                                value: profile?.cnic,
                                iconBg: Colors.teal.shade700,
                                iconOnDark: true,
                              ),
                              _FieldRow(
                                icon: Icons.cake_outlined,
                                label: 'Date of Birth',
                                value: (profile?.dob != null &&
                                    profile!.dob!.isNotEmpty)
                                    ? profile.dob
                                    : null,
                                iconBg: Colors.purple.shade700,
                                iconOnDark: true,
                              ),
                              _FieldRow(
                                icon: Icons.flag_outlined,
                                label: 'Country',
                                value: profile?.countryId?.toString(),
                                iconBg: Colors.orange.shade800,
                                iconOnDark: true,
                              ),
                              _FieldRow(
                                icon: Icons.location_city_outlined,
                                label: 'City',
                                value: profile?.cityId?.toString(),
                                iconBg: Colors.cyan.shade800,
                                iconOnDark: true,
                              ),
                              _FieldRow(
                                icon: Icons.location_on_outlined,
                                label: 'Address',
                                value: (profile?.address != null &&
                                    profile!.address!.isNotEmpty)
                                    ? profile.address
                                    : null,
                                iconBg: AppColors.primary,
                                iconOnDark: true,
                                isLast: true,
                              ),
                            ],
                          ),
                          SizedBox(height: 2.h),
                          _SectionCard(
                            title: 'Contact Information',
                            icon: Icons.contact_phone_outlined,
                            accentColor:  AppColors.primary,
                            children: [
                              _FieldRow(
                                icon: Icons.phone_outlined,
                                label: 'Mobile No',
                                value: (profile?.phone != null &&
                                    profile!.phone!.isNotEmpty)
                                    ? profile.phone
                                    : null,
                                iconBg: Colors.green.shade700,
                                iconOnDark: true,
                              ),
                              _FieldRow(
                                icon: Icons.phone_callback_outlined,
                                label: 'Alternate Phone',
                                value: (profile?.alternateMobile != null &&
                                    profile!.alternateMobile!.isNotEmpty)
                                    ? profile.alternateMobile
                                    : null,
                                iconBg: Colors.teal.shade600,
                                iconOnDark: true,
                              ),
                              _FieldRow(
                                icon: Icons.call_outlined,
                                label: 'Landline',
                                value: (profile?.landLine != null &&
                                    profile!.landLine!.isNotEmpty)
                                    ? profile.landLine
                                    : null,
                                iconBg: Colors.blueGrey.shade700,
                                iconOnDark: true,
                              ),
                              _FieldRow(
                                icon: Icons.chat_outlined,
                                label: 'WhatsApp',
                                value: (profile?.whatsappNo != null &&
                                    profile!.whatsappNo!.isNotEmpty)
                                    ? profile.whatsappNo
                                    : null,
                                iconBg: Colors.green.shade600,
                                iconOnDark: true,
                                isLast: true,
                              ),
                            ],
                          ),
                          SizedBox(height: 2.h),
                          _SectionCard(
                            title: 'Additional Information',
                            icon: Icons.info_outline,
                            accentColor: AppColors.primary,
                            children: [
                              _FieldRow(
                                icon: Icons.work_outline,
                                label: 'Occupation',
                                value: (profile?.occupation != null &&
                                    profile!.occupation!.isNotEmpty)
                                    ? profile.occupation
                                    : null,   // ← fixed
                                iconBg: Colors.amber.shade800,
                                iconOnDark: true,
                              ),
                              _FieldRow(
                                icon: Icons.people_outline,
                                label: 'Father/Husband',
                                value: profile?.sodowo,
                                iconBg: Colors.brown.shade600,
                                iconOnDark: true,
                              ),
                              _FieldRow(
                                icon: Icons.person_2_outlined,
                                label: 'Mother Name',
                                value: (profile?.motherName != null &&
                                    profile!.motherName!.isNotEmpty)
                                    ? profile.motherName
                                    : null,   // ← fixed
                                iconBg: Colors.pink.shade700,
                                iconOnDark: true,
                              ),
                              _FieldRow(
                                icon: Icons.badge_outlined,
                                label: 'Mother CNIC',
                                value: (profile?.motherCnic != null &&
                                    profile!.motherCnic!.isNotEmpty)
                                    ? profile.motherCnic
                                    : null,   // ← fixed
                                iconBg: Colors.deepPurple.shade700,
                                iconOnDark: true,
                                isLast: true,
                              ),
                            ],
                          ),
                        /*  SizedBox(height: 2.h),
                          _ActionCard(
                            iconWidget: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.pink.shade600,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.lock_outline,
                                  color: Colors.white, size: 22),
                            ),
                            label: 'Change Password',
                            subtitle: 'Update your login credentials',
                            onTap: () {},
                          ),*/
                          SizedBox(height: 2.h),
                       //   _LogoutButton(),
                         // SizedBox(height: 3.h),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Avatar Card
// ─────────────────────────────────────────────────────────────────────────────
class _AvatarCard extends StatelessWidget {
  final Data? profile;
  const _AvatarCard({this.profile});

  @override
  Widget build(BuildContext context) {
     String name = profile?.name ?? 'N/A';
    print("namee:$name");
    name=name.isEmpty?"N/A":name;
    final String fatherName =
    (profile?.sodowo != null && profile!.sodowo!.isNotEmpty)
        ? 'S/o ${profile!.sodowo}'
        : '';
    final String imageUrl = profile?.image ?? '';
    final String cnic = profile?.cnic ?? '';

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.btnColor,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Top accent strip
          Container(
            height: 10.h,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.08),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(22),
                topRight: Radius.circular(22),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(5.w, 1.5.h, 5.w, 3.h),
            child: Column(
              children: [
                // Edit button top-right
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditProfileScreen(profile: profile),
                          ),
                        );

                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 3.w, vertical: 0.8.h),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: AppColors.primary.withOpacity(0.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.edit_outlined,
                                size: 14, color: AppColors.primary),
                            SizedBox(width: 1.w),
                            CustomText(
                              text:'Edit',
                              style:basicColorBold(14.5, AppColors.primary)

                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 1.h),

                // Avatar with golden ring
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primary.withOpacity(0.6), width: 2),
                  ),
                  child: Container(
                    width: 26.w,
                    height: 26.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.btnColor,
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: imageUrl.isNotEmpty && imageUrl.contains('http')
                        ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Icon(Icons.person,
                          size: 16.w, color: AppColors.primary),
                    )
                        : Icon(Icons.person,
                        size: 16.w, color: AppColors.primary),
                  ),
                ),

                SizedBox(height: 1.5.h),

                // Name
                CustomText(
                text:   name,
                  align: TextAlign.center,
                  style: basicColorBold(18, AppColors.primary)
                ),

                if (fatherName.isNotEmpty) ...[
                  SizedBox(height: 0.5.h),
                  CustomText(
                   text:  fatherName.toUpperCase(),
                    style: basicColor(14.5, AppColors.brown)

                  ),
                ],

                SizedBox(height: 1.5.h),

                // CNIC badge
                if (cnic.isNotEmpty)
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 4.w, vertical: 0.8.h),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: AppColors.primary.withOpacity(0.5)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.badge_outlined,
                            size: 15, color: AppColors.primary),
                        SizedBox(width: 2.w),
                        CustomText(
                         text:  cnic,
                          style: basicColorBold(14, AppColors.primary)
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Section Card
// ─────────────────────────────────────────────────────────────────────────────
class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color accentColor;
  final List<Widget> children;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.accentColor,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.btnColor,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with colored left accent bar
          Container(
            padding:
            EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.8.h),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.08),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(22),
                topRight: Radius.circular(22),
              ),
              /*border: Border(
                left: BorderSide(color: accentColor, width: 4),
              ),*/
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, size: 16, color: Colors.white),
                ),
                SizedBox(width: 3.w),
                CustomText(
                 text: title,
                  style: basicColorBold(16.5, AppColors.darkBrown)

                ),
              ],
            ),
          ),

          // Fields
          Padding(
            padding:
            EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Field Row
// ─────────────────────────────────────────────────────────────────────────────
class _FieldRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? value;
  final Color? iconBg;
  final bool iconOnDark;
  final bool isLast;

  const _FieldRow({
    required this.icon,
    required this.label,
    this.value,
    this.iconBg,
    this.iconOnDark = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasValue = value != null && value!.isNotEmpty;
    final String display = hasValue ? value! : 'Not Available';

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 1.2.h),
          child:
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: iconBg ?? AppColors.iconBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon,
                    size: 17,
                    color: iconOnDark ? Colors.white : AppColors.darkBrown),
              ),

              SizedBox(width: 3.w),

              // Label — fixed width, left aligned
              Expanded(
                flex: 3,
                child: CustomText(
                  text: label,
                  style: basicColor(14, AppColors.primary),
                ),
              ),

              // Value pill — right aligned, fixed width
              Container(
                constraints: BoxConstraints(maxWidth: 48.w),
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.6.h),
                decoration: BoxDecoration(
                  color: hasValue
                      ? (iconBg ?? AppColors.primary).withOpacity(0.1)
                      : Colors.grey.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: CustomText(
                  text: display,
                  align: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: hasValue
                      ? basicColorBold(13.5, AppColors.primary)
                      : basicColor(13.5, AppColors.primary),
                ),
              ),
            ],
          ),
        ),
        if (!isLast)
          Divider(
            color: AppColors.darkBrown.withOpacity(0.08),
            thickness: 0.8,
            height: 0,
          ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Action Card
// ─────────────────────────────────────────────────────────────────────────────
class _ActionCard extends StatelessWidget {
  final Widget iconWidget;
  final String label;
  final String? subtitle;
  final VoidCallback onTap;

  const _ActionCard({
    required this.iconWidget,
    required this.label,
    this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: AppColors.btnColor,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.3),
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            iconWidget,
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.darkBrown,
                    ),
                  ),

                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color:AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.arrow_forward_ios,
                  size: 13, color: AppColors.btnColor),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Logout Button
// ─────────────────────────────────────────────────────────────────────────────
class _LogoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final prefs = await SharedPreferences.getInstance();
        prefs.setBool("login", false);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
              (route) => false,
        );
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 2.h),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.logout_rounded, color: AppColors.btnColor, size: 20),
            SizedBox(width: 3.w),
            Text(
              'LOGOUT',
              style: GoogleFonts.playfairDisplay(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                letterSpacing: 3,
                color: AppColors.btnColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}