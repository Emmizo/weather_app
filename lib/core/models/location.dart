class Location {
  final double latitude;
  final double longitude;
  final String name;

  Location({
    required this.latitude,
    required this.longitude,
    required this.name,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('results')) {
      final result = json['results'][0];
      return Location(
        latitude: result['latitude'],
        longitude: result['longitude'],
        name: result['name'],
      );
    } else {
      return Location(
        latitude: json['latitude'],
        longitude: json['longitude'],
        name: json['name'],
      );
    }
  }

  Map<String, dynamic> toJson() => {
    'latitude': latitude,
    'longitude': longitude,
    'name': name,
  };
}
