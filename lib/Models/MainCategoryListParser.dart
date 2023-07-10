class MainCategoryListParser {
  String? maincategoryID;
  String? maincategoryName;
  String? maincategoryPic;
  String? maincategoryDate;
  String? maincategoryStatus;

  MainCategoryListParser(
      {this.maincategoryID,
      this.maincategoryName,
      this.maincategoryPic,
      this.maincategoryDate,
      this.maincategoryStatus});

  MainCategoryListParser.fromJson(Map<dynamic, dynamic> json) {
    maincategoryID = json['maincategoryID'];
    maincategoryName = json['maincategoryName'];
    maincategoryPic = json['maincategoryPic'];
    maincategoryDate = json['maincategoryDate'];
    maincategoryStatus = json['maincategoryStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['maincategoryID'] = this.maincategoryID;
    data['maincategoryName'] = this.maincategoryName;
    data['maincategoryPic'] = this.maincategoryPic;
    data['maincategoryDate'] = this.maincategoryDate;
    data['maincategoryStatus'] = this.maincategoryStatus;
    return data;
  }
}

class GetCategory {
  String? status;
  List<CategoryModel>? category;
  List<Subcategory>? subcategory;

  GetCategory({
    this.status,
    this.category,
    this.subcategory,
  });

  factory GetCategory.fromJson(Map<String, dynamic> json) => GetCategory(
        status: json["status"] ?? "false",
        category:
            json["category"] == null ? [] : List<CategoryModel>.from(json["category"].map((x) => CategoryModel.fromJson(x))),
        subcategory: json["subcategory"] == null
            ? []
            : List<Subcategory>.from(json["subcategory"].map((x) => Subcategory.fromJson(x))),
      );
}

class CategoryModel {
  String? categoryId;
  String? categoryName;
  String? categoryFile;
  DateTime? categoryDate;
  String? categoryStatus;

  CategoryModel({
    this.categoryId,
    this.categoryName,
    this.categoryFile,
    this.categoryDate,
    this.categoryStatus,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        categoryId: json["categoryID"] ?? "",
        categoryName: json["categoryName"] ?? "",
        categoryFile: json["categoryFile"] ?? "",
        categoryDate: DateTime.parse(json["categoryDate"] ?? DateTime.now().toString()),
        categoryStatus: json["categoryStatus"] ?? "",
      );
}

class Subcategory {
  String? subcategoryId;
  String? categoryId;
  String? subcategoryName;
  String? subcategoryFile;
  DateTime? subcategoryDate;
  String? subcategoryStatus;

  Subcategory({
    this.subcategoryId,
    this.categoryId,
    this.subcategoryName,
    this.subcategoryFile,
    this.subcategoryDate,
    this.subcategoryStatus,
  });

  factory Subcategory.fromJson(Map<String, dynamic> json) => Subcategory(
        subcategoryId: json["subcategoryID"] ?? "",
        categoryId: json["CategoryId"] ?? "",
        subcategoryName: json["subcategoryName"] ?? "",
        subcategoryFile: json["subcategoryFile"] ?? "",
        subcategoryDate: DateTime.parse(json["subcategoryDate"] ?? DateTime.now().toString()),
        subcategoryStatus: json["subcategoryStatus"] ?? "",
      );
}
