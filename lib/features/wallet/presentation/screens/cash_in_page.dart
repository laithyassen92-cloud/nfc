// lib/screens/cash_in_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/logger.dart';
import '../../domain/models/student_wallet.dart';
import '../../domain/models/wallet_transaction.dart';
import '../../domain/requests/deposit_transaction_request.dart';
import '../cubits/wallet_cubit.dart';
import '../widgets/amount_display_widget.dart';
import '../widgets/numeric_keypad_widget.dart';
import '../../../../services/nfc_service.dart';

class CashInPage extends StatefulWidget {
  const CashInPage({super.key});

  @override
  State<CashInPage> createState() => _CashInPageState();
}

class _CashInPageState extends State<CashInPage> {
  final NfcService _nfcService = NfcService();

  String _amount = '';
  // Mapping NFC UIDs to studentNumbers locally (Mock)
  final Map<String, String> _nfcToStudentMapping = {
    '04:A1:B2:C3': '001004', // Example UID
    '04:DE:AD:BE': '001005',
    '73:52:16:03': '001006',
  };

  StudentWallet? _resolvedWallet;
  String? _cardUid;
  String? _studentNumber;
  String? _errorMessage;
  String? _successMessage;

  @override
  void initState() {
    super.initState();
    // Default: don't auto-scan, let user trigger it
  }

  @override
  void dispose() {
    _nfcService.cancelScan();
    super.dispose();
  }

  Future<void> _startNfcScan() async {
    setState(() {
      _errorMessage = null;
      _successMessage = null;
    });

    try {
      final result = await _nfcService.scanTag();
      if (result != null) {
        final uid = result.tag.id;
        final studentNumber = _nfcToStudentMapping[uid];

        setState(() {
          _cardUid = uid;
          _studentNumber = studentNumber;
        });

        if (studentNumber != null) {
          if (!mounted) return;
          context.read<WalletCubit>().getWalletDetails(studentNumber);
        } else {
          setState(() {
            _errorMessage = 'البطاقة غير مسجلة في النظام';
          });
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'فشل في قراءة البطاقة: $e';
      });
      AppLogger.error('خطأ NFC: $e');
    }
  }

  void _onAmountChanged(String amount) {
    setState(() {
      _amount = amount;
      _errorMessage = null;
      _successMessage = null;
    });
  }

  double get _parsedAmount {
    if (_amount.isEmpty) return 0;
    return double.tryParse(_amount) ?? 0;
  }

  bool get _canProcess {
    return _studentNumber != null &&
        _parsedAmount > 0 &&
        _resolvedWallet != null;
  }

  Future<void> _processCashIn() async {
    if (!_canProcess) return;

    final request = DepositTransactionRequest(
      studentNumber: _studentNumber!,
      amount: _parsedAmount,
    );

    context.read<WalletCubit>().deposit(request);
  }

  void _showSuccessDialog(WalletTransaction transaction) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green.shade600, size: 32),
            const SizedBox(width: 12),
            const Text('تمت العملية بنجاح'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('رقم العملية:', transaction.id.toString()),
            _buildInfoRow(
              'المبلغ:',
              '${transaction.amount.toStringAsFixed(2)} ر.س',
            ),
            _buildInfoRow(
              'الرصيد السابق:',
              '${transaction.balanceBefore.toStringAsFixed(2)} ر.س',
            ),
            _buildInfoRow(
              'الرصيد الحالي:',
              '${transaction.balanceAfter.toStringAsFixed(2)} ر.س',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WalletCubit, WalletState>(
      listener: (context, state) {
        if (state is WalletLoaded) {
          setState(() {
            _resolvedWallet = state.wallet;
            _errorMessage = null;
          });
        } else if (state is WalletTransactionSuccess) {
          setState(() {
            _successMessage = 'تم الإيداع بنجاح!';
            _amount = '';
            // Refresh wallet balance after deposit
            if (_studentNumber != null) {
              context.read<WalletCubit>().getWalletDetails(_studentNumber!);
            }
          });
          _showSuccessDialog(state.transaction);
        } else if (state is WalletError) {
          setState(() {
            _errorMessage = state.failure.message;
            _resolvedWallet = null;
          });
        }
      },
      builder: (context, state) {
        final isProcessing = state is WalletLoading;

        return Scaffold(
          appBar: AppBar(
            title: const Text('إيداع رصيد'),
            centerTitle: true,
            backgroundColor: Colors.green.shade600,
            foregroundColor: Colors.white,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // معلومات البطاقة / الطالب
                  CardInfoWidget(
                    uid: _cardUid,
                    balance: _resolvedWallet?.balance,
                    holderName:
                        _resolvedWallet?.studentName ??
                        'طالب رقم $_studentNumber',
                    isScanning:
                        state is WalletLoading && _resolvedWallet == null,
                    error: _errorMessage != null && _resolvedWallet == null
                        ? _errorMessage
                        : null,
                  ),

                  if (_resolvedWallet == null && state is! WalletLoading) ...[
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _startNfcScan,
                      icon: const Icon(Icons.nfc),
                      label: const Text('مسح البطاقة للبدء'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade600,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),

                  // عرض المبلغ
                  AmountDisplayWidget(
                    amount: _amount,
                    label: 'مبلغ الإيداع',
                    currency: 'ر.س',
                  ),

                  const SizedBox(height: 16),

                  // رسالة الخطأ (عند فشل الإيداع)
                  if (_errorMessage != null && _resolvedWallet != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error_outline, color: Colors.red.shade700),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _errorMessage!,
                              style: TextStyle(color: Colors.red.shade700),
                            ),
                          ),
                        ],
                      ),
                    ),

                  // رسالة النجاح
                  if (_successMessage != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.green.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.green.shade700,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _successMessage!,
                              style: TextStyle(color: Colors.green.shade700),
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 24),

                  // لوحة الأرقام
                  NumericKeypadWidget(
                    currentAmount: _amount,
                    onAmountChanged: _onAmountChanged,
                    enabled: _resolvedWallet != null && !isProcessing,
                  ),

                  const SizedBox(height: 24),

                  // زر التنفيذ
                  SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _canProcess && !isProcessing
                          ? _processCashIn
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade600,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        disabledBackgroundColor: Colors.grey.shade300,
                      ),
                      child: isProcessing
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_circle_outline, size: 24),
                                SizedBox(width: 8),
                                Text(
                                  'إيداع الرصيد',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
