import 'package:dio/dio.dart';
import 'package:jetrideruser/domain/geolocator/geoLocationModel.dart';
const apiKey = 'AIzaSyAHT1K019X7zz2S6ckgVZWcnWsZoX_-VzE';

class GeoCodeManager {
  final Dio _dio = Dio();

  Future<Location> fetchAddress({required double lat, required double long}) async {
    const String url = 'https://maps.googleapis.com/maps/api/geocode/json';

    try {
      // Make the GET request
      final response = await _dio.get<Map<String, dynamic>>(
        url,
        queryParameters: {
          'latlng': '$lat,$long',
          'key': apiKey,
        },
      );

      if (response.statusCode == 200) {
        final Location location = Location.fromMap(response.data!);
        return location;
      } else {
        return Future.error('Failed to fetch address. Status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      // Handle Dio errors
      if (e.response != null) {
        return Future.error('DioError: ${e.response?.data}');
      } else {
        return Future.error('DioError: ${e.message}');
      }
    }
  }
}


