class CategoryApi {
  final String? id;
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
       image = json['image'];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
    };
  }
}
