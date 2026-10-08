import 'package:flutter/material.dart';
import '../services/job_card_service.dart';
import '../utils/storage_service.dart';
import '../widgets/qr_scanner_dialog.dart';
import 'home_screen.dart';
import 'job_card_details_screen.dart';

class SearchScreen extends StatefulWidget {
  final String? initialJobCardNumber;

  const SearchScreen({super.key, this.initialJobCardNumber});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late final AnimationController _loaderController;
  bool _isLoading = false;
  bool _isAutoSearchInProgress = false;
  String _message = '';

  @override
  void initState() {
    super.initState();
    _loaderController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();

    if (widget.initialJobCardNumber != null &&
        widget.initialJobCardNumber!.isNotEmpty) {
      _searchController.text = widget.initialJobCardNumber!;
      _performSearch(widget.initialJobCardNumber!, isAutoSearch: true);
    }
  }

  Future<void> _scanQRCode() async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => const QRScannerDialog(),
    );

    if (result != null && result.isNotEmpty) {
      _searchController.text = result;
      _performSearch(result);
    }
  }

  Future<void> _performSearch(String jobCardNumber,
      {bool isAutoSearch = false}) async {
    if (jobCardNumber.isEmpty) {
      setState(() {
        _message = 'Please enter a Job Card number.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _isAutoSearchInProgress = isAutoSearch;
      _message = '';
    });

    try {
      String? encryptedToken;
      if (jobCardNumber.contains('/household/qr/')) {
        encryptedToken = jobCardNumber.split('/household/qr/').last;
      }

      String encryptedRegNo;
      String regNo;
      String headOfHousehold;
      Map<String, dynamic> detailsData;

      if (encryptedToken != null) {
        final detailsResponse =
            await JobCardService.getJobCardDetails(encryptedToken);
        if (detailsResponse['success'] != true || detailsResponse['data'] == null) {
          if (mounted) {
            setState(() {
              _isLoading = false;
              _isAutoSearchInProgress = false;
              _message = 'No details found for this QR code.';
            });
          }
          return;
        }

        detailsData = detailsResponse['data'] as Map<String, dynamic>;
        encryptedRegNo = encryptedToken;
        regNo = (detailsData['reg_no'] ?? 'N/A').toString();
        headOfHousehold = (detailsData['head_of_household'] ?? 'N/A').toString();
      } else {
        final searchData = await JobCardService.searchJobCard(jobCardNumber);
        if (searchData['success'] != true || searchData['data'] == null) {
          if (mounted) {
            setState(() {
              _isLoading = false;
              _isAutoSearchInProgress = false;
              _message = 'No details found. Please check the Job Card number.';
            });
          }
          return;
        }

        final searchPayload = searchData['data'] as Map<String, dynamic>;
        encryptedRegNo = (searchPayload['encrypted_reg_no'] ?? '').toString();
        regNo = (searchPayload['reg_no'] ?? jobCardNumber).toString();
        headOfHousehold =
            (searchPayload['head_of_household'] ?? 'N/A').toString();

        if (encryptedRegNo.isEmpty) {
          if (mounted) {
            setState(() {
              _isLoading = false;
              _isAutoSearchInProgress = false;
              _message = 'Invalid response from server. Please try again.';
            });
          }
          return;
        }

        final detailsResponse =
            await JobCardService.getJobCardDetails(encryptedRegNo);
        if (detailsResponse['success'] != true || detailsResponse['data'] == null) {
          if (mounted) {
            setState(() {
              _isLoading = false;
              _isAutoSearchInProgress = false;
              _message = 'Error: Unable to fetch details. Please try again.';
            });
          }
          return;
        }

        detailsData = detailsResponse['data'] as Map<String, dynamic>;
      }

      await StorageService.saveJobCardDetails(
        encryptedRegNo: encryptedRegNo,
        regNo: regNo,
        headOfHousehold: headOfHousehold,
      );

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => JobCardDetailsScreen(
            encryptedRegNo: encryptedRegNo,
            headOfHousehold: headOfHousehold,
            regNo: regNo,
            preloadedDetails: detailsData,
          ),
        ),
      ).then((_) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _isAutoSearchInProgress = false;
          });
        }
      });
    } catch (_) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isAutoSearchInProgress = false;
          _message = 'Error: Unable to fetch details. Please try again.';
        });
      }
    }
  }

  @override
  void dispose() {
    _loaderController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFE6643D), Colors.orangeAccent],
              stops: [0.0, 1.0],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/AS.png',
                        height: 40,
                        width: 40,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      const Text(
                        'SMART JOB CARD',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                      ),
                      Text(
                        'পঞ্চায়ত আৰু গ্ৰামোন্নয়ন বিভাগ, অসম',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                    child: Column(
                      children: [
                        // Search Card Wrapper
                        Container(
                          width: double.infinity,
                          constraints: const BoxConstraints(maxWidth: 450),
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 20,
                                offset: Offset(0, 4),
                              ),
                            ],
                            border: Border.all(color: const Color(0xFFF3F4F6)),
                          ),
                          child: Stack(
                            children: [
                              // Top border gradient
                              Positioned(
                                top: 0,
                                left: 0,
                                right: 0,
                                height: 8,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [Color(0xFFE6643D), Colors.orangeAccent],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                  ),
                                ),
                              ),
                              
                              // Background blurry blobs
                              Positioned(
                                top: -40,
                                right: -40,
                                child: Container(
                                  width: 128,
                                  height: 128,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: const Color(0xFFFFF7ED).withValues(alpha: 0.5),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: -40,
                                left: -40,
                                child: Container(
                                  width: 128,
                                  height: 128,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: const Color(0xFFFFF7ED).withValues(alpha: 0.5),
                                  ),
                                ),
                              ),
                              
                              // Content padding
                              Padding(
                                padding: const EdgeInsets.all(32.0),
                                child: Column(
                                  children: [
                                    // Icon
                                    Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFFFF7ED),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.search,
                                        color: Color(0xFFE6643D),
                                        size: 32,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    
                                    // Titles
                                    const Text(
                                      'Search Job Card',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1F2937),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      'Enter your Job Card number to view details',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF6B7280),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      'জব কাৰ্ডৰ বিৱৰণ চাবলৈ আপোনাৰ নম্বৰ প্ৰৱেশ কৰক',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF9CA3AF),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 24),
                                    
                                    // Form
                                    const Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 4.0, bottom: 4.0),
                                        child: Text(
                                          'Job Card Number / জব কাৰ্ড নম্বৰ',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF374151),
                                          ),
                                        ),
                                      ),
                                    ),
                                    TextField(
                                      controller: _searchController,
                                      onSubmitted: (_) => _performSearch(_searchController.text.trim()),
                                      decoration: InputDecoration(
                                        hintText: 'Ex: AS-01-001-XXXXXX',
                                        hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
                                        prefixIcon: const Icon(Icons.badge_outlined, color: Color(0xFF9CA3AF), size: 18),
                                        suffixIcon: IconButton(
                                          icon: const Icon(
                                            Icons.qr_code_scanner,
                                            color: Color(0xFFE6643D),
                                          ),
                                          onPressed: _scanQRCode,
                                        ),
                                        filled: true,
                                        fillColor: const Color(0xFFF9FAFB),
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: const BorderSide(color: Color(0xFFE6643D), width: 2),
                                        ),
                                      ),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Color(0xFF1F2937),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    
                                    // Search Button
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: _isLoading
                                            ? null
                                            : () => _performSearch(_searchController.text.trim()),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFFE6643D),
                                          foregroundColor: Colors.white,
                                          elevation: 4,
                                          shadowColor: const Color(0xFFFED7AA),
                                          padding: const EdgeInsets.symmetric(vertical: 16),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        ),
                                        child: const Text('Search', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                      ),
                                    ),
                                    
                                    // Error message
                                    if (_message.isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 16),
                                        child: Text(
                                          _message,
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.red.shade600,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 48), // Spacing before footer

                        // Footer
                        Center(
                          child: Column(
                            children: [
                              const Text(
                                '© 2026 Panchayat & Rural Development Department,\nGovernment of Assam. All rights reserved.',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 12, color: Color(0xFF6B7280), fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text('Powered by', style: TextStyle(fontSize: 10, color: Color(0xFF9CA3AF), fontWeight: FontWeight.w500)),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(color: const Color(0xFF1F2937), borderRadius: BorderRadius.circular(4)),
                                    child: const Text('@', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                                  ),
                                  const SizedBox(width: 4),
                                  const Text('AMTRON', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF4B5563))),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (_isLoading)
              _PremiumLoaderOverlay(
                controller: _loaderController,
                isAutoSearch: _isAutoSearchInProgress,
              ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFE5E7EB), width: 1)),
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ),
                      );
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.transparent, width: 3)),
                    ),
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.home_outlined, color: Color(0xFF9CA3AF), size: 24),
                        SizedBox(height: 4),
                        Text('Home', style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 12, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {}, // Already on Search tab
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: Color(0xFFE6643D), width: 3)),
                    ),
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.search, color: Color(0xFF4B5563), size: 24),
                        SizedBox(height: 4),
                        Text('Job Card', style: TextStyle(color: Color(0xFF4B5563), fontSize: 12, fontWeight: FontWeight.w500)),
                      ],
                    ),
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

class _PremiumLoaderOverlay extends StatelessWidget {
  final AnimationController controller;
  final bool isAutoSearch;

  const _PremiumLoaderOverlay({
    required this.controller,
    required this.isAutoSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.32),
      child: Center(
        child: Container(
          width: 280,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFFF7F3), Color(0xFFFFEEE6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: const Color(0xFFFFC3AE),
              width: 1.5,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x33FF6F3C),
                blurRadius: 24,
                offset: Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RotationTransition(
                turns: CurvedAnimation(
                  parent: controller,
                  curve: Curves.linear,
                ),
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFFFF6F3C),
                        Colors.orange.shade500,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x55FF6F3C),
                        blurRadius: 16,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.verified_outlined,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                isAutoSearch
                    ? 'Opening your saved job card...'
                    : 'Fetching your job card details...',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF3D2C24),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Please wait a moment',
                style: TextStyle(
                  color: Colors.brown.shade500,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
