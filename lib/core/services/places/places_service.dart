import 'package:flutter/material.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';

class PlacesService {
  static const String _apiKey =
      'SUA_API_KEY_AQUI'; // Substitua pela sua API key

  static Widget buildPlaceSearchField({
    required Function(Prediction) onPlaceSelected,
    required TextEditingController controller,
    String? hintText,
  }) {
    return GooglePlaceAutoCompleteTextField(
      textEditingController: controller,
      googleAPIKey: _apiKey,
      inputDecoration: InputDecoration(
        hintText: hintText ?? 'Digite um endereço',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      debounceTime: 800,
      countries: const ["br"],
      isLatLngRequired: true,
      getPlaceDetailWithLatLng: (Prediction prediction) {
        onPlaceSelected(prediction);
      },
    );
  }
}
