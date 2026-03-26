import '../../core/utils/app_extensions.dart';
import 'response.dart';

class TransactionsResponse {
  final bool success;
  final PaginationResponse<Transaction> paginationResponse;
  final String message;

  TransactionsResponse({
    this.success = false,
    this.paginationResponse = const PaginationResponse(),
    this.message = '',
  });

  factory TransactionsResponse.fromMap(Map<String, dynamic> json) {
    bool success = json['success'] ?? false;
    String message = json['message'] ?? '';
    return TransactionsResponse(
      success: success,
      paginationResponse:
          json['data'] != null && json['data']['transactions'] != null
          ? PaginationResponse<Transaction>.fromMap(
              json['data'],
              json['data']['transactions'],
              Transaction.fromMap,
            )
          : const PaginationResponse(),
      message: message,
    );
  }

  Map<String, dynamic> toMap() => {
    'success': success,
    'data': {
      'transactions': paginationResponse.toMap((value) => value.toMap()),
    },
    'message': message,
  };
}

class Pagination {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  Pagination({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory Pagination.fromMap(Map<String, dynamic> json) => Pagination(
    currentPage: json['current_page'],
    lastPage: json['last_page'],
    perPage: json['per_page'],
    total: json['total'],
  );

  Map<String, dynamic> toMap() => {
    'current_page': currentPage,
    'last_page': lastPage,
    'per_page': perPage,
    'total': total,
  };
}

class Transaction {
  final int id;
  final TransactionType type;
  final TransactionRawType rawType;
  final TransactionDirection direction;
  final int coins;
  final int callId;
  final int callDurationSeconds;
  final String callDuration;
  final double amountInr;
  final int balanceBefore;
  final int balanceAfter;
  final TransactionStatus status;
  final String description;
  final DateTime? createdAt;

  const Transaction({
    this.id = 0,
    this.type = TransactionType.none,
    this.rawType = TransactionRawType.none,
    this.direction = TransactionDirection.none,
    this.coins = 0,
    this.callId = 0,
    this.callDurationSeconds = 0,
    this.callDuration = '',
    this.amountInr = 0,
    this.balanceBefore = 0,
    this.balanceAfter = 0,
    this.status = TransactionStatus.none,
    this.description = '',
    this.createdAt,
  });

  factory Transaction.fromMap(Map<String, dynamic> json) => Transaction(
    id: json['id'] ?? 0,
    type: TransactionType.values.fromJson(json['type']),
    rawType: TransactionRawType.values.fromJson(json['raw_type']),
    direction: TransactionDirection.values.fromJson(json['direction']),
    coins: json['coins'] ?? 0,
    callId: json['call_id'] ?? 0,
    callDurationSeconds: json['call_duration_seconds'] ?? 0,
    callDuration: json['call_duration'] ?? '',
    amountInr: double.tryParse((json['amount_inr'] ?? '').toString()) ?? 0,
    balanceBefore: json['balance_before'] ?? 0,
    balanceAfter: json['balance_after'] ?? 0,
    status: TransactionStatus.values.fromJson(json['status']),
    description: json['description'] ?? '',
    createdAt: DateTime.tryParse(json['created_at'] ?? '')?.toLocal(),
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'type': type,
    'raw_type': rawType,
    'direction': direction,
    'coins': coins,
    'call_id': callId,
    'call_duration_seconds': callDurationSeconds,
    'call_duration': callDuration,
    'amount_inr': amountInr,
    'balance_before': balanceBefore,
    'balance_after': balanceAfter,
    'status': status,
    'description': description,
    'created_at': createdAt?.toIso8601String(),
  };
}

enum TransactionRawType implements JsonEnum {
  none('none'),
  credit('credit'),
  debit('debit');

  @override
  final String value;

  @override
  TransactionRawType get defaultValue => TransactionRawType.none;

  const TransactionRawType(this.value);
}

enum TransactionDirection implements JsonEnum {
  none('none'),
  in_('in'),
  out('out');

  @override
  final String value;

  @override
  TransactionDirection get defaultValue => TransactionDirection.none;

  const TransactionDirection(this.value);
}

enum TransactionType implements JsonEnum {
  none('none'),
  voiceCall('call'),
  videoCall('videoCall'),
  withdrawal('withdrawal'),
  credit('credit'),
  refund('refund'),
  adjustment('adjustment');

  @override
  final String value;

  @override
  TransactionType get defaultValue => TransactionType.none;

  const TransactionType(this.value);
}

enum TransactionStatus implements JsonEnum {
  none('none'),
  pending('pending'),
  completed('completed');

  @override
  final String value;

  @override
  TransactionStatus get defaultValue => TransactionStatus.none;

  const TransactionStatus(this.value);
}
