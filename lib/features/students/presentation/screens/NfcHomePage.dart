import 'package:flutter/material.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';

import '../../../../core/app_colors.dart';
import '../../../../core/logger.dart';
import '../../../../models/nfc_result.dart';
import '../../../../services/nfc_service.dart';
import '../../../../widgets/ndef_records_card.dart';
import '../../../../widgets/tag_info_card.dart';
import '../../../wallet/presentation/screens/cash_in_page.dart';
import '../../../wallet/presentation/screens/cash_out_page.dart';
import '../../../wallet/presentation/screens/wallet_transactions_page.dart';

/// Main home page with premium NFC scanning design
class NfcHomePage extends StatefulWidget {
  const NfcHomePage({super.key});

  @override
  State<NfcHomePage> createState() => _NfcHomePageState();
}

class _NfcHomePageState extends State<NfcHomePage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  // Service for NFC operations
  final NfcService _nfcService = NfcService();

  // State variables
  NFCAvailability _nfcAvailability = NFCAvailability.not_supported;
  bool _isScanning = false;
  NfcScanResult? _scanResult;
  String? _errorMessage;
  final List<NfcScanResult> _recentScans = [];

  // Animation controllers
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Check availability after the first frame to ensure activity is attached
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkNfcAvailability();
    });

    // Setup pulse animation for the scan button
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.4,
    ).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeOut));

    _opacityAnimation = Tween<double>(
      begin: 0.6,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _pulseController.dispose();
    _nfcService.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkNfcAvailability();
    }
  }

  Future<void> _checkNfcAvailability() async {
    try {
      final availability = await _nfcService.checkAvailability();
      if (mounted) {
        setState(() {
          _nfcAvailability = availability;
          _errorMessage = null;
        });
        AppLogger.debug(
          'Home page availability updated: $availability',
          tag: 'UI',
        );
      }
    } catch (e) {
      AppLogger.error(
        'Critical error checking NFC availability',
        error: e,
        tag: 'UI',
      );
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to check NFC availability: $e';
        });
      }
    }
  }

  Future<void> _startScanning() async {
    if (_nfcAvailability != NFCAvailability.available) return;

    setState(() {
      _isScanning = true;
      _errorMessage = null;
    });

    try {
      final result = await _nfcService.scanTag();

      if (mounted) {
        setState(() {
          _scanResult = result;
          _recentScans.insert(0, result);
          if (_recentScans.length > 5) _recentScans.removeLast();
          _isScanning = false;
        });
        AppLogger.success(
          'Scan result received in UI: ${result.tag.id}',
          tag: 'UI',
        );
      }
    } on NfcException catch (e) {
      AppLogger.warning('NFC Scan failed: ${e.message}', tag: 'UI');
      if (mounted) {
        setState(() {
          _errorMessage = e.message;
          _isScanning = false;
        });
        _showErrorSnackBar(e.message);
      }
    } catch (e) {
      AppLogger.error('Unexpected error during scan', error: e, tag: 'UI');
      if (mounted) {
        setState(() {
          _errorMessage = 'Unexpected error: $e';
          _isScanning = false;
        });
        _showErrorSnackBar('Unexpected error: $e');
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _cancelScan() async {
    await _nfcService.cancelScan();
    if (mounted) {
      setState(() {
        _isScanning = false;
      });
    }
  }

  void _clearResults() {
    setState(() {
      _scanResult = null;
      _errorMessage = null;
      _recentScans.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: Text(
          'NFC Reader',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : AppColors.slate(900),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _checkNfcAvailability,
            tooltip: 'Refresh Status',
          ),

          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      _buildStatusCard(colorScheme, isDark),
                      const SizedBox(height: 60),
                      _buildScanSection(colorScheme, isDark),
                      _buildInstructions(theme, isDark),
                      const SizedBox(height: 24),
                      _buildActionButtons(),
                      const SizedBox(height: 24),
                      if (_errorMessage != null && !_isScanning) ...[
                        const SizedBox(height: 20),
                        _buildErrorDisplay(isDark),
                      ],
                      if (_scanResult != null) ...[
                        const SizedBox(height: 30),
                        _buildRecentResultHeader(theme, isDark),
                        const SizedBox(height: 10),
                        TagInfoCard(tagInfo: _scanResult!.tag),
                        const SizedBox(height: 16),
                        NdefRecordsCard(records: _scanResult!.ndefRecords),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: () => setState(() => _scanResult = null),
                          icon: const Icon(Icons.arrow_back),
                          label: const Text('Back to Home'),
                        ),
                      ],
                      if (_recentScans.isNotEmpty && _scanResult == null) ...[
                        const SizedBox(height: 30),
                        _buildRecentScansSection(theme, isDark),
                      ],
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorDisplay(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.redAccent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.redAccent.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.redAccent),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _errorMessage!,
              style: const TextStyle(color: Colors.redAccent, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(ColorScheme colorScheme, bool isDark) {
    final bool isReady = _nfcAvailability == NFCAvailability.available;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C252E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.05) : AppColors.slate(200),
        ),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isReady
                  ? Colors.green.withOpacity(0.1)
                  : Colors.orange.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isReady ? Icons.check_circle : Icons.error_outline,
              color: isReady ? Colors.green : Colors.orange,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isReady ? 'NFC is Ready' : 'NFC Unavailable',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: isDark ? Colors.white : AppColors.slate(900),
                  ),
                ),
                Text(
                  isReady
                      ? 'Sensor active & listening'
                      : _nfcAvailability == NFCAvailability.disabled
                      ? 'Please enable NFC in settings'
                      : 'Not supported on this device',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark
                        ? const Color(0xFF94A3B8)
                        : AppColors.slate(500),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 40,
            height: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: LinearGradient(
                colors: [
                  colorScheme.primary.withOpacity(0.2),
                  colorScheme.primary.withOpacity(0.05),
                ],
              ),
            ),
            child: Icon(
              Icons.waves,
              color: colorScheme.primary.withOpacity(0.3),
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScanSection(ColorScheme colorScheme, bool isDark) {
    return Center(
      child: GestureDetector(
        onTap: _isScanning ? _cancelScan : _startScanning,
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (_nfcAvailability == NFCAvailability.available)
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Container(
                    width: 200 * _pulseAnimation.value,
                    height: 200 * _pulseAnimation.value,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colorScheme.primary.withOpacity(
                        _opacityAnimation.value,
                      ),
                    ),
                  );
                },
              ),

            Container(
              width: 190,
              height: 190,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.primary.withOpacity(0.3),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
            ),

            Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [colorScheme.primary, AppColors.primaryDark],
                ),
                border: Border.all(
                  color: isDark ? const Color(0xFF16202A) : Colors.white,
                  width: 4,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _isScanning ? Icons.close : Icons.contactless,
                    size: 64,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isScanning ? 'CANCEL' : 'SCAN',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructions(ThemeData theme, bool isDark) {
    return Column(
      children: [
        Text(
          _isScanning ? 'Scanning...' : 'Hold near a tag',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : AppColors.slate(900),
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            _isScanning
                ? 'Searching for NFC tags. Move your device closer if needed.'
                : 'Approach an NFC tag with your device to read data automatically.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: isDark ? const Color(0xFF94A3B8) : AppColors.slate(500),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentResultHeader(ThemeData theme, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        'LAST SCAN RESULT',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
          color: isDark
              ? Colors.white.withOpacity(0.6)
              : AppColors.slate(900).withOpacity(0.6),
        ),
      ),
    );
  }

  Widget _buildRecentScansSection(ThemeData theme, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'RECENT SCANS',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                color: isDark
                    ? Colors.white.withOpacity(0.6)
                    : AppColors.slate(900).withOpacity(0.6),
              ),
            ),
            TextButton(onPressed: () {}, child: const Text('View All')),
          ],
        ),
        const SizedBox(height: 8),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _recentScans.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final scan = _recentScans[index];
            return _buildScanListItem(scan, isDark);
          },
        ),
      ],
    );
  }

  Widget _buildScanListItem(NfcScanResult scan, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C252E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.05) : AppColors.slate(200),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF101922) : AppColors.slate(100),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.credit_card,
              color: isDark ? const Color(0xFFCBD5E1) : AppColors.slate(600),
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tag ID: ${scan.tag.id}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: isDark ? Colors.white : AppColors.slate(900),
                  ),
                ),
                Text(
                  '${scan.tag.type} • Just now',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark
                        ? const Color(0xFF94A3B8)
                        : AppColors.slate(500),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: isDark ? const Color(0xFF475569) : AppColors.slate(400),
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CashInPage()),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text('إيداع'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CashOutPage()),
                  );
                },
                icon: const Icon(Icons.remove),
                label: const Text('سحب'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              // Note: In a real app, this walletId would come from the scanned tag/student data
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const WalletTransactionsPage(
                    studentNumber: '001004', // Mock for general history view
                    studentName: 'سجل العمليات العام',
                  ),
                ),
              );
            },
            icon: const Icon(Icons.history, color: Colors.blueGrey),
            label: const Text('سجل العمليات والاسترجاع'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: const BorderSide(color: Colors.blueGrey),
              foregroundColor: Colors.blueGrey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
