class CakeOrderModel {
  final int cakeId;
  final String name;
  final String imageUrl;
  final double price;
  String flavor;
  int quantity;
  List<String>? addOns;

  CakeOrderModel({
    required this.cakeId,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.flavor,
    required this.quantity,
    this.addOns,
  });
  Map<String, dynamic> toJson(CakeOrderModel cakeOrderModel) => {
        "cakeId": cakeOrderModel.cakeId,
        "name": cakeOrderModel.name,
        "imageUrl": cakeOrderModel.imageUrl,
        "price": cakeOrderModel.price,
        "flavor": cakeOrderModel.flavor,
        "quantity": cakeOrderModel.quantity,
        "addOns": cakeOrderModel.addOns
      };

  factory CakeOrderModel.fromJson(dynamic json) => CakeOrderModel(
        imageUrl: json["imageUrl"],
        cakeId: json["cakeId"],
        name: json["name"],
        price: json["price"],
        flavor: json["flavor"],
        quantity: json["quantity"],
        addOns: json["addOns"] ?? [],
      );

// convert list of orders to json file
  static Map<String, dynamic> orderListToJson(
          List<CakeOrderModel> cakeOrderModel, String key) =>
      {
        key: List<dynamic>.from(cakeOrderModel.map((e) => e.toJson(e))),
      };

// convert json file to list of orders
  static List<CakeOrderModel> jsonToOrderList(json, String key) =>
      List<CakeOrderModel>.from(
          json[key].map((x) => CakeOrderModel.fromJson(x)));
}
