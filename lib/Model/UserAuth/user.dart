class User {
  User({
    this.userId,
    this.salePersonId,
    this.regionId,
    this.username,
    this.password,
    this.fullName,
    this.isActive,
    this.branchId,
    this.isAdmin,
    this.branchAdmin,
    this.isSalesPerson,
    this.branchName,
  });

  int? userId;
  int? salePersonId;
  int? regionId;
  String? username;
  String? password;
  String? fullName;
  bool? isActive;
  int? branchId;
  bool? isAdmin;
  bool? branchAdmin;
  bool? isSalesPerson;
  String? branchName;

  factory User.fromJson(Map<String, dynamic> json) => User(
        userId: json["UserID"],
        salePersonId: json["SalePersonID"],
        regionId: json["RegionID"],
        username: json["Username"],
        password: json["Password"],
        fullName: json["FullName"],
        isActive: json["IsActive"],
        branchId: json["BranchID"],
        isAdmin: json["IsAdmin"],
        branchAdmin: json["BranchAdmin"],
        isSalesPerson: json["IsSalesPerson"],
        branchName: json["BranchName"],
      );

  Map<String, dynamic> toJson() => {
        "UserID": userId,
        "SalePersonID": salePersonId,
        "RegionID": regionId,
        "Username": username,
        "Password": password,
        "FullName": fullName,
        "IsActive": isActive,
        "BranchID": branchId,
        "IsAdmin": isAdmin,
        "BranchAdmin": branchAdmin,
        "IsSalesPerson": isSalesPerson,
        "BranchName": branchName,
      };
}
