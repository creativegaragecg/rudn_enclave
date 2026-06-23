// To parse this JSON data, do
//
//     final aboutUsModel = aboutUsModelFromJson(jsonString);

import 'dart:convert';

AboutUsModel aboutUsModelFromJson(String str) => AboutUsModel.fromJson(json.decode(str));

String aboutUsModelToJson(AboutUsModel data) => json.encode(data.toJson());

class AboutUsModel {
  bool? success;
  Payload? payload;

  AboutUsModel({
    this.success,
    this.payload,
  });

  factory AboutUsModel.fromJson(Map<String, dynamic> json) => AboutUsModel(
    success: json["success"],
    payload: json["payload"] == null ? null : Payload.fromJson(json["payload"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "payload": payload?.toJson(),
  };
}

class Payload {
  String? companyname;
  String? adrress;
  String? phonenumber;
  String? email;
  String? logo;

  Payload({
    this.companyname,
    this.adrress,
    this.phonenumber,
    this.email,
    this.logo,
  });

  factory Payload.fromJson(Map<String, dynamic> json) => Payload(
    companyname: json["companyname"],
    adrress: json["adrress"],
    phonenumber: json["phonenumber"],
    email: json["email"],
    logo: json["logo"],
  );

  Map<String, dynamic> toJson() => {
    "companyname": companyname,
    "adrress": adrress,
    "phonenumber": phonenumber,
    "email": email,
    "logo": logo,
  };
}
