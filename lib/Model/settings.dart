class Items {
  int? ItemID;
  int? ItemCatID;
  int? ItemSubCatID;
  String? ItemType;
  String? ItemCode;
  String? ItemName;
  String? Description;
  bool? IsActive;
  double? PurchaseRate;
  double? SaleRate;
  int? UOMID;
  double? ReorderLevel;
  String? ImageUrl;
  double? UnitQuantity;
  double? ReOrderQuantity;
  bool? AutoCode;
  int? SortID;
  int? PartyID;
  double? SaleTaxRate;

  Items(
      {this.ItemID,
      this.ItemCatID,
      this.ItemSubCatID,
      this.ItemType,
      this.ItemCode,
      this.ItemName,
      this.Description,
      this.IsActive,
      this.PurchaseRate,
      this.SaleRate,
      this.UOMID,
      this.ReorderLevel,
      this.ImageUrl,
      this.UnitQuantity,
      this.ReOrderQuantity,
      this.AutoCode,
      this.SortID,
      this.PartyID,
      this.SaleTaxRate});

  factory Items.fromJson(Map<String, dynamic> json) {
    return Items(
      ItemID: json['ItemID'],
      ItemCatID: json['ItemCatID'],
      ItemSubCatID: json['ItemSubCatID'],
      ItemType: json['ItemType'],
      ItemCode: json['ItemCode'],
      ItemName: json['ItemName'],
      Description: json['Description'],
      IsActive: json['IsActive'],
      PurchaseRate: json['PurchaseRate'],
      SaleRate: json['SaleRate'],
      UOMID: json['UOMID'],
      ReorderLevel: json['ReorderLevel'],
      ImageUrl: json['ImageUrl'],
      UnitQuantity: json['UnitQuantity'],
      ReOrderQuantity: json['ReOrderQuantity'],
      AutoCode: json['AutoCode'],
      SortID: json['SortID'],
      PartyID: json['PartyID'],
      SaleTaxRate: json['SaleTaxRate'],
    );
  }

  // factory Items.fromMaps(Map<String, dynamic> json) => Items(
  //   ItemID: json['ItemID'],
  // );
  //
  // Map<String, dynamic> toMaps() => {
  //   'ItemID' : this.ItemID,
  // };

  factory Items.fromMap(Map<String, dynamic> json) {
    return Items(
      ItemID: json['ItemID'],
      ItemCatID: json['ItemCatID'],
      ItemSubCatID: json['ItemSubCatID'],
      ItemType: json['ItemType'],
      ItemCode: json['ItemCode'],
      ItemName: json['ItemName'],
      Description: json['Description'],
      IsActive: json['IsActive'],
      PurchaseRate: json['PurchaseRate'],
      SaleRate: json['SaleRate'],
      UOMID: json['UOMID'],
      ReorderLevel: json['ReorderLevel'],
      ImageUrl: json['ImageUrl'],
      UnitQuantity: json['UnitQuantity'],
      ReOrderQuantity: json['ReOrderQuantity'],
      AutoCode: json['AutoCode'],
      SortID: json['SortID'],
      PartyID: json['PartyID'],
      SaleTaxRate: json['SaleTaxRate'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ItemID': this.ItemID,
      'ItemCatID': this.ItemCatID,
      'ItemSubCatID': this.ItemSubCatID,
      'ItemType': this.ItemType,
      'ItemCode': this.ItemCode,
      'ItemName': this.ItemName,
      'Description': this.Description,
      'IsActive': this.IsActive,
      'PurchaseRate': this.PurchaseRate,
      'SaleRate': this.SaleRate,
      'UOMID': this.UOMID,
      'ReorderLevel': this.ReorderLevel,
      'ImageUrl': this.ImageUrl,
      'UnitQuantity': this.UnitQuantity,
      'ReOrderQuantity': this.ReOrderQuantity,
      'AutoCode': this.AutoCode,
      'SortID': this.SortID,
      'PartyID': this.PartyID,
      'SaleTaxRate': this.SaleTaxRate,
    };
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ItemID'] = this.ItemID;
    data['ItemCatID'] = this.ItemCatID;
    data['ItemSubCatID'] = this.ItemSubCatID;
    data['ItemType'] = this.ItemType;
    data['ItemCode'] = this.ItemCode;
    data['ItemName'] = this.ItemName;
    data['Description'] = this.Description;
    data['IsActive'] = this.IsActive;
    data['PurchaseRate'] = this.PurchaseRate;
    data['SaleRate'] = this.SaleRate;
    data['UOMID'] = this.UOMID;
    data['ReorderLevel'] = this.ReorderLevel;
    data['ImageUrl'] = this.ImageUrl;
    data['UnitQuantity'] = this.UnitQuantity;
    data['ReOrderQuantity'] = this.ReOrderQuantity;
    data['AutoCode'] = this.AutoCode;
    data['SortID'] = this.SortID;
    data['PartyID'] = this.PartyID;
    data['SaleTaxRate'] = this.SaleTaxRate;
    return data;
  }
}
