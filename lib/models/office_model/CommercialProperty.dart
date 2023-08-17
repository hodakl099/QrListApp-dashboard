class OfficePropertyApi {
  final String? id;
  final String agentContact;
  final int price;
  final String location;
  final String layoutType;
  final int acres;
  final int floorNumber;
  final String amenities;
  final String accessibility;
  final String propertyType;
  final List<dynamic> images;
  final List<dynamic> videos;

  OfficePropertyApi({
    this.id,
    required this.agentContact,
    required this.price,
    required this.location,
    required this.layoutType,
    required this.acres,
    required this.floorNumber,
    required this.propertyType,
    required this.amenities,
    required this.accessibility,
    required this.images,
    required this.videos,
  });

  OfficePropertyApi.fromJson(Map<String, dynamic> json)
      : id = (json['property']['id'] as int).toString(),
        agentContact = json['property']['agentContact'],
        price = (json['property']['price'] as int).toInt(),
        location = json['property']['location'],
        acres = (json['acres'] as int).toInt(),
        floorNumber = (json['floorNumber'] as int).toInt(),
        amenities = json['amenities'],
        propertyType = json['propertyType'],
        layoutType = json['layoutType'],
        accessibility = json['accessibility'],
        images = json['property']['images'],
        videos = json['property']['videos'];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'agentContact': agentContact,
      'price': price,
      'location': location,
      'layoutType': layoutType,
      'acres': acres,
      'propertyType': propertyType,
      'floorNumber': floorNumber,
      'amenities': amenities,
      'accessibility': accessibility,
    };
  }
}
