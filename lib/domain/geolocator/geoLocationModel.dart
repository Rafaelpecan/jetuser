import 'dart:convert';

class Location {
  final double latitude;
  final double longitude;
  final String? address;

  Location({
    required this.latitude,
    required this.longitude,
    this.address,
  });

  /// ✅ Factory constructor to create a `Location` object from JSON response.
  factory Location.fromMapID(Map<String, dynamic> map) {
    final result = map['result'] ?? {};

    return Location(
      latitude: result['geometry']['location']['lat']?.toDouble() ?? 0.0,
      longitude: result['geometry']['location']['lng']?.toDouble() ?? 0.0,
      address: result['formatted_address'],
    );
  }

    factory Location.fromMap(Map<String, dynamic> map) {
    final results = map['results'] as List?;
    if (results == null || results.isEmpty) {
      return Location(latitude: 0.0, longitude: 0.0, address: "Unknown Location");
    }

    final geometry = results[0]['geometry']['location'];
    return Location(
      latitude: geometry['lat']?.toDouble() ?? 0.0,
      longitude: geometry['lng']?.toDouble() ?? 0.0,
      address: results[0]['formatted_address'],
    );
  }

  /// ✅ Convert Location object to a Map (useful for saving to Firebase)
  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
    };
  }

  /// ✅ Convert Location to JSON string
  String toJson() => json.encode(toMap());

  /// ✅ Create a Location object from a JSON string
  factory Location.fromJson(String source) => Location.fromMapID(json.decode(source));

  @override
  String toString() => 'Location(lat: $latitude, lng: $longitude, address: $address)';
}


