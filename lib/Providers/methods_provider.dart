
import 'dart:io';

import 'package:faisal_town/Data/token.dart';
import 'package:faisal_town/Models/CancellationsModel.dart';
import 'package:faisal_town/Models/CompaniesModel.dart';
import 'package:faisal_town/Utils/Constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:faisal_town/Models/AboutUs%20Model.dart';
import 'package:faisal_town/Models/DevelopmentProgressModel.dart';
import 'package:faisal_town/Models/MemberShip%20Model.dart';
import 'package:faisal_town/Models/Transfers%20Model.dart';
import 'package:faisal_town/Models/User%20Profile%20Model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Repository/methods_repository.dart';
import '../UI Screens/Home Screen.dart';
import '../Utils/Constants/utils.dart';


class MethodsViewModel extends ChangeNotifier {
  final _myRepo = MethodsRepository();
  bool _loading = false;
  bool get loading => _loading;

  // All model variables
  CompaniesModel? _companiesModel;
  UserModel? _profileModel;
  MemberShipModel? _memberShipModel;
  CancellationsModel? _cancellationsModel;
  AboutUsModel? _aboutUsModel;
  DevelopmentProgressModel? _developmentProgressModel;
  TransfersModel? _transfersModel;

  // Getters
  CompaniesModel? get companiesModel => _companiesModel;
  UserModel? get profileModel => _profileModel;
  MemberShipModel? get memberShipModel => _memberShipModel;
  CancellationsModel? get cancellationsModel => _cancellationsModel;
  AboutUsModel? get aboutUsModel => _aboutUsModel;
  DevelopmentProgressModel? get developmentProgressModel => _developmentProgressModel;
  TransfersModel? get transfersModel => _transfersModel;


  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> fetchData<T>(
      BuildContext context,
      Future<T> Function() repoCall,
      void Function(T?) onResult,
      ) async {
    try {
      setLoading(true);
      final response = await repoCall();
      onResult(response);
      setLoading(false);
      notifyListeners();
    } catch (e) {
      debugPrint("Failed to load data: ${e.toString()}");
      setLoading(false);
      onResult(null);
    }
  }


  Future<void> postData<T>(
      BuildContext context,
      Future<T> Function() repoCall,
      void Function(T?) onResult, {
        void Function(T?)? onSuccess,   // ← onSuccess now receives the response
      }) async {
    try {
      setLoading(true);
      final response = await repoCall();
      onResult(response);
      onSuccess?.call(response);    // ← pass response here
      setLoading(false);
      notifyListeners();
    } catch (e) {
      debugPrint("Failed to post data: ${e.toString()}");
      setLoading(false);
      onResult(null);
    }
  }

  // Add the fetch method
  Future<void> fetchCompanies(BuildContext context, String url) =>
      fetchData<Map<String, dynamic>>(
        context,
            () => _myRepo.getRequest(url, (val) => val),
            (val) {
          if (val == null) return;
          final String status = val['status'] ?? '';   // ← API uses "status", not "success"
          if (status == 'success') {
            _companiesModel = CompaniesModel.fromJson(val);
            notifyListeners();
          } else {
            final msg = val['message'] ?? 'Failed to load companies';
            showToast(msg);
          }
        },
      );


  Future<void> signupForm(
      BuildContext context,
      String url, {
        required String registrationNumber,
        required String firstName,
        required String lastName,
        required String email,
        required String phone,
        required String dob,
        required String motherName,
        required String nationality,
        required String city,
        required String cnic,
        required String cnicExpiry,
        String passportNumber = '',
        String passportExpiry = '',
        required String primaryWhatsapp,
        String alternateMobile = '',
        required String mailingAddress,
        required String permanentAddress,
        File? cnicFront,
        File? cnicBack,
        required File allotmentLetter,
        required File profileImage,
      }) async {
    try {
      setLoading(true);

      // Build multipart request manually via repository
      final response = await _myRepo.postMultipart(
        url,
        fields: {
          'action'              : 'signupform',
          'key'                 : '#pphE7,i_x]F',
          'registration_number' : registrationNumber,
          'first_name'          : firstName,
          'last_name'           : lastName,
          'email'               : email,
          'phone'               : phone,
          'dob'                 : dob,
          'mother_name'         : motherName,
          'nationality'         : nationality,
          'city'                : city,
          'cnic'                : cnic,
          'cnic_expiry'         : cnicExpiry,
          'passport_number'     : passportNumber,
          'passport_expiry'     : passportExpiry,
          'primary_whatsapp'    : primaryWhatsapp,
          'alternate_mobile'    : alternateMobile,
          'mailing_address'     : mailingAddress,
          'permanent_address'   : permanentAddress,
          'is_approved'         : '0',
          'created_at'          : DateTime.now().toIso8601String().split('T').first,
          'updated_at'          : DateTime.now().toIso8601String().split('T').first,
        },
        files: {
          if (cnicFront != null)   'cnic_image'      : cnicFront,
          if (cnicBack != null)    'cnic_image_back'  : cnicBack,
          'allotment_letter' : allotmentLetter,
          'profile_image'    : profileImage,
        },
      );

      setLoading(false);

      final bool success = response?['status'] == 'success';
      final String msg   = response?['message'] ?? '';

      if (success) {
        showToast(msg.isNotEmpty ? msg : 'Registration successful!');
        print("signup msg: $msg");
        Navigator.pop(context); // back to login
      } else {
        showToast(msg.isNotEmpty ? msg : 'Registration failed. Please try again.');
        print("signup msg: $msg");
      }

      notifyListeners();
    } catch (e) {
      debugPrint("signupForm error: ${e.toString()}");
      setLoading(false);
      showToast('Something went wrong. Please try again.');
    }
  }


  Future<void> login(BuildContext context, String url,dynamic params,String selectedSlung,bool isLoginPage,String selectedId) =>
      postData<Map<String, dynamic>>(
        context,
            () => _myRepo.postRequest(
          url,
              params: params,
        ),
            (val) {},
        onSuccess: (val) async {
          final bool success = val?['status']=='success' ?true:false;
          final msg = val?['message'];
          final payload = val?['data'];
          if (success && payload!=null) {
           // final payload = val?['data'];
            final prefs = await SharedPreferences.getInstance();
            prefs.setBool("login", true);
            UserToken().setUserInfo(userId: payload['id'].toString(), url: selectedSlung,userName: params['username'],password:params['password'],slung_Id: selectedId );
            if (payload is Map<String, dynamic>) {
              _profileModel = UserModel.fromJson(val!);
              if(isLoginPage)
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
                    (route) => false,
              );
              if(isLoginPage)
                showToast(msg);
              notifyListeners();
            }
          } else {
           // final msg = val?['message'] ?? 'Failed to login';
            if(isLoginPage)

              final msg =  'Failed to login';
            showToast(msg);
          }
        },
      );


  Future<void> updateProfile(BuildContext context, String url, dynamic params) =>
      postData<Map<String, dynamic>>(
        context,
            () async {
          final result = await _myRepo.postMultipart(
            url,
            fields: {
              'action'           : params['action']           ?? '',
              'id'               : params['id']               ?? '',
              'project'          : params['project'].toString(),
              'cnic'             : params['cnic']             ?? '',
              'name'             : params['name']             ?? '',
              'country_code'     : params['country_code']     ?? '',
              'phone'            : params['phone']            ?? '',
              'email'            : params['email']            ?? '',
              'address'          : params['address']          ?? '',
              'password'         : params['password']         ?? '',
              'confirm_password' : params['confirm_password'] ?? '',
            },
            files: {
              if (params['profile_picture'] != null)
                'profile_picture': params['profile_picture'] as File,
            },
          );
          return result ?? {};   // ← unwrap nullable → non-nullable
        },
            (val) {},
        onSuccess: (val) {
          final bool success = val?['status'] == 'success';
          final String msg   = val?['message'] ?? '';
          final payload      = val?['data'];

          if (success && msg == 'User updated successfully.') {
            final String newPass = params['password'] ?? '';
            if (newPass.isNotEmpty) {
              UserToken.user_password = newPass;
              SharedPreferences.getInstance().then((prefs) {
                prefs.setString('password', newPass);
                UserToken().loadUserInfo();
              });
            }
            if (payload is Map<String, dynamic>) {
              _profileModel = UserModel.fromJson(val!);
              notifyListeners();
              Navigator.pop(context);
              dynamic lparams={
                'action': 'login',
                'username': UserToken.user_name,
                'password': UserToken.user_password, // ← send slug to API
              };
              login(context, url, lparams, UserToken.slung, false, UserToken.slungId);
              showToast(msg);
            }
          } else {
            showToast(msg.isNotEmpty ? msg : 'Failed to update profile');
          }
        },
      );

  Future<void> checkCnic(
      BuildContext context,
      String url,
      dynamic params, {
        required void Function(bool success, Map<String, dynamic>? data) onResult,
      }) =>
      postData<dynamic>(                          // ← change from Map<String, dynamic>
        context,
            () => _myRepo.postRequest(url, params: params),
            (val) {},
        onSuccess: (val) {
          final String status = val?['status'] ?? "";
          if (status == "success") {
            final dynamic rawData = val?['data']; // "3310439238433" (String)
            print("payload: $rawData");

            // Wrap into a Map so onResult contract is satisfied
            onResult(true, {'data': rawData});    // ← always wrap, never cast

          } else {
            final String msg = val?['message'] ?? 'CNIC check failed';
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                backgroundColor: const Color(0xFF1E2A3A),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                title: Row(
                  children: [
                    Icon(CupertinoIcons.question_circle, color: Colors.white, size: 22),
                    SizedBox(width: 8),
                    Text(
                      "Check Validation",
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
                  msg,
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
            );
            onResult(false, null);
          }
        },
      );

  Future<void> forgotPassword(BuildContext context, String url,String cnic) =>
      postData<Map<String, dynamic>>(
        context,
            () => _myRepo.postRequest(
          url,
          params: {
            'action': 'forgot_password',
            'cnic':cnic,
          },
        ),
            (val) {},
        onSuccess: (val) {
          final  String success = val?['status'] ?? "";
          final  String msg = val?['message'] ?? "";
          if (success=="success" ) {

              showToast("Your account credentials, including your username and password, have been sent to your registered email and mobile number");
          }
          else {
            final msg = 'An Error occurred';
            showToast(msg);
          }
        },
      );


  Future<void> fetchMemberShips(BuildContext context, String url,String id) =>
      postData<Map<String, dynamic>>(
        context,
            () => _myRepo.postRequest(
          url,
          params: {
            'action': 'get_my_plots',
            'member_id':UserToken.user_id,
          },
        ),
            (val) {},
        onSuccess: (val) {
          final  String success = val?['status'] ?? "";
          final  String msg = val?['message'] ?? "";
          if (success=="success" && msg== 'Plots fetched successfully') {
            final payload = val?['data'];
            if (payload is Map<String, dynamic>) {
              _memberShipModel = MemberShipModel.fromJson(val!);
              notifyListeners();
            }

            else if (payload is List) {
              _memberShipModel = MemberShipModel.fromJson(val!);
              notifyListeners();
            }
         //   showToast(msg);
          }
          else {
            final msg = 'Failed to load memberships';
            showToast(msg);
          }
        },
      );


  Future<void> fetchCancellation(BuildContext context, String url,String id) =>
      postData<Map<String, dynamic>>(
        context,
            () => _myRepo.postRequest(
          url,
          params: {
            'action': 'get_cancellations',
            'member_id':id,
          },
        ),
            (val) {},
        onSuccess: (val) {
          final  String success = val?['status'] ?? "";
          final  String msg = val?['message'] ?? "";
          if (success=="success" && msg== 'Canncel Memberships fetched successfully') {
            final payload = val?['data'];
            if (payload is Map<String, dynamic>) {
              _cancellationsModel = CancellationsModel.fromJson(val!);
              notifyListeners();
            }

            else if (payload is List) {
              _cancellationsModel = CancellationsModel.fromJson(val!);
              notifyListeners();
            }
            showToast(msg);
          }
          else {
            final msg = 'Failed to load cancellations';
            showToast(msg);
          }
        },
      );


  Future<void> fetchTransfers(BuildContext context, String url,String id) =>
      postData<Map<String, dynamic>>(
        context,
            () => _myRepo.postRequest(
          url,
          params: {
            'action': 'get_transfers_list',
            'member_id':id,
          },
        ),
            (val) {},
        onSuccess: (val) {
          final  String success = val?['status'] ?? "";
          final  String msg = val?['message'] ?? "";
          if (success=="success") {
            final payload = val?['data'];
            if (payload is Map<String, dynamic>) {
              _transfersModel = TransfersModel.fromJson(val!);
              notifyListeners();
            }
            else if (payload is List) {
              _transfersModel = TransfersModel.fromJson(val!);
              notifyListeners();
            }
            showToast(msg);

          }
          else {
            final msg = 'Failed to load transfers list';
            showToast(msg);
          }
        },
      );


  Future<void> fetchAboutUs(BuildContext context, String url) =>
      postData<Map<String, dynamic>>(
        context,
            () => _myRepo.postRequest(
          url,
          params: {
            'key': '#pphE7,i_x]F',
          },
        ),
            (val) {},
        onSuccess: (val) {
          final bool success = val?['success'] ?? false;
          if (success) {
            final payload = val?['payload'];
            if (payload is Map<String, dynamic>) {
              _aboutUsModel = AboutUsModel.fromJson(val!);
              notifyListeners();
            }
            else if (payload is List) {
              _aboutUsModel = AboutUsModel.fromJson(val!);
              notifyListeners();
            }
          } else {
            final msg = val?['payload'] ?? 'Failed to load information about us';
            showToast(msg);
          }
        },
      );


  Future<void> fetchProgress(BuildContext context, String url) =>
      postData<Map<String, dynamic>>(
        context,
            () => _myRepo.postRequest(
          url,
          params: {
            'action': 'dev_status',
            'id':UserToken.user_id

          },
        ),
            (val) {},
        onSuccess: (val) {
          final  success = val?['status'] ?? "";
          if (success=='success') {
            final payload = val?['data'];
            final msg = val?['message'];
            if (payload is Map<String, dynamic>) {
              _developmentProgressModel = DevelopmentProgressModel.fromJson(val!);
              notifyListeners();
            }
            else if (payload is List) {
              _developmentProgressModel = DevelopmentProgressModel.fromJson(val!);
              notifyListeners();
            }
            showToast(msg);
          } else {
            final msg = val?['message'] ?? 'Failed to load development progress';
            showToast(msg);
          }
        },
      );

/*
  Future<void> approveApproval(dynamic data, BuildContext context,String id) async {
    try {
      setLoading(true);
      final response = await _myRepo.createAcceptReq(data,id);

      debugPrint('Response: $response');

      final Map<String, dynamic> decoded = jsonDecode(response);

      // Check for success
      if (decoded['message'] == "Approval request approved successfully" && decoded['data'] != null) {
        String msg = decoded['message'];
        setLoading(false);
        fetchApprovalDetail(context, id);
        showToast(msg);
      } else {
        setLoading(false);
        String errorMsg = decoded['message'] ?? 'Failed to approve approval request';
        fetchApprovalDetail(context, id);
        debugPrint("errorMsg: $errorMsg");
        showToast(errorMsg);
      }

    } catch (e) {
      debugPrint("Error: ${e.toString()}");
      setLoading(false);
    }
  }
*/


}