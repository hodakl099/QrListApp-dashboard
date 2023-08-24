class CategoryApi {
  final int? id;
  final String name;
  final dynamic image;

  CategoryApi
      ({
    required this.name, required this.image,
    this.id,

  });

  CategoryApi.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        image = json['imageUrl'];


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imageUrl': image,
    };
  }
}
