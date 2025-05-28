import 'package:flutter/material.dart';

class FreightRequestResponse {
  final int id;
  final String clientId;
  final String status;
  final String proposalStatus;
  final DateTime createdAt;
  final String pickupAddress;
  final String deliveryAddress;
  final String serviceType;
  final DateTime withdrawalDate;
  final TimeOfDay? pickupTime;
  final String? itemDescription;
  final bool? helpLoading;
  final bool? disassemblyAssembly;
  final bool? specialPackaging;
  final String? observations;
  final List<String>? photoUrls;
  final int? partnerId;
  final double? agreedValue;

  FreightRequestResponse({
    required this.id,
    required this.clientId,
    required this.status,
    required this.proposalStatus,
    required this.createdAt,
    required this.pickupAddress,
    required this.deliveryAddress,
    required this.serviceType,
    required this.withdrawalDate,
    this.pickupTime,
    this.itemDescription,
    this.helpLoading,
    this.disassemblyAssembly,
    this.specialPackaging,
    this.observations,
    this.photoUrls,
    this.partnerId,
    this.agreedValue,
  });

  factory FreightRequestResponse.fromJson(Map<String, dynamic> json) {
    return FreightRequestResponse(
      id: json['id'],
      clientId: json['clientId'],
      status: json['status'],
      proposalStatus: json['proposalStatus'],
      createdAt: DateTime.parse(json['createdAt']),
      pickupAddress: json['pickupAddress'],
      deliveryAddress: json['deliveryAddress'],
      serviceType: json['serviceType'],
      withdrawalDate: DateTime.parse(json['withdrawalDate']),
      pickupTime: json['pickupTime'] != null
          ? _parseTimeFromJson(json['pickupTime'])
          : null,
      itemDescription: json['itemDescription'],
      helpLoading: json['helpLoading'],
      disassemblyAssembly: json['disassemblyAssembly'],
      specialPackaging: json['specialPackaging'],
      observations: json['observations'],
      photoUrls: json['photoUrls'] != null
          ? List<String>.from(json['photoUrls'])
          : null,
      partnerId: json['partnerId'],
      agreedValue: json['agreedValue']?.toDouble(),
    );
  }

  static TimeOfDay _parseTimeFromJson(String timeString) {
    try {
      final parts = timeString.split(':');
      if (parts.length >= 2) {
        return TimeOfDay(
          hour: int.parse(parts[0]),
          minute: int.parse(parts[1]),
        );
      }
      return const TimeOfDay(hour: 0, minute: 0);
    } catch (e) {
      return const TimeOfDay(hour: 0, minute: 0);
    }
  }

  String get pickupTimeFormatted {
    return '${pickupTime?.hour.toString().padLeft(2, '0')}:${pickupTime?.minute.toString().padLeft(2, '0')}';
  }

  String get agreedValueFormatted {
    if (agreedValue == null) return 'R\$ --,--';
    return 'R\$ ${agreedValue!.toStringAsFixed(2).replaceAll('.', ',')}';
  }
}
