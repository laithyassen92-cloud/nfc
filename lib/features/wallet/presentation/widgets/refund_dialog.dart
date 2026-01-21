import 'package:flutter/material.dart';

import '../../domain/models/wallet_transaction.dart';
import '../../domain/requests/refund_transaction_request.dart';

class RefundDialog extends StatefulWidget {
  final String studentNumber;
  final WalletTransaction transaction;
  final Function(RefundTransactionRequest) onConfirm;

  const RefundDialog({
    Key? key,
    required this.studentNumber,
    required this.transaction,
    required this.onConfirm,
  }) : super(key: key);

  @override
  State<RefundDialog> createState() => _RefundDialogState();
}

class _RefundDialogState extends State<RefundDialog> {
  final _formKey = GlobalKey<FormState>();

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final request = RefundTransactionRequest(
        studentNumber: widget.studentNumber,
        orginalTransactionRefNumber: widget.transaction.referenceNumber ?? '',
      );

      widget.onConfirm(request);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.replay_circle_filled_rounded,
                    color: Colors.orange,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'استرداد العملية',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'الرقم المرجعي: ${widget.transaction.referenceNumber ?? "N/A"}',
                style: TextStyle(color: Colors.grey[600]),
              ),
              Text(
                'المبلغ: ${widget.transaction.amount.toStringAsFixed(2)} ر.س',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 24),
              const Text(
                'هل أنت متأكد من رغبتك في استرداد هذه العملية؟ سيتم إرجاع المبلغ إلى المحفظة.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('تأكيد الاسترداد'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(
                      'إلغاء',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
