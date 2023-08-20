

class SubCategory {
  final int? id;
  final String name;
  final dynamic image;
  final String? categoryId;

  SubCategory({
     this.id, required this.name, required this.image,  this.categoryId,});

  factory SubCategory.fromJson(Map<String,dynamic> json) {
    return SubCategory(
        id: json['id'],
        name: json['name'],
        image: json['image'],
        categoryId: json['categoryId']
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id' : id,
      'name' : name,
      'image' : image,
      'categoryId' : categoryId
    };
  }
}