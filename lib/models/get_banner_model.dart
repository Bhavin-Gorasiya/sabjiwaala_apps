class GetBannerModel {
  GetBannerModel({
    required this.bannerId,
    required this.bannerTitle,
    required this.bannerFile,
    required this.bannerDate,
    required this.bannerStatus,
  });

  String? bannerId;
  String? bannerTitle;
  String? bannerFile;
  DateTime? bannerDate;
  String? bannerStatus;

  factory GetBannerModel.fromJson(Map<String, dynamic> json) => GetBannerModel(
    bannerId: json["bannerID"] ?? '',
    bannerTitle: json["bannerTitle"] ?? '',
    bannerFile: json["bannerFile"] ?? '',
    bannerDate: DateTime.parse(json["bannerDate"] ?? "${DateTime.now()}"),
    bannerStatus: json["bannerStatus"] ?? '',
  );
}
