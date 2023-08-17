class IndustrialPropertyApi {
  final String? id;
  final String agentContact;
  final int price;
  final String location;
  final String propertyType;
  final int acres;
  final String zoningInfo;
  final int cellingHeight;
  final int numberOfLoadingDocks;
  final String powerCapabilities;
  final String accessToTransportation;
  final String environmentalReports;
  final List<dynamic> images;
  final List<dynamic> videos;

  IndustrialPropertyApi({
    this.id,
    required this.agentContact,
    required this.price,
    required this.location,
    required this.propertyType,
    required this.acres,
    required this.zoningInfo,
    required this.cellingHeight,
    required this.numberOfLoadingDocks,
    required this.powerCapabilities,
    required this.accessToTransportation,
    required this.environmentalReports,
    required this.images,
    required this.videos,
  });

  IndustrialPropertyApi.fromJson(Map<String, dynamic> json)
      : id = (json['property']['id'] as int).toString(),
        agentContact = json['property']['agentContact'],
        price = (json['property']['price'] as int).toInt(),
        location = json['property']['location'],
        propertyType = json['propertyType'],
        acres = (json['acres'] as int).toInt(),
        zoningInfo = json['zoningInfo'],
        cellingHeight = (json['cellingHeight'] as int).toInt(),
        numberOfLoadingDocks = (json['numberOfLoadingDocks'] as int).toInt(),
        powerCapabilities = json['powerCapabilities'],
        accessToTransportation = json['accessToTransportation'],
        environmentalReports = json['environmentalReports'],
        images = json['property']['images'],
        videos = json['property']['videos'];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'agentContact': agentContact,
      'price': price,
      'location': location,
      'propertyType': propertyType,
      'acres': acres,
      'zoningInfo': zoningInfo,
      'cellingHeight': cellingHeight,
      'numberOfLoadingDocks': numberOfLoadingDocks,
      'powerCapabilities': powerCapabilities,
      'accessToTransportation': accessToTransportation,
      'environmentalReports': environmentalReports,
      'images': images,
      'videos': videos,
    };
  }
}
