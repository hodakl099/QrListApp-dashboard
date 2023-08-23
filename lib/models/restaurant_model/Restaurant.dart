class RestaurantApi {
  final String id;
  final String name;
  final String email;

  RestaurantApi
      ({
    required this.name,
    required this.email,
   required this.id,
  });

  RestaurantApi.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        email = json['email'];


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }
}
