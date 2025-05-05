// To parse this JSON data, do
//
//     final CategoriesDataModel = CategoriesDataModelFromJson(jsonString);

import 'dart:convert';

CategoriesDataModel CategoriesDataModelFromJson(String str) =>
    CategoriesDataModel.fromJson(json.decode(str));

String CategoriesDataModelToJson(CategoriesDataModel data) =>
    json.encode(data.toJson());

class CategoriesDataModel {
  bool? success;
  List<Datum>? data;

  CategoriesDataModel({this.success, this.data});

  factory CategoriesDataModel.fromJson(Map<String, dynamic> json) =>
      CategoriesDataModel(
        success: json["success"],
        data:
            json["data"] == null
                ? []
                : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data":
        data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  String? categoryId;
  String? categoryEng;
  String? categorySpan;
  String? categoryChine;
  String? categoryDutch;
  String? orderNum;
  String? image;
  String? color;
  List<Subcategory>? subcategories;

  Datum({
    this.categoryId,
    this.categoryEng,
    this.categorySpan,
    this.categoryChine,
    this.categoryDutch,
    this.orderNum,
    this.image,
    this.color,
    this.subcategories,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    categoryId: json["categoryID"],
    categoryEng: json["categoryEng"],
    categorySpan: json["categorySpan"],
    categoryChine: json["categoryChine"],
    categoryDutch: json["categoryDutch"],
    orderNum: json["orderNum"],
    image: json["image"],
    color: json["color"],
    subcategories:
        json["subcategories"] == null
            ? []
            : List<Subcategory>.from(
              json["subcategories"]!.map((x) => Subcategory.fromJson(x)),
            ),
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
    "subcategories":
        subcategories == null
            ? []
            : List<dynamic>.from(subcategories!.map((x) => x.toJson())),
  };
}

class Subcategory {
  String? subcategoryId;
  String? subcategoryEng;
  String? subcategorySpan;
  String? subcategoryChine;
  String? subcategoryDutch;
  String? orderNum;
  List<Word>? words;

  Subcategory({
    this.subcategoryId,
    this.subcategoryEng,
    this.subcategorySpan,
    this.subcategoryChine,
    this.subcategoryDutch,
    this.orderNum,
    this.words,
  });

  factory Subcategory.fromJson(Map<String, dynamic> json) => Subcategory(
    subcategoryId: json["subcategoryID"],
    subcategoryEng: json["subcategoryEng"],
    subcategorySpan: json["subcategorySpan"],
    subcategoryChine: json["subcategoryChine"],
    subcategoryDutch: json["subcategoryDutch"],
    orderNum: json["orderNum"],
    words:
        json["words"] == null
            ? []
            : List<Word>.from(json["words"]!.map((x) => Word.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "subcategoryID": subcategoryId,
    "subcategoryEng": subcategoryEng,
    "subcategorySpan": subcategorySpan,
    "subcategoryChine": subcategoryChine,
    "subcategoryDutch": subcategoryDutch,
    "orderNum": orderNum,
    "words":
        words == null ? [] : List<dynamic>.from(words!.map((x) => x.toJson())),
  };
}

class Word {
  String? learnContentsId;
  String? papiamento;
  String? english;
  String? spanish;
  String? dutch;
  String? chinese;
  String? orderNumber;
  dynamic audioFile;

  Word({
    this.learnContentsId,
    this.papiamento,
    this.english,
    this.spanish,
    this.dutch,
    this.chinese,
    this.orderNumber,
    this.audioFile,
  });

  factory Word.fromJson(Map<String, dynamic> json) => Word(
    learnContentsId: json["learnContentsID"],
    papiamento: json["papiamento"],
    english: json["english"],
    spanish: json["spanish"],
    dutch: json["dutch"],
    chinese: json["chinese"],
    orderNumber: json["orderNumber"],
    audioFile: json["audioId"],
  );

  Map<String, dynamic> toJson() => {
    "learnContentsID": learnContentsId,
    "papiamento": papiamento,
    "english": english,
    "spanish": spanish,
    "dutch": dutch,
    "chinese": chinese,
    "orderNumber": orderNumber,
    "audioFile": audioFile,
  };
}
