class ApiResponse<T> {
  final bool isSuccess;
  final String message;
  final T? data;

  ApiResponse({
    required this.isSuccess,
    required this.message,
    this.data,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json, T? Function(Map<String, dynamic>)? fromJson) {
    return ApiResponse(
      isSuccess: json['isSuccess'] ?? false,
      message: json['message'] ?? 'Ocorreu um erro desconhecido',
      data: json['data'] != null && fromJson != null ? fromJson(json['data']) : null,
    );
  }
}