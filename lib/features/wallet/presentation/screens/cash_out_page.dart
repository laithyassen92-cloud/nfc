// lib/screens/cash_out_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/logger.dart';
import '../../domain/models/student_wallet.dart';
import '../../domain/models/wallet_transaction.dart';
import '../../domain/requests/withdraw_transaction_request.dart';
import '../cubits/wallet_cubit.dart';
import '../widgets/amount_display_widget.dart';
import '../widgets/numeric_keypad_widget.dart';
import '../../../../services/nfc_service.dart';

class CashOutPage extends StatefulWidget {
  const CashOutPage({super.key});

  @override
  State<CashOutPage> createState() => _CashOutPageState();
}

class _CashOutPageState extends State<CashOutPage> {
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
      _resolvedWallet = null;
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

    // Immediate balance check
    if (_resolvedWallet != null) {
      final parsedAmount = double.tryParse(amount) ?? 0;
      if (parsedAmount > _resolvedWallet!.balance) {
        setState(() {
          _errorMessage = 'الرصيد غير كافٍ';
        });
      }
    }
  }

  double get _parsedAmount {
    if (_amount.isEmpty) return 0;
    return double.tryParse(_amount) ?? 0;
  }

  bool get _canProcess {
    return _studentNumber != null &&
        _parsedAmount > 0 &&
        _resolvedWallet != null &&
        _parsedAmount <= _resolvedWallet!.balance;
  }

  Future<void> _processCashOut() async {
    if (!_canProcess) return;

    final request = WithdrawTransactionRequest(
      studentNumber: _studentNumber!,
      amount: _parsedAmount,
    );

    context.read<WalletCubit>().withdraw(request);
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

  Widget _buildQuickAmountButtons() {
    final quickAmounts = [50, 100, 200, 500];
    final availableAmounts = _resolvedWallet != null
        ? quickAmounts.where((a) => a <= _resolvedWallet!.balance).toList()
        : <int>[];

    if (availableAmounts.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: availableAmounts.map((amount) {
        return ActionChip(
          label: Text('$amount ر.س'),
          onPressed: () => _onAmountChanged(amount.toString()),
          backgroundColor: Colors.orange.shade50,
          labelStyle: TextStyle(color: Colors.orange.shade800),
        );
      }).toList(),
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
            _successMessage = 'تم السحب بنجاح!';
            _amount = '';
            // Refresh wallet balance after withdrawal
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
            title: const Text('سحب رصيد'),
            centerTitle: true,
            backgroundColor: Colors.orange.shade600,
            foregroundColor: Colors.white,
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: state is WalletLoading ? null : _startNfcScan,
                tooltip: 'إعادة المسح',
              ),
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CardInfoWidget(
                    uid: _cardUid,
                    balance: _resolvedWallet?.balance,
                    holderName:
                        _resolvedWallet?.studentName ??
                        (_studentNumber != null
                            ? 'طالب رقم $_studentNumber'
                            : null),
                    isScanning:
                        state is WalletLoading && _resolvedWallet == null,
                    error: _resolvedWallet == null && state is! WalletLoading
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

                  const SizedBox(height: 16),
                  _buildQuickAmountButtons(),
                  const SizedBox(height: 16),

                  AmountDisplayWidget(
                    amount: _amount,
                    label: 'مبلغ السحب',
                    currency: 'ر.س',
                  ),

                  const SizedBox(height: 16),

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

                  NumericKeypadWidget(
                    currentAmount: _amount,
                    onAmountChanged: _onAmountChanged,
                    enabled: _resolvedWallet != null && !isProcessing,
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _canProcess && !isProcessing
                          ? _processCashOut
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange.shade600,
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
                                Icon(Icons.remove_circle_outline, size: 24),
                                SizedBox(width: 8),
                                Text(
                                  'سحب الرصيد',
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
