class CakeOrderModel {
  final int cakeId;
  final String name;
  final String imageUrl;
  final double price;
  String flavor;
  String weight;
  final String occasion;
  final String? message;
  final String? theme;
  // List<Ingredients>
  List<dynamic>? addOns;

  CakeOrderModel({
    required this.cakeId,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.flavor,
    required this.weight,
    required this.occasion,
    this.message,
    this.theme,
    this.addOns,
  });
  Map<String, dynamic> toJson(CakeOrderModel cakeOrderModel) => {
        "cakeId": cakeOrderModel.cakeId,
        "name": cakeOrderModel.name,
        "imageUrl": cakeOrderModel.imageUrl,
        "price": cakeOrderModel.price,
        "flavor": cakeOrderModel.flavor,
        "weight": cakeOrderModel.weight,
        "occasion": cakeOrderModel.occasion,
        "message": cakeOrderModel.message ?? 'No Message',
        "theme": cakeOrderModel.theme ?? 'No Theme',
        "addOns": cakeOrderModel.addOns
      };

  factory CakeOrderModel.fromJson(dynamic json) => CakeOrderModel(
        imageUrl: json["imageUrl"],
        cakeId: json["cakeId"],
        name: json["name"],
        price: json["price"].toDouble(),
        flavor: json["flavor"],
        weight: json["weight"],
        occasion: json["occasion"],
        message: json["message"],
        theme: json["theme"],
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
