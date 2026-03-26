class AvatarsResponse {
  final bool success;
  final List<Avatar> avatars;
  final String message;

  const AvatarsResponse({
    this.success = false,
    this.avatars = const [],
    this.message = '',
  });

  factory AvatarsResponse.fromMap(Map<String, dynamic> json) {
    bool success = json['success'] ?? false;
    String message = json['message'] ?? '';
    return AvatarsResponse(
      success: success,
      avatars: json['data'] != null
          ? List<Avatar>.from(json['data'].map((x) => Avatar.fromMap(x)))
          : const [],
      message: message,
    );
  }

  Map<String, dynamic> toMap() => {
    'success': success,
    'data': List<dynamic>.from(avatars.map((x) => x.toMap())),
    'message': message,
  };
}

class Avatar {
  final int id;
  final String url;

  const Avatar({this.id = 0, this.url = ''});

  factory Avatar.fromMap(Map<String, dynamic> json) =>
      Avatar(id: json['id'] ?? 0, url: json['url'] ?? '');

  Map<String, dynamic> toMap() => {'id': id, 'url': url};

  @override
  operator ==(Object other) =>
      identical(this, other) ||
      other is Avatar && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id;
}
