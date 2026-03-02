class BaseResponseList<T> {
  final List<T> data;

  BaseResponseList({
    required this.data,
  });

  factory BaseResponseList.fromJson(
    Map<String, dynamic> json, {
    required T Function(dynamic x) func,
  }) {
    List<T> items = [];

    if (json['data'] != null && json['data'] is List) {
      items = (json['data'] as List).map((item) => func(item)).toList();
    }

    return BaseResponseList<T>(
      data: items,
    );
  }
}