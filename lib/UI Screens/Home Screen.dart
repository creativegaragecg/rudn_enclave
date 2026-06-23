import 'package:faisal_town/Utils/Constants/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Data/token.dart';
import '../Models/User Profile Model.dart';
import '../Providers/methods_provider.dart';
import '../Utils/Constants/colors.dart';
import '../Utils/Constants/icons.dart';
import '../Utils/Constants/images.dart';
import '../Utils/Constants/urls.dart';
import '../Utils/Custom/custom_text.dart';
import '../Utils/Custom/webview.dart';
import 'Auth Screens/Login Screen.dart';

const _maroon     = Color(0xFF5C0A14);
const _memberCard = Color(0xFFEDE3D4);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  // 8 items — rendered as 3 + 3 + 2 (last row centered)
  final List<Map<String, dynamic>> _menuItems = [
    {'title': 'Profile',             'icon': AppIcons.profile,    'route': '/profile'},
    {'title': 'Property',            'icon': AppIcons.properties, 'route': '/properties'},
    {'title': 'Transfer History',            'icon': AppIcons.change,     'route': '/transfers'},
/*    {'title': 'Cancellation',        'icon': AppIcons.cancel,     'route': '/cancellations'},*/
    {'title': 'Customer Care',       'icon': AppIcons.customer,   'route': '/customer-care'},
    {'title': 'New Projects',        'icon': AppIcons.progress,   'route': '/progress'},
    {'title': 'Events',              'icon': AppIcons.search,     'route': '/events'},
/*
    {'title': 'Development\nStatus', 'icon': AppIcons.progress,   'route': '/progresss'},
*/
  ];


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchData());
  }

  void _fetchData() {
   /* UserToken().loadUserInfo();
    final provider = Provider.of<MethodsViewModel>(context, listen: false);
    final url = "${AppEndPoints.profile}&id=${UserToken.user_id}";
     provider.fetchProfile(context, url);*/

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
    final double sw    = 90.w;
    final double hPad  = sw * 0.1;
    final double gap   = sw * 0.03;
    final double cardW = (sw - hPad * 2 - gap * 2) / 3;
    final double cardH = cardW * 1.0;

    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(

          // Inside your FAB onPressed:
          onPressed: () async {
            print("object: url:https://faisaltown.com.pk/portal/members_portal/payonline_app.php?payfrom_phone=true&project=${UserToken.slungId}&username=${UserToken.user_name}&password=${UserToken.user_password}",);
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => WebViewScreen(
                  url:"https://faisaltown.com.pk/portal/members_portal/payonline_app.php?payfrom_phone=true&project=${UserToken.slungId}&username=${UserToken.user_name}&password=${UserToken.user_password}",
                  isPayment: true,
                ),
              ),
            );


          },
          backgroundColor: AppColors.primary,
         // elevation: 6,
          icon: const Icon(
            Icons.payment_rounded,
            color: Colors.white,
          ),
          label: CustomText(
           text:  'Pay Online',
            style: basicColorBold(14, Colors.white)
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
         //   side: BorderSide(color: AppColors.golden, width: 1.5),
          ),
        ),

        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        backgroundColor: _maroon,
        body: Container(
          height: 100.h,
          width: 100.w,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppImages.bg),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 2.h),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                           /* GestureDetector(
                                onTap: () async {
                                  print("object: url:https://faisaltown.com.pk/portal/members_portal/payonline_app.php?payfrom_phone=true&project=${UserToken.slungId}&username=${UserToken.user_name}&password=${UserToken.user_password}",);
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => WebViewScreen(
                                        url:"https://faisaltown.com.pk/portal/members_portal/payonline_app.php?payfrom_phone=true&project=${UserToken.slungId}&username=${UserToken.user_name}&password=${UserToken.user_password}",
                                        isPayment: true,
                                      ),
                                    ),
                                  );


                                },

                                child: Icon(Icons.payment,color: AppColors.primary,)),
                              SizedBox(width: 5.w,),*/
                            GestureDetector(
                                onTap: () async {
                                  final confirmed = await showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title:  CustomText(text: 'Logout',style: basicColorBold(17, Colors.black),),
                                      content: CustomText(text: 'Are you sure you want to logout?',style: basicColor(15.5, Colors.black)),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context, false),
                                          child: CustomText(text: 'Cancel',style: basicColor(14.5, Colors.black)),
                                        ),
                                        TextButton(
                                          onPressed: () => Navigator.pop(context, true),
                                          child: CustomText(text: 'Logout',style: basicColorBold(14.5, Colors.red),
                                          ),

                                        ),
                                      ],
                                    ),
                                  );

                                  if (confirmed == true) {
                                    final prefs = await SharedPreferences.getInstance();
                                    prefs.setBool("login", false);
                                    prefs.clear();
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(builder: (context) => const LoginPage()),
                                          (route) => false,
                                    );
                                  }
                                },
                                child: Icon(Icons.logout,color: AppColors.primary,)),
                          ],
                        ),
                        SizedBox(height: 6.h),

                        // ── Logo ──────────────────────────────────────────
                        SizedBox(
                          height: 12.h,
                          width: 70.w,
                          child: SvgPicture.asset(
                            AppIcons.appLogo,
                            color: AppColors.primary,
                            fit: BoxFit.contain,
                          ),
                        ),

                        SizedBox(height: 6.h),

                        // ── Membership Card ───────────────────────────────
                        Consumer<MethodsViewModel>(
                          builder: (context, provider, _) {
                            final profile = provider.profileModel?.data;
                            return _MembershipCard(profile: profile);
                          },
                        ),

                        SizedBox(height: 3.h),

                        // ── Row 1: items 0-1-2 ────────────────────────────
                        _buildRow(_menuItems.sublist(0, 3), cardW, cardH, gap),
                        SizedBox(height: gap),

                        // ── Row 2: items 3-4-5 ────────────────────────────
                        _buildRow(_menuItems.sublist(3, 6), cardW, cardH, gap),
                        /*SizedBox(height: gap),

                        // ── Row 3: items 6-7 (centered) ───────────────────
                        _buildRow(_menuItems.sublist(6, 8), cardW, cardH, gap),*/

                        SizedBox(height: 4.h),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(
      List<Map<String, dynamic>> items,
      double cardW,
      double cardH,
      double gap,
      ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: items.asMap().entries.map((entry) {
        final i    = entry.key;
        final item = entry.value;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (i > 0) SizedBox(width: gap),
            _MenuCard(
              title:    item['title'],
              iconPath: item['icon'],
              width:    cardW,
              height:   cardH,
              onTap: item['route'] != null
                  ? () => Navigator.pushNamed(context, item['route'])
                  : () {},
            ),
          ],
        );
      }).toList(),
    );
  }
}

// ─── Membership Card ──────────────────────────────────────────────────────────
class _MembershipCard extends StatelessWidget {
  final Data? profile;
  const _MembershipCard({required this.profile});

  @override
  Widget build(BuildContext context) {
    final String imageUrl = profile?.image ?? '';
    final String name = profile?.name??"";

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.5.h),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Row(
              children: [
                CustomText(
                  text: "Member Name: ",
                  style:basicColor(15.5, AppColors.btnColor)

                ),
                Flexible(
                  child:
                  CustomText(
                      text: name,
                      style:basicColorBold(14.5, AppColors.btnColor)

                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 3.w),
          Container(
            width: 13.w,
            height: 13.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.btnColor,
           //   border: Border.all(color: Colors.white, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 6,
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: imageUrl.isNotEmpty && imageUrl.contains('http')
                ? Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  Icon(Icons.person, size: 8.w, color: Colors.white),
            )
                : Icon(Icons.person, size: 8.w, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

// ─── Menu Card ────────────────────────────────────────────────────────────────
class _MenuCard extends StatelessWidget {
  final String title;
  final String iconPath;
  final VoidCallback onTap;
  final double width;
  final double height;

  const _MenuCard({
    required this.title,
    required this.iconPath,
    required this.onTap,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.13),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              iconPath,
              width: width * 0.26,
              height: width * 0.26,
              colorFilter:
              const ColorFilter.mode(AppColors.btnColor, BlendMode.srcIn),
            ),
            SizedBox(height: height * 0.09),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.08),
              child: CustomText(
             text:    title,
                align: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style:basicColor(14.5, AppColors.btnColor)

              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Bottom Nav Bar ───────────────────────────────────────────────────────────
class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 10.h,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 7.5.h,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFD4A84B), Color(0xFFB8842A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),
            ),
          ),
          Positioned(
            top: -3.h,
            child: Container(
              width: 14.w,
              height: 14.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _memberCard,
                border: Border.all(color: _memberCard, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.20),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Container(
                margin: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: _maroon,
                ),
                child: Icon(Icons.home_rounded, color: Colors.white, size: 7.w),
              ),
            ),
          ),
        ],
      ),
    );
  }
}