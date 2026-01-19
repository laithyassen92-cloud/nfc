// lib/screens/cash_in_page.dart

import 'package:flutter/material.dart';
import '../../../../models/cash_transaction.dart';
import '../../../../services/nfc_service.dart';
import '../../../../services/transaction_service.dart';
import '../../../../widgets/numeric_keypad_widget.dart';
import '../../../../widgets/amount_display_widget.dart';
import '../../../../core/logger.dart';

class CashInPage extends StatefulWidget {
  const CashInPage({super.key});

  @override
  State<CashInPage> createState() => _CashInPageState();
}

class _CashInPageState extends State<CashInPage> {
  final TransactionService _transactionService = TransactionService();
  final NfcService _nfcService = NfcService();

  String _amount = '';
  CardData? _cardData;
  bool _isScanning = false;
  bool _isProcessing = false;
  String? _errorMessage;
  String? _successMessage;

  @override
  void initState() {
    super.initState();
    _startNfcScan();
  }

  @override
  void dispose() {
    _nfcService.cancelScan();
    super.dispose();
  }

  Future<void> _startNfcScan() async {
    setState(() {
      _isScanning = true;
      _errorMessage = null;
      _cardData = null;
    });

    try {
      // استخدام خدمة NFC الموجودة
      final result = await _nfcService.scanTag();

      if (result != null) {
        // محاكاة بيانات البطاقة (يُستبدل بالقراءة الفعلية)
        setState(() {
          _cardData = CardData(
            uid: result.tag.id,
            balance: 500.0, // يُقرأ من البطاقة فعلياً
            holderName: 'محمد أحمد',
            isActive: true,
          );
          _isScanning = false;
        });

        AppLogger.info('تم قراءة البطاقة: ${result.tag.id}');
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'فشل في قراءة البطاقة: $e';
        _isScanning = false;
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
    return _cardData != null &&
        _parsedAmount > 0 &&
        !_isProcessing &&
        !_isScanning;
  }

  Future<void> _processCashIn() async {
    if (!_canProcess) return;

    setState(() {
      _isProcessing = true;
      _errorMessage = null;
      _successMessage = null;
    });

    try {
      final result = await _transactionService.processCashIn(
        card: _cardData!,
        amount: _parsedAmount,
      );

      if (result.success) {
        setState(() {
          _successMessage =
              'تم الإيداع بنجاح!\nالرصيد الجديد: ${result.updatedCard!.balance.toStringAsFixed(2)} ر.س';
          _cardData = result.updatedCard;
          _amount = '';
        });

        _showSuccessDialog(result.transaction!);
      } else {
        setState(() {
          _errorMessage = result.errorMessage;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'حدث خطأ غير متوقع';
      });
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  void _showSuccessDialog(CashTransaction transaction) {
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
            _buildInfoRow('رقم العملية:', transaction.id),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('إيداع رصيد'),
        centerTitle: true,
        backgroundColor: Colors.green.shade600,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isScanning ? null : _startNfcScan,
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
              // معلومات البطاقة
              CardInfoWidget(
                uid: _cardData?.uid,
                balance: _cardData?.balance,
                holderName: _cardData?.holderName,
                isScanning: _isScanning,
                error: _cardData == null && !_isScanning ? _errorMessage : null,
              ),

              const SizedBox(height: 24),

              // عرض المبلغ
              AmountDisplayWidget(
                amount: _amount,
                label: 'مبلغ الإيداع',
                currency: 'ر.س',
              ),

              const SizedBox(height: 16),

              // رسالة الخطأ
              if (_errorMessage != null && _cardData != null)
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
                      Icon(Icons.check_circle, color: Colors.green.shade700),
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
                enabled: _cardData != null && !_isProcessing,
              ),

              const SizedBox(height: 24),

              // زر التنفيذ
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: _canProcess ? _processCashIn : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade600,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    disabledBackgroundColor: Colors.grey.shade300,
                  ),
                  child: _isProcessing
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
  }
}
