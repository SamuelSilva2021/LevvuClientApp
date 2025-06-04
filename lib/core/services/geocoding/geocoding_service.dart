import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GeocodingService {
  static const String _baseUrl = 'https://maps.googleapis.com/maps/api/place';
  static String get _apiKey => dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';

  static Future<List<Map<String, dynamic>>> searchAddress(String query) async {
    if (query.isEmpty) return [];

    final url = Uri.parse(
      '$_baseUrl/autocomplete/json?input=$query&key=$_apiKey&components=country:br&language=pt-BR',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK') {
          final predictions = data['predictions'] as List;
          final results = predictions.map((prediction) {
            return {
              'description': prediction['description'],
              'placeId': prediction['place_id'],
            };
          }).toList();
          return results;
        } else {
          print('❌ Status da API: ${data['status']}');
          print('❌ Mensagem de erro: ${data['error_message']}');
        }
      }
      return [];
    } catch (e, stackTrace) {
      print('❌ Erro ao buscar endereços: $e');
      print('📚 Stack trace: $stackTrace');
      return [];
    }
  }

  static Future<Map<String, dynamic>?> getPlaceDetails(String placeId) async {
    final url = Uri.parse(
      '$_baseUrl/details/json?place_id=$placeId&key=$_apiKey&language=pt-BR',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK') {
          final result = data['result'];
          final details = {
            'address': result['formatted_address'],
            'lat': result['geometry']['location']['lat'],
            'lng': result['geometry']['location']['lng'],
          };
          return details;
        } else {
          print('❌ Status da API: ${data['status']}');
          print('❌ Mensagem de erro: ${data['error_message']}');
        }
      }
      return null;
    } catch (e, stackTrace) {
      print('❌ Erro ao buscar detalhes do endereço: $e');
      print('📚 Stack trace: $stackTrace');
      return null;
    }
  }
}
