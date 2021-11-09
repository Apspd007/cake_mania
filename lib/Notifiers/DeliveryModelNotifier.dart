import 'package:cake_mania/Models/DeliveryDetailsModel.dart';
import 'package:flutter/cupertino.dart';

class DeliveryModelNotifier extends ChangeNotifier {
  DeliveryDetailsModel? deliveryModel;
  DeliveryModelNotifier({this.deliveryModel});
  changeDeliveryDetails(DeliveryDetailsModel deliveryDetailsModel) {
    this.deliveryModel = deliveryDetailsModel;
    notifyListeners();
  }
}
