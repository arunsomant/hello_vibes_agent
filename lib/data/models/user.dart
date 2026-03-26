

import '../../core/utils/app_extensions.dart';
import 'avatar.dart';
import 'language.dart';
import 'response.dart';

class UsersResponse {
  final bool success;
  final List<User> users;

  const UsersResponse({this.success = false, this.users = const []});

  factory UsersResponse.fromMap(Map<String, dynamic> json) {
    return UsersResponse(
      users: (json['users'] as List).map((e) => User.fromMap(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'users': users.map((e) => e.toMap()).toList()};
  }
}

class UserResponse {
  final bool success;
  final User user;
  final String message;

  UserResponse({
    this.success = false,
    this.user = const User(),
    this.message = '',
  });

  factory UserResponse.fromMap(Map<String, dynamic> json) {
    bool success = json['success'] ?? false;
    String message = json['message'] ?? '';
    User userData = const User();

    if (json['data'] != null) {
      if (success && json['data']['user'] != null) {
        userData = User.fromMap(json['data']['user']);
      } else {
        message =
            '$message ${AppResponse.parseErrorResponse(json['data']).join(',')}';
      }
    }
    return UserResponse(success: success, user: userData, message: message);
  }

  Map<String, dynamic> toMap() => {
    'success': success,
    'data': {'user': user.toMap()},
    'message': message,
  };
}

class User {
  final int id;
  final int applicationId;
  final String name;
  final String email;
  final String dialCode;
  final String mobile;
  final String gender;
  final DateTime? dob;
  final int age;
  final String role;
  final bool isOnline;
  final ApprovalStatus approvalStatus;
  final int status;
  final List<Language> languages;
  final int walletBalance;
  final double walletBalanceInInr;
  final double lifetimeEarningsInInr;
  final double rating;
  final Avatar avatar;

  const User({
    this.id = 0,
    this.applicationId = 0,
    this.name = '',
    this.email = '',
    this.dialCode = '',
    this.mobile = '',
    this.gender = '',
    this.dob,
    this.age = 0,
    this.role = '',
    this.isOnline = false,
    this.approvalStatus = ApprovalStatus.pending,
    this.status = 0,
    this.languages = const [],
    this.walletBalance = 0,
    this.walletBalanceInInr = 0,
    this.lifetimeEarningsInInr = 0,
    this.rating = 0,
    this.avatar = const Avatar(),
  });

  factory User.fromMap(Map<String, dynamic> json) {
    final avatarId = json['avatar_id'] ?? 0;
    final avatarUrl = json['avatar_url'] ?? '';
    return User(
      id: json['id'] ?? 0,
      applicationId: json['application_id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      dialCode: json['dial_code'] ?? '',
      mobile: json['mobile'] ?? '',
      gender: json['gender'] ?? '',
      dob: DateTime.tryParse(json['dob'] ?? '')?.toLocal(),
      age: json['age'] ?? 0,
      avatar: Avatar(id: avatarId, url: avatarUrl),
      role: json['role'] ?? '',
      isOnline: json['is_online'] ?? false,
      approvalStatus: ApprovalStatus.values.fromJson(
        json['approval_status'] ?? '',
      ),
      status: json['status'] ?? 0,
      languages: json['languages'] != null
          ? List<Language>.from(
              json['languages'].map((x) => Language.fromMap(x)),
            )
          : const [],
      walletBalance: json['wallet_balance'] ?? 0,
      walletBalanceInInr:
          double.tryParse((json['wallet_balance_in_inr'] ?? '').toString()) ??
          0,
      lifetimeEarningsInInr:
          double.tryParse(
            (json['lifetime_earnings_in_inr'] ?? '').toString(),
          ) ??
          0,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'application_id': applicationId,
    'name': name,
    'email': email,
    'dial_code': dialCode,
    'mobile': mobile,
    'gender': gender,
    'dob': dob?.toUtc().toIso8601String(),
    'age': age,
    'role': role,
    'is_online': isOnline,
    'approval_status': approvalStatus,
    'status': status,
    'languages': List<Language>.from(languages.map((x) => x)),
    'wallet_balance': walletBalance,
    'wallet_balance_in_inr': walletBalanceInInr,
    'lifetime_earnings_in_inr': lifetimeEarningsInInr,
  };

  static List<String> avatars = [
    'https://i.ibb.co/6RRycvDy/avatar-1.png',
    'https://i.ibb.co/LzjQc6hG/avatar-2.png',
    'https://i.ibb.co/prnC3Y82/avatar-3.png',
    'https://i.ibb.co/7JLM00Cj/avatar-4.png',
  ];

  static List<User> users = [
    User(
      id: 1,
      avatar: Avatar(url: User.avatars[0]),
      name: 'Alivia',
      age: 26,
      gender: 'Female',
      rating: 4.9,
      isOnline: true,
    ),
    User(
      id: 2,
      avatar: Avatar(url: User.avatars[1]),
      name: 'Alexia Berger',
      age: 27,
      gender: 'Male',
      rating: 0,
    ),
    User(
      id: 3,
      avatar: Avatar(url: User.avatars[2]),
      name: 'Azalea Sampson',
      age: 24,
      gender: 'Female',
      rating: 3.9,
    ),
    User(
      id: 4,
      avatar: Avatar(url: User.avatars[0]),
      name: 'Alivia',
      age: 30,
      gender: 'Female',
      rating: 4.9,
    ),
    User(
      id: 5,
      avatar: Avatar(url: User.avatars[0]),
      name: 'Alivia',
      age: 26,
      gender: 'Female',
      rating: 4.9,
    ),
    User(
      id: 6,
      avatar: Avatar(url: User.avatars[1]),
      name: 'Alexia Berger',
      age: 27,
      gender: 'Male',
      rating: 0,
    ),
    User(
      id: 7,
      avatar: Avatar(url: User.avatars[2]),
      name: 'Azalea Sampson',
      age: 24,
      gender: 'Female',
      rating: 3.9,
    ),
    User(
      id: 8,
      avatar: Avatar(url: User.avatars[0]),
      name: 'Alivia',
      age: 30,
      gender: 'Female',
      rating: 4.9,
    ),
  ];

  User copyWith({
    int? id,
    int? applicationId,
    String? name,
    String? email,
    String? dialCode,
    String? mobile,
    String? gender,
    DateTime? dob,
    int? age,
    String? role,
    bool? isOnline,
    ApprovalStatus? approvalStatus,
    int? status,
    List<Language>? languages,
    int? walletBalance,
    double? walletBalanceInInr,
    dynamic lifetimeEarningsInInr,
    double? rating,
  }) {
    return User(
      id: id ?? this.id,
      applicationId: applicationId ?? this.applicationId,
      name: name ?? this.name,
      email: email ?? this.email,
      dialCode: dialCode ?? this.dialCode,
      mobile: mobile ?? this.mobile,
      gender: gender ?? this.gender,
      dob: dob ?? this.dob,
      age: age ?? this.age,
      role: role ?? this.role,
      isOnline: isOnline ?? this.isOnline,
      approvalStatus: approvalStatus ?? this.approvalStatus,
      status: status ?? this.status,
      languages: languages ?? this.languages,
      walletBalance: walletBalance ?? this.walletBalance,
      walletBalanceInInr: walletBalanceInInr ?? this.walletBalanceInInr,
      lifetimeEarningsInInr:
          lifetimeEarningsInInr ?? this.lifetimeEarningsInInr,
      rating: rating ?? this.rating,
    );
  }
}

enum ApprovalStatus implements JsonEnum {
  pending('pending'),
  rejected('rejected'),
  approved('approved');

  @override
  final String value;

  @override
  ApprovalStatus get defaultValue => ApprovalStatus.pending;

  const ApprovalStatus(this.value);
}
