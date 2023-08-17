class CommercialPropertyApi {
  final String? id;
  final String agentContact;
  final int price;
  final String location;
  final String propertyType;
  final int acres;
  final String trafficCount;
  final String zoningInfo;
  final String amenities;
  final List<dynamic> images;
  final List<dynamic> videos;

  CommercialPropertyApi( {
    this.id,
    required this.trafficCount,
    required this.zoningInfo,
    required this.amenities,
    required this.propertyType,
    required this.agentContact,
    required this.price,
    required this.acres,
    required this.location,
    required this.images,
    required this.videos,
  });

  CommercialPropertyApi.fromJson(Map<String, dynamic> json)
      : id = (json['property']['id'] as int).toString(),
        propertyType = json['propertyType'],
        agentContact = json['property']['agentContact'],
        price = (json['property']['price'] as int).toInt(),
        acres = (json['acres'] as int).toInt(),
        trafficCount = json['trafficCount'],
        zoningInfo = json['zoningInfo'],
        amenities = json['amenities'],
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
      'trafficCount': trafficCount,
      'zoningInfo': zoningInfo,
      'amenities': amenities,
      'location': location,
      'images': images,
      'videos': videos,
    };
  }
}
