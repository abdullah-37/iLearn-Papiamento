import 'dart:convert';

import 'package:ilearn_papiamento/models/data_model.dart';

/// Top-level conversion functions
DictionaryDataModel dictionaryResponseFromJson(String str) =>
    DictionaryDataModel.fromJson(json.decode(str) as Map<String, dynamic>);

String dictionaryResponseToJson(DictionaryDataModel data) =>
    json.encode(data.toJson());

class DictionaryDataModel {
  bool? success;
  String? total;
  int? perPage;
  int? currentPage;
  int? totalPages;
  List<Word>? dictionaryWords;

  DictionaryDataModel({
    this.success,
    this.total,
    this.perPage,
    this.currentPage,
    this.totalPages,
    this.dictionaryWords,
  });

  factory DictionaryDataModel.fromJson(Map<String, dynamic> json) {
    return DictionaryDataModel(
      success: json['success'] as bool? ?? false,
      total: json['total']?.toString() ?? '',
      perPage:
          (json['per_page'] is int)
              ? json['per_page'] as int
              : int.tryParse(json['per_page']?.toString() ?? '') ?? 0,
      currentPage:
          (json['current_page'] is int)
              ? json['current_page'] as int
              : int.tryParse(json['current_page']?.toString() ?? '') ?? 0,
      totalPages:
          (json['total_pages'] is int)
              ? json['total_pages'] as int
              : int.tryParse(json['total_pages']?.toString() ?? '') ?? 0,
      dictionaryWords:
          json['dictionaryWords'] == null
              ? []
              : List<Word>.from(
                (json['dictionaryWords'] as List<dynamic>).map(
                  (x) => Word.fromJson(x as Map<String, dynamic>),
                ),
              ),
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'total': total,
    'per_page': perPage,
    'current_page': currentPage,
    'total_pages': totalPages,
    'dictionaryWords':
        dictionaryWords == null
            ? []
            : List<dynamic>.from(dictionaryWords!.map((x) => x.toJson())),
  };
}

// class DictionaryWord {
//   String? dictionaryContentsId;
//   String? papiamento;
//   String? english;
//   String? spanish;
//   String? chinese;
//   String? dutch;
//   String? audio;

//   DictionaryWord({
//     this.dictionaryContentsId,
//     this.papiamento,
//     this.english,
//     this.spanish,
//     this.chinese,
//     this.dutch,
//     this.audio,
//   });

//   factory DictionaryWord.fromJson(Map<String, dynamic> json) {
//     return DictionaryWord(
//       dictionaryContentsId: json['dictionaryContentsID']?.toString() ?? '',
//       papiamento: json['papiamento']?.toString() ?? '',
//       english: json['english']?.toString() ?? '',
//       spanish: json['spanish']?.toString() ?? '',
//       chinese: json['chinese']?.toString() ?? '',
//       dutch: json['dutch']?.toString() ?? '',
//       audio: json['audio']?.toString() ?? '',
//     );
//   }

//   Map<String, dynamic> toJson() => {
//     'dictionaryContentsID': dictionaryContentsId,
//     'papiamento': papiamento,
//     'english': english,
//     'spanish': spanish,
//     'chinese': chinese,
//     'dutch': dutch,
//     'audio': audio,
//   };
// }
