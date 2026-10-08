import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class CommonCardHeader extends StatelessWidget {
  const CommonCardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: const BoxDecoration(
        color: AppColors.amberDark,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.0),
          topRight: Radius.circular(12.0),
        ),
      ),
      child: Row(
        children: [
          // Government Emblem
          const Icon(
            Icons.account_balance,
            color: Colors.white,
            size: 36,
          ),
          const SizedBox(width: 12),
          // Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'গ্ৰাম্য বিকাশ মন্ত্ৰণালয়',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.95),
                    fontSize: 10.0,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                  ),
                ),
                const Text(
                  'Ministry of Rural Development',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 9.0,
                    fontWeight: FontWeight.w500,
                    height: 1.2,
                  ),
                ),
                const Text(
                  'Government of India',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8.5,
                    fontWeight: FontWeight.w400,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
          // JOB CARD text
          const Text(
            'JOB CARD',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(width: 12),
          // Image Replacement
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Container(
              width: 50,
              height: 50,
              color: Colors.white.withValues(alpha: 0.2),
              child: const Icon(Icons.person, color: Colors.white, size: 30),
            ),
          ),
        ],
      ),
    );
  }
}
