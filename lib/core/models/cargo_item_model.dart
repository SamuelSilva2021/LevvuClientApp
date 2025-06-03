class CargoItemModel {
  final String name;
  final String description;
  final int quantity;
  final double unitWeight;
  final double unitVolume;
  final double length;
  final double width;
  final double height;
  final bool isFragile;
  final bool requiresRefrigeration;
  final bool hazardousMaterial;

  CargoItemModel({
    required this.name,
    required this.description,
    required this.quantity,
    required this.unitWeight,
    required this.unitVolume,
    required this.length,
    required this.width,
    required this.height,
    required this.isFragile,
    required this.requiresRefrigeration,
    required this.hazardousMaterial,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'quantity': quantity,
      'unitWeight': unitWeight,
      'unitVolume': unitVolume,
      'length': length,
      'width': width,
      'height': height,
      'isFragile': isFragile,
      'requiresRefrigeration': requiresRefrigeration,
      'hazardousMaterial': hazardousMaterial,
    };
  }

  factory CargoItemModel.fromJson(Map<String, dynamic> json) {
    return CargoItemModel(
      name: json['name'] as String,
      description: json['description'] as String,
      quantity: json['quantity'] as int,
      unitWeight: (json['unitWeight'] as num).toDouble(),
      unitVolume: (json['unitVolume'] as num).toDouble(),
      length: (json['length'] as num).toDouble(),
      width: (json['width'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
      isFragile: json['isFragile'] as bool,
      requiresRefrigeration: json['requiresRefrigeration'] as bool,
      hazardousMaterial: json['hazardousMaterial'] as bool,
    );
  }
}
