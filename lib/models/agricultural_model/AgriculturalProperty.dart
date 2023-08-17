class AgriculturalPropertyApi {
  final String? id;
  final String propertyType;
  final String agentContact;
  final int price;
  final int acres;
  final String buildings;
  final String crops;
  final String waterSources;
  final String soilType;
  final String location;
  final String equipment;
  final List<dynamic> images;
  final List<dynamic> videos;

  AgriculturalPropertyApi({
     this.id,
    required this.propertyType,
    required this.agentContact,
    required this.price,
    required this.acres,
    required this.buildings,
    required this.crops,
    required this.waterSources,
    required this.soilType,
    required this.equipment,
    required this.location,
    required this.images,
    required this.videos,
  });

  AgriculturalPropertyApi.fromJson(Map<String, dynamic> json)
      : id = (json['property']['id'] as int).toString(),
        propertyType = json['propertyType'],
        agentContact = json['property']['agentContact'],
        price = (json['property']['price'] as int).toInt(),
        acres = (json['acres'] as int).toInt(),
        buildings = json['buildings'],
        crops = json['crops'],
        waterSources = json['waterSources'],
        soilType = json['soilType'],
        equipment = json['equipment'],
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
      'buildings': buildings,
      'crops': crops,
      'waterSources': waterSources,
      'soilType': soilType,
      'equipment': equipment,
      'location': location,
      'images': images,
      'videos': videos,
    };
  }
}
