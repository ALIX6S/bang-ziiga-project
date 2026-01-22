/// Wrapper générique pour les réponses API
class ApiResponse<T> {
  final bool success;
  final String? message;
  final T? data;
  final dynamic error;

  ApiResponse({
    required this.success,
    this.message,
    this.data,
    this.error,
  });

  /// Réponse réussie
  factory ApiResponse.success({T? data, String? message}) {
    return ApiResponse<T>(
      success: true,
      data: data,
      message: message,
    );
  }

  /// Réponse d'erreur
  factory ApiResponse.error({required String message, dynamic error}) {
    return ApiResponse<T>(
      success: false,
      message: message,
      error: error,
    );
  }

  /// Parsing depuis JSON
  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? fromJsonT,
  ) {
    return ApiResponse<T>(
      success: json['success'] ?? json['status'] == 'success',
      message: json['message'],
      data: json['data'] != null && fromJsonT != null
          ? fromJsonT(json['data'])
          : json['data'],
      error: json['error'],
    );
  }
}