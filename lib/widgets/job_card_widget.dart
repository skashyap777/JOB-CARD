import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../screens/job_card_details_screen.dart';
import '../utils/app_theme.dart';
import 'common_card_header.dart';
import 'common_card_footer.dart';

class JobCardWidget extends StatelessWidget {
  final Map<String, dynamic> cardData;

  const JobCardWidget({super.key, required this.cardData});

  @override
  Widget build(BuildContext context) {
    final data = cardData['data'] ?? {};
    final headOfHousehold = data['head_of_household'] ?? 'N/A';
    final gender = data['gender'] ?? 'N/A';
    final category = data['category'] ?? 'N/A';
    final issueDate = data['issue_date'] ?? 'N/A';
    final qrCodeUrl = data['qr_code_url'];
    final regNo = data['reg_no'] ?? 'N/A';
    final encryptedRegNo = data['encrypted_reg_no'] ?? '';

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: AppStyles.cardDecoration,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12.0),
          onTap: () {
            if (encryptedRegNo.isNotEmpty) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => JobCardDetailsScreen(
                    encryptedRegNo: encryptedRegNo,
                    headOfHousehold: headOfHousehold,
                    regNo: regNo,
                  ),
                ),
              );
            }
          },
          child: Stack(
          children: [
            // Background container
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Container(
                  color: Colors.white,
                ),
              ),
            ),
            
            Column(
              children: [
                // Reusable Header
                const CommonCardHeader(),

                // Card Content (Removed fixed height)
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left side - QR Code
                      Column(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300, width: 2),
                              borderRadius: BorderRadius.circular(8.0),
                              color: Colors.white,
                            ),
                            child: qrCodeUrl != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(6.0),
                                    child: CachedNetworkImage(
                                      imageUrl: qrCodeUrl,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          const Center(
                                              child:
                                                  CircularProgressIndicator()),
                                      errorWidget: (context, url, error) =>
                                          _buildQRPlaceholder(),
                                    ),
                                  )
                                : _buildQRPlaceholder(),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Mahatma Gandhi',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1565C0),
                            ),
                          ),
                          const Text(
                            'NREGA',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1565C0),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 20),

                      // Right side - Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              headOfHousehold,
                              style: const TextStyle(
                                fontSize: 22.0,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2E7D32),
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildDetailRow('Gender(লিংগ):',
                                gender == 'M' ? 'M' : gender),
                            const SizedBox(height: 6),
                            _buildDetailRow('Category(শ্ৰেণী):', category),
                            const SizedBox(height: 6),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Flexible(
                                  child: Text(
                                    'Issue Date(জাৰি কৰা তাৰিখ): ',
                                    style: TextStyle(
                                      fontSize: 11.0,
                                      color: Color(0xFF666666),
                                    ),
                                  ),
                                ),
                                Text(
                                  issueDate,
                                  style: const TextStyle(
                                    fontSize: 11.0,
                                    color: Color(0xFFE8744F),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Icon(
                                  Icons.touch_app,
                                  color: Colors.blue.shade600,
                                  size: 16,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Tap to view details',
                                  style: TextStyle(
                                    color: Colors.blue.shade600,
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Reusable Footer
                const CommonCardFooter(),
              ],
            ),
          ],
        ),
      ),
    ),
    ),
    );
  }

  Widget _buildQRPlaceholder() {
    return const Center(
      child: Icon(
        Icons.qr_code,
        size: 60,
        color: Colors.grey,
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(child: Text(label, style: AppStyles.labelStyle)),
        const SizedBox(width: 6),
        Flexible(child: Text(value, style: AppStyles.valueStyle)),
      ],
    );
  }
}

// Address Card Widget
class AddressCardWidget extends StatelessWidget {
  final Map<String, dynamic> cardData;

  const AddressCardWidget({super.key, required this.cardData});

  @override
  Widget build(BuildContext context) {
    final data = cardData['data'] ?? {};
    final regNo = data['reg_no'] ?? 'N/A';
    final village = data['village'] ?? 'N/A';
    final block = data['block'] ?? 'N/A';
    final panchayat = data['panchayat'] ?? 'N/A';
    final district = data['district'] ?? 'N/A';

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background container
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Container(
                color: Colors.white,
              ),
            ),
          ),
          
          Column(
            children: [
              // Reusable Header
              const CommonCardHeader(),

              // Address Content (Removed fixed height)
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 20.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Logo Placeholder
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.info_outline, size: 40, color: Colors.grey),
                    ),
                    const SizedBox(width: 24),
                    // Address Details
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                          Text(
                            'Address(ঠিকনা): $village',
                            style: const TextStyle(
                              fontSize: 12.0,
                              color: Color(0xFF333333),
                              fontWeight: FontWeight.w600,
                              height: 1.3,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Village(গাঁও):',
                            style: TextStyle(
                              fontSize: 11.0,
                              color: Colors.grey.shade700,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Block(উন্নয়ন খণ্ড): $block',
                            style: TextStyle(
                              fontSize: 11.0,
                              color: Colors.grey.shade700,
                              height: 1.3,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Gaon/Panchayat(গাঁও পঞ্চায়ত): $panchayat',
                            style: TextStyle(
                              fontSize: 11.0,
                              color: Colors.grey.shade700,
                              height: 1.3,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'District(জিলা): $district',
                            style: TextStyle(
                              fontSize: 11.0,
                              color: Colors.grey.shade700,
                              height: 1.3,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Job Card Number
              Container(
                margin: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(6.0),
                ),
                child: Text(
                  'JOB CARD NUMBER - $regNo',
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.green.shade800,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              // Reusable Footer
              const CommonCardFooter(),
            ],
          ),
        ],
      ),
    );
  }
}

