class Product {
  String id;
  String name;
  String filter;
  String phone;
  String buyprice;
  String sellprice;
  DateTime buyDate;
  List<String> photos;
  String description;

  Product({
    required this.id,
    required this.name,
    required this.filter,
    required this.phone,
    required this.buyprice,
    required this.sellprice,
    required this.buyDate,
    required this.photos,
    required this.description
  });

  factory Product.fromJson(Map<String, dynamic> json) =>
      Product(
        id: json["id"],
        name: json["name"],
        filter: json["filter"],
        phone: json["phone"],
        buyprice: json["buyprice"],
        sellprice: json["sellprice"],
        buyDate: json["buyDate"].toDate(),
        photos: (json['photos'] as List<dynamic>?)
           ?.map((item) => item.toString())
           .toList() ?? [],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "filter": filter,
    "phone": phone,
    "buyprice": buyprice,
    "buyDate": buyDate,
    "sellprice": sellprice,
    "photos": photos,
    "description": description,
  };


}