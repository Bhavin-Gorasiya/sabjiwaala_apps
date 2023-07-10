import 'package:flutter/material.dart';

class ProductReviewModel {
  ProductReviewModel({
    required this.reviewId,
    required this.reviewCid,
    required this.reviewVid,
    required this.reviewPid,
    required this.reviewRating,
    required this.reviewDesc,
    required this.reviewDate,
    required this.fullName,
  });

  String reviewId;
  String reviewCid;
  String reviewVid;
  String reviewPid;
  String reviewRating;
  String reviewDesc;
  String reviewDate;
  String fullName;

  factory ProductReviewModel.fromJson(Map json) {
    return ProductReviewModel(
      reviewId: json["reviewID"],
      reviewCid: json["reviewCid"],
      reviewVid: json["reviewVid"],
      reviewPid: json["reviewPid"],
      reviewRating: json["reviewRating"],
      reviewDesc: json["reviewDesc"],
      reviewDate: json["reviewDate"],
      fullName: json["Full Name"],
    );
  }

  Map<String, dynamic> toJson() => {
    "reviewID": reviewId,
    "reviewCid": reviewCid,
    "reviewVid": reviewVid,
    "reviewPid": reviewPid,
    "reviewRating": reviewRating,
    "reviewDesc": reviewDesc,
    "reviewDate": reviewDate,
    "Full Name": fullName,
  };
}
