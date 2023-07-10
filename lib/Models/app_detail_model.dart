class AppDetailModel {
  AppDetailModel({
    this.androidVersion,
    this.iosVersion,
    this.playstore,
    this.appstore,
    this.telephone,
    this.phone,
    this.email,
    this.website,
    this.aboutus,
    this.facebook,
    this.instagram,
  });

  String? androidVersion;
  String? iosVersion;
  String? playstore;
  String? appstore;
  String? telephone;
  String? phone;
  String? email;
  String? website;
  String? aboutus;
  String? facebook;
  String? instagram;

  factory AppDetailModel.fromJson(Map<String, dynamic> json) => AppDetailModel(
        androidVersion: json["android_version"] ?? "",
        iosVersion: json["ios_version"] ?? "",
        playstore: json["playstore"] ?? "",
        appstore: json["appstore"] ?? "",
        telephone: json["telephone"] ?? "",
        phone: json["phone"] ?? "",
        email: json["email"] ?? "",
        website: json["website"] ?? "",
        aboutus: json["aboutus"] ?? "",
        facebook: json["facebook"] ?? "",
        instagram: json["instagram"] ?? "",
      );
}
