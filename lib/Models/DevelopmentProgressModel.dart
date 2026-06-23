// To parse this JSON data, do
//
//     final developmentProgressModel = developmentProgressModelFromJson(jsonString);

import 'dart:convert';

DevelopmentProgressModel developmentProgressModelFromJson(String str) => DevelopmentProgressModel.fromJson(json.decode(str));

String developmentProgressModelToJson(DevelopmentProgressModel data) => json.encode(data.toJson());

class DevelopmentProgressModel {
  String? status;
  String? message;
  List<Datum>? data;

  DevelopmentProgressModel({
    this.status,
    this.message,
    this.data,
  });

  factory DevelopmentProgressModel.fromJson(Map<String, dynamic> json) => DevelopmentProgressModel(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  String? id;
  String? type;
  String? title;
  String? pic;
  String? detail;
  String? status;
  DateTime? createDate;

  Datum({
    this.id,
    this.type,
    this.title,
    this.pic,
    this.detail,
    this.status,
    this.createDate,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    type: json["type"],
    title: json["title"],
    pic: json["pic"],
    detail: json["detail"],
    status: json["status"],
    createDate: json["create_date"] == null ? null : DateTime.parse(json["create_date"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "title": title,
    "pic": pic,
    "detail": detail,
    "status": status,
    "create_date": "${createDate!.year.toString().padLeft(4, '0')}-${createDate!.month.toString().padLeft(2, '0')}-${createDate!.day.toString().padLeft(2, '0')}",
  };
}
