class ApiResponse<T> {
  final bool isSuccess;
  final String message;
  final T? data;
  final Map<String, List<String>>? errors;
  final int statusCode;
  final DateTime timestamp;
  final String? path;

  ApiResponse({
    required this.isSuccess,
    required this.message,
    this.data,
    this.errors,
    required this.statusCode,
    required this.timestamp,
    this.path,
  });

  factory ApiResponse.fromJson(
      Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJsonT) {
    return ApiResponse<T>(
      isSuccess: json['isSuccess'] as bool,
      message: json['message'] as String,
      data: json['data'] != null ? fromJsonT(json['data']) : null,
      errors: json['errors'] != null
          ? Map<String, List<String>>.from(
              (json['errors'] as Map<String, dynamic>).map(
                (key, value) => MapEntry(
                  key,
                  (value as List<dynamic>).map((e) => e.toString()).toList(),
                ),
              ),
            )
          : null,
      statusCode: json['statusCode'] as int,
      timestamp: DateTime.parse(json['timestamp'] as String),
      path: json['path'] as String?,
    );
  }

  Map<String, dynamic> toJson(Map<String, dynamic> Function(T) toJsonT) {
    return {
      'isSuccess': isSuccess,
      'message': message,
      'errors': errors,
      'data': data != null ? toJsonT(data!) : null,
      'statusCode': statusCode,
      'timestamp': timestamp.toIso8601String(),
      'path': path,
    };
  }
}
