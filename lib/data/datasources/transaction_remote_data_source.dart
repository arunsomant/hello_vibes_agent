import '../../core/network/api_base_helper.dart';
import '../../core/network/api_endpoints.dart';
import '../models/bank_detail.dart';
import '../models/transaction.dart';

class TransactionRemoteDataSource {
  TransactionRemoteDataSource({required this.apiHelper});

  final ApiBaseHelper apiHelper;

  Future<TransactionsResponse> transactions() async {
    final response = await apiHelper.get(ApiEndpoints.transactions);
    print(response);
    return TransactionsResponse.fromMap(response);
  }

  Future<BankDetailResponse> getBankDetails() async {
    final response = await apiHelper.get(ApiEndpoints.bankDetails);
    return BankDetailResponse.fromMap(response);
  }

  Future<BankDetailResponse> updateBankDetails({
    required String name,
    required String bankName,
    required String accountNumber,
    required String ifsc,
  }) async {
    final body = {
      'account_holder_name': name,
      'bank_name': bankName,
      'account_number': accountNumber,
      'ifsc_code': ifsc,
    };
    final response = await apiHelper.post(ApiEndpoints.bankDetails, body: body);
    return BankDetailResponse.fromMap(response);
  }

  Future<BankDetailResponse> requestWithdrawal({required int coins}) async {
    final body = {'coins': coins, 'confirm': true};
    final response = await apiHelper.post(
      ApiEndpoints.requestWithdrawal,
      body: body,
    );
    return BankDetailResponse.fromMap(response);
  }
}
