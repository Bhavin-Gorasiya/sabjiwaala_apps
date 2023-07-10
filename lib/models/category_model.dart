class MainCategoryModel {
  MainCategoryModel({
    this.categoryId,
    this.categoryName,
    this.categoryFile,
    this.categoryDate,
    this.categoryStatus,
  });

  String? categoryId;
  String? categoryName;
  String? categoryFile;
  DateTime? categoryDate;
  String? categoryStatus;

  factory MainCategoryModel.fromJson(Map<String, dynamic> json) => MainCategoryModel(
        categoryId: json["maincategoryID"] ?? "",
        categoryName: json["maincategoryName"] ?? "",
        categoryFile: json["maincategoryPic"] ?? "",
        categoryDate: DateTime.parse(json["maincategoryDate"]),
        categoryStatus: json["maincategoryStatus"] ?? "",
      );
}

class SubCategoryModel {
  SubCategoryModel({
    required this.subcategoryId,
    required this.categoryId,
    required this.subcategoryName,
    required this.subcategoryFile,
    required this.subcategoryDate,
    required this.subcategoryStatus,
  });

  String subcategoryId;
  String categoryId;
  String subcategoryName;
  String subcategoryFile;
  DateTime subcategoryDate;
  String subcategoryStatus;

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) => SubCategoryModel(
        subcategoryId: json["subcategoryID"],
        categoryId: json["CategoryId"],
        subcategoryName: json["subcategoryName"],
        subcategoryFile: json["subcategoryFile"],
        subcategoryDate: DateTime.parse(json["subcategoryDate"]),
        subcategoryStatus: json["subcategoryStatus"],
      );
}
