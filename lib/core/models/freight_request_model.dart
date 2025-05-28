class FreightRequestModel {
  final String pickupAddress;
  final String deliveryAddress;
  final String serviceType;
  final DateTime withdrawalDate;
  final String pickupTime;
  final String itemDescription;
  final bool helpLoading;
  final bool disassemblyAssembly;
  final bool specialPackaging;
  final String observations;
  final List<String> photoUrls;

  FreightRequestModel({
    required this.pickupAddress,
    required this.deliveryAddress,
    required this.serviceType,
    required this.withdrawalDate,
    required this.pickupTime,
    required this.itemDescription,
    this.helpLoading = false,
    this.disassemblyAssembly = false,
    this.specialPackaging = false,
    this.observations = '',
    this.photoUrls = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'pickupAddress': pickupAddress,
      'deliveryAddress': deliveryAddress,
      'serviceType': serviceType,
      'withdrawalDate': withdrawalDate.toIso8601String(),
      'pickupTime': pickupTime,
      'itemDescription': itemDescription,
      'helpLoading': helpLoading,
      'disassemblyAssembly': disassemblyAssembly,
      'specialPackaging': specialPackaging,
      'observations': observations,
      'photoUrls': photoUrls,
    };
  }
}
