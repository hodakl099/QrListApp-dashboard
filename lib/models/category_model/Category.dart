class CategoryApi {
  final int? id;
  final String name;
  final String objectName;
  final dynamic image;

  CategoryApi
      ({
    required this.name, required this.image,
    this.id, required this.objectName

  });

  CategoryApi.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        objectName = json['objectName'],
        image = json['imageUrl'];


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imageUrl': image,
      'objectName' : objectName
    };
  }
}
