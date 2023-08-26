

class SubCategory {
  final String? id;
  final String name;
  final dynamic image;
  final String? categoryId;
  final String price;

  SubCategory({
     this.id, required this.name, required this.image,  this.categoryId,required this.price});

  factory SubCategory.fromJson(Map<String,dynamic> json) {
    return SubCategory(
        id: json['id'].toString(),
        name: json['name'],
        image: json['image'],
        categoryId: json['categoryId'].toString(),
        price: json['price'].toString()
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id' : id,
      'name' : name,
      'image' : image,
      'categoryId' : categoryId,
      'price' : price.toString()
    };
  }
}