

class SubCategory {
  final String? id;
  final String name;
  final dynamic image;
  final String? categoryId;
  final String? objectName;
  final String price;

  SubCategory({
     this.id, required this.name, required this.image,  this.categoryId,required this.price, required this.objectName});

  factory SubCategory.fromJson(Map<String,dynamic> json) {
    return SubCategory(
        id: json['id'].toString(),
        name: json['name'],
        image: json['imageUrl'],
        categoryId: json['categoryId'].toString(),
        price: json['price'].toString(),
      objectName: json['objectName']
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id' : id,
      'name' : name,
      'imageUrl' : image,
      'categoryId' : categoryId,
      'price' : price.toString(),
      'objectName' : objectName
    };
  }
}