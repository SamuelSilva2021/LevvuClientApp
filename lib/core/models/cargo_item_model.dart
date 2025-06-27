class CargoItemModel {
  final String description;
  final double weight;
  final double volume;
  final int quantity;

  CargoItemModel({
    required this.description,
    required this.weight,
    required this.volume,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'weight': weight,
      'volume': volume,
      'quantity': quantity,
    };
  }

  factory CargoItemModel.fromJson(Map<String, dynamic> json) {
    return CargoItemModel(
      description: json['description'] as String,
      weight: json['weight'] as double,
      volume: json['volume'] as double,
      quantity: json['quantity'] as int,
    );
  }
}
