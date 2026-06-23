// To parse this JSON data, do
//
//     final cancellationsModel = cancellationsModelFromJson(jsonString);

import 'dart:convert';

CancellationsModel cancellationsModelFromJson(String str) => CancellationsModel.fromJson(json.decode(str));

String cancellationsModelToJson(CancellationsModel data) => json.encode(data.toJson());

class CancellationsModel {
  String? status;
  String? message;
  List<Datum>? data;

  CancellationsModel({
    this.status,
    this.message,
    this.data,
  });

  factory CancellationsModel.fromJson(Map<String, dynamic> json) => CancellationsModel(
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
  String? consumerNo;
  String? mpcomment;
  int? pid;
  String? pltype;
  String? ppprice;
  int? projectId;
  String? msPrice;
  DateTime? cdate;
  DateTime? crDate;
  int? msId;
  String? plotNoo;
  String? plotDetailAddress;
  String? plotSize;
  String? projectName;
  String? streetName;
  String? sectorName;

  Datum({
    this.consumerNo,
    this.mpcomment,
    this.pid,
    this.pltype,
    this.ppprice,
    this.projectId,
    this.msPrice,
    this.cdate,
    this.crDate,
    this.msId,
    this.plotNoo,
    this.plotDetailAddress,
    this.plotSize,
    this.projectName,
    this.streetName,
    this.sectorName,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    consumerNo: json["consumer_no"],
    mpcomment: json["mpcomment"],
    pid: json["pid"],
    pltype: json["pltype"],
    ppprice: json["ppprice"],
    projectId: json["project_id"],
    msPrice: json["ms_price"],
    cdate: json["cdate"] == null ? null : DateTime.parse(json["cdate"]),
    crDate: json["cr_date"] == null ? null : DateTime.parse(json["cr_date"]),
    msId: json["ms_id"],
    plotNoo: json["plot_noo"],
    plotDetailAddress: json["plot_detail_address"],
    plotSize: json["plot_size"],
    projectName: json["project_name"],
    streetName: json["street_name"],
    sectorName: json["sector_name"],
  );

  Map<String, dynamic> toJson() => {
    "consumer_no": consumerNo,
    "mpcomment": mpcomment,
    "pid": pid,
    "pltype":pltype,
    "ppprice": ppprice,
    "project_id": projectId,
    "ms_price": msPrice,
    "cdate": cdate?.toIso8601String(),
    "cr_date": crDate?.toIso8601String(),
    "ms_id": msId,
    "plot_noo": plotNoo,
    "plot_detail_address": plotDetailAddress,
    "plot_size": plotSize,
    "project_name": projectName,
    "street_name": streetName,
    "sector_name": sectorName,
  };
}



