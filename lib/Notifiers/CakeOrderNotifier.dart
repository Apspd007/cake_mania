import 'package:cake_mania/Models/CakeOrderModel.dart';
import 'package:flutter/foundation.dart';

class CakeOrderNotifier extends ChangeNotifier {
  List<CakeOrderModel> _cakeOrderModel = <CakeOrderModel>[];
  // List<CakeOrderModel> _cakeOrderModel = [];
  List<CakeOrderModel> get cakeOrderModel => _cakeOrderModel;
  set setCakeOrderModel(List<CakeOrderModel> orders) {
    _cakeOrderModel = orders;
  }

  int get totalOrders => _cakeOrderModel.length;

  void add(CakeOrderModel event) {
    bool _add = true;
    if (!_cakeOrderModel.contains(event)) {
      _cakeOrderModel.forEach((element) {
        if (element.cakeId == event.cakeId && element.flavor == event.flavor) {
          _add = false;
          element.weight = event.weight;
          print('Already Added');
        }
      });
    } else {
      print('not added');
    }
    if (_add) {
      _cakeOrderModel.add(event);
      notifyListeners();
      print('added');
    }
  }

  void deleteAllOrders() {
    _cakeOrderModel.clear();
    notifyListeners();
  }

  void deleteOrderAt(int index) {
    _cakeOrderModel.removeAt(index);
    notifyListeners();
  }

  void changeFlavorAt(int index, String flavor) {
    _cakeOrderModel.elementAt(index).flavor = flavor;
    notifyListeners();
  }

  void changeWeightAt(int index, String weight) {
    _cakeOrderModel.elementAt(index).weight = weight;
    notifyListeners();
  }

  void changeAddOnsAt(int index, List<String> addOns) {
    _cakeOrderModel.elementAt(index).addOns = addOns;
    notifyListeners();
  }
}
