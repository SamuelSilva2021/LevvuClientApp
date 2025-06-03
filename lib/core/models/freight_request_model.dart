import 'package:levvu_client/core/models/cargo_item_model.dart';

enum VehicleType {
  van,
  truck,
  refrigeratedTruck,
  specialVehicle,
}

class FreightRequestModel {
  final String pickupAddress;
  final String deliveryAddress;
  final VehicleType vehicleType;
  final String serviceType;
  final String description;
  final String cargoType;
  final double weight;
  final double volume;
  final DateTime withdrawalDate;
  final String pickupTime;
  final bool helpLoading;
  final bool disassemblyAssembly;
  final bool specialPackaging;
  final String itemDescription;
  final String observations;
  final List<String> photoUrls;
  final List<String> imageUrls;
  final List<CargoItemModel> cargoItems;

  FreightRequestModel({
    required this.pickupAddress,
    required this.deliveryAddress,
    required this.vehicleType,
    required this.serviceType,
    required this.description,
    required this.cargoType,
    required this.weight,
    required this.volume,
    required this.withdrawalDate,
    required this.pickupTime,
    required this.helpLoading,
    required this.disassemblyAssembly,
    required this.specialPackaging,
    required this.itemDescription,
    required this.observations,
    required this.photoUrls,
    required this.imageUrls,
    required this.cargoItems,
  });

  Map<String, dynamic> toJson() {
    return {
      'pickupAddress': pickupAddress,
      'deliveryAddress': deliveryAddress,
      'vehicleType': vehicleType.name,
      'serviceType': serviceType,
      'description': description,
      'cargoType': cargoType,
      'weight': weight,
      'volume': volume,
      'withdrawalDate': withdrawalDate.toIso8601String(),
      'pickupTime': pickupTime,
      'helpLoading': helpLoading,
      'disassemblyAssembly': disassemblyAssembly,
      'specialPackaging': specialPackaging,
      'itemDescription': itemDescription,
      'observations': observations,
      'photoUrls': photoUrls,
      'imageUrls': imageUrls,
      'cargoItems': cargoItems.map((item) => item.toJson()).toList(),
    };
  }

  factory FreightRequestModel.fromJson(Map<String, dynamic> json) {
    return FreightRequestModel(
      pickupAddress: json['pickupAddress'] as String,
      deliveryAddress: json['deliveryAddress'] as String,
      vehicleType: VehicleType.values.firstWhere(
        (type) => type.name == json['vehicleType'],
        orElse: () => VehicleType.van,
      ),
      serviceType: json['serviceType'] as String,
      description: json['description'] as String,
      cargoType: json['cargoType'] as String,
      weight: (json['weight'] as num).toDouble(),
      volume: (json['volume'] as num).toDouble(),
      withdrawalDate: DateTime.parse(json['withdrawalDate'] as String),
      pickupTime: json['pickupTime'] as String,
      helpLoading: json['helpLoading'] as bool,
      disassemblyAssembly: json['disassemblyAssembly'] as bool,
      specialPackaging: json['specialPackaging'] as bool,
      itemDescription: json['itemDescription'] as String,
      observations: json['observations'] as String,
      photoUrls:
          (json['photoUrls'] as List<dynamic>).map((e) => e as String).toList(),
      imageUrls:
          (json['imageUrls'] as List<dynamic>).map((e) => e as String).toList(),
      cargoItems: (json['cargoItems'] as List<dynamic>)
          .map((item) => CargoItemModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
