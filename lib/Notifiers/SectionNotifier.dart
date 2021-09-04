// import 'package:cake_mania/Models/SectionModel.dart';
import 'package:flutter/foundation.dart';

class SectionNameNotifier extends ChangeNotifier {
  List<String> _sectionNames = [];
  List<String> get sectionNames => _sectionNames;
  // List<SectionModel> _sectionModels = [];
  // List<SectionModel> get sectionModels => _sectionModels;

  // void addSection(SectionModel sectionModel) {
  //   // print(sectionModel);
  //   if (_sectionModels.isNotEmpty) {
  //     _sectionModels.forEach((element) {
  //       if (element.title != sectionModel.title) {
  //         _sectionModels.add(sectionModel);
  //       } else {
  //         print('object');
  //       }
  //     });
  //   } else {
  //     _sectionModels.add(sectionModel);
  //   }
  //   // notifyListeners();
  // }

  void addSectionNames(String sectionName) {
    if (!_sectionNames.contains(sectionName)) {
      _sectionNames.add(sectionName);
    }
    notifyListeners();
  }

  // void addSectionNoUpdate(SectionModel sectionModel) {
  //   if (!_sectionModels.contains(sectionModel)) {
  //     _sectionModels.add(sectionModel);
  //   }
  // }

  // void addSectionNamesNoUpdate(String sectionName) {
  //   if (!_sectionNames.contains(sectionName)) {
  //     _sectionNames.add(sectionName);
  //   }
  //   // notifyListeners();
  // }
}
