import 'package:cake_mania/Models/CakeCardColor.dart';
import 'package:cake_mania/Models/CakeModel.dart';

class SectionModel {
  final String title;
  final CakeCardColor cardColor;
  final List<CakeModel> cakeModels;
  SectionModel({
    required this.title,
    required this.cardColor,
    required this.cakeModels,
  });

  factory SectionModel.fromJson(json) => SectionModel(
        title: json["title"],
        cardColor: CakeCardColorConvertor.fromJson(json["cardColor"]),
        cakeModels: CakeModel.jsonToCakeModelList(json["cakeModels"]),
      );

  static Map<String, dynamic> toJson(SectionModel sectionModel) => {
        "title": sectionModel.title,
        "cardColor": sectionModel.cardColor,
        "cakeModels": sectionModel.cakeModels,
      };

  static List<SectionModel> jsonToSectionList(json) {
    final list = List<SectionModel>.from(
        json.map((x) => SectionModel.fromJson(x.data())));
    return list;
  }

  // static List<SectionCard> sectionModelListToSectionCardList(
  //     List<SectionModel> sectionModelList) {
  //   final list = List<SectionCard>.from(sectionModelList.map((e) => SectionCard(
  //       title: e.title,
  //       cardColor: e.cardColor,
  //       cakeModels: CakeModel.sectionListToCakeModelList(e.cakeModels))));
  //   return list;
  // }
}
