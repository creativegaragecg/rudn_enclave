// To parse this JSON data, do
//
//     final transfersModel = transfersModelFromJson(jsonString);

import 'dart:convert';

TransfersModel transfersModelFromJson(String str) => TransfersModel.fromJson(json.decode(str));

String transfersModelToJson(TransfersModel data) => json.encode(data.toJson());

class TransfersModel {
  String? status;
  String? message;
  List<Datum>? data;

  TransfersModel({
    this.status,
    this.message,
    this.data,
  });

  factory TransfersModel.fromJson(Map<String, dynamic> json) => TransfersModel(
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
  int? id;
  int? plotId;
  int? share;
  int? ref;
  dynamic sub;
  int? transferfromId;
  int? transfertoId;
  String? uid;
  String? status;
  String? fstatus;
  String? fp;
  String? cmnt;
  String? fcomment;
  String? rfm;
  String? image;
  DateTime? createDate;
  DateTime? modifyDate;
  int? amount;
  int? biometric;
  dynamic supplierId;
  dynamic relationWithSeller;
  dynamic purchaserImage;
  String? memberFrom;
  String? plotNo;
  String? memberTo;

  Datum({
    this.id,
    this.plotId,
    this.share,
    this.ref,
    this.sub,
    this.transferfromId,
    this.transfertoId,
    this.uid,
    this.status,
    this.fstatus,
    this.fp,
    this.cmnt,
    this.fcomment,
    this.rfm,
    this.image,
    this.createDate,
    this.modifyDate,
    this.amount,
    this.biometric,
    this.supplierId,
    this.relationWithSeller,
    this.purchaserImage,
    this.memberFrom,
    this.plotNo,
    this.memberTo,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    plotId: json["plot_id"],
    share: json["share"],
    ref: json["ref"],
    sub: json["sub"],
    transferfromId: json["transferfrom_id"],
    transfertoId: json["transferto_id"],
    uid: json["uid"],
    status: json["status"],
    fstatus: json["fstatus"],
    fp: json["fp"],
    cmnt: json["cmnt"],
    fcomment: json["fcomment"],
    rfm: json["RFM"],
    image: json["image"],
    createDate: json["create_date"] == null ? null : DateTime.parse(json["create_date"]),
    modifyDate: json["modify_date"] == null ? null : DateTime.parse(json["modify_date"]),
    amount: json["amount"],
    biometric: json["biometric"],
    supplierId: json["supplier_id"],
    relationWithSeller: json["relation_with_seller"],
    purchaserImage: json["purchaser_image"],
    memberFrom: json["member_from"],
    plotNo: json["plot_no"],
    memberTo: json["member_to"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "plot_id": plotId,
    "share": share,
    "ref": ref,
    "sub": sub,
    "transferfrom_id": transferfromId,
    "transferto_id": transfertoId,
    "uid": uid,
    "status": status,
    "fstatus": fstatus,
    "fp": fp,
    "cmnt": cmnt,
    "fcomment": fcomment,
    "RFM": rfm,
    "image": image,
    "create_date": "${createDate!.year.toString().padLeft(4, '0')}-${createDate!.month.toString().padLeft(2, '0')}-${createDate!.day.toString().padLeft(2, '0')}",
    "modify_date": "${modifyDate!.year.toString().padLeft(4, '0')}-${modifyDate!.month.toString().padLeft(2, '0')}-${modifyDate!.day.toString().padLeft(2, '0')}",
    "amount": amount,
    "biometric": biometric,
    "supplier_id": supplierId,
    "relation_with_seller": relationWithSeller,
    "purchaser_image": purchaserImage,
    "member_from": memberFrom,
    "plot_no": plotNo,
    "member_to": memberTo,
  };
}
