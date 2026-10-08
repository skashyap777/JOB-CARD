import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';
import '../services/job_card_service.dart';
import '../utils/storage_service.dart';
import '../utils/app_theme.dart';
import 'home_screen.dart';

class JobCardDetailsScreen extends StatefulWidget {
  final String encryptedRegNo;
  final String headOfHousehold;
  final String regNo;
  final Map<String, dynamic>? preloadedDetails;

  const JobCardDetailsScreen({
    super.key,
    required this.encryptedRegNo,
    required this.headOfHousehold,
    required this.regNo,
    this.preloadedDetails,
  });

  @override
  State<JobCardDetailsScreen> createState() => _JobCardDetailsScreenState();
}

class _JobCardDetailsScreenState extends State<JobCardDetailsScreen> {
  bool _isLoading = true;
  Map<String, dynamic>? _detailsData;
  String _selectedSection = 'basic';
  String _selectedYear = 'All';
  bool _isCardView = true; // Card vs Table toggle
  String _employmentSearch = ''; // Search text for employment
  final ScrollController _familyScrollController = ScrollController();
  final ScrollController _employmentScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    if (widget.preloadedDetails != null) {
      _detailsData = widget.preloadedDetails;
      _isLoading = false;
    } else {
      _fetchJobCardDetails();
    }
  }

  @override
  void dispose() {
    _familyScrollController.dispose();
    _employmentScrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchJobCardDetails() async {
    try {
      final data = await JobCardService.getJobCardDetails(widget.encryptedRegNo);

      if (data['success'] == true) {
        if (mounted) {
          setState(() {
            _detailsData = data['data'];
            _isLoading = false;
          });
        }
      } else {
        if (mounted) {
           setState(() {
             _isLoading = false;
             // Optionally handle error message here
           });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  int _getTotalFamilyMembers() {
    if (_detailsData == null) return 0;
    final members = _detailsData!['registered_members'] as List?;
    return members?.length ?? 0;
  }

  int _getTotalWorkDays() {
    if (_detailsData == null) return 0;
    final employment = _detailsData!['employment_details'] as List?;
    if (employment == null) return 0;
    int total = 0;
    for (var emp in employment) {
      if (_selectedYear != 'All' && emp['financial_year']?.toString() != _selectedYear) continue;
      total += (emp['work_completed_days'] as num?)?.toInt() ?? 0;
    }
    return total;
  }

  String _getTotalWagesPaid() {
    if (_detailsData == null) return '0';
    final employment = _detailsData!['employment_details'] as List?;
    if (employment == null) return '0';
    double total = 0;
    for (var emp in employment) {
      if (_selectedYear != 'All' && emp['financial_year']?.toString() != _selectedYear) continue;
      total += double.tryParse(emp['total_wages_paid']?.toString() ?? '0') ?? 0;
    }
    if (total >= 1000) {
      return '${(total / 1000).toStringAsFixed(2)}k';
    }
    return total.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        SystemNavigator.pop();
      },
      child: Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.home_outlined, color: AppColors.textDark),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
              (route) => false,
            );
          },
        ),
        title: const Text(
          'Job Card Details',
          style: TextStyle(
            color: AppColors.textDark,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.3,
          ),
        ),
        centerTitle: false,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Color(0xFF333333)),
            onSelected: (value) async {
              if (value == 'logout') {
                _showLogoutDialog();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.red, size: 20),
                    SizedBox(width: 12),
                    Text('Logout', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: _isLoading
            ? _buildShimmerLoading()
            : SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  
                  // Profile Card
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Profile Section
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
                          child: Column(
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFE8E0),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(0xFFFF6F3C),
                                    width: 2,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.person,
                                  size: 32,
                                  color: Color(0xFFFF6F3C),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                widget.headOfHousehold,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF333333),
                                  letterSpacing: 0.2,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                widget.regNo,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF666666),
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Stats Section
                        Container(
                          decoration: const BoxDecoration(
                            color: Color(0xFFFFF8F5),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: _buildStatItem(
                                  _getTotalFamilyMembers().toString(),
                                  'Family Members',
                                  'মুঠ পৰিয়ালৰ সদস্য',
                                ),
                              ),
                              Container(
                                width: 1,
                                height: 40,
                                color: Colors.grey.shade400,
                              ),
                              Expanded(
                                child: _buildStatItem(
                                  _getTotalWorkDays().toString(),
                                  'Total Work Days',
                                  'মুঠ কৰ্ম দিনৰ সংখ্যা',
                                ),
                              ),
                              Container(
                                width: 1,
                                height: 40,
                                color: Colors.grey.shade400,
                              ),
                              Expanded(
                                child: _buildStatItem(
                                  _getTotalWagesPaid(),
                                  'Total Wages Paid',
                                  'মুঠ পৰিশোধ কৰা মজুৰি',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Main Content Card (Sidebar + Content together)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left Sidebar
                        Container(
                          width: 95,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFFF8F5),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                            ),
                          ),
                          child: Column(
                            children: [
                              _buildMenuItem(
                                'basic',
                                Icons.home_outlined,
                                'Basic Details',
                                '(মৌলিক বিৱৰণ)',
                              ),
                              const Divider(height: 1, thickness: 0.5),
                              _buildMenuItem(
                                'family',
                                Icons.people_outline,
                                'Family Members',
                                '(পৰিয়ালৰ সদস্য)',
                              ),
                              const Divider(height: 1, thickness: 0.5),
                              _buildMenuItem(
                                'employment',
                                Icons.work_outline,
                                'Employment',
                                '(নিয়োগ)',
                              ),
                              const Divider(height: 1, thickness: 0.5),
                              /*
                              _buildMenuItem(
                                'attendance',
                                Icons.calendar_today_outlined,
                                'Attendance',
                                '(উপস্থিতি)',
                              ),
                              const Divider(height: 1, thickness: 0.5),
                              */
                              _buildMenuItem(
                                'bank',
                                Icons.account_balance_outlined,
                                'Bank Details',
                                '(বেংকৰ বিৱৰণ)',
                              ),
                            ],
                          ),
                        ),

                        // Right Content Area
                        Expanded(
                          child: Container(
                            constraints: const BoxConstraints(minHeight: 350),
                            padding: const EdgeInsets.all(14.0),
                            child: _buildContentSection(),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ),
    );
  }

  Widget _buildStatItem(String value, String labelEn, String labelAs) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFF6F3C),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          labelEn,
          style: const TextStyle(
            fontSize: 10,
            color: Color(0xFF333333),
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          labelAs,
          style: const TextStyle(
            fontSize: 9,
            color: Color(0xFF666666),
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildMenuItem(String id, IconData icon, String labelEn, String labelAs) {
    final isSelected = _selectedSection == id;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedSection = id;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 4.0),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFE8E0) : Colors.transparent,
          border: Border(
            left: BorderSide(
              color: isSelected ? const Color(0xFFFF6F3C) : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFFFF6F3C) : const Color(0xFF999999),
              size: 22,
            ),
            const SizedBox(height: 3),
            Text(
              labelEn,
              style: TextStyle(
                fontSize: 9,
                color: isSelected ? const Color(0xFFFF6F3C) : const Color(0xFF666666),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                height: 1.1,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
            ),
            Text(
              labelAs,
              style: TextStyle(
                fontSize: 8,
                color: isSelected ? const Color(0xFFFF6F3C) : const Color(0xFF999999),
                fontWeight: FontWeight.w400,
                height: 1.1,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentSection() {
    if (_detailsData == null) {
      return const Center(child: Text('No data available'));
    }

    switch (_selectedSection) {
      case 'basic':
        return _buildBasicDetails();
      case 'family':
        return _buildFamilyMembers();
      case 'employment':
        return _buildEmployment();
      case 'attendance':
        return _buildAttendance();
      case 'bank':
        return _buildBankDetails();
      default:
        return const SizedBox();
    }
  }

  Widget _buildBasicDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Information (তথ্য)',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFF6F3C),
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 12),
        _buildDetailRow('Job Card (জব কাৰ্ড)', _detailsData!['reg_no'] ?? 'N/A'),
        _buildDetailRow('Issue Date (জাৰি কৰা তাৰিখ)',
            _formatDate(_detailsData!['registration_date'] ?? '')),
        _buildDetailRow(
            'Head of Family (পৰিয়ালৰ মুৰব্বী)', _detailsData!['head_of_household'] ?? 'N/A'),
        _buildDetailRow('Father/ Husband Name (পিতা/ স্বামীৰ নাম)', _detailsData!['father_or_husband_name'] ?? 'N/A'),
        _buildDetailRow('Family ID (পৰিয়ালৰ আইডি)', (_detailsData!['id'] ?? 'N/A').toString()),
        _buildDetailRow('PMAY-G/IAY Beneficiary (PMAY-G/IAY হিতাধিকাৰী)',
            (_detailsData!['is_iay_beneficiary']?.toString().trim() == 'Y') ? 'Yes' : 'No'),
        _buildDetailRow('Category (শ্ৰেণী)', _detailsData!['caste'] ?? 'N/A'),
        _buildDetailRow('Caste (জাতি)', _detailsData!['caste'] ?? 'N/A'),
        _buildDetailRow(
          'Village ( গাঁও)',
          _detailsData!['village_name'] ?? 'N/A',
        ),
        _buildDetailRow('Gaon Panchayat ( গাঁও পঞ্চায়ত)',
            _detailsData!['panchayat_name'] ?? 'N/A'),
        _buildDetailRow('Development Block ( উন্নয়ন খণ্ড)', _detailsData!['block_name'] ?? 'N/A'),
        _buildDetailRow('District ( জিলা)',
            _detailsData!['district_name'] ?? 'N/A'),
        _buildDetailRow('State ( ৰাজ্য)', _detailsData!['state_name'] ?? 'N/A'),
      ],
    );
  }

  Widget _buildFamilyMembers() {
    final members = _detailsData!['registered_members'] as List? ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Family Members (পৰিয়ালৰ সদস্য)',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFF6F3C),
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 12),
        if (members.isEmpty)
          const Text('No family members available', style: TextStyle(fontSize: 12, color: Color(0xFF666666)))
        else
          Container(
            constraints: const BoxConstraints(maxHeight: 380),
            child: Scrollbar(
              controller: _familyScrollController,
              thumbVisibility: true,
              trackVisibility: true,
              thickness: 5,
              radius: const Radius.circular(8),
              interactive: true,
              child: ListView.builder(
                controller: _familyScrollController,
                shrinkWrap: true,
                padding: const EdgeInsets.only(right: 8),
                itemCount: members.length,
                itemBuilder: (context, index) {
                  return _buildFamilyMemberCard(members[index]);
                },
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildFamilyMemberCard(Map<String, dynamic> member) {
    final gender = member['gender'] ?? 'N/A';
    final relation = member['relation'] ?? 'N/A';
    final phone = member['mobile_no']?.toString() ?? '-';
    final disabled = (member['disabled'] == 'Y') ? 'Yes' : 'No';
    final status = member['status'] ?? 'N/A';
    final isActive = status.toString().toLowerCase() == 'active';
    
    final caste = member['caste'] ?? _detailsData!['caste'] ?? 'N/A';
    
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBF8),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFFFE8E0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: const Color(0xFFFFE8E0),
            child: Icon(
              gender == 'M' ? Icons.person : Icons.person_outline,
              color: const Color(0xFFFF6F3C),
              size: 24,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        member['applicant_name'] ?? 'N/A',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: isActive ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          color: isActive ? const Color(0xFF4CAF50) : Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                _buildMemberDetailRow('Relation (সম্পৰ্ক)', relation),
                _buildMemberDetailRow('Gender (লিংগ)', gender == 'M' ? 'Male' : 'Female'),
                _buildMemberDetailRow('Caste (জাতি)', caste),
                _buildMemberDetailRow('Phone (ফোন)', phone),
                _buildMemberDetailRow('Disabled (অক্ষমতা)', disabled),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildMemberDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 3,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                color: Color(0xFF666666),
              ),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 10,
              color: Color(0xFF333333),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmployment() {
    final employment = _detailsData!['employment_details'] as List? ?? [];
    
    // Get unique years from employment data
    final years = ['All'] + employment
        .map((emp) => emp['financial_year']?.toString() ?? '2025-2026')
        .toSet()
        .toList()
      ..sort((a, b) => a == 'All' ? -1 : b == 'All' ? 1 : a.compareTo(b));
    
    // Filter employment by selected year
    List filteredEmployment = employment.where((emp) {
      return _selectedYear == 'All' || emp['financial_year']?.toString() == _selectedYear;
    }).toList();
    
    // Apply search filter
    if (_employmentSearch.isNotEmpty) {
      final query = _employmentSearch.toLowerCase();
      filteredEmployment = filteredEmployment.where((emp) {
        final workName = (emp['work_name'] ?? '').toString().toLowerCase();
        final mrNo = (emp['allocated_work_ids_mr_numbers'] ?? '').toString().toLowerCase();
        final memberName = (emp['applicant_name'] ?? '').toString().toLowerCase();
        final status = (emp['payment_status'] ?? '').toString().toLowerCase();
        return workName.contains(query) || mrNo.contains(query) || memberName.contains(query) || status.contains(query);
      }).toList();
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top bar: Year filter + Card/Table toggle
        Row(
          children: [
            // Year filter (flexible to prevent overflow)
            Flexible(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Year:', style: TextStyle(fontSize: 10, color: Color(0xFF666666), fontWeight: FontWeight.w500)),
                  const SizedBox(width: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEEEEE),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: DropdownButton<String>(
                      value: _selectedYear,
                      underline: const SizedBox(),
                      isDense: true,
                      icon: const Icon(Icons.arrow_drop_down, size: 16, color: Color(0xFF333333)),
                      style: const TextStyle(fontSize: 11, color: Color(0xFF333333), fontWeight: FontWeight.w600),
                      items: years.map((year) => DropdownMenuItem<String>(value: year, child: Text(year))).toList(),
                      onChanged: (value) => setState(() => _selectedYear = value ?? 'All'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 4),
            // Card / Table toggle
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFEEEEEE),
                borderRadius: BorderRadius.circular(6),
              ),
              padding: const EdgeInsets.all(2),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildViewToggle(Icons.grid_view_rounded, 'Card', true),
                  _buildViewToggle(Icons.table_rows_rounded, 'Table', false),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Search box
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFEEEEEE),
            borderRadius: BorderRadius.circular(4),
          ),
          child: TextField(
            onChanged: (val) => setState(() => _employmentSearch = val),
            style: const TextStyle(fontSize: 11),
            decoration: const InputDecoration(
              hintText: 'Search...',
              hintStyle: TextStyle(fontSize: 11, color: Color(0xFF999999)),
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              border: InputBorder.none,
              isDense: true,
              prefixIcon: Icon(Icons.search, size: 16, color: Color(0xFF999999)),
              prefixIconConstraints: BoxConstraints(minWidth: 32),
            ),
          ),
        ),
        const SizedBox(height: 10),
        // Content
        if (filteredEmployment.isEmpty)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8F5),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFFFE8E0)),
            ),
            child: const Center(
              child: Text('No employment data available', style: TextStyle(fontSize: 12, color: Color(0xFF666666))),
            ),
          )
        else
          Container(
            constraints: const BoxConstraints(maxHeight: 380),
            child: Scrollbar(
              controller: _employmentScrollController,
              thumbVisibility: true,
              trackVisibility: true,
              thickness: 5,
              radius: const Radius.circular(8),
              interactive: true,
              child: SingleChildScrollView(
                controller: _employmentScrollController,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Column(
                    children: [
                      if (_isCardView)
                        ...filteredEmployment.asMap().entries.map((entry) => _buildEmploymentCard(entry.value, entry.key))
                      else
                        _buildEmploymentTable(filteredEmployment),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildViewToggle(IconData icon, String label, bool isCard) {
    final isActive = _isCardView == isCard;
    return GestureDetector(
      onTap: () => setState(() => _isCardView = isCard),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
          boxShadow: isActive ? [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 2)] : null,
        ),
        child: Row(
          children: [
            Icon(icon, size: 12, color: isActive ? const Color(0xFF333333) : const Color(0xFF999999)),
            const SizedBox(width: 3),
            Text(label, style: TextStyle(fontSize: 10, fontWeight: isActive ? FontWeight.w600 : FontWeight.w400, color: isActive ? const Color(0xFF333333) : const Color(0xFF999999))),
          ],
        ),
      ),
    );
  }

  Widget _buildEmploymentCard(Map<String, dynamic> emp, int index) {
    final serialNo = emp['id']?.toString() ?? 'N/A';
    final mrNumber = emp['allocated_work_ids_mr_numbers'] ?? 'N/A';
    final year = emp['financial_year'] ?? '';
    final workName = emp['work_name'] ?? '';
    final memberName = emp['applicant_name'] ?? _detailsData!['head_of_household'] ?? 'N/A';
    final workDemandDays = emp['work_demanded_days'] ?? 0;
    final workAllottedDays = emp['work_allotted_days'] ?? 0;
    final workDays = emp['work_completed_days'] ?? 0;
    final wageRate = double.tryParse(emp['wage_rate']?.toString() ?? '0') ?? 0;
    final totalWages = double.tryParse(emp['total_wages_paid']?.toString() ?? '0') ?? 0;
    final paymentStatus = emp['payment_status'] ?? 'Pending';
    final dtCredited = emp['dt_ac_credited'] ?? 'N/A';
    final requestDate = emp['employment_requested_date'] ?? 'N/A';
    final delayComp = double.tryParse(emp['delay_compensation_paid']?.toString() ?? '0') ?? 0;
    final unempAllow = double.tryParse(emp['unemployment_allowance_paid']?.toString() ?? '0') ?? 0;
    final isCredited = paymentStatus.toLowerCase() == 'credited';

    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            'Job Card Activity for $year (MSR #$mrNumber)',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
          ),
          const SizedBox(height: 10),
          _buildDetailRow('Serial No. (ক্ৰমিক নম্বৰ)', serialNo),
          if (workName.isNotEmpty) _buildDetailRow('Work Name (কাৰ্যৰ নাম)', workName),
          _buildDetailRow('Name of Job Seeking Verified Member', memberName),
          _buildDetailRow('Work Demand Days (কামৰ দাবী দিন)', '$workDemandDays days'),
          _buildDetailRow('Work Alloted Days (কামৰ আবণ্টিত দিন)', '$workAllottedDays days'),
          _buildDetailRow('Number of Working Days (কৰ্মদিনৰ সংখ্যা)', '$workDays days'),
          _buildDetailRow('Electronic Muster Roll No.', mrNumber),
          _buildDetailRow('Wage Rate (মজুৰিৰ হাৰ)', '₹${wageRate.toStringAsFixed(2)}/-'),
          // Total Wage highlighted
          Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(child: Text('Total Wage Amount (মুঠ মজুৰি পৰিমাণ)', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF333333)), overflow: TextOverflow.ellipsis)),
                Text('₹${totalWages.toStringAsFixed(2)}/-', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF4CAF50))),
              ],
            ),
          ),
          _buildDetailRow('Payment Status (পৰিশোধৰ স্থিতি)', paymentStatus, valueColor: isCredited ? const Color(0xFF4CAF50) : const Color(0xFFFF9800)),
          if (requestDate != 'N/A') _buildDetailRow('Payment Request Date (মজুৰিৰ অনুৰোধৰ তাৰিখ)', requestDate),
          if (dtCredited != 'N/A' && dtCredited != null) _buildDetailRow('Date of Wage Received (মজুৰি লাভ কৰাৰ তাৰিখ)', dtCredited.toString()),
          _buildDetailRow('Delay Compensation Paid (বিলম্ব ক্ষতিপূৰণ প্ৰদান)', '₹${delayComp.toStringAsFixed(2)}/-'),
          _buildDetailRow('Unemployment Allowance (নিবনুৱা ভাট্টা)', '₹${unempAllow.toStringAsFixed(2)}/-'),
        ],
      ),
    );
  }

  Widget _buildEmploymentTable(List filteredEmployment) {
    return Column(
      children: filteredEmployment.asMap().entries.map((entry) {
        final i = entry.key;
        final emp = entry.value;
        final mrNo = emp['allocated_work_ids_mr_numbers'] ?? 'N/A';
        final year = emp['financial_year'] ?? '';
        final days = emp['work_completed_days'] ?? 0;
        final status = emp['payment_status'] ?? 'Pending';
        final isCredited = status.toString().toLowerCase() == 'credited';
        final workName = emp['work_name'] ?? '';
        final totalWages = double.tryParse(emp['total_wages_paid']?.toString() ?? '0') ?? 0;

        return GestureDetector(
          onTap: () => _showEmploymentDetailDialog(emp),
          child: Container(
            margin: EdgeInsets.only(bottom: i < filteredEmployment.length - 1 ? 8 : 0),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFEEEEEE)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Row(
              children: [
                // MSR Badge
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF3EE),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    mrNo,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF6F3C),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(width: 10),
                // Info Column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 6,
                        runSpacing: 2,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.calendar_today_outlined, size: 10, color: Colors.grey.shade500),
                              const SizedBox(width: 3),
                              Text(year, style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.timer_outlined, size: 10, color: Colors.grey.shade500),
                              const SizedBox(width: 3),
                              Text('$days days', style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '₹${totalWages.toStringAsFixed(0)}/-',
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF4CAF50)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                // Status + View column
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Status pill
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: isCredited ? const Color(0xFFE8F5E9) : const Color(0xFFFFF3E0),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isCredited ? Icons.check_circle : Icons.access_time_filled,
                            size: 10,
                            color: isCredited ? const Color(0xFF4CAF50) : const Color(0xFFFF9800),
                          ),
                          const SizedBox(width: 3),
                          Text(
                            status,
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              color: isCredited ? const Color(0xFF4CAF50) : const Color(0xFFFF9800),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    // View button
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFF6F3C), Color(0xFFFF8F5C)],
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.visibility_outlined, size: 10, color: Colors.white),
                          SizedBox(width: 3),
                          Text('View', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: Colors.white)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  void _showEmploymentDetailDialog(Map<String, dynamic> emp) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          constraints: const BoxConstraints(maxHeight: 500),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: _buildEmploymentCard(emp, 0),
          ),
        ),
      ),
    );
  }

  Widget _buildAttendance() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Attendance (উপস্থিতি)',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFF6F3C),
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 12),
        const Center(
          child: Text(
            'February 2025',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildCalendar(),
      ],
    );
  }

  Widget _buildCalendar() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: ['S', 'M', 'T', 'W', 'T', 'F', 'S']
              .map((day) => Expanded(
                    child: Text(
                      day,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ))
              .toList(),
        ),
        const SizedBox(height: 8),
        // Sample calendar grid
        ...List.generate(4, (week) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(7, (day) {
                final dayNum = week * 7 + day + 1;
                if (dayNum > 28) {
                  return const Expanded(child: SizedBox());
                }
                final isWorkDay = dayNum >= 10 && dayNum <= 15;
                return Expanded(
                  child: Container(
                    height: 32,
                    margin: const EdgeInsets.all(2),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color:
                          isWorkDay ? const Color(0xFFE8F5E9) : Colors.transparent,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      dayNum.toString(),
                      style: TextStyle(
                        fontSize: 11,
                        color: isWorkDay ? const Color(0xFF4CAF50) : const Color(0xFF333333),
                        fontWeight:
                            isWorkDay ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }),
            ),
          );
        }),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 6),
            const Text(
              'Present / Work Done',
              style: TextStyle(fontSize: 11, color: Color(0xFF666666)),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBankDetails() {
    final bankDetails = _detailsData!['bank_detail'] as List? ?? [];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Bank Information (বেংক তথ্য)',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFF6F3C),
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 12),
        if (bankDetails.isEmpty)
          const Text('No bank details available', style: TextStyle(fontSize: 12, color: Color(0xFF666666)))
        else
          ...bankDetails.map((bank) {
                final ifscCode = (bank['ifsc_code'] != null && bank['ifsc_code'].toString().trim().isNotEmpty)
                    ? bank['ifsc_code'].toString()
                    : (bank['bank_branch_code']?.toString() ?? 'N/A');

                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFBF8),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFFFFE8E0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.account_balance, size: 16, color: Color(0xFFFF6F3C)),
                          SizedBox(width: 6),
                          Text(
                            'Bank Account (বেংক একাউণ্ট)',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _buildDetailRow('Bank Holder Name (বেংক একাউণ্টধাৰীৰ নাম)', bank['applicant_name'] ?? 'N/A'),
                      _buildDetailRow('Name of Bank (বেংকৰ নাম)', bank['bank_name'] ?? 'N/A'),
                      _buildDetailRow('Branch Name (শাখা নাম)', bank['bank_branch_name'] ?? 'N/A'),
                      _buildDetailRow('Account Number (একাউণ্ট নম্বৰ)', bank['bank_account_no']?.toString() ?? 'N/A'),
                      _buildDetailRow("IFSC Code (আই.এফ.এচ.চি কোড)", ifscCode),
                    ],
                  ),
                );
              }),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 4,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF666666),
                fontWeight: FontWeight.w500,
                height: 1.3,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            flex: 6,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 11,
                color: valueColor ?? const Color(0xFF333333),
                fontWeight: FontWeight.w600,
                height: 1.3,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateStr) {
    if (dateStr.isEmpty) return 'N/A';
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return dateStr;
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout? You will need to search for your job card again.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              // Clear saved data
              await StorageService.clearJobCardDetails();
              
              // Navigate to home screen
              if (mounted) {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                  (route) => false,
                );
              }
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12.0),
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const SizedBox(width: 12),
                Container(
                  width: 100,
                  height: 350,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    height: 350,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
