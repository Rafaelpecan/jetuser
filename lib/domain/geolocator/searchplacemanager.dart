
import 'package:dio/dio.dart';
import 'package:jetrideruser/domain/geolocator/geoLocationModel.dart';
import 'package:jetrideruser/domain/geolocator/searchplacemodel.dart';
const apiKey = 'AIzaSyAHT1K019X7zz2S6ckgVZWcnWsZoX_-VzE';

class SearchplaceManager {

  final String _inputText;
  SearchplaceManager(this._inputText);
  final Dio _dio = Dio();
  String url = '';
   List<SearchplaceModel> placePredictionsList = [];

  Future<List<SearchplaceModel>> findPlaceAutoCompleteSearch() async {
    if(_inputText.length > 1){
      url = "https://maps.googleapis.com/maps/api/place/autocomplete/json";
    }

    try {
      final response = await _dio.get<Map<String, dynamic>>(
        url,
        queryParameters: {
          'input': _inputText,
          'key': apiKey,
        },
      );
      if (response.statusCode == 200) {
        var placePredictions = response.data!['predictions'];
        placePredictionsList = (placePredictions as List).map((map) => SearchplaceModel.fromMap(map)).toList();
        return placePredictionsList;
      } else {
        return Future.error('Failed to fetch address. Status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        return Future.error('DioError: ${e.response?.data}');
      } else {
        return Future.error('DioError: ${e.message}');
      }
    }
  }

  Future<Location> findPlaceAById(String? placeId) async {

    url = "https://maps.googleapis.com/maps/api/place/details/json";

    try {
      final response = await _dio.get<Map<String, dynamic>>(
        url,
        queryParameters: {
          'place_id': placeId,
          'key': apiKey,
        },
      );
      if (response.statusCode == 200) {
        var newplace = response.data;
        Location newPlaceFinal = Location.fromMapID(newplace!);
        print(newplace);
        return newPlaceFinal;
      } else {
        return Future.error('Failed to fetch address. Status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        return Future.error('DioError: ${e.response?.data}');
      } else {
        return Future.error('DioError: ${e.message}');
      }
    }
  }   
}