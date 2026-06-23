// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String? status;
  String? message;
  Data? data;

  UserModel({
    this.status,
    this.message,
    this.data,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  int? id;
  String? name;
  String? username;
  String? sodowo;
  String? motherName;
  String? motherCnic;
  String? title;
  String? cnic;
  String? image;
  String? image1;
  String? image2;
  String? address;
  String? address2;
  String? cityId;
  String? phone;
  String? phone2;
  String? phone3;
  String? landLine;
  String? yob;
  String? email;
  String? countryId;
  String? state;
  String? password;
  String? status;
  String? fp;
  String? mtype;
  String? accNo;
  String? loginStatus;
  String? userId;
  DateTime? createDate;
  DateTime? modifyDate;
  String? dob;
  dynamic rfm;
  String? whatsappNo;
  String? occupation;
  dynamic firstName;
  dynamic lastName;
  dynamic cnicExpiry;
  dynamic passportNumber;
  dynamic passportExpiry;
  dynamic alternateMobile;
  List<dynamic>? shareHolders;

  Data({
    this.id,
    this.name,
    this.username,
    this.sodowo,
    this.motherName,
    this.motherCnic,
    this.title,
    this.cnic,
    this.image,
    this.image1,
    this.image2,
    this.address,
    this.address2,
    this.cityId,
    this.phone,
    this.phone2,
    this.phone3,
    this.landLine,
    this.yob,
    this.email,
    this.countryId,
    this.state,
    this.password,
    this.status,
    this.fp,
    this.mtype,
    this.accNo,
    this.loginStatus,
    this.userId,
    this.createDate,
    this.modifyDate,
    this.dob,
    this.rfm,
    this.whatsappNo,
    this.occupation,
    this.firstName,
    this.lastName,
    this.cnicExpiry,
    this.passportNumber,
    this.passportExpiry,
    this.alternateMobile,
    this.shareHolders,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    name: json["name"],
    username: json["username"],
    sodowo: json["sodowo"],
    motherName: json["mother_name"],
    motherCnic: json["mother_cnic"],
    title: json["title"],
    cnic: json["cnic"],
    image: json["image"],
    image1: json["image1"],
    image2: json["image2"],
    address: json["address"],
    address2: json["address2"],
    cityId: json["city_id"],
    phone: json["phone"],
    phone2: json["phone2"],
    phone3: json["phone3"],
    landLine: json["land_line"],
    yob: json["yob"],
    email: json["email"],
    countryId: json["country_id"],
    state: json["state"],
    password: json["password"],
    status: json["status"],
    fp: json["fp"],
    mtype: json["mtype"],
    accNo: json["acc_no"],
    loginStatus: json["login_status"],
    userId: json["user_id"],
    createDate: json["create_date"] == null ? null : DateTime.parse(json["create_date"]),
    modifyDate: json["modify_date"] == null ? null : DateTime.parse(json["modify_date"]),
    dob: json["dob"],
    rfm: json["RFM"],
    whatsappNo: json["whatsapp_no"],
    occupation: json["occupation"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    cnicExpiry: json["cnic_expiry"],
    passportNumber: json["passport_number"],
    passportExpiry: json["passport_expiry"],
    alternateMobile: json["alternate_mobile"],
    shareHolders: json["share_holders"] == null ? [] : List<dynamic>.from(json["share_holders"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "username": username,
    "sodowo": sodowo,
    "mother_name": motherName,
    "mother_cnic": motherCnic,
    "title": title,
    "cnic": cnic,
    "image": image,
    "image1": image1,
    "image2": image2,
    "address": address,
    "address2": address2,
    "city_id": cityId,
    "phone": phone,
    "phone2": phone2,
    "phone3": phone3,
    "land_line": landLine,
    "yob": yob,
    "email": email,
    "country_id": countryId,
    "state": state,
    "password": password,
    "status": status,
    "fp": fp,
    "mtype": mtype,
    "acc_no": accNo,
    "login_status": loginStatus,
    "user_id": userId,
    "create_date": "${createDate!.year.toString().padLeft(4, '0')}-${createDate!.month.toString().padLeft(2, '0')}-${createDate!.day.toString().padLeft(2, '0')}",
    "modify_date": "${modifyDate!.year.toString().padLeft(4, '0')}-${modifyDate!.month.toString().padLeft(2, '0')}-${modifyDate!.day.toString().padLeft(2, '0')}",
    "dob": dob,
    "RFM": rfm,
    "whatsapp_no": whatsappNo,
    "occupation": occupation,
    "first_name": firstName,
    "last_name": lastName,
    "cnic_expiry": cnicExpiry,
    "passport_number": passportNumber,
    "passport_expiry": passportExpiry,
    "alternate_mobile": alternateMobile,
    "share_holders": shareHolders == null ? [] : List<dynamic>.from(shareHolders!.map((x) => x)),
  };
}
