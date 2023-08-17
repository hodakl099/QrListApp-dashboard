class ResidentialPropertyApi {
  final String? id;
  final String agentContact;
  final String propertyType;
  final int price;
  final String location;
  final int acres;
  final int bedrooms;
  final int bathrooms;
  final String amenities;
  final String parking;
  final List<dynamic> images;
  final List<dynamic> videos;

  ResidentialPropertyApi({
    this.id,
    required this.agentContact,
    required this.price,
    required this.location,
    required this.acres,
    required this.bedrooms,
    required this.bathrooms,
    required this.propertyType,
    required this.amenities,
    required this.parking,
    required this.images,
    required this.videos,
  });

  ResidentialPropertyApi.fromJson(Map<String, dynamic> json)
      : id = (json['property']['id'] as int).toString(),
        agentContact = json['property']['agentContact'],
        price = (json['property']['price'] as int).toInt(),
        location = json['property']['location'],
        acres = (json['acres'] as int).toInt(),
        bedrooms = (json['bedrooms'] as int).toInt(),
        bathrooms = (json['bathrooms'] as int).toInt(),
        amenities = json['amenities'],
        propertyType = json['propertyType'],
        parking = json['parking'],
        images = json['property']['images'],
        videos = json['property']['videos'];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'agentContact': agentContact,
      'price': price,
      'location': location,
      'acres': acres,
      'propertyType': propertyType,
      'bedrooms': bedrooms,
      'bathrooms': bathrooms,
      'amenities': amenities,
      'parking': parking,
    };
  }
}
