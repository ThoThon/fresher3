class BaseResponse<T> {
  final T? data;

  BaseResponse({
    this.data,
  });

  factory BaseResponse.fromJson(
    Map<String, dynamic> json, {
    T Function(dynamic x)? func,
  }) {
    return BaseResponse<T>(
      data: json['data'] != null
          ? (func != null ? func(json['data']) : json['data'] as T?)
          : null,
    );
  }
}