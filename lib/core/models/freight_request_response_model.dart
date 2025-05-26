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
  final List<String> photoUrls;

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
    required this.photoUrls,
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
      pickupTime: json['pickupTime'] != null ? _parseTimeFromJson(json['pickupTime']) : null,
      photoUrls: List<String>.from(json['photoUrls']),
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
}