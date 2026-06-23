import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Utils/Constants/urls.dart';

class UserToken with ChangeNotifier {
  static String user_id ="0";
  static String slung ="";
  static String slungId ="";
  static String user_name = "";
  static String user_password = "";



  void setUserInfo({required String userId,required String url,required String userName,required String password ,required String slung_Id}) async {
    user_id=userId;
    slung=url;
    user_name=userName;
    user_password=password;
    slungId=slung_Id;

   /* user_name=userName;
    user_email=userEmail;*/

    final prefs = await SharedPreferences.getInstance();
    prefs.setString('userId',user_id);
    prefs.setString('slung',slung);
    prefs.setString('slungId',slungId);
    prefs.setString('userName', user_name);
    prefs.setString('password', user_password);

  }
  Future<void> loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    user_id = prefs.getString('userId') ?? "0";
    slung = prefs.getString('slung') ?? "0";
    slungId = prefs.getString('slungId') ?? "0";
    user_name = prefs.getString('userName') ?? '';
    user_password = prefs.getString('password') ?? '';
    debugPrint("ID LOAD: $user_id");
    debugPrint("UserNAme LOAD: $user_name");
    debugPrint("Slung LOAD: $slung");
    debugPrint("Slung ID LOAD: $slungId");
   /* debugPrint("USER NAME LOAD: $user_name");
    debugPrint("USER EMAIL LOAD: $user_email");
*/
  }

}
