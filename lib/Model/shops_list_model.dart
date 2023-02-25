import 'package:intl/intl.dart';

class ShopsListModel {
  int? ID;
  int? ShopID ;
  String? ShopName;
  String? ShopCode;
  String? SalePersonName;
  String? AreaName;
  String? VPO;
  String? ContactPerson;
  String? ContactNo;
  String? EntryDate;
  String? SEO;
  String? ChannelName;

  ShopsListModel(
      {
        this.ID,
        this.ShopID,
        this.ShopName,
        this.ShopCode,
        this.SalePersonName,
        this.AreaName,
        this.VPO,
        this.ContactPerson,
        this.ContactNo,
        this.EntryDate,
        this.SEO,
        this.ChannelName
      });

  ShopsListModel.fromJson(Map<String, dynamic> json) {
    ID = json['ID'];
    ShopID = json['ShopID'];
    ShopName = json['ShopName'];
    ShopCode = json['ShopCode'];
    SalePersonName = json['SalePersonName'];
    AreaName = json['AreaName'];
    VPO = json['VPO'];
    ContactPerson = json['ContactPerson'];
    ContactNo = json['ContactNo'];
    EntryDate = DateFormat('dd-MM-yyyy').format(DateTime.parse(json['EntryDate']));
    SEO = json['SEO'];
    ChannelName = json['ChannelName'];
  }
}