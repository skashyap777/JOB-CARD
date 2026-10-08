import 'package:flutter/material.dart';
import '../utils/localization.dart';
import '../utils/app_theme.dart';
import 'search_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              
              // Welcome Banner
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFE6643D), Colors.orangeAccent],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))
                  ],
                ),
                padding: const EdgeInsets.all(24.0),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SMART JOB CARD - PNRD, ASSAM',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'স্মাৰ্ট জব কাৰ্ড - পঞ্চায়ত আৰু গ্ৰামোন্নয়ন, অসম',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Your gateway to VB-G RAM G employment information',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Search, verify and track job card details instantly',
                      style: TextStyle(fontSize: 12, color: Colors.white70),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),

              // About This App
              _buildCard(
                icon: Icons.info_outline,
                iconColor: const Color(0xFFE6643D),
                iconBgColor: const Color(0xFFFFF3E0),
                titleEn: 'About This App',
                titleAs: 'এই এপৰ বিষয়ে',
                children: [
                  const Text(
                    'This digital portal provides comprehensive access to VB-G RAM G (Formerly known as MGNREGA) job card information for citizens of Assam. Track employment records, verify job cards, and access wage details instantly.',
                    style: TextStyle(fontSize: 14, color: Color(0xFF4B5563), height: 1.5),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'এই ডিজিটেল প্ৰৱেশদ্বাৰে অসমৰ নাগৰিকসকলক VB-G RAM G (আগতে জনা গৈছিল MGNREGA) জব কাৰ্ডৰ তথ্য সম্পূৰ্ণ ৰূপে প্ৰদান কৰে। নিয়োগৰ তথ্য ট্ৰেক কৰক, জব কাৰ্ড প্ৰমাণিত কৰক আৰু তৎক্ষণাৎ মজুৰিৰ বিৱৰণ লাভ কৰক।',
                    style: TextStyle(fontSize: 12, color: Color(0xFF6B7280), height: 1.5),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),

              // Services Available
              _buildCard(
                icon: Icons.layers_outlined,
                iconColor: const Color(0xFF2563EB),
                iconBgColor: const Color(0xFFEFF6FF),
                titleEn: 'Services Available',
                titleAs: 'উপলব্ধ সেৱাসমূহ',
                children: [
                  _buildServiceListTile(Icons.badge_outlined, 'Job Card Search & Verification', 'জব কাৰ্ড সন্ধান আৰু প্ৰমাণীকৰণ'),
                  const SizedBox(height: 12),
                  // _buildServiceListTile(Icons.event_available_outlined, 'Attendance & Work Days Tracking', 'উপস্থিতি আৰু কৰ্মদিৱস ট্ৰেকিং'),
                  // const SizedBox(height: 12),
                  _buildServiceListTile(Icons.currency_rupee, 'Wage Payment Details', 'মজুৰি পৰিশোধৰ বিৱৰণ'),
                ],
              ),

              const SizedBox(height: 16),

              // What is Job Card
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF111827),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
                  ],
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(8)),
                          child: const Icon(Icons.description_outlined, color: Colors.white, size: 24),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('What is Job Card?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                            Text('জব কার্ড কি?', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.white60)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'A Job Card is an official document issued under the VB-G RAM G scheme. It guarantees 125 days of wage employment per year to rural households and serves as proof of identity and entitlement.',
                      style: TextStyle(fontSize: 13, color: Colors.white70, height: 1.6),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'জব কার্ড হৈছে VB-G RAM G আঁচনিৰ অধীনত জাৰি কৰা এখন চৰকাৰী নথি। ই গ্রাম্য পৰিয়ালসমূহক বছৰত ১২৫ দিনৰ মজুৰি নিযুক্তিৰ নিশ্চয়তা দিয়ে আৰু পৰিচয় আৰু অধিকাৰৰ প্ৰমাণ হিচাপে কাম কৰে।',
                      style: TextStyle(fontSize: 11, color: Colors.white60, height: 1.6),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // How to Use This Portal
              _buildCard(
                icon: Icons.touch_app_outlined,
                iconColor: const Color(0xFF16A34A),
                iconBgColor: const Color(0xFFF0FDF4),
                titleEn: 'How to Use This Portal',
                titleAs: 'এই পৰ্টেল কেনেকৈ ব্যৱহাৰ কৰিব',
                children: [
                  _buildStepTile('1', 'Navigate to Search Tab', 'সন্ধান টেবলৈ যাওক'),
                  const SizedBox(height: 8),
                  _buildStepTile('2', 'Enter Job Card Number', 'আপোনাৰ জব কাৰ্ড নম্বৰ প্ৰৱেশ কৰক'),
                  const SizedBox(height: 8),
                  _buildStepTile('3', 'View Details & Records', 'বিৱৰণ আৰু অভিলেখ চাওক'),
                ],
              ),

              const SizedBox(height: 16),

              // Need Help?
              Ink(
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF6F3),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE6643D).withValues(alpha: 0.1)),
                ),
                child: InkWell(
                  onTap: () async {
                    final Uri launchUri = Uri(scheme: 'tel', path: '1800123235600');
                    if (await canLaunchUrl(launchUri)) {
                      await launchUrl(launchUri);
                    }
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
                          ),
                          child: const Icon(Icons.phone_in_talk_outlined, color: Color(0xFFE6643D), size: 24),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Need Help? / সহায় লাগে নেকি?',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1F2937)),
                              ),
                              const SizedBox(height: 8),
                              RichText(
                                text: const TextSpan(
                                  style: TextStyle(fontSize: 14, color: Color(0xFF4B5563), height: 1.5),
                                  children: [
                                    TextSpan(text: 'For any technical support or queries, our helpline is available 24/7. Contact us at: '),
                                    TextSpan(text: '1800123235600 (Toll-Free)', style: TextStyle(color: Color(0xFFE6643D), fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text('Available: 9 AM to 5 PM (Mon-Sat)', style: TextStyle(fontSize: 14, color: Color(0xFF4B5563))),
                              
                              const SizedBox(height: 12),
                              RichText(
                                text: const TextSpan(
                                  style: TextStyle(fontSize: 14, color: Color(0xFF4B5563), height: 1.5),
                                  children: [
                                    TextSpan(text: 'যিকোনো কাৰিকৰী সহায় বা প্ৰশ্নৰ বাবে, আমাৰ হেল্পলাইন ২৪/৭ উপলব্ধ। আমাক যোগাযোগ কৰক: '),
                                    TextSpan(text: '১৮০০১২৩২৩৫৬০০ (টোল-ফ্রী)', style: TextStyle(color: Color(0xFFE6643D), fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text('উপলব্ধ: পুৱা ৯ বজাৰ পৰা সন্ধিয়া ৫ বজালৈ (সোম-শনি)', style: TextStyle(fontSize: 14, color: Color(0xFF4B5563))),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),

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
              
              const SizedBox(height: 40),
            ],
          ),
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
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: Color(0xFFE6643D), width: 3)),
                    ),
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.home_outlined, color: Color(0xFF4B5563), size: 24),
                        SizedBox(height: 4),
                        Text('Home', style: TextStyle(color: Color(0xFF4B5563), fontSize: 12, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SearchScreen()),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.transparent, width: 3)),
                    ),
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.search, color: Color(0xFF9CA3AF), size: 24),
                        SizedBox(height: 4),
                        Text('Job Card', style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 12, fontWeight: FontWeight.w500)),
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

  Widget _buildCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String titleEn,
    required String titleAs,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: iconBgColor, borderRadius: BorderRadius.circular(8)),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(titleEn, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1F2937))),
                    Text(titleAs, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF6B7280))),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildServiceListTile(IconData icon, String titleEn, String titleAs) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: const Color(0xFFE6643D)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(titleEn, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF374151))),
              Text(titleAs, style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280))),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStepTile(String stepNumber, String titleEn, String titleAs) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF3F4F6)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Color(0xFFE6643D),
              shape: BoxShape.circle,
            ),
            child: Text(stepNumber, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(titleEn, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF374151))),
                Text(titleAs, style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
