class DeliveryDetailsModel {
  String address;
  String pinCode;
  String mobileNumber;
  DeliveryDetailsModel({
    required this.address,
    required this.mobileNumber,
    required this.pinCode,
  });

  factory DeliveryDetailsModel.fromJson(Map<String, dynamic> json) =>
      DeliveryDetailsModel(
        address: json["address"],
        mobileNumber: json["mobileNumber"],
        pinCode: json["pinCode"],
      );
  static toJson(DeliveryDetailsModel deliveryModel) => {
        "address": deliveryModel.address,
        "mobileNumber": deliveryModel.mobileNumber,
        "pinCode": deliveryModel.pinCode,
      };
}
