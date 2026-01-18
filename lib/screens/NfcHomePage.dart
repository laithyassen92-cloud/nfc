import 'package:flutter/material.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';

import '../models/nfc_result.dart';
import '../services/nfc_service.dart';
import '../widgets/availability_card.dart';
import '../widgets/ndef_records_card.dart';
import '../widgets/scan_button.dart';
import '../widgets/tag_info_card.dart';

/// Main home page with NFC scanning functionality
class NfcHomePage extends StatefulWidget {
  const NfcHomePage({super.key});

  @override
  State<NfcHomePage> createState() => _NfcHomePageState();
}

class _NfcHomePageState extends State<NfcHomePage> with WidgetsBindingObserver {
  // Service for NFC operations
  final NfcService _nfcService = NfcService();

  // State variables
  NFCAvailability _nfcAvailability = NFCAvailability.not_supported;
  bool _isScanning = false;
  NfcScanResult? _scanResult;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Add observer to detect app lifecycle changes
    WidgetsBinding.instance.addObserver(this);
    // Check NFC availability on startup
    _checkNfcAvailability();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // Ensure NFC session is properly closed
    _nfcService.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Re-check NFC availability when app resumes
    // (user might have enabled/disabled NFC in settings)
    if (state == AppLifecycleState.resumed) {
      _checkNfcAvailability();
    }
  }

  /// Check if NFC is available on the device
  Future<void> _checkNfcAvailability() async {
    try {
      final availability = await _nfcService.checkAvailability();
      if (mounted) {
        setState(() {
          _nfcAvailability = availability;
          _errorMessage = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to check NFC availability: $e';
        });
      }
    }
  }

  /// Start scanning for NFC tags
  Future<void> _startScanning() async {
    // Clear previous results
    setState(() {
      _isScanning = true;
      _scanResult = null;
      _errorMessage = null;
    });

    try {
      // Perform NFC scan
      final result = await _nfcService.scanTag();

      if (mounted) {
        setState(() {
          _scanResult = result;
          _isScanning = false;
        });
      }
    } on NfcException catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.message;
          _isScanning = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Unexpected error: $e';
          _isScanning = false;
        });
      }
    }
  }

  /// Cancel ongoing NFC scan
  Future<void> _cancelScan() async {
    await _nfcService.cancelScan();
    if (mounted) {
      setState(() {
        _isScanning = false;
      });
    }
  }

  /// Clear scan results
  void _clearResults() {
    setState(() {
      _scanResult = null;
      _errorMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NFC Reader'),
        centerTitle: true,
        actions: [
          // Refresh NFC status button
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _checkNfcAvailability,
            tooltip: 'Refresh NFC status',
          ),
          // Clear results button (shown only when there are results)
          if (_scanResult != null || _errorMessage != null)
            IconButton(
              icon: const Icon(Icons.clear_all),
              onPressed: _clearResults,
              tooltip: 'Clear results',
            ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // NFC Availability Status
              AvailabilityCard(availability: _nfcAvailability),

              const SizedBox(height: 24),

              // Scan Button
              ScanButton(
                isAvailable: _nfcAvailability == NFCAvailability.available,
                isScanning: _isScanning,
                onPressed: _startScanning,
                onCancel: _cancelScan,
              ),

              const SizedBox(height: 24),

              // Loading Indicator
              if (_isScanning) _buildLoadingIndicator(),

              // Error Message
              if (_errorMessage != null && !_isScanning)
                _buildErrorCard(_errorMessage!),

              // Tag Information
              if (_scanResult != null && !_isScanning) ...[
                TagInfoCard(tagInfo: _scanResult!.tag),
                const SizedBox(height: 16),
                NdefRecordsCard(records: _scanResult!.ndefRecords),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Build loading indicator widget
  Widget _buildLoadingIndicator() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            // Animated NFC icon
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.8, end: 1.2),
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeInOut,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Icon(
                    Icons.nfc,
                    size: 64,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                );
              },
              onEnd: () {
                // Restart animation
                if (mounted && _isScanning) {
                  setState(() {});
                }
              },
            ),
            const SizedBox(height: 24),
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              'Scanning for NFC tags...',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Hold your device near an NFC tag',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Build error message card
  Widget _buildErrorCard(String message) {
    return Card(
      color: Theme.of(context).colorScheme.errorContainer,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(
              Icons.error_outline,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onErrorContainer,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
