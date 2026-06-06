import '../datasources/transaction_remote_data_source.dart';
import '../models/bank_detail.dart';
import '../models/transaction.dart';

class TransactionRepository {
  final TransactionRemoteDataSource remoteDataSource;

  TransactionRepository({required this.remoteDataSource});

  Future<TransactionsResponse> getTransactions({
    required int nextPage,
    required String transactionType,
    required String fromDate,
    required String toDate,
  }) async {
    return await remoteDataSource.transactions(
      nextPage: nextPage,
      transactionType: transactionType,
      fromDate: fromDate,
      toDate: toDate,
    );
  }

  Future<BankDetailResponse> getBankDetails() async {
    return await remoteDataSource.getBankDetails();
  }

  Future<BankDetailResponse> updateBankDetails({
    required String name,
    required String bankName,
    required String accountNumber,
    required String ifsc,
  }) async {
    return await remoteDataSource.updateBankDetails(
      name: name,
      bankName: bankName,
      accountNumber: accountNumber,
      ifsc: ifsc,
    );
  }

  Future<BankDetailResponse> requestWithdrawal({required double coins}) async {
    return await remoteDataSource.requestWithdrawal(coins: coins);
  }
}
