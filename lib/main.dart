import 'package:faisal_town/Models/DevelopmentProgressModel.dart';
import 'package:faisal_town/UI%20Screens/Auth%20Screens/Login%20Screen.dart';
import 'package:faisal_town/Utils/Constants/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:faisal_town/Providers/methods_provider.dart';
import 'package:faisal_town/UI%20Screens/Cancellations.dart';
import 'package:faisal_town/UI%20Screens/Home%20Screen.dart';
import 'package:faisal_town/UI%20Screens/Transfers%20Screen.dart';
import 'package:faisal_town/Utils/Constants/images.dart';
import 'package:faisal_town/Utils/Custom/webview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Data/token.dart';
import 'UI Screens/Development Progress Screen.dart';
import 'UI Screens/Profile Screen.dart';
import 'UI Screens/Properties Screen.dart';
import 'UI Screens/Services/session time out.dart';
import 'Utils/Constants/colors.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => MethodsViewModel()),

    ],
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (BuildContext p1, Orientation p2, ScreenType p3) {

       return MaterialApp(
         debugShowCheckedModeBanner: false,
         // ── Initial route ──────────────────────────────────────────────
         initialRoute: '/',

         // ── Named routes ───────────────────────────────────────────────
         routes: {
           '/profile':       (context) => const ProfileScreen(),
           '/properties':    (context) => const PropertiesScreen(),
           '/transfers':     (context) => const TransfersScreen(),
          '/cancellations': (context) =>  CancellationsScreen(),
           '/customer-care': (context) => const WebViewScreen(url: 'https://faisaltowngroup.com/contact-us/'),
/*
           '/downloads':     (context) => const WebViewScreen(url: 'https://rudnenclave.com/downloads/'),
*/
           '/progresss':      (context) => const DevelopmentProgressScreen(),

           '/progress':      (context) => WebViewScreen(url: 'https://faisaltowngroup.com/projects/'),
          '/events':       (context) => const WebViewScreen(url: 'https://faisaltowngroup.com/'),
       //   '/queries':       (context) => const QueriesScreen(),
      //    '/faqs':       (context) => const WebViewScreen(url: 'https://rudnenclave.com/faqs/'),

         },

          home:  MyHomePage(),
        );
      }

    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, });


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLogin();

  }

  void checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    bool isLogin = prefs.getBool('login') ?? false;

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    if (!isLogin) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
            (route) => false,
      );
    } else {
      UserToken().loadUserInfo();

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => SessionTimeoutWrapper(  // ← wrap here
            child: const HomeScreen(),
          ),
        ),
            (route) => false,
      );
    }
  }

/*
  void checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    bool isLogin = prefs.getBool('login') ?? false;

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    if (!isLogin) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) =>  LoginPage()),
            (route) => false,
      );
    }

    else if (isLogin){
      UserToken().loadUserInfo();

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
            (route) => false,
      );
    }
    else{

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) =>  LoginPage()),
            (route) => false,
      );
    }
  }
*/


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        height: 100.h,
        width: 100.w,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppImages.login_bg),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding:  EdgeInsets.symmetric(vertical: 1.h,horizontal: 4.w),
            child: SvgPicture.asset(AppIcons.appLogo,color: AppColors.btnColor,),
          )
        ),
      ),
    );
  }
}
