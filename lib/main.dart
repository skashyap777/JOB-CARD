import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/search_screen.dart';
import 'screens/job_card_details_screen.dart';
import 'utils/storage_service.dart';
import 'package:flutter/services.dart';

import 'dart:convert';
import 'cert.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    SecurityContext sc = SecurityContext(withTrustedRoots: true);
    sc.setTrustedCertificatesBytes(utf8.encode(assamGovCert));
    return super.createHttpClient(sc);
  }
}

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Job Card Assam',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Noto Sans',
        useMaterial3: false,
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkSavedJobCard();
  }

  Future<void> _checkSavedJobCard() async {
    // Check if user has saved job card details
    final hasSaved = await StorageService.hasSavedJobCard();
    
    if (hasSaved) {
      // Get saved details
      final details = await StorageService.getSavedJobCardDetails();
      
      if (details['regNo'] != null && details['encryptedRegNo'] != null) {
        // Navigate directly to Details Screen if saved
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => JobCardDetailsScreen(
                encryptedRegNo: details['encryptedRegNo']!,
                headOfHousehold: details['headOfHousehold'] ?? 'N/A',
                regNo: details['regNo']!,
              ),
            ),
          );
        }
        return;
      }
    }
    
    // Navigate to home screen if no saved details
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.credit_card,
              size: 80,
              color: Colors.orange.shade700,
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(
              color: Color(0xFFFF6F3C),
            ),
          ],
        ),
      ),
    );
  }
}
