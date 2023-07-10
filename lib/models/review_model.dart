class ReviewModel {
  String? reviewTag;
  String? reviewCid;
  String? reviewVid;
  String? reviewPid;
  String? reviewRating;
  String? reviewDesc;

  ReviewModel({
    this.reviewTag,
    this.reviewCid,
    this.reviewVid,
    this.reviewPid,
    this.reviewRating,
    this.reviewDesc,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) => ReviewModel(
    reviewTag: json["reviewTag"],
    reviewCid: json["reviewCid"],
    reviewVid: json["reviewVid"],
    reviewPid: json["reviewPid"],
    reviewRating: json["reviewRating"],
    reviewDesc: json["reviewDesc"],
  );

  Map<String, dynamic> toJson() => {
    "reviewTag": reviewTag,
    "reviewCid": reviewCid,
    "reviewVid": reviewVid,
    "reviewPid": reviewPid,
    "reviewRating": reviewRating,
    "reviewDesc": reviewDesc,
  };
}