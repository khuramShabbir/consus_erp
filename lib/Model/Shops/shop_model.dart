class ShopData {
  ShopData({
    this.id,
    this.shopId,
    this.shopName,
    this.shopCode,
    this.contactPerson,
    this.contactNo,
    this.NTNno,
    this.regionId,
    this.areaId,
    this.salePersonId,
    this.createdById,
    this.updatedById,
    this.createdOn,
    this.updatedOn,
    this.systemNotes,
    this.remarks,
    this.description,
    this.entryDate,
    this.branchId,
    this.latitiude,
    this.longitiude,
    this.googleAddress,
    this.tradeChannelId,
    this.vpo,
    this.seo,
    this.imageUrl,
    this.isModify,
    this.salePersonName,
    this.areaName,
    this.channelName,
    this.isSync=true,
    this.totalRows
  });
bool? isSync;
  int? id;
  int? shopId;
  int? totalRows;
  String? shopName;
  String? shopCode;
  String? contactPerson;
  String? contactNo;
  String? NTNno;
  int? regionId;
  int? areaId;
  int? salePersonId;
  int? createdById;
  int? updatedById;
  DateTime? createdOn;
  DateTime? updatedOn;
  String? systemNotes;
  String? remarks;
  String? description;
  DateTime? entryDate;
  int? branchId;
  double? latitiude;
  double? longitiude;
  String? googleAddress;
  int? tradeChannelId;
  String? vpo;
  String? seo;
  String? imageUrl;
  bool? isModify;
  String? salePersonName;
  String? areaName;
  String? channelName;

  factory ShopData.fromJson(Map<String, dynamic> json) => ShopData(
        isSync: json["isSync"],
        id: json["ID"] != null ? int.parse(json["ID"].toString()) : null,
        shopId: json["ShopID"] != null ? int.parse(json["ShopID"].toString()) : null,
        shopName: json["ShopName"],
        shopCode: json["ShopCode"],
        contactPerson: json["ContactPerson"],
        contactNo: json["ContactNo"],
        NTNno: json["NTNNO"],
        regionId: json["RegionID"] != null ? int.parse(json["RegionID"].toString()) : null,
        areaId: json["AreaID"] != null ? int.parse(json["AreaID"].toString()) : null,
        salePersonId: json["SalePersonID"] != null ? int.parse(json["SalePersonID"].toString()) : null,
        totalRows: json["TotalRows"] != null ? int.parse(json["TotalRows"].toString()) : null,
        createdById: json["CreatedByID"] != null ? int.parse(json["CreatedByID"].toString()) : null,
        updatedById: json["UpdatedByID"] != null ? int.parse(json["UpdatedByID"].toString()) : null,
        createdOn: json["CreatedOn"] != null ? DateTime.parse(json["CreatedOn"].toString()) : null,
        updatedOn: json["UpdatedOn"] != null ? DateTime.parse(json["UpdatedOn"].toString()) : null,
        systemNotes: json["SystemNotes"],
        remarks: json["Remarks"],
        description: json["Description"],
        entryDate: json["EntryDate"] != null ? DateTime.parse(json["EntryDate"].toString()) : null,
        branchId: json["BranchID"] != null ? int.parse(json["BranchID"].toString()) : null,
        latitiude: json["Latitiude"] != null ? double.parse(json["Latitiude"].toString()) : null,
        longitiude: json["Longitiude"] != null ? double.parse(json["Longitiude"].toString()) : null,
        googleAddress: json["GoogleAddress"],
        tradeChannelId:
            json["TradeChannelID"] != null ? int.parse(json["TradeChannelID"].toString()) : null,
        vpo: json["VPO"],
        seo: json["SEO"],
        imageUrl: json["ImageUrl"],
        isModify: json["IsModify"] == 0 ? false : true,
        salePersonName: json["SalePersonName"],
        areaName: json["AreaName"],
        channelName: json["ChannelName"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "isSync": isSync,
        "ShopID": shopId,
        "ShopName": shopName,
        "ShopCode": shopCode,
        "ContactPerson": contactPerson,
        "ContactNo": contactNo,
        "NTNNO": NTNno,
        "RegionID": regionId,
        "AreaID": areaId,
        "SalePersonID": salePersonId,
        "CreatedByID": createdById,
        "UpdatedByID": updatedById,
        "CreatedOn": createdOn?.toIso8601String(),
        "UpdatedOn": updatedOn?.toIso8601String(),
        "SystemNotes": systemNotes,
        "Remarks": remarks,
        "Description": description,
        "EntryDate": entryDate?.toIso8601String(),
        "BranchID": branchId,
        "Latitiude": latitiude,
        "Longitiude": longitiude,
        "GoogleAddress": googleAddress,
        "TradeChannelID": tradeChannelId,
        "VPO": vpo,
        "SEO": seo,
        "ImageUrl": imageUrl,
        "IsModify": isModify,
        "SalePersonName": salePersonName,
        "AreaName": areaName,
        "ChannelName": channelName,
      };
}
