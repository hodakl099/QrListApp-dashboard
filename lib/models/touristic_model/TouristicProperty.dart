class TouristicPropertyApi {
  final String? id;
  final String propertyType;
  final String agentContact;
  final int price;
  final int acres;
  final int rooms;
  final int units;
  final String amenities;
  final String proximityToAttractions;
  final String occupancyRate;
  final String location;
  final List<dynamic> images;
  final List<dynamic> videos;

  TouristicPropertyApi({
     this.id,
    required this.propertyType,
    required this.agentContact,
    required this.price,
    required this.acres,
    required this.rooms,
    required this.units,
    required this.amenities,
    required this.proximityToAttractions,
    required this.occupancyRate,
    required this.location,
    required this.images,
    required this.videos,
  });

  TouristicPropertyApi.fromJson(Map<String, dynamic> json)
      : id = (json['property']['id'] as int).toString(),
        propertyType = json['propertyType'],
        agentContact = json['property']['agentContact'],
        price = (json['property']['price'] as int).toInt(),
        acres = (json['acres'] as int).toInt(),
        rooms = json['rooms'],
        units = json['units'],
        amenities = json['amenities'],
        proximityToAttractions = json['proximityToAttractions'],
        occupancyRate = json['occupancyRate'],
        location = json['property']['location'],
        images = json['property']['images'],
        videos = json['property']['videos'];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'propertyType': propertyType,
      'agentContact': agentContact,
      'price': price,
      'acres': acres,
      'rooms': rooms,
      'units': units,
      'amenities': amenities,
      'proximityToAttractions': proximityToAttractions,
      'occupancyRate': occupancyRate,
      'location': location,
      'images': images,
      'videos': videos,
    };
  }
}
