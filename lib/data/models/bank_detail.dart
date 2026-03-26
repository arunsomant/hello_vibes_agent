class BankDetailResponse {
  final bool success;
  final BankDetail bankDetail;
  final String message;

  const BankDetailResponse({
    this.success = false,
    this.bankDetail = const BankDetail(),
    this.message = '',
  });

  factory BankDetailResponse.fromMap(Map<String, dynamic> json) =>
      BankDetailResponse(
        success: json['success'] ?? false,
        bankDetail: json['data'] != null
            ? BankDetail.fromMap(json['data'])
            : const BankDetail(),
        message: json['message'] ?? '',
      );

  Map<String, dynamic> toMap() => {
    'success': success,
    'data': bankDetail.toMap(),
    'message': message,
  };
}

class BankDetail {
  final int agentId;
  final String accountHolderName;
  final String bankName;
  final String accountNumber;
  final String ifscCode;
  final DateTime? updatedAt;
  final DateTime? createdAt;
  final int id;

  const BankDetail({
    this.agentId = 0,
    this.accountHolderName = '',
    this.bankName = '',
    this.accountNumber = '',
    this.ifscCode = '',
    this.updatedAt,
    this.createdAt,
    this.id = 0,
  });

  factory BankDetail.fromMap(Map<String, dynamic> json) => BankDetail(
    agentId: json['agent_id'] ?? 0,
    accountHolderName: json['account_holder_name'] ?? '',
    bankName: json['bank_name'] ?? '',
    accountNumber: json['account_number'] ?? '',
    ifscCode: json['ifsc_code'] ?? '',
    updatedAt: DateTime.tryParse(json['updated_at'] ?? '')?.toLocal(),
    createdAt: DateTime.tryParse(json['created_at'] ?? '')?.toLocal(),
    id: json['id'] ?? 0,
  );

  Map<String, dynamic> toMap() => {
    'agent_id': agentId,
    'account_holder_name': accountHolderName,
    'bank_name': bankName,
    'account_number': accountNumber,
    'ifsc_code': ifscCode,
    'updated_at': updatedAt?.toIso8601String(),
    'created_at': createdAt?.toIso8601String(),
    'id': id,
  };
}
