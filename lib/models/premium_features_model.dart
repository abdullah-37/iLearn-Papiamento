import 'dart:convert';

// Corrected function signature
String premiumDataModelToJson(PremiumFeaturesModel data) =>
    json.encode(data.toJson());

// Corrected from String to model
PremiumFeaturesModel premiumDataModelFromJson(String str) =>
    PremiumFeaturesModel.fromJson(json.decode(str));

class PremiumFeaturesModel {
  bool? success;
  List<PremiumItem>? categories;

  PremiumFeaturesModel({this.success, this.categories});

  factory PremiumFeaturesModel.fromJson(Map<String, dynamic> json) =>
      PremiumFeaturesModel(
        success: json["success"] ?? false,
        categories:
            json["categories"] == null
                ? []
                : List<PremiumItem>.from(
                  json["categories"].map((x) => PremiumItem.fromJson(x)),
                ),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "categories":
        categories == null
            ? []
            : List<dynamic>.from(categories!.map((x) => x.toJson())),
  };
}

class PremiumItem {
  String? categoryId;
  String? categoryEng;
  String? categorySpan;
  String? categoryChine;
  String? categoryDutch;
  String? orderNum;
  String? image;
  String? color;
  String? productId;

  PremiumItem({
    this.categoryId,
    this.categoryEng,
    this.categorySpan,
    this.categoryChine,
    this.categoryDutch,
    this.orderNum,
    this.image,
    this.color,
    this.productId,
  });

  factory PremiumItem.fromJson(Map<String, dynamic> json) => PremiumItem(
    categoryId: json["categoryID"] ?? '',
    categoryEng: json["categoryEng"] ?? '',
    categorySpan: json["categorySpan"] ?? '',
    categoryChine: json["categoryChine"] ?? '',
    categoryDutch: json["categoryDutch"] ?? '',
    orderNum: json["orderNum"] ?? '',
    image: json["image"] ?? '',
    color: json["color"] ?? '',
    productId: json['product_id'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "categoryID": categoryId,
    "categoryEng": categoryEng,
    "categorySpan": categorySpan,
    "categoryChine": categoryChine,
    "categoryDutch": categoryDutch,
    "orderNum": orderNum,
    "image": image,
    "color": color,
    "product_id": productId,
  };
}
