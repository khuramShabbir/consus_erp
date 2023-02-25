class User {
  int? userID;
  int? salePersonID;
  int? regionID;
  String? username;
  String? password;
  String? fullName;
  bool? isActive;
  int? branchID;
  bool? isAdmin;
  bool? branchAdmin;
  bool? isSalesPerson;
  String? branchName;

  User(
      {this.userID,
      this.salePersonID,
      this.regionID,
      this.username,
      this.password,
      this.fullName,
      this.isActive,
      this.branchID,
      this.isAdmin,
      this.branchAdmin,
      this.isSalesPerson,
      this.branchName});

  User.fromJson(Map<String, dynamic> json) {
    userID = json['UserID'];
    salePersonID = json['SalePersonID'];
    regionID = json['RegionID'];
    username = json['Username'];
    password = json['Password'];
    fullName = json['FullName'];
    isActive = json['IsActive'];
    branchID = json['BranchID'];
    isAdmin = json['IsAdmin'];
    branchAdmin = json['BranchAdmin'];
    isSalesPerson = json['IsSalesPerson'];
    branchName = json['BranchName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['UserID'] = this.userID;
    data['SalePersonID'] = this.salePersonID;
    data['RegionID'] = this.regionID;
    data['Username'] = this.username;
    data['Password'] = this.password;
    data['FullName'] = this.fullName;
    data['IsActive'] = this.isActive;
    data['BranchID'] = this.branchID;
    data['IsAdmin'] = this.isAdmin;
    data['BranchAdmin'] = this.branchAdmin;
    data['IsSalesPerson'] = this.isSalesPerson;
    data['BranchName'] = this.branchName;
    return data;
  }
}
