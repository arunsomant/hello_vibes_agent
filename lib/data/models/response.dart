class AppResponse {
  final bool success;
  final String message;

  AppResponse({this.success = false, this.message = ''});

  factory AppResponse.fromMap(Map<String, dynamic> json) {
    bool success = json['success'] ?? false;
    String message = json['message'] ?? '';
    if (json['data'] != null) {
      if (!success) {
        message =
            '$message ${AppResponse.parseErrorResponse(json['data']).join(',')}';
      }
    }
    return AppResponse(success: success, message: message);
  }

  Map<String, dynamic> toMap() => {'success': success, 'message': message};

  static List<String> parseErrorResponse(dynamic json) {
    List<String> messages = [];
    if (json is Map<String, dynamic>) {
      json.forEach((key, value) {
        messages.addAll(parseErrorResponse(value));
      });
    } else if (json is List) {
      for (var item in json) {
        messages.addAll(parseErrorResponse(item));
      }
    } else {
      messages.add(json.toString());
    }
    return messages;
  }

  factory AppResponse.fromMapDeleteThread(Map<String, dynamic>? json) {
    if (json == null) {
      return AppResponse(success: true);
    }
    return AppResponse(message: json['message'] ?? '');
  }
}

class PaginationResponse<T> {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;
  final List<T> data;

  const PaginationResponse({
    this.currentPage = 0,
    this.lastPage = 0,
    this.perPage = 0,
    this.total = 0,
    this.data = const [],
  });

  factory PaginationResponse.fromMap(
    Map<String, dynamic> json,
    List<dynamic>? jsonX,
    T Function(Map<String, dynamic> json) fromMapT,
  ) {
      return  PaginationResponse<T>(
          data: jsonX != null
              ? List<T>.from(jsonX.map((x) => fromMapT(x)))
              : const [],
          currentPage: json['pagination']['current_page'] ?? 0,
          lastPage: json['pagination']['last_page'] ?? 0,
          perPage: json['pagination']['per_page'] ?? 0,
          total: json['pagination']['total'] ?? 0,
        );
  }

  Map<String, dynamic> toMap(Map<String, dynamic> Function(T value) toMapT) => {
    'current_page': currentPage,
    'data': List<dynamic>.from(data.map((x) => toMapT(x))),
    'last_page': lastPage,
    'per_page': perPage,
    'total': total,
  };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
