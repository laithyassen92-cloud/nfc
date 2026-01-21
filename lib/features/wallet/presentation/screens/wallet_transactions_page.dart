import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../cubits/wallet_cubit.dart';
import '../../domain/models/wallet_transaction.dart';
import '../widgets/refund_dialog.dart';

class WalletTransactionsPage extends StatefulWidget {
  final String studentNumber;
  final String studentName;

  const WalletTransactionsPage({
    Key? key,
    required this.studentNumber,
    required this.studentName,
  }) : super(key: key);

  @override
  State<WalletTransactionsPage> createState() => _WalletTransactionsPageState();
}

class _WalletTransactionsPageState extends State<WalletTransactionsPage> {
  @override
  void initState() {
    super.initState();
    // Load transactions when page opens
    context.read<WalletCubit>().getTransactions(widget.studentNumber);
  }

  void _showRefundDialog(WalletTransaction transaction) {
    showDialog(
      context: context,
      builder: (context) => RefundDialog(
        studentNumber: widget.studentNumber,
        transaction: transaction,
        onConfirm: (request) {
          context.read<WalletCubit>().refund(request);
        },
      ),
    );
  }

  Color _getTransactionColor(String type) {
    switch (type.toLowerCase()) {
      case 'deposit':
        return Colors.green;
      case 'withdraw':
        return Colors.red;
      case 'refund':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  IconData _getTransactionIcon(String type) {
    switch (type.toLowerCase()) {
      case 'deposit':
        return Icons.arrow_downward;
      case 'withdraw':
        return Icons.arrow_upward;
      case 'refund':
        return Icons.replay;
      default:
        return Icons.monetization_on;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('سجل العمليات'),
            Text(
              widget.studentName,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<WalletCubit, WalletState>(
        listener: (context, state) {
          if (state is WalletTransactionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تمت معالجة الاسترداد بنجاح'),
                backgroundColor: Colors.green,
              ),
            );
            // Reload transactions to show the new refund
            context.read<WalletCubit>().getTransactions(widget.studentNumber);
          } else if (state is WalletError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.failure.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is WalletLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TransactionHistoryLoaded) {
            if (state.transactions.isEmpty) {
              return const Center(child: Text('لا توجد عمليات حالياً'));
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.transactions.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final transaction = state.transactions[index];
                final isRefundable =
                    transaction.isDeposit; // Only allow refunding deposits

                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: _getTransactionColor(
                      transaction.transactionType,
                    ).withOpacity(0.1),
                    child: Icon(
                      _getTransactionIcon(transaction.transactionType),
                      color: _getTransactionColor(transaction.transactionType),
                    ),
                  ),
                  title: Text(
                    transaction.transactionType,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat(
                          'yyyy-MM-dd HH:mm',
                        ).format(transaction.transactionDate),
                      ),
                      if (transaction.purpose != null)
                        Text(
                          transaction.purpose!,
                          style: const TextStyle(fontSize: 12),
                        ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${transaction.amount.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: _getTransactionColor(
                            transaction.transactionType,
                          ),
                        ),
                      ),
                      if (isRefundable) ...[
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(
                            Icons.replay_circle_filled,
                            color: Colors.orange,
                          ),
                          tooltip: 'استرداد',
                          onPressed: () => _showRefundDialog(transaction),
                        ),
                      ],
                    ],
                  ),
                );
              },
            );
          }
          return const Center(child: Text('ابدأ بتحميل سجل العمليات'));
        },
      ),
    );
  }
}
