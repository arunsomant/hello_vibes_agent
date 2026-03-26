class LanguagesResponse {
  final bool success;
  final List<Language> languages;
  final String message;

  const LanguagesResponse({
    this.success = false,
    this.languages = const [],
    this.message = '',
  });

  factory LanguagesResponse.fromMap(Map<String, dynamic> json) {
    bool success = json['success'] ?? false;
    String message = json['message'] ?? '';
    return LanguagesResponse(
      success: success,
      languages: json['data'] != null
          ? List<Language>.from(json['data'].map((x) => Language.fromMap(x)))
          : const [],
      message: message,
    );
  }

  Map<String, dynamic> toMap() => {
    'success': success,
    'data': List<dynamic>.from(languages.map((x) => x.toMap())),
    'message': message,
  };
}

class Language {
  final int id;
  final String name;
  final String displayName;
  final String shortDisplayName;

  const Language({
    this.id = 0,
    this.name = '',
    this.displayName = '',
    this.shortDisplayName = '',
  });

  factory Language.fromMap(Map<String, dynamic> json) => Language(
    id: json['id'] ?? 0,
    name: json['name'] ?? '',
    displayName: json['display_name'] ?? '',
    shortDisplayName: json['short_display_name'] ?? '',
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'display_name': displayName,
    'short_display_name': shortDisplayName,
  };

  @override
  operator ==(Object other) =>
      identical(this, other) ||
      other is Language && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id;
}
