// To parse this JSON data, do
//
//     final memberShipModel = memberShipModelFromJson(jsonString);

import 'dart:convert';

MemberShipModel memberShipModelFromJson(String str) => MemberShipModel.fromJson(json.decode(str));

String memberShipModelToJson(MemberShipModel data) => json.encode(data.toJson());

class MemberShipModel {
  String? status;
  String? message;
  List<Datum>? data;

  MemberShipModel({
    this.status,
    this.message,
    this.data,
  });

  factory MemberShipModel.fromJson(Map<String, dynamic> json) => MemberShipModel(
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
  String? consumerNo;
  String? allotmentType;
  String? paymentType;
  String? appNo;
  int? plotId;
  int? sub;
  int? memberId;
  DateTime? createDate;
  DateTime? modifyDate;
  String? noi;
  int? insplan;
  String? status;
  String? bstatus;
  String? fstatus;
  String? userName;
  String? plotno;
  String? up;
  String? discount;
  String? extra;
  String? net;
  String? bid;
  int? dealId;
  String? tempms;
  int? wlstatus;
  dynamic wldate;
  DateTime? cutDate;
  String? mmtype;
  String? comment;
  String? fcomment;
  int? uid;
  int? mstatus;
  int? statusType;
  String? statusCom;
  int? regirstyStatus;
  DateTime? reshedulePlan;
  String? financeRemarks;
  dynamic plotstatusesFlag;
  String? type;
  int? projectId;
  String? streetId;
  String? plotDetailAddress;
  String? plotSize;
  dynamic plotArea;
  String? size2;
  String? installment;
  String? price;
  dynamic ratePerSqYds;
  String? own;
  String? pLcharges;
  String? remarks;
  String? comRes;
  String? categoryId;
  String? sector;
  String? image;
  String? shapId;
  dynamic posRemarks;
  String? cstatus;
  String? rstatus;
  String? ctag;
  String? atype;
  String? rownumber;
  int? pType;
  int? subDivision;
  dynamic physicalType;
  dynamic physicalStatus;
  dynamic physicalStatusDocument;
  String? mpcomment;
  int? pid;
  String? pltype;
  String? ppprice;
  String? msPrice;
  String? msDiscount;
  String? msExtra;
  String? netPrice;
  DateTime? cdate;
  DateTime? crDate;
  int? msId;
  String? plotNoo;
  String? projectName;
  String? streetName;
  String? sectorName;
  String? totalAmount;
  String? paid;
  String? overdue;
  String? remaining;
  String? statement;
  String? statementPdfLink;

  Datum({
    this.id,
    this.consumerNo,
    this.allotmentType,
    this.paymentType,
    this.appNo,
    this.plotId,
    this.sub,
    this.memberId,
    this.createDate,
    this.modifyDate,
    this.noi,
    this.insplan,
    this.status,
    this.bstatus,
    this.fstatus,
    this.userName,
    this.plotno,
    this.up,
    this.discount,
    this.extra,
    this.net,
    this.bid,
    this.dealId,
    this.tempms,
    this.wlstatus,
    this.wldate,
    this.cutDate,
    this.mmtype,
    this.comment,
    this.fcomment,
    this.uid,
    this.mstatus,
    this.statusType,
    this.statusCom,
    this.regirstyStatus,
    this.reshedulePlan,
    this.financeRemarks,
    this.plotstatusesFlag,
    this.type,
    this.projectId,
    this.streetId,
    this.plotDetailAddress,
    this.plotSize,
    this.plotArea,
    this.size2,
    this.installment,
    this.price,
    this.ratePerSqYds,
    this.own,
    this.pLcharges,
    this.remarks,
    this.comRes,
    this.categoryId,
    this.sector,
    this.image,
    this.shapId,
    this.posRemarks,
    this.cstatus,
    this.rstatus,
    this.ctag,
    this.atype,
    this.rownumber,
    this.pType,
    this.subDivision,
    this.physicalType,
    this.physicalStatus,
    this.physicalStatusDocument,
    this.mpcomment,
    this.pid,
    this.pltype,
    this.ppprice,
    this.msPrice,
    this.msDiscount,
    this.msExtra,
    this.netPrice,
    this.cdate,
    this.crDate,
    this.msId,
    this.plotNoo,
    this.projectName,
    this.streetName,
    this.sectorName,
    this.totalAmount,
    this.paid,
    this.overdue,
    this.remaining,
    this.statement,
    this.statementPdfLink,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    consumerNo: json["consumer_no"],
    allotmentType: json["allotment_type"],
    paymentType: json["payment_type"],
    appNo: json["app_no"],
    plotId: json["plot_id"],
    sub: json["sub"],
    memberId: json["member_id"],
    createDate: json["create_date"] == null ? null : DateTime.parse(json["create_date"]),
    modifyDate: json["modify_date"] == null ? null : DateTime.parse(json["modify_date"]),
    noi: json["noi"],
    insplan: json["insplan"],
    status: json["status"],
    bstatus: json["bstatus"],
    fstatus: json["fstatus"],
    userName: json["user_name"],
    plotno: json["plotno"],
    up: json["up"],
    discount: json["discount"],
    extra: json["extra"],
    net: json["net"],
    bid: json["bid"],
    dealId: json["deal_id"],
    tempms: json["tempms"],
    wlstatus: json["wlstatus"],
    wldate: json["wldate"],
    cutDate: json["cut_date"] == null ? null : DateTime.parse(json["cut_date"]),
    mmtype: json["mmtype"],
    comment: json["comment"],
    fcomment: json["fcomment"],
    uid: json["uid"],
    mstatus: json["mstatus"],
    statusType: json["status_type"],
    statusCom: json["status_com"],
    regirstyStatus: json["regirsty_status"],
    reshedulePlan: json["reshedule_plan"] == null ? null : DateTime.parse(json["reshedule_plan"]),
    financeRemarks: json["finance_remarks"],
    plotstatusesFlag: json["plotstatuses_flag"],
    type: json["type"],
    projectId: json["project_id"],
    streetId: json["street_id"],
    plotDetailAddress: json["plot_detail_address"],
    plotSize: json["plot_size"],
    plotArea: json["plot_area"],
    size2: json["size2"],
    installment: json["installment"],
    price: json["price"],
    ratePerSqYds: json["rate_per_sq_yds"],
    own: json["own"],
    pLcharges: json["PLcharges"],
    remarks: json["remarks"],
    comRes: json["com_res"],
    categoryId: json["category_id"],
    sector: json["sector"],
    image: json["image"],
    shapId: json["shap_id"],
    posRemarks: json["pos_remarks"],
    cstatus: json["cstatus"],
    rstatus: json["rstatus"],
    ctag: json["ctag"],
    atype: json["atype"],
    rownumber: json["rownumber"],
    pType: json["p_type"],
    subDivision: json["sub_division"],
    physicalType: json["physical_type"],
    physicalStatus: json["physical_status"],
    physicalStatusDocument: json["physical_status_document"],
    mpcomment: json["mpcomment"],
    pid: json["pid"],
    pltype: json["pltype"],
    ppprice: json["ppprice"],
    msPrice: json["ms_price"],
    msDiscount: json["ms_discount"],
    msExtra: json["ms_extra"],
    netPrice: json["net_price"],
    cdate: json["cdate"] == null ? null : DateTime.parse(json["cdate"]),
    crDate: json["cr_date"] == null ? null : DateTime.parse(json["cr_date"]),
    msId: json["ms_id"],
    plotNoo: json["plot_noo"],
    projectName: json["project_name"],
    streetName: json["street_name"],
    sectorName: json["sector_name"],
    totalAmount: json["total_amount"],
    paid: json["paid"],
    overdue: json["overdue"],
    remaining: json["remaining"],
    statement: json["statement"],
    statementPdfLink: json["statement_pdf_link"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "consumer_no": consumerNo,
    "allotment_type": allotmentType,
    "payment_type": paymentType,
    "app_no": appNo,
    "plot_id": plotId,
    "sub": sub,
    "member_id": memberId,
    "create_date": createDate?.toIso8601String(),
    "modify_date": modifyDate?.toIso8601String(),
    "noi": noi,
    "insplan": insplan,
    "status": status,
    "bstatus": bstatus,
    "fstatus": fstatus,
    "user_name": userName,
    "plotno": plotno,
    "up": up,
    "discount": discount,
    "extra": extra,
    "net": net,
    "bid": bid,
    "deal_id": dealId,
    "tempms": tempms,
    "wlstatus": wlstatus,
    "wldate": wldate,
    "cut_date": "${cutDate!.year.toString().padLeft(4, '0')}-${cutDate!.month.toString().padLeft(2, '0')}-${cutDate!.day.toString().padLeft(2, '0')}",
    "mmtype": mmtype,
    "comment": comment,
    "fcomment": fcomment,
    "uid": uid,
    "mstatus": mstatus,
    "status_type": statusType,
    "status_com": statusCom,
    "regirsty_status": regirstyStatus,
    "reshedule_plan": reshedulePlan?.toIso8601String(),
    "finance_remarks": financeRemarks,
    "plotstatuses_flag": plotstatusesFlag,
    "type": type,
    "project_id": projectId,
    "street_id": streetId,
    "plot_detail_address": plotDetailAddress,
    "plot_size": plotSize,
    "plot_area": plotArea,
    "size2": size2,
    "installment": installment,
    "price": price,
    "rate_per_sq_yds": ratePerSqYds,
    "own": own,
    "PLcharges": pLcharges,
    "remarks": remarks,
    "com_res": comRes,
    "category_id": categoryId,
    "sector": sector,
    "image": image,
    "shap_id": shapId,
    "pos_remarks": posRemarks,
    "cstatus": cstatus,
    "rstatus": rstatus,
    "ctag": ctag,
    "atype": atype,
    "rownumber": rownumber,
    "p_type": pType,
    "sub_division": subDivision,
    "physical_type": physicalType,
    "physical_status": physicalStatus,
    "physical_status_document": physicalStatusDocument,
    "mpcomment": mpcomment,
    "pid": pid,
    "pltype": pltype,
    "ppprice": ppprice,
    "ms_price": msPrice,
    "ms_discount": msDiscount,
    "ms_extra": msExtra,
    "net_price": netPrice,
    "cdate": cdate?.toIso8601String(),
    "cr_date": crDate?.toIso8601String(),
    "ms_id": msId,
    "plot_noo": plotNoo,
    "project_name": projectName,
    "street_name": streetName,
    "sector_name": sectorName,
    "total_amount": totalAmount,
    "paid": paid,
    "overdue": overdue,
    "remaining": remaining,
    "statement": statement,
    "statement_pdf_link": statementPdfLink,
  };
}
